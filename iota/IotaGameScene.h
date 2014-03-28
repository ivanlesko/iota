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

#import "AppSpecificValues.h"

#import "Scorezone.h"

#import "Constants.h"

#import  "Reachability.h"

@interface IotaGameScene : SKScene <SKPhysicsContactDelegate, GameCenterManagerDelegate, UIAccelerometerDelegate>

@property (nonatomic, strong) MainMenuViewController *mainMenuViewController;
@property (nonatomic) BOOL contentCreated;
@property (nonatomic) int ballLives;
@property (nonatomic) int score;
@property (nonatomic) NSDecimalNumber *multiplier;

@property (nonatomic) kPKGameState gameState;

@property (nonatomic, strong) Scorezone *scorezone;

@property (nonatomic, strong) GKLeaderboard *currentLeaderboard;
@property (nonatomic, strong) NSString *currentLeaderboardIdentifier;
@property (nonatomic) int64_t cachedHighestScore;

- (void)createContent;
- (void)resetGame;
- (void)presentTheFinger;

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;

@end
