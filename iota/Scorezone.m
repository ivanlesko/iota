//
//  Scorezone.m
//  Iota
//
//  Created by Ivan Lesko on 3/13/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "Scorezone.h"

#import "YSIotaSE.h"
#import "MainMenu.h"
#import "UIShareAcitivityViewController.h"
#import "NSNumberFormatter+CustomFormatters.h"

@implementation Scorezone

+ (Scorezone *)createNewScoreZoneAtPosition:(CGPoint)position withGameScene:(IotaGameScene *)gameScene {
    Scorezone *newScorezone = [Scorezone node];
    newScorezone.position  = position;
    newScorezone.gameScene = gameScene;
    
    newScorezone.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
    newScorezone.scoreLabel.position         = CGPointMake(0, -34);
    newScorezone.scoreLabel.text             = @"0 x 0";
    newScorezone.scoreLabel.fontColor        = [UIColor whiteColor];
    newScorezone.scoreLabel.fontSize         = 25.0f;
    newScorezone.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [newScorezone addChild:newScorezone.scoreLabel];
    
    newScorezone.shareButton = [[SKButton alloc] initWithImageNamedNormal:@"share" selected:@"share"];
    newScorezone.replayButton = [[SKButton alloc] initWithImageNamedNormal:@"replay" selected:@"replay"];
    
    // These two values are used to animate the replay buttons up and down.
    newScorezone.buttonStartingY        = -(93  + newScorezone.replayButton.size.height / 2.0);
    newScorezone.buttonEndingY          = -202;
    newScorezone.totalScoreStartingY    = -77;
    
    newScorezone.totalScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"helveticaNeue-Bold"];
    newScorezone.totalScoreLabel.position    = CGPointMake(0, newScorezone.totalScoreStartingY);
    newScorezone.totalScoreLabel.text        = @"";
    newScorezone.totalScoreLabel.fontColor   = [UIColor whiteColor];
    newScorezone.totalScoreLabel.fontSize    = 94.0f;
    newScorezone.totalScoreLabel.xScale      = 0.5;
    newScorezone.totalScoreLabel.yScale      = 0.5;
    newScorezone.totalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    newScorezone.totalScoreLabel.zPosition   = 1000;
    newScorezone.totalScoreLabel.name        = @"totalScoreLabel";
    [newScorezone addChild:newScorezone.totalScoreLabel];
    
    newScorezone.highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"helveticaNeue-Light"];
    newScorezone.highScoreLabel.position  = CGPointMake(0, newScorezone.totalScoreStartingY);
    newScorezone.highScoreLabel.text      = [NSString stringWithFormat:@"HIGH SCORE:"];
    newScorezone.highScoreLabel.fontSize  = 30.0f;
    newScorezone.highScoreLabel.fontColor = [UIColor whiteColor];
    newScorezone.highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    newScorezone.highScoreLabel.hidden    = YES;
    newScorezone.highScoreLabel.name      = @"highScorelabel";
    [newScorezone addChild:newScorezone.highScoreLabel];
    
    // The divider graphic below the
    newScorezone.dividerBar = [SKSpriteNode spriteNodeWithImageNamed:@"scoreDivider"];
    newScorezone.dividerBar.anchorPoint   = CGPointMake(0.5, 1);
    newScorezone.dividerBar.position      = CGPointMake(0, -93);
    [newScorezone addChild:newScorezone.dividerBar];
    
    newScorezone.soundToggle = [[SKButton alloc] initWithImageNamedNormal:@"sound_on" selected:@"sound_on"];
    newScorezone.soundToggle.anchorPoint = CGPointMake(1, 1);
    newScorezone.soundToggle.position    = CGPointMake(-333, -15);
    newScorezone.soundToggle.name        = @"sound_on";
    [newScorezone.soundToggle setTouchUpInsideTarget:newScorezone action:@selector(toggleSound)];
    [newScorezone addChild:newScorezone.soundToggle];
    
    newScorezone.exitButton  = [[SKButton alloc] initWithImageNamedNormal:@"exit" selected:@"exit"];
    newScorezone.exitButton.anchorPoint  = CGPointMake(0, 1);
    newScorezone.exitButton.position     = CGPointMake(333, -15);
    [newScorezone.exitButton setTouchUpInsideTarget:newScorezone action:@selector(exit)];
    [newScorezone addChild:newScorezone.exitButton];
    
    newScorezone.shareButton.position    = CGPointMake(-247, newScorezone.buttonStartingY);
    newScorezone.shareButton.alpha       = 0.0;
    newScorezone.shareButton.isEnabled   = NO;
    newScorezone.shareButton.name        = @"shareButton";
    [newScorezone.shareButton setTouchUpInsideTarget:newScorezone action:@selector(share)];
    [newScorezone addChild:newScorezone.shareButton];

    newScorezone.replayButton.position   = CGPointMake(247, newScorezone.buttonStartingY);
    newScorezone.replayButton.alpha      = 0.0;
    newScorezone.replayButton.isEnabled  = NO;
    [newScorezone.replayButton setTouchUpInsideTarget:newScorezone action:@selector(replay)];
    [newScorezone addChild:newScorezone.replayButton];
    
    newScorezone.totalScoreEndingY       = newScorezone.buttonEndingY - newScorezone.replayButton.size.height / 2.0;
    
    newScorezone.ballLivesSprites = [NSMutableArray new];
    
    [newScorezone setupBallLivesSprites];
    
    return newScorezone;
}

