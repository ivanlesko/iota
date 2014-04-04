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
#import "AppDelegate.h"

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *)self.view;
    spriteView.showsDrawCount = NO;
    spriteView.showsFPS       = NO;
    spriteView.showsNodeCount = NO;
    
    self.mainMenu = [[MainMenu alloc] initWithSize:CGSizeMake(768, 1024)];
    self.mainMenu.mainMenuViewController = self;
    
    [spriteView presentScene:self.mainMenu];
    
    self.iotaGameScene = [[IotaGameScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.iotaGameScene.mainMenuViewController = self;
    [self.iotaGameScene createContent];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.iotaGameScene = self.iotaGameScene;
    appDelegate.gameCenterManager.delegate = self.iotaGameScene;
    [appDelegate.gameCenterManager authenticateLocalUser];
    
    self.adView.alpha = 0.0f;
    
    self.mainMenu.gameScene = self.iotaGameScene;
    
    NSString *docDirPathString;
    docDirPathString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    docDirPathString = [docDirPathString stringByAppendingPathComponent:@"Stats.plist"]; // Than make it specific with your plist's name.
    
    // You need a NSFileManager to manage and check any files.
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    
    // Tell you NSFileManager to check if that plist is in your docDir.
    if (![myFileManager fileExistsAtPath:docDirPathString]) {
        // If not, then we need to setup the address to the Main Bundle and get the plist from there instead.
        NSString *mainBundleSourcePathString = [[NSBundle mainBundle] pathForResource:@"Stats" ofType:@"plist"];
        // And tell the NSFileManager to copy that file into our docDir, so we never need to look back at our Main Bundle again.
        [myFileManager copyItemAtPath:mainBundleSourcePathString toPath:docDirPathString error:nil];
        NSLog(@"the plist does not exist and we create it");
    } else {
        NSLog(@"the plist DOES exist");
    }
    
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
                             banner.alpha = 1.0;
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
                             banner.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             self.bannerIsVisible = NO;
                         }];
    }
}

@end













