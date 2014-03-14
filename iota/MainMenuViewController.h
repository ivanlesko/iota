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

@class IotaGameScene;

@interface MainMenuViewController : UIViewController <GKGameCenterControllerDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@property (nonatomic) IotaGameScene *iotaGameScene;

@end
