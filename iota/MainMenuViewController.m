//
//  ViewController.m
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/19/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "MainMenuViewController.h"
#import "IotaGameScene.h"
#import "MainMenu.h"

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *)self.view;
    spriteView.showsDrawCount = NO;
    spriteView.showsFPS = NO;
    spriteView.showsNodeCount = NO;
    
    MainMenu *mainMenu = [[MainMenu alloc] initWithSize:CGSizeMake(768, 1024)];
    mainMenu.mainMenuViewController = self;
    
    [spriteView presentScene:mainMenu];
    
    self.iotaGameScene = [[IotaGameScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.iotaGameScene.mainMenuViewController = self;
    [self.iotaGameScene createContent];
    
    mainMenu.gameScene = self.iotaGameScene;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
         
#pragma mark - iAD Delegate Methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    if (!self.bannerIsVisible) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             banner.frame = CGRectOffset(banner.frame, 0, 66);
                             self.iotaGameScene.scorezone.position = CGPointMake(self.iotaGameScene.scorezone.position.x, self.iotaGameScene.scorezone.position.y - 66);
                         }
                         completion:^(BOOL finished) {
                             self.bannerIsVisible = YES;
                         }];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
        [UIView animateWithDuration:0.4
                         animations:^{
                             banner.frame = CGRectOffset(banner.frame, 0, -66);
                             self.iotaGameScene.scorezone.position = CGPointMake(self.iotaGameScene.scorezone.position.x, self.iotaGameScene.scorezone.position.y + 66);
                         }
                         completion:^(BOOL finished) {
                             self.bannerIsVisible = NO;
                         }];
    }
}

@end













