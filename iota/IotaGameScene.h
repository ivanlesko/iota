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
#import <CoreMotion/CoreMotion.h>

#import "Scorezone.h"

#import "Constants.h"

@interface IotaGameScene : SKScene <SKPhysicsContactDelegate, GameCenterManagerDelegate, UIAccelerometerDelegate>

@property (nonatomic, strong) MainMenuViewController *mainMenuViewController;
@property (nonatomic) BOOL contentCreated;
@property (nonatomic) int ballLives;
@property (nonatomic) int score;
@property (nonatomic) NSDecimalNumber *multiplier;

@property (nonatomic) kPKGameState gameState;

@property (nonatomic, strong) Scorezone *scorezone;

- (void)createContent;
- (void)resetGame;
- (void)presentTheFinger;

@end
