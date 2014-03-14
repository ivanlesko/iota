//
//  PlinkoScene.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/19/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

#import "MainMenuViewController.h"

#import "GameCenterManager.h"
#import "AppSpecificValues.h"

@interface IotaGameScene : SKScene <SKPhysicsContactDelegate, GameCenterManagerDelegate>

@property (nonatomic, strong) MainMenuViewController *mainMenuViewController;
@property (nonatomic) BOOL contentCreated;
@property (nonatomic) int ballLives;

- (void)createContent;
- (void)resetGame;

@end
