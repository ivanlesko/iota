//
//  ViewController.h
//  SpriteWalkthrough
//

//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import "MainMenu.h"
#import "GameCenterManager.h"

@class IotaGameScene;

@interface MainMenuViewController : UIViewController <GKGameCenterControllerDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@property (nonatomic, strong) IotaGameScene *iotaGameScene;
@property (nonatomic, strong) MainMenu *mainMenu;
@property (nonatomic, strong) GameCenterManager *gcm;
@property (nonatomic) BOOL bannerIsVisible;

@end
