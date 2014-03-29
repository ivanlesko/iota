//
//  MainMenu.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/23/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

#import "MainMenuViewController.h"
#import "GameCenterManager.h"
#import "IotaGameScene.h"
#import "SKButton.h"

@class MainMenuViewController;
@class IotaGameScene;

@interface MainMenu : SKScene <GameCenterManagerDelegate, GKGameCenterControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MainMenuViewController *mainMenuViewController;
@property (nonatomic) IotaGameScene *gameScene;

@end
