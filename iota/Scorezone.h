//
//  Scorezone.h
//  Iota
//
//  Created by Ivan Lesko on 3/13/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SKButton.h"
#import "PegColors.h"
#import "IotaGameScene.h"

@interface Scorezone : SKNode

@property (nonatomic, strong) SKButton *soundToggle;
@property (nonatomic, strong) SKButton *exitButton;
@property (nonatomic, strong) SKLabelNode *score;
@property (nonatomic, strong) SKLabelNode *totalScore;
@property (nonatomic, strong) SKLabelNode *highScore;
@property (nonatomic, strong) SKButton *shareButton;
@property (nonatomic, strong) SKButton *replayButton;
@property (nonatomic, strong) NSMutableArray *ballLivesSprites;

/// The game scene the score zone belongs to.
@property (nonatomic, strong) IotaGameScene *gameScene;

+ (Scorezone *)createNewScoreZoneAtPosition:(CGPoint)position withGameScene:(IotaGameScene *)gameScene;

- (void)share;
- (void)replay;
- (void)toggleSound;
- (void)exit;

- (void)setupBallLivesSprites;
- (void)presentGameOverButtons;

@end