- (void)setupBallLivesSprites {
    for (int i = 0; i < self.gameScene.ballLives; i++) {
        SKSpriteNode *turnsBall = [Ball newBall];
        turnsBall.position = CGPointMake(-275 + (i * (turnsBall.size.width / 2.0)), -25);
        turnsBall.texture  = [[PegColors iotaColors] objectAtIndex:i];
        turnsBall.physicsBody.dynamic = NO;
        turnsBall.name     = @"turnsBall";
        [self.ballLivesSprites addObject:turnsBall];
        [self addChild:turnsBall];
    }
}

- (void)clearBallLivesSprites {
    if (self.ballLivesSprites.count) {
        [self.ballLivesSprites removeAllObjects];
        [self enumerateChildNodesWithName:@"turnsBall" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];        
    }
}

- (void)presentGameOverButtonsWithScore:(int64_t)score andLocalHighScore:(int64_t)highScore {
    self.replayScreenPresented = YES;
    SKAction *moveDown = [SKAction moveTo:CGPointMake(self.totalScoreLabel.position.x, self.totalScoreEndingY) duration:0.15];
    SKAction *scaleUp  = [SKAction scaleBy:2 duration:0.2];
    SKAction *moveDownScaleUp = [SKAction sequence:@[moveDown, scaleUp]];
    moveDownScaleUp.timingMode = SKActionTimingEaseOut;
    
    if ([[YSIotaSE sharedSE] canPlaySound]) {
        [self runAction:[self swoosh]];
    }
    
    [self.totalScoreLabel runAction:moveDownScaleUp completion:^{
        for (SKButton *button in @[self.shareButton, self.replayButton]) {
            SKAction *moveDown = [SKAction moveTo:CGPointMake(button.position.x, self.buttonEndingY) duration:0.2];
            SKAction *fadeIn   = [SKAction fadeInWithDuration:0.2];
            SKAction *fadeInMoveDown = [SKAction group:@[moveDown, fadeIn]];
            [button runAction:fadeInMoveDown completion:^{
                button.isEnabled = YES;
            }];
        }
    }];
}

- (void)share {
    UIGraphicsBeginImageContextWithOptions(self.gameScene.frame.size, NO, [UIScreen mainScreen].scale);
    
    [self.gameScene.view drawViewHierarchyInRect:self.gameScene.frame afterScreenUpdates:YES];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *scoreString = [NSString stringWithFormat:@"I just got %@ in iota! https://itunes.apple.com/us/app/id828498770", self.totalScoreLabel.text];
    
    NSArray *activityItems = @[scoreString, snapshot];
    
    UIShareAcitivityViewController *activityVC = [[UIShareAcitivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [activityVC setValue:@"Check out my iota score!" forKey:@"subject"];

    [self.gameScene.mainMenuViewController presentViewController:activityVC animated:YES completion:^{
        
    }];
}

- (void)replay {
    self.highScoreLabel.hidden = YES;
    SKAction *moveUp    = [SKAction moveTo:CGPointMake(self.totalScoreLabel.position.x, self.totalScoreStartingY) duration:0.15];
    SKAction *scaleDown = [SKAction scaleBy:.5 duration:0.2];
    
    SKAction *moveUpScaleDown;
    moveUpScaleDown.timingMode = SKActionTimingEaseOut;
    
    if ([[YSIotaSE sharedSE] canPlaySound]) {
        moveUpScaleDown = [SKAction sequence:@[scaleDown, [self swoosh], moveUp]];
    } else {
        moveUpScaleDown = [SKAction sequence:@[scaleDown, moveUp]];
    }
    
    SKAction *fadeIn    = [SKAction fadeOutWithDuration:0.2];
    SKAction *wait      = [SKAction waitForDuration:0.25];
    
    for (SKButton *button in @[self.shareButton]) {
        button.isEnabled = NO;
        SKAction *moveDown = [SKAction moveTo:CGPointMake(button.position.x, self.buttonStartingY) duration:0.2];
        SKAction *fadeInMoveDown = [SKAction group:@[moveDown, fadeIn, wait]];
        fadeInMoveDown.timingMode = SKActionTimingEaseOut;
        
        [button runAction:fadeInMoveDown completion:^{
            
        }];
    }
    
    for (SKButton *button in @[self.replayButton]) {
        button.isEnabled = NO;
        SKAction *moveDown = [SKAction moveTo:CGPointMake(button.position.x, self.buttonStartingY) duration:0.2];
        SKAction *fadeInMoveDown = [SKAction group:@[moveDown,fadeIn, wait]];
        fadeInMoveDown.timingMode = SKActionTimingEaseOut;
        
        [button runAction:fadeInMoveDown completion:^{
            self.highScoreLabel.hidden = YES;
            [self.totalScoreLabel runAction:moveUpScaleDown completion:^{
                [self.gameScene resetGame];
                [self.gameScene presentTheFingerSprite];
                self.replayScreenPresented = NO;
            }];
        }];
    }
    
}

- (void)toggleSound {
    if ([self.soundToggle.name isEqualToString:@"sound_on"]) {
        self.soundToggle.name = @"sound_off";
        [self.soundToggle runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"sound_off"]]];
        [[YSIotaSE sharedSE] setCanPlaySound:NO];
    } else {
        self.soundToggle.name = @"sound_on";
        [self.soundToggle runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"sound_on"]]];
        [[YSIotaSE sharedSE] setCanPlaySound:YES];
    }
}

