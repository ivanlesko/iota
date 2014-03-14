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
    
    newScorezone.totalScore = [SKLabelNode labelNodeWithFontNamed:@"helveticaNeue-Bold"];
    newScorezone.totalScore.position    = CGPointMake(0, -77);
    newScorezone.totalScore.text        = @"";
    newScorezone.totalScore.fontColor   = [UIColor whiteColor];
    newScorezone.totalScore.fontSize    = 47.0f;
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
    
    newScorezone.shareButton = [[SKButton alloc] initWithImageNamedNormal:@"share" selected:@"share"];
    newScorezone.shareButton.position    = CGPointMake(-247, -202);
    [newScorezone.shareButton setTouchUpInsideTarget:newScorezone action:@selector(share)];
    [newScorezone addChild:newScorezone.shareButton];
    
    newScorezone.replayButton = [[SKButton alloc] initWithImageNamedNormal:@"replay" selected:@"replay"];
    newScorezone.replayButton.position   = CGPointMake(247, -202);
    [newScorezone.replayButton setTouchUpInsideTarget:newScorezone action:@selector(replay)];
    [newScorezone addChild:newScorezone.replayButton];
    
    newScorezone.ballLivesSprites = [NSMutableArray new];
    
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

- (void)share {
    NSLog(@"sharing");
}

- (void)replay {
    [self.gameScene resetGame];
}

- (void)toggleSound {
    NSLog(@"toggle sound");
    self.soundToggle.isEnabled = !self.soundToggle.isEnabled;
}

- (void)exit {
    NSLog(@"exit");
}

@end















