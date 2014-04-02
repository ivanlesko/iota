//
//  AppDelegate.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/19/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSIotaSE.h"

#import "IotaGameScene.h"
#import "GameCenterManager.h"
#import "Stats.h"

@class IotaGameScene;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) YSIotaSE *iotaSE;

@property (nonatomic, strong) IotaGameScene *iotaGameScene;

@property (nonatomic, strong) GameCenterManager *gameCenterManager;

@property (nonatomic, strong) SKView *gameView;

@property (nonatomic, strong) Stats *stats;

@end