- (SKAction *)swoosh {
    return [SKAction playSoundFileNamed:@"swoosh.mp3" waitForCompletion:NO];
}

- (void)removeNodesAndExittoMenu {
    self.highScoreLabel.hidden = YES;
    
    [self.gameScene enumerateChildNodesWithName:@"finger" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self.gameScene resetGame];
    
    [self.gameScene.view presentScene:self.gameScene.mainMenuViewController.mainMenu transition:[SKTransition fadeToBlackOneSecondDuration]];
}

- (void)exit {
    if (self.replayScreenPresented) {
        SKAction *moveUp    = [SKAction moveTo:CGPointMake(self.totalScoreLabel.position.x, self.totalScoreStartingY) duration:0.15];
        SKAction *scaleDown = [SKAction scaleBy:.5 duration:0.2];
        
        SKAction *moveUpScaleDown;
        moveUpScaleDown.timingMode = SKActionTimingEaseOut;
        moveUpScaleDown = [SKAction sequence:@[scaleDown, moveUp]];
        
        SKAction *fadeIn    = [SKAction fadeOutWithDuration:0.2];
        SKAction *wait      = [SKAction waitForDuration:0.25];
        
        SKAction *moveDown = [SKAction moveBy:CGVectorMake(0, self.buttonStartingY - self.buttonEndingY) duration:0.2];
        SKAction *fadeInMoveDown = [SKAction group:@[moveDown, fadeIn, wait]];
        fadeInMoveDown.timingMode = SKActionTimingEaseOut;
        
        for (SKButton *button in @[self.shareButton]) {
            
            button.isEnabled = YES;
            [button runAction:fadeInMoveDown completion:^{
                self.replayScreenPresented = NO;
            }];
        }
        
        for (SKButton *button in @[self.replayButton]) {
            SKAction *moveDown = [SKAction moveTo:CGPointMake(button.position.x, self.buttonStartingY) duration:0.2];
            SKAction *fadeInMoveDown = [SKAction group:@[moveDown,fadeIn, wait]];
            fadeInMoveDown.timingMode = SKActionTimingEaseOut;
            
            button.isEnabled = YES;
            [button runAction:fadeInMoveDown completion:^{
                
                [self.totalScoreLabel runAction:moveUpScaleDown completion:^{
                    [self removeNodesAndExittoMenu];
                }];
            }];
        }
    } else {
        [self removeNodesAndExittoMenu];
    }
}

#pragma mark - Setter Methods

- (void)setScoreLabel:(SKLabelNode *)scoreLabel withMultiplier:(int)multiplier withScore:(int)score {
    _scoreLabel = scoreLabel;
    
    NSString *scoreString = [[NSNumberFormatter commaFormattedNumber] stringFromNumber:[NSNumber numberWithInt:score]];
    NSString *totalScoreString = [[NSNumberFormatter commaFormattedNumber] stringFromNumber:[NSNumber numberWithInt:(multiplier * score)]];
    
    _scoreLabel.text = [NSString stringWithFormat:@"%d x %@", multiplier, scoreString];
    _totalScoreLabel.text = totalScoreString;
    SKAction *scaleUp = [SKAction scaleBy:1.2 duration:0.03];
    [_scoreLabel runAction:[SKAction sequence:@[scaleUp, [scaleUp reversedAction]]]];
}

- (void)setHighScoreLabel:(SKLabelNode *)highScoreLabel withScore:(int64_t)score andHighScore:(int64_t)highscore{
    _highScoreLabel        = highScoreLabel;
    _highScoreLabel.hidden = NO;
    
    NSString *scoreString;
    
    if (score > highscore || highscore == 0 || !highscore) {
        scoreString = [[NSNumberFormatter commaFormattedNumber] stringFromNumber:[NSNumber numberWithLongLong:score]];
        self.highScoreLabel.fontColor = [SKColor colorWithRed:223.0/255.0 green:90.0/255.0 blue:73.0/255.0 alpha:1.0]; // iota red
        self.highScoreLabel.text      = [NSString stringWithFormat:@"NEW HIGH SCORE: %@", scoreString];
        
    } else {
        scoreString = [[NSNumberFormatter commaFormattedNumber] stringFromNumber:[NSNumber numberWithLongLong:highscore]];
        self.highScoreLabel.fontColor = [SKColor whiteColor];
        self.highScoreLabel.text      = [NSString stringWithFormat:@"HIGH SCORE: %@", scoreString];
    }
}

@end











