//
//  PlinkoScene.m
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/19/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <AVFoundation/AVFoundation.h>
#import "IotaGameScene.h"

#import "SKButton.h"

#import "ScoreDetector.h"
#import "ScoreIndicators.h"
#import "MainMenu.h"
#import "YSIotaSE.h"
#import "AppDelegate.h"
#import "PegColors.h"
#import "Scorezone.h"

#import "GameCenterManager.h"

#import "ParseHelper.h"

@interface IotaGameScene () {
    int pegColor; // This is used to determine what color the peg should next.
    int pegColorMax;
    int pegColorReset;
    
    NSMutableArray  *scoreDetectors;  // Contains all of the score detectors on the screen.
    ScoreIndicators *scoreIndicators; // Score indicators are used to show where each ball has landed.
    NSMutableArray  *scoreValues;     // Values for each score detector.
    NSMutableArray  *pegs;
    NSMutableArray  *dividerBars;
    
    GameCenterManager *gameCenterManager;
    int64_t finalScore;
    
    YSIotaSE *iotaSE;
    
    Reachability *internetReachability;
}

@property BOOL ballIsOnScreen;

@end

@implementation IotaGameScene

#define STARTING_BALL_LIVES 5
#define PEG_COLUMNS 12
#define PEG_ROWS    11


- (void)didMoveToView:(SKView *)view {
    [self presentTheFinger];
    
    [self enumerateChildNodesWithName:@"peg" usingBlock:^(SKNode *node, BOOL *stop) {
        Peg *peg = (Peg *)node;
        peg.multiplier = NO;
        peg.wasHitThisRound = NO;
        peg.colorCount = pegColorReset;
    }];
    
    [gameCenterManager reloadHighScoresForCategory:self.currentLeaderboardIdentifier];
}

#pragma mark - Setup

- (void)createContent {
    self.backgroundColor = [UIColor colorWithRed:33.0 / 255.0
                                           green:35.0 / 255.0
                                            blue:37.0 / 255.0
                                           alpha:1.0];
    
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    self.ballIsOnScreen = NO;
    self.ballLives = STARTING_BALL_LIVES;
    self.score = 0;
    finalScore = 0;
    self.multiplier = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    pegColor = self.ballLives;
    pegColorMax = 7;
    pegColorReset = 8;
    
    self.currentLeaderboardIdentifier = kIotaMainLeaderboard;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    gameCenterManager = appDelegate.gameCenterManager;
    
    if ([GameCenterManager isGameCenterAvailable]) {
        gameCenterManager.delegate = self;
    }
    
    iotaSE = appDelegate.iotaSE;
    
    self.cachedLocalHighScore = [[HighScoreHelper sharedInstance] localHighScore];
    if (_cachedLocalHighScore > self.cachedRemoteHighScore) {
        [gameCenterManager reportScore:_cachedLocalHighScore forCategory:kIotaMainLeaderboard];
    }
    
    [self setupPhysicsWorld];
    [self setupPegs];
    [self setupScorezone];

    [self setupScoreValues];
    [self setupPointAmountLabels];
    [self setupScoreIndicators];
    [self setupDividerBars];
    [self setupScoreDetectors];
}

#pragma mark - Physics World

- (void)setupPhysicsWorld {
    self.physicsWorld.gravity = CGVectorMake(skRand(-0.02, 0.02), -19.0);
    self.physicsWorld.contactDelegate = self;
}

#pragma mark - The Finger

- (void)presentTheFinger {
    [self addChild:[self theFinger]];
}

- (SKSpriteNode *)theFinger {
    SKSpriteNode *finger = [SKSpriteNode spriteNodeWithImageNamed:@"finger.png"];
    finger.position = CGPointMake(CGRectGetMidX(self.frame) + 55, CGRectGetMidY(self.frame) * 1.5);
    finger.name = @"finger";
    finger.zRotation = 45 * M_PI / 180;
    finger.alpha = 0.0;
    
    SKAction *waitShort = [SKAction waitForDuration:0.12];
    SKAction *waitLong  = [SKAction waitForDuration:0.35];
    
    SKAction *fingerUp  = [SKAction setTexture:[SKTexture textureWithImageNamed:@"finger"]];
    SKAction *fingerDown = [SKAction setTexture:[SKTexture textureWithImageNamed:@"finger_pressed"]];
    
    SKAction *anim = [SKAction sequence:@[waitShort, fingerDown, waitShort, fingerUp, waitShort, fingerDown, waitShort, fingerUp, waitLong]];
    SKAction *repeatAnim = [SKAction repeatActionForever:anim];
    
    SKAction *fadeInMoveDown = [SKAction group:@[
                                                 [SKAction moveByX:0 y:-30 duration:0.2],
                                                 [SKAction fadeInWithDuration:0.2]
                                                 ]];
    
    [finger runAction:[SKAction sequence:@[fadeInMoveDown, repeatAnim]]];
    
    return finger;
}

