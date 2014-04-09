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

#define STARTING_BALL_LIVES 5
#define PEG_COLUMNS 12
#define PEG_ROWS    11

@interface IotaGameScene () {
    int pegColor; // This is used to determine what color the peg should next.
    int pegColorReset;
    
    NSMutableArray  *scoreDetectors;  // Contains all of the score detectors on the screen.
    ScoreIndicators *scoreIndicators; // Score indicators are used to show where each ball has landed.
    NSMutableArray  *scoreValues;     // Values for each score detector.
    NSMutableArray  *pegs;
    NSMutableArray  *dividerBars;
    int64_t finalScore;
    
    YSIotaSE *iotaSE;
    
    Reachability *internetReachability;
}

@property BOOL ballIsOnScreen;

@end

@implementation IotaGameScene


- (void)didMoveToView:(SKView *)view {
    [self presentTheFingerSprite];
    
    [self enumerateChildNodesWithName:kIOPegName usingBlock:^(SKNode *node, BOOL *stop) {
        Peg *peg = (Peg *)node;
        peg.multiplier = NO;
        peg.wasHitThisRound = NO;
        peg.colorCount = pegColorReset;
    }];
    
    [self.gameCenterManager reloadHighScoresForCategory:self.currentLeaderboardIdentifier];
}

#pragma mark - Setup

- (void)createContent {
    self.backgroundColor = [UIColor colorWithRed:33.0 / 255.0
                                           green:35.0 / 255.0
                                            blue:37.0 / 255.0
                                           alpha:1.0];
    
    self.ballIsOnScreen = NO;
    self.ballLives = STARTING_BALL_LIVES;
    self.score = 0;
    finalScore = 0;
    self.multiplier = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    pegColor = self.ballLives;
    pegColorReset = 8;
    
    self.currentLeaderboardIdentifier = kIOMainLeaderboard;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.stats = appDelegate.stats;
    self.stats.gameScene = self;
    self.gameCenterManager    = appDelegate.gameCenterManager;
    iotaSE               = appDelegate.iotaSE;
    
    if ([GameCenterManager isGameCenterAvailable]) {
        self.gameCenterManager.delegate = self;
    }
    
    if ([self.stats.localHighScore longLongValue] > [self.stats.remoteHighScore longLongValue]) {
        [self.gameCenterManager reportScore:[self.stats.localHighScore longLongValue] forCategory:kIOMainLeaderboard];
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

#pragma mark - The Finger Sprite

- (void)presentTheFingerSprite {
    [self addChild:[FingerSprite drawFingerAtPostion:CGPointMake(CGRectGetMidX(self.frame) + 55, CGRectGetMidY(self.frame) * 1.5)]];
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

#pragma mark - Divider Bar

- (SKSpriteNode *)dividerBarWithSize:(CGSize)size {
    SKSpriteNode *bar = [SKSpriteNode spriteNodeWithColor:[SKColor lightGrayColor] size:size];
    bar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    bar.physicsBody.dynamic = NO;
    bar.name = kIODividerName;
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
            
            [self.stats incrementBallsPlayed];
        }
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
    
    [self enumerateChildNodesWithName:kIOFingerName usingBlock:^(SKNode *node, BOOL *stop) {
        FingerSprite *finger = (FingerSprite *)node;
        [finger moveUpFadeOut];
    }];
}

#pragma mark - Physics Methods

- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:kIOBallName usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0 || node.position.x < self.view.frame.origin.x || node.position.x > self.view.frame.size.width) {
            [node removeFromParent];
            self.ballIsOnScreen = NO;
            self.score += 0;
        }
    }];
}

