//
//  AppDelegate.m
//  iota
//
//  Created by Ivan Lesko on 3/14/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>

#import <Parse/Parse.h>
#import "ParseHelper.h"

#import "NSUserDefaults+MPSecureUserDefaults.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.gameCenterManager = [[GameCenterManager alloc] init];
    [self.gameCenterManager authenticateLocalUser];
    
    self.iotaSE = [YSIotaSE sharedSE];
    [self.iotaSE prime];
    
    [[ParseHelper sharedHelper] setApplicationId];
    
    [self startAudio];
    
    [NSUserDefaults setSecret:@"secret"];

//    [[NSFileManager defaultManager] removeItemAtPath:[Stats statsFilePath] error:nil];
    if (!self.stats) self.stats = [Stats sharedInstance];
    
    
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if ([self.gameView.scene isKindOfClass:[IotaGameScene class]]) {
        self.gameView.scene.paused = YES;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self stopAudio];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([self.gameView.scene isKindOfClass:[IotaGameScene class]]) {
        self.gameView.scene.paused = NO;
    }
    
    [self startAudio];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if([GKLocalPlayer localPlayer].authenticated == NO)
	{
        [self.gameCenterManager authenticateLocalUser];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self stopAudio];
}

static BOOL isAudioSessionActive = NO;

- (void)startAudio {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    if (audioSession.otherAudioPlaying) {
        [audioSession setCategory: AVAudioSessionCategoryAmbient error:&error];
    } else {
        [audioSession setCategory: AVAudioSessionCategorySoloAmbient error:&error];
    }
    
    if (!error) {
        [audioSession setActive:YES error:&error];
        isAudioSessionActive = YES;
    }
}

- (void)stopAudio {
    // Prevent background apps from duplicate entering if terminating an app.
    if (!isAudioSessionActive) return;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    [audioSession setActive:NO error:&error];
    
    
    if (error) {
        // It's not enough to setActive:NO
        // We have to deactivate it effectively (without that error),
        // so try again (and again... until success).
        [self stopAudio];
    } else {
        isAudioSessionActive = NO;
    }
}

@end








