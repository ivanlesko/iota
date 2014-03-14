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

#import "AppSpecificValues.h"
#import "GameCenterManager.h"

#import "IotaGameScene.h"

@interface MainMenu : SKScene <GameCenterManagerDelegate, GKGameCenterControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MainMenuViewController *mainMenuViewController;
@property (nonatomic) IotaGameScene *gameScene;

@end