#pragma mark - Physics Contact Delegate Methods

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
                
                [self.stats incrementScoreDetectorsHitCount];
                
                switch (scoreDetector.value) {
                    case 50:
                        [iotaSE playEvent:YSIotaSEEvent25];
                        [[Stats sharedInstance] incrementAccuracyWithValue:scoreDetector.value];
                        break;
                        
                    case 75:
                        [iotaSE playEvent:YSIotaSEEvent50];
                        [[Stats sharedInstance] incrementAccuracyWithValue:scoreDetector.value];
                        break;
                        
                    case 250:
                        [iotaSE playEvent:YSIotaSEEvent100];
                        [[Stats sharedInstance] incrementAccuracyWithValue:scoreDetector.value];
                        break;
                        
                    case 25:
                        [iotaSE playEvent:YSIotaSEEvent5];
                        [[Stats sharedInstance] incrementAccuracyWithValue:scoreDetector.value];
                        break;
                        
                    case 0:
                        [iotaSE playEvent:YSIotaSEEventLoose];
                        [[Stats sharedInstance] incrementAccuracyWithValue:scoreDetector.value];
                        break;
                }
                
                NSUInteger detectorIndex = [scoreDetectors indexOfObject:scoreDetector];
                if (detectorIndex < 9) {
                    [scoreIndicators insertIndicatorAtIndex:detectorIndex withColor:[[PegColors iotaColorValues] objectAtIndex:ball.currentColor - 1] withValue:scoreDetector.value];
                }
            }
            
            [self enumerateChildNodesWithName:kIOPegName usingBlock:^(SKNode *node, BOOL *stop) {
                Peg *peg = (Peg *)node;
                peg.wasHitThisRound = NO;
            }];
            
            // Ran out of lives, game over.
            if (self.ballLives == 0) {
                finalScore = abs(self.score * [self.multiplier intValue]);
                if (!self.scorezone.replayScreenPresented) {
                    [self.scorezone presentGameOverButtonsWithScore:finalScore andLocalHighScore:[self.stats.localHighScore longLongValue]];
                    [self.scorezone setHighScoreLabel:self.scorezone.highScoreLabel withScore:finalScore andHighScore:[self.stats.localHighScore longLongValue]];
                }
                
                // Local high score check
                if (finalScore > [self.stats.localHighScore longLongValue]) {
                    self.stats.localHighScore = [NSNumber numberWithLongLong:finalScore];
                }
                
                // Low score check
                if (self.stats.lowestScore.longLongValue == 0) {
                    self.stats.lowestScore = [NSNumber numberWithLongLong:finalScore];
                } else if (finalScore < self.stats.lowestScore.longLongValue && finalScore != 0) {
                    self.stats.lowestScore = [NSNumber numberWithLong:finalScore];
                }
                
                [self.stats updateTotalScoreWithScore:finalScore];
                [self.stats incrementGamesPlayedCount];
                
                [self performSelector:@selector(reportScores) withObject:self afterDelay:1.0];
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
                    self.multiplier = [self.multiplier decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"2.0"]];
                    peg.multiplier = TRUE;
                }
            
                Ball *ball = (Ball *)secondBody.node;
                peg.wasHitThisRound = YES;
                peg.colorCount = ball.currentColor;
                
                [self.stats incrementPegsLitUpCount];
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

- (void)reportScores {
    [self.gameCenterManager reportScore:finalScore forCategory:kIOMainLeaderboard];
    [self.gameCenterManager reportScore:self.stats.totalPointsEarned.longLongValue forCategory:kIOTotalPointsEarnedLeaderboard];
    [self.gameCenterManager reportScore:self.stats.lowestScore.longLongValue forCategory:kIOLowestScoreLeaderboard];
    [self.gameCenterManager reportScore:self.stats.highestMultiplier.longLongValue forCategory:kIOHighestMultiplierLeaderboard];
    [self.gameCenterManager reportScore:self.stats.totalGamesPlayed.longLongValue forCategory:kIOTotalGamesPlayedLeaderboard];
    
    if (self.stats.localHighScore.longLongValue > self.stats.remoteHighScore.longLongValue) {
        [self.gameCenterManager reportScore:self.stats.localHighScore.longLongValue forCategory:kIOMainLeaderboard];
    }
    
    if ([self connected]) {
        [[ParseHelper sharedHelper] reportScoreWithTotalScore:finalScore multiplier:[self.multiplier intValue] score:self.score withValues:scoreIndicators.values];
    }
    
    [self checkHighScoreAchievements];
    [self checkTotalPointsAchievements];
}

- (void)checkHighScoreAchievements {
    NSString *identifier = NULL;
    
    if (self.stats.localHighScore.longLongValue >= 40000) {
        identifier = iotaAchievementHighScore40k;
    }
    
    if (self.stats.localHighScore.longLongValue >= 50000) {
        identifier = iotaAchievementHighScore50k;
    }
    
    if (self.stats.localHighScore.longLongValue >= 60000) {
        identifier = iotaAchievementHighScore60k;
    }
    
    if (self.stats.localHighScore.longLongValue >= 65000) {
        identifier = iotaAchievementHighScore65k;
    }
    
    if (self.stats.localHighScore.longLongValue >= 70000) {
        identifier = iotaAchievementHighScore70k;
    }
    
	if(identifier!= NULL)
	{
		[self.gameCenterManager submitAchievement: identifier percentComplete: 100.0];
	}
}

