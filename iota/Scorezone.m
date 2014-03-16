//
//  Scorezone.m
//  Iota
//
//  Created by Ivan Lesko on 3/13/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "Scorezone.h"

@implementation Scorezone

+ (Scorezone *)createNewScoreZoneAtPosition:(CGPoint)position withGameScene:(IotaGameScene *)gameScene {
    Scorezone *newScorezone = [Scorezone node];
    newScorezone.position  = position;
    newScorezone.gameScene = gameScene;
    
    newScorezone.score = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
    newScorezone.score.position         = CGPointMake(0, -34);
    newScorezone.score.text             = @"0 x 0";
    newScorezone.score.fontColor        = [UIColor whiteColor];
    newScorezone.score.fontSize         = 25.0f;
    newScorezone.score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [newScorezone addChild:newScorezone.score];
    
    newScorezone.shareButton = [[SKButton alloc] initWithImageNamedNormal:@"share" selected:@"share"];
    newScorezone.replayButton = [[SKButton alloc] initWithImageNamedNormal:@"replay" selected:@"replay"];
    
    // These two values are used to animate the replay buttons up and down.
    newScorezone.buttonStartingY        = -(93  + newScorezone.replayButton.size.height / 2.0);
    newScorezone.buttonEndingY          = -202;
    newScorezone.totalScoreStartingY    = -77;
    
    newScorezone.totalScore = [SKLabelNode labelNodeWithFontNamed:@"helveticaNeue-Bold"];
    newScorezone.totalScore.position    = CGPointMake(0, newScorezone.totalScoreStartingY);
    newScorezone.totalScore.text        = @"";
    newScorezone.totalScore.fontColor   = [UIColor whiteColor];
    newScorezone.totalScore.fontSize    = 94.0f;
    newScorezone.totalScore.xScale      = 0.5;
    newScorezone.totalScore.yScale      = 0.5;
    newScorezone.totalScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [newScorezone addChild:newScorezone.totalScore];
    
    newScorezone.highScore = [SKLabelNode labelNodeWithFontNamed:@"helveticaNeue-Light"];
    newScorezone.highScore.position  = CGPointMake(0, 71);
    newScorezone.highScore.text      = @"NEW HIGH SCORE!";
    newScorezone.highScore.fontSize  = 25.0f;
    newScorezone.highScore.fontColor = [UIColor colorWithRed:223.0/255.0 green:90.0/255.0 blue:73.0/255.0 alpha:1.0]; // iota red color.
    newScorezone.highScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [newScorezone addChild:newScorezone.highScore];
    
    // The divider graphic below the
    SKSpriteNode *divider = [SKSpriteNode spriteNodeWithImageNamed:@"scoreDivider"];
    divider.anchorPoint   = CGPointMake(0.5, 1);
    divider.position      = CGPointMake(0, -93);
    [newScorezone addChild:divider];
    
    newScorezone.soundToggle = [[SKButton alloc] initWithImageNamedNormal:@"sound_on" selected:@"sound_on" disabled:@"sound_off"];
    newScorezone.soundToggle.anchorPoint = CGPointMake(1, 1);
    newScorezone.soundToggle.position    = CGPointMake(-333, -15);
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
    [newScorezone.shareButton setTouchUpInsideTarget:newScorezone action:@selector(share)];

    newScorezone.replayButton.position   = CGPointMake(247, newScorezone.buttonStartingY);
    newScorezone.replayButton.alpha      = 0.0;
    newScorezone.replayButton.isEnabled  = NO;
    [newScorezone.replayButton setTouchUpInsideTarget:newScorezone action:@selector(replay)];
    
    newScorezone.totalScoreEndingY      = newScorezone.buttonEndingY - newScorezone.replayButton.size.height / 2.0;
    
    newScorezone.ballLivesSprites = [NSMutableArray new];
    [newScorezone setupBallLivesSprites];
    
    return newScorezone;
}

- (void)setupBallLivesSprites {
    for (int i = 0; i < self.gameScene.ballLives; i++) {
        SKSpriteNode *turnsBall = [Ball newBall];
        turnsBall.position = CGPointMake(-275 + (i * (turnsBall.size.width / 2.0)), -25);
        turnsBall.texture  = [[PegColors iOSColors] objectAtIndex:i + 1];
        turnsBall.physicsBody.dynamic = NO;
        [self.ballLivesSprites addObject:turnsBall];
        [self addChild:turnsBall];
    }
}

- (void)presentGameOverButtons {
    SKAction *moveDown = [SKAction moveTo:CGPointMake(self.totalScore.position.x, self.totalScoreEndingY) duration:0.15];
    SKAction *scaleUp  = [SKAction scaleBy:2 duration:0.2];
    SKAction *moveDownScaleUp = [SKAction sequence:@[moveDown, scaleUp]];
    moveDownScaleUp.timingMode = SKActionTimingEaseOut;
    
    [self runAction:[SKAction playSoundFileNamed:@"swoosh.mp3" waitForCompletion:NO]];
    
    [self.totalScore runAction:moveDownScaleUp completion:^{
        for (SKButton *button in @[self.shareButton, self.replayButton]) {
            [self addChild:button];
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
    NSLog(@"sharing");
}

- (void)replay {
    SKAction *moveUp    = [SKAction moveTo:CGPointMake(self.totalScore.position.x, self.totalScoreStartingY) duration:0.15];
    SKAction *scaleDown = [SKAction scaleBy:.5 duration:0.2];
    SKAction *swoosh    = [SKAction playSoundFileNamed:@"swoosh.mp3" waitForCompletion:NO];
    SKAction *moveUpScaleDown = [SKAction sequence:@[scaleDown, swoosh, moveUp]];
    moveUpScaleDown.timingMode = SKActionTimingEaseOut;
    
    SKAction *fadeIn    = [SKAction fadeOutWithDuration:0.2];
    SKAction *wait      = [SKAction waitForDuration:0.25];
    
    for (SKButton *button in @[self.shareButton]) {
        SKAction *moveDown = [SKAction moveTo:CGPointMake(button.position.x, self.buttonStartingY) duration:0.2];
        SKAction *fadeInMoveDown = [SKAction group:@[moveDown, fadeIn, wait]];
        fadeInMoveDown.timingMode = SKActionTimingEaseOut;
        
        button.isEnabled = YES;
        [button runAction:fadeInMoveDown completion:^{
            [button removeFromParent];
        }];
    }
    
    for (SKButton *button in @[self.replayButton]) {
        SKAction *moveDown = [SKAction moveTo:CGPointMake(button.position.x, self.buttonStartingY) duration:0.2];
        SKAction *fadeInMoveDown = [SKAction group:@[moveDown,fadeIn, wait]];
        fadeInMoveDown.timingMode = SKActionTimingEaseOut;
        
        button.isEnabled = YES;
        [button runAction:fadeInMoveDown completion:^{
            [button removeFromParent];
            
            [self.totalScore runAction:moveUpScaleDown completion:^{
                [self.gameScene resetGame];
            }];
        }];
    }
}

- (void)toggleSound {
    NSLog(@"toggle sound");
}

- (void)exit {
    NSLog(@"exit");
}

@end