#pragma mark - Pegs

- (void)setupPegs {
    pegs = [NSMutableArray array];
    
    CGPoint origin = CGPointMake(107, 121);
    
    int columns = PEG_COLUMNS;
    int rows    = PEG_ROWS;
    
    for (int j = 0; j < rows; j++) {
        for (int i = 0; i < columns; i ++) {
            if ((j % 2 == 1) && (i == columns - 1)) {
                // Don't make a peg if we are in an even row and last column.
            } else {
                Peg *peg = [Peg newPeg];
                if (j % 2 == 0) {
                    peg.position = CGPointMake(origin.x + (i * 50), origin.y + (j * 50));
                } else {
                    peg.position = CGPointMake(origin.x + (i * 50) + 25, origin.y + (j * 50));
                }
                [pegs addObject:peg];
                [self addChild:peg];
            }
        }
    }
}

#pragma mark - Score Zone

- (void)setupScorezone {
    self.scorezone = [Scorezone createNewScoreZoneAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 66) withGameScene:self];
    self.scorezone.scoreLabel.text = [NSString stringWithFormat:@"%d x %d",[self.multiplier intValue], self.score];
    self.scorezone.totalScoreLabel.text = [NSString stringWithFormat:@"%d", abs(self.score * [self.multiplier floatValue])];
    
    [self addChild:self.scorezone];
}

- (void)presentPointsEarnedLabelWithPointValue:(int)value {
    SKLabelNode *pointsEarned = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
    pointsEarned.fontSize     = 48.0f;
    pointsEarned.fontColor    = [SKColor whiteColor];
    pointsEarned.position     = CGPointMake(CGRectGetMidX(self.view.frame), 700);
    pointsEarned.alpha        = 0.0f;
    pointsEarned.text         = [NSString stringWithFormat:@"+%d", value];
    pointsEarned.name         = @"pointsEarned";
    
    [self addChild:pointsEarned];
    
    SKAction *fadeIn  = [SKAction fadeInWithDuration:0.15];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.15];
    SKAction *moveUp  = [SKAction moveBy:CGVectorMake(0, 75) duration:0.15];
    SKAction *moveUpSlightly = [SKAction moveBy:CGVectorMake(0, 10) duration:0.75];
    SKAction *scaleUp = [SKAction scaleBy:1.25 duration:0.15];
    SKAction *wait    = [SKAction waitForDuration:.4];
    
    fadeIn.timingMode = SKActionTimingEaseInEaseOut;
    fadeOut.timingMode = SKActionTimingEaseInEaseOut;
    moveUp.timingMode = SKActionTimingEaseInEaseOut;
    scaleUp.timingMode = SKActionTimingEaseInEaseOut;
    moveUpSlightly.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *moveUpFadeIn  = [SKAction group:@[fadeIn, moveUp]];
    SKAction *moveUpFadeOut = [SKAction group:@[fadeOut, moveUp]];
    
    [pointsEarned runAction:[SKAction sequence:@[moveUpFadeIn, wait, scaleUp, moveUpFadeOut]] completion:^{
        [pointsEarned removeFromParent];
    }];
}

#pragma mark - Divider Bar

- (SKSpriteNode *)dividerBarWithSize:(CGSize)size {
    SKSpriteNode *bar = [SKSpriteNode spriteNodeWithColor:[SKColor lightGrayColor] size:size];
    bar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    bar.physicsBody.dynamic = NO;
    bar.name = kPKDividername;
    bar.zPosition = 1000;
    
    return bar;
}