- (void)checkTotalPointsAchievements {
    NSString *identifier = NULL;
    double percent = 0.0;

    double values[] = {
                        1000000,
                        5000000,
                        10000000,
                        25000000,
                        100000000
                      };
    
    NSArray *strings = @[
                         iotaAchievementTotalPoints1m,
                         iotaAchievementTotalPoints5m,
                         iotaAchievementTotalPoints10m,
                         iotaAchievementTotalPoints25m,
                         iotaAchievementTotalPoints100m
                         ];
    
    for (int i = 0; i < strings.count; i++) {
        identifier = strings[i];
        percent = self.stats.totalPointsEarned.doubleValue / values[i] * 100;
        NSLog(@"percent: %.2f, identifier: %@", percent, identifier);
        if (identifier != NULL) {
            [self.gameCenterManager submitAchievement:identifier percentComplete:percent];
        }
    }
    
}

- (void)checkMultiplierAchievements {
    NSString *identifer = NULL;
    
    if (self.stats.highestMultiplier.longLongValue >= 80) {
        identifer = iotaAchievementMultiplier80;
    }
    
    if (self.stats.highestMultiplier.longLongValue >= 85) {
        identifer = iotaAchievementMultiplier85;
    }
    
    if (self.stats.highestMultiplier.longLongValue >= 90) {
        identifer = iotaAchievementMultiplier90;
    }
    
    if (self.stats.highestMultiplier.longLongValue >= 95) {
        identifer = iotaAchievementMultiplier95;
    }
    
    if (self.stats.highestMultiplier.longLongValue >= 100) {
        identifer = iotaAchievementMultiplier100;
    }
    
    if (identifer != NULL) {
        [self.gameCenterManager submitAchievement:identifer percentComplete:100.0];
    }
}

- (void)resetGame {
    self.score = 0;
    finalScore = 0;
    self.ballLives = STARTING_BALL_LIVES;
    self.ballIsOnScreen = NO;
    self.multiplier = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    [self enumerateChildNodesWithName:kIOPegName usingBlock:^(SKNode *node, BOOL *stop) {
        Peg *peg = (Peg *)node;
        peg.multiplier = NO;
        peg.wasHitThisRound = NO;
        peg.colorCount = pegColorReset;
    }];
    
    [self.scorezone clearBallLivesSprites];
    [self.scorezone setupBallLivesSprites];
    
    [self removeNodesForNames:@[kIOBallName]];
    
    [scoreIndicators clearAllIndicators];
    
    // The scene's X gravity changes slightly each round.
    self.physicsWorld.gravity = CGVectorMake(skRand(-0.02, 0.02), self.physicsWorld.gravity.dy);
}

#pragma mark - Setters
- (void)setMultiplier:(NSDecimalNumber *)multiplier{
    _multiplier = multiplier;
    
    [self.scorezone setScoreLabel:self.scorezone.scoreLabel withMultiplier:[_multiplier intValue] withScore:self.score];
    
    if ([_multiplier intValue] > [[self.stats highestMultiplier] intValue]) {
        self.stats.highestMultiplier = [NSNumber numberWithLongLong:[_multiplier longLongValue]];
    }
}

- (void)setScore:(int)score {
    _score = score;
    
    [self.scorezone setScoreLabel:self.scorezone.scoreLabel withMultiplier:[_multiplier intValue] withScore:self.score];
}

#pragma mark - Game Center Manager Delegate methods

- (void) processGameCenterAuth: (NSError*) error
{
	if(error == NULL)
	{
		[self.gameCenterManager reloadHighScoresForCategory: self.currentLeaderboardIdentifier];
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
            self.stats.remoteHighScore = [NSNumber numberWithLongLong:personalBest];
            if ([self.stats.remoteHighScore longLongValue] > [self.stats.localHighScore longLongValue]) {
                self.stats.localHighScore = self.stats.remoteHighScore;
            }
        }
	}
}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
	if((error == NULL) && (ach != NULL))
	{
		if(ach.percentComplete == 100.0)
		{
            [GKNotificationBanner showBannerWithTitle:@"Achievement unlocked!" message:ach.identifier completionHandler:^{
            }];
            
            if (iotaSE.canPlaySound) {
                [iotaSE playEvent:YSIotaSEEventPowerUp];
            }
		}
	}
	else
	{
		[self showAlertWithTitle: @"Achievement Submission Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[UIAlertView alloc] initWithTitle: title message: message
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL];
	[alert show];
	
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
