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
#import "Scorezone.h"
#import "Reachability.h"
#import "Stats.h"
#import "SKButton.h"
#import "ScoreDetector.h"
#import "ScoreIndicators.h"
#import "MainMenu.h"
#import "YSIotaSE.h"
#import "AppDelegate.h"
#import "PegColors.h"
#import "GameCenterManager.h"
#import "ParseHelper.h"
#import "FingerSprite.h"

@interface IotaGameScene : SKScene <SKPhysicsContactDelegate, GameCenterManagerDelegate, UIAccelerometerDelegate>

/// The scene needs a pointer to the main view controller.
@property (nonatomic, strong) MainMenuViewController *mainMenuViewController;

/// Determine's whether or not the scene has created content or not.
@property (nonatomic) BOOL contentCreated;

/// How many lives the user has left.
@property (nonatomic) int ballLives;

/// Score is how many points the user has scored BEFORE applying the multiplier;
@property (nonatomic) int score;

/// The multiplier is how many pegs the user has lit up.
@property (nonatomic) NSDecimalNumber *multiplier;

@property (nonatomic) Stats *stats;

/// The scorezone is the top portion of the game scene that shows the scores, lives left, and replay buttons.
@property (nonatomic, strong) Scorezone *scorezone;

/// The current Game Center leaderboard that score will be submitted to.
@property (nonatomic, strong) GKLeaderboard *currentLeaderboard;
@property (nonatomic, strong) NSString *currentLeaderboardIdentifier;

- (void)createContent;
- (void)resetGame;
- (void)presentTheFingerSprite;

/// Reloads the user's high score from Game Center.  
- (void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error;

@end