- (void)setupDividerBars {
    dividerBars = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        switch (i) {
            case 4: {
                SKSpriteNode *bar = [self dividerBarWithSize:CGSizeMake(1, 75)];
                bar.position = CGPointMake(160.0 + (i * 50), 37);
                [dividerBars addObject:bar];
                [self addChild:bar];
                break;
            }
            case 5: {
                SKSpriteNode *bar = [self dividerBarWithSize:CGSizeMake(1, 75)];
                bar.position = CGPointMake(160.0 + (i * 50), 37);
                [dividerBars addObject:bar];
                [self addChild:bar];
                break;
            }
            default: {
                SKSpriteNode *bar = [self dividerBarWithSize:CGSizeMake(1, 50)];
                bar.position = CGPointMake(160.0 + (i * 50), 25);
                [dividerBars addObject:bar];
                [self addChild:bar];
                break;
            }
        }
    }
    
    SKSpriteNode *firstBar = [dividerBars firstObject];
    scoreIndicators.position = CGPointMake(firstBar.position.x, 0);
}

#pragma mark - Score Detector

- (void)setupScoreIndicators {
    scoreIndicators = [ScoreIndicators createNewScoreIndicators];
    scoreIndicators.zPosition = 0;
    
    [self addChild:scoreIndicators];
}

- (void)setupScoreValues {
    scoreValues = [NSMutableArray new];
    
    // Scores for each divider
    scoreValues = [NSMutableArray arrayWithArray:@[@75, @25, @50, @0, @250, @0, @50, @25, @75]];
}

- (void)setupScoreDetectors {
    scoreDetectors = [NSMutableArray new];
    
    for (int i = 0; i < scoreValues.count; i++) {
        ScoreDetector *detector = [ScoreDetector newScoreDetectorWithSize:CGSizeMake(50, 1)];
        detector.position = CGPointMake(185.0 + (i * 50), 1);
        detector.value = [scoreValues[i] intValue];
        
        [self addChild:detector];
        
        [scoreDetectors addObject:detector];
    }
    
    // Getting a pointer to the first and last divider bar to know where to draw
    // bottom left and bottom right edge detectors.
    SKSpriteNode *firstDivider = [dividerBars firstObject];
    SKSpriteNode *lastDivider  = [dividerBars lastObject];
    
    ScoreDetector *leftEdge, *rightEdge, *bottomLeftEdge, *bottomRightEdge;
    leftEdge =   [ScoreDetector newScoreDetectorWithSize:CGSizeMake(1, self.frame.size.height)];
    rightEdge =  [ScoreDetector newScoreDetectorWithSize:CGSizeMake(1, self.frame.size.height)];
    bottomLeftEdge = [ScoreDetector newScoreDetectorWithSize:CGSizeMake(firstDivider.position.x, 1)];
    bottomRightEdge = [ScoreDetector newScoreDetectorWithSize:CGSizeMake(self.frame.size.width - lastDivider.position.x, 1)];
    
    leftEdge.position = CGPointMake(0, CGRectGetMidY(self.frame));
    leftEdge.name = @"edgeDetector";
    
    rightEdge.position = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
    rightEdge.name = @"edgeDetector";
    
    bottomLeftEdge.position = CGPointMake(bottomLeftEdge.position.x + (bottomLeftEdge.size.width / 2), bottomLeftEdge.position.y);
    bottomLeftEdge.name = @"edgeDetector";
    
    bottomRightEdge.position    = CGPointMake(lastDivider.position.x + (bottomRightEdge.size.width / 2.0), 1);
    bottomRightEdge.name  = @"edgeDetector";
    
    NSArray *edgeDetectors = @[leftEdge, rightEdge, bottomLeftEdge, bottomRightEdge];
    
    for (ScoreDetector *detector in edgeDetectors) {
        detector.value = 0;
        [scoreDetectors addObject:detector];
        [self addChild:detector];
    }
    
    [scoreDetectors addObjectsFromArray:edgeDetectors];
}

- (void)setupPointAmountLabels {
    for (int i = 0; i < 9; i++) {
        SKLabelNode *pointAmountLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
        pointAmountLabel.fontColor = [SKColor whiteColor];
        pointAmountLabel.fontSize = 24;
        pointAmountLabel.position = CGPointMake(185.0 + (i * 50), 15);
        pointAmountLabel.text = [NSString stringWithFormat:@"%d", [scoreValues[i] intValue]];
        pointAmountLabel.zPosition = 1000;
        pointAmountLabel.name = @"pointAmountLabel";
        
        [self addChild:pointAmountLabel];
    }
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPos = [touch locationInView:self.view];
    
    if (self.ballIsOnScreen == NO && self.ballLives != 0) {
        Peg *lastPeg = [pegs lastObject];
        
        CGPoint scoreZoneDividerBarPointInScene = [self convertPoint:self.scorezone.dividerBar.position fromNode:self.scorezone];
        
        if (touchPos.y <= self.frame.size.height - lastPeg.position.y - (lastPeg.size.height / 2.0) &&
            touchPos.y >= self.frame.size.height - scoreZoneDividerBarPointInScene.y &&
            touchPos.x > 20 &&
            touchPos.x < self.frame.size.width - 20) {
            [self dropBallAtTouchLocation:touchPos];
        }
    }
}

- (NetworkStatus *)notifyNetworkStatus:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    NSString* statusString = @"Network Mode Changed / Connection closed!!";
    
    @try
    {
        switch (netStatus)
        {
            case NotReachable:
            {
                statusString = @"No network Access!! Connection closed";
                break;
            }
            case ReachableViaWWAN:
            {
                statusString = @"Network Mode Changed / Connection reachable only via WWAN!!";
                break;
            }
            case ReachableViaWiFi:
            {
                statusString = @"Network Mode Changed / Connection reachable via WiFi";
                break;
            }
            default:
            {
                break;
            }
                
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n Exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

- (void)dropBallAtTouchLocation:(CGPoint)touchPos {
    Ball *ball = [Ball newBall];
    ball.position = CGPointMake(touchPos.x, self.view.frame.size.height - touchPos.y);
    ball.currentColor = self.ballLives;
    
    [self addChild:ball];
    self.ballIsOnScreen = YES;
    
    self.ballLives--;
    
    // Remove the last ball from the ball lives in the top left corner.
    SKSpriteNode *turnsBall = [self.scorezone.ballLivesSprites lastObject];
    [turnsBall removeFromParent];
    [self.scorezone.ballLivesSprites removeLastObject];
    
    [iotaSE reset];
    
    [self enumerateChildNodesWithName:@"finger" usingBlock:^(SKNode *node, BOOL *stop) {
        SKAction *fadeOutMoveUp  = [SKAction group:@[
                                                     [SKAction moveByX:0 y:30 duration:0.1],
                                                     [SKAction fadeOutWithDuration:0.1]
                                                     ]];
        [node runAction:fadeOutMoveUp completion:^{
            [node removeFromParent];
        }];
    }];
    
    
}

#pragma mark - Physics Methods

- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0 || node.position.x < self.view.frame.origin.x || node.position.x > self.view.frame.size.width) {
            [node removeFromParent];
            self.ballIsOnScreen = NO;
            self.score += 0;
        }
    }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    // Hit a score detector
    if ([scoreDetectors containsObject:firstBody.node] || [scoreDetectors containsObject:secondBody.node]) {
        if ([firstBody.node isKindOfClass:[ScoreDetector class]]) {
            ScoreDetector *scoreDetector = (ScoreDetector *)firstBody.node;
            Ball *ball = (Ball *)secondBody.node;
            
            if (ball.isDead == NO) {
                ball.isDead = YES;
                self.score += scoreDetector.value;
                
                if (scoreDetector.value == 0) {
                    [iotaSE playEvent:YSIotaSEEventLoose];
                } else {
                    switch (scoreDetector.value) {
                        case 50:
                            [iotaSE playEvent:YSIotaSEEvent25];
                            break;
                            
                        case 75:
                            [iotaSE playEvent:YSIotaSEEvent50];
                            break;
                            
                        case 250:
                            [iotaSE playEvent:YSIotaSEEvent100];
                            break;
                            
                        case 25:
                            [iotaSE playEvent:YSIotaSEEvent5];
                            
                        default:
                            break;
                    }
                }
                
                NSUInteger detectorIndex = [scoreDetectors indexOfObject:scoreDetector];
                if (detectorIndex < 9) {
                    [scoreIndicators insertIndicatorAtIndex:detectorIndex withColor:[[PegColors iotaColorValues] objectAtIndex:ball.currentColor - 1] withValue:scoreDetector.value];
                }
            }
            
            [self enumerateChildNodesWithName:@"peg" usingBlock:^(SKNode *node, BOOL *stop) {
                Peg *peg = (Peg *)node;
                peg.wasHitThisRound = NO;
            }];
            
            // Ran out of lives, game over.
            if (self.ballLives == 0) {
                finalScore = abs(self.score * [self.multiplier intValue]);
                [self.scorezone presentGameOverButtonsWithScore:finalScore andCachedHighScore:self.cachedLocalHighScore];
                [self.scorezone setHighScoreLabel:self.scorezone.highScoreLabel withScore:finalScore andHighScore:self.cachedLocalHighScore];
                
                if ([self connected]) {
                    [[ParseHelper sharedHelper] reportScoreWithTotalScore:self.cachedLocalHighScore multiplier:[self.multiplier intValue] score:self.score withValues:scoreIndicators.values];
                }
                
                if (finalScore > self.cachedLocalHighScore) {
                    self.cachedLocalHighScore = finalScore;

                    NSLog(@"set new high score in user defaults: %lld", [[HighScoreHelper sharedInstance] localHighScore]);
                }
                NSLog(@"cached high score: %lld", self.cachedLocalHighScore);
                NSLog(@"cahced remote high score: %lld", self.cachedRemoteHighScore);
            }
        }
    }
    
    // Hit a peg
        if ([pegs containsObject:firstBody.node]) {
            
            if ([firstBody.node isKindOfClass:[Peg class]]) {
                Peg *peg = (Peg *)firstBody.node;
                
                // Score Logic
                if (!peg.wasHitThisRound) {
                    [iotaSE playHit];
                    
                    // Turn off the multiplier after itis been hit.
                    if (peg.multiplier == FALSE) {
                        self.multiplier = [self.multiplier decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1.0"]];
                        peg.multiplier = TRUE;
                }
                
                Ball *ball = (Ball *)secondBody.node;
                peg.wasHitThisRound = YES;
                peg.colorCount = ball.currentColor;
            }
        }
    }
}

#pragma mark - Game Ended

- (void)removeNodesForNames:(NSArray *)names{
    for (NSString *name in names) {
        [self enumerateChildNodesWithName:name usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
    }
}

- (void)resetGame {
    self.score = 0;
    finalScore = 0;
    self.ballLives = STARTING_BALL_LIVES;
    self.ballIsOnScreen = NO;
    self.multiplier = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    [self enumerateChildNodesWithName:@"peg" usingBlock:^(SKNode *node, BOOL *stop) {
        Peg *peg = (Peg *)node;
        peg.multiplier = NO;
        peg.wasHitThisRound = NO;
        peg.colorCount = pegColorReset;
    }];
    
    [self.scorezone clearBallLivesSprites];
    [self.scorezone setupBallLivesSprites];
    
    [self removeNodesForNames:@[@"pointsEarned", @"ball"]];
    
    [scoreIndicators clearAllIndicators];
    
    // The scene's X gravity changes on each round.
    self.physicsWorld.gravity = CGVectorMake(skRand(-0.02, 0.02), self.physicsWorld.gravity.dy);
}

#pragma mark - Setters
- (void)setMultiplier:(NSDecimalNumber *)multiplier{
    _multiplier = multiplier;
    
    [self.scorezone setScoreLabel:self.scorezone.scoreLabel withMultiplier:[_multiplier intValue] withScore:self.score];
}

- (void)setScore:(int)score {
    _score = score;
    
    [self.scorezone setScoreLabel:self.scorezone.scoreLabel withMultiplier:[_multiplier intValue] withScore:self.score];
}

- (void)setCachedLocalHighScore:(int64_t)cachedLocalHighScore {
    _cachedLocalHighScore = cachedLocalHighScore;
    
    if (_cachedLocalHighScore > _cachedLocalHighScore > 0) {
        [gameCenterManager reportScore:_cachedLocalHighScore forCategory:kIotaMainLeaderboard];
        NSLog(@"reporting score");
    }
}

#pragma mark - Game Center Manager Delegate methods

- (void) processGameCenterAuth: (NSError*) error
{
	if(error == NULL)
	{
		[gameCenterManager reloadHighScoresForCategory: self.currentLeaderboardIdentifier];
	}
	else
	{
		UIAlertView* alert= [[UIAlertView alloc] initWithTitle: @"Game Center Account Required"
                                                       message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]
                                                      delegate: self cancelButtonTitle: @"Try Again..." otherButtonTitles: NULL];
		[alert show];
	}
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error
{
	if(error == NULL)
	{
        self.currentLeaderboard = leaderBoard;
		int64_t personalBest= leaderBoard.localPlayerScore.value;
		if([leaderBoard.scores count] >0) {
            self.cachedRemoteHighScore = personalBest;
            if (self.cachedRemoteHighScore > self.cachedLocalHighScore) {
                self.cachedLocalHighScore = self.cachedRemoteHighScore;
                [[HighScoreHelper sharedInstance] updateHighScoreWithScore:self.cachedLocalHighScore];
            }
        }
	}
}

#pragma mark - Reachability Method

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark - Math Helpers

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}


@end
