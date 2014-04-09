//
//  MainMenu.m
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/23/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "MainMenu.h"
#import "IotaGameScene.h"
#import "SKButton.h"
#import "YSIotaSE.h"
#import "CreditsScene.h"
#import "StatsScene.h"
#import "GameCenterManager.h"

@interface MainMenu() {
    NSString *currentLeaderboard;
}

@property (nonatomic) BOOL contentCreated;

@end

@implementation MainMenu


- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createContent];
        self.contentCreated = YES;
    }
}

- (void)createContent {
    self.backgroundColor = [SKColor colorWithRed:33.0 / 255.0
                                           green:35.0 / 255.0
                                            blue:37.0 / 255.0
                                           alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"iota"];
    logo.anchorPoint   = CGPointMake(0.5, 0);
    logo.position      = CGPointMake(CGRectGetMidX(self.frame), 727);
    [self addChild:logo];
    
    SKNode *buttonsContainer = [SKNode node];
    buttonsContainer.position = CGPointMake(CGRectGetMidX(self.frame), 603);
    [self addChild:buttonsContainer];
    
    NSArray *buttons = @[
                         @"mainMenu_play",
                         @"mainMenu_stats",
                         @"mainMenu_leaderboard",
                         @"mainMenu_rate",
                         @"mainMenu_credits"
                         ];
    
    SEL selectors[] = {
                        @selector(playGame),
                        @selector(presentStatsScreen),
                        @selector(presentLeaderboard),
                        @selector(rateTheApp),
                        @selector(presentCreditsScreen),
                      };
    
    CGFloat spacing = 65.0f;
    
    for (int i = 0; i < buttons.count; i++) {
        SKButton *button = [[SKButton alloc] initWithImageNamed:buttons[i]];
        button.anchorPoint = CGPointMake(0.5, 1);
        button.position    = CGPointMake(0, -(spacing * i));
        [button setTouchDownTarget:self action:selectors[i]];
        [buttonsContainer addChild:button];
    }
    
    SKNode *socialContainer = [SKNode node];
    socialContainer.position = CGPointMake(CGRectGetMidX(self.frame), 110);
    [self addChild:socialContainer];
    
    SKButton *twitter = [[SKButton alloc] initWithImageNamed:@"twitter"];
    twitter.position  = CGPointMake(-48.0, 0);
    [twitter setTouchDownTarget:self action:@selector(goToTwitter)];
    [socialContainer addChild:twitter];
    
    SKButton *facebook = [[SKButton alloc] initWithImageNamed:@"facebook"];
    facebook.position  = CGPointMake(48.0, 0);
    [facebook setTouchDownTarget:self action:@selector(goToFacebook)];
    [socialContainer addChild:facebook];
}

- (void)playGame {
    [self.view presentScene:self.gameScene transition:[SKTransition fadeToBlackOneSecondDuration]];
}

- (void)presentLeaderboard {
    GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
    if (leaderboardController != NULL) {
        leaderboardController.gameCenterDelegate = self.mainMenuViewController;
        [self.view.window.rootViewController presentViewController:leaderboardController animated:YES completion:nil];
    }
}   

- (void)presentCreditsScreen {
    CreditsScene *creditsScene = [[CreditsScene alloc] initWithSize:self.frame.size];
    creditsScene.mainMenu      = self;
    [self.view presentScene:creditsScene transition:[SKTransition fadeToBlackOneSecondDuration]];
}

- (void)presentStatsScreen {
    StatsScene *statsScene = [[StatsScene alloc] initWithSize:self.frame.size];
    statsScene.mainMenu = self;
    [self.view presentScene:statsScene transition:[SKTransition fadeToBlackOneSecondDuration]];
}

- (void)rateTheApp {
    UIAlertView *rateAlert = [[UIAlertView alloc] initWithTitle:@"Fan of iota?"
                                                        message:@"Show some love by rating this app."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Rate iota!", nil];
    
    [rateAlert show];
}

- (void)goToTwitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/_ivonski"]];
    [self.gcm submitAchievement:iotaAchievementTwitter percentComplete:100.0];
}

- (void)goToFacebook {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Ivonski/630399290365944"]];
    [self.gcm submitAchievement:iotaAchievementFacebook percentComplete:100.0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id828498770"]];
            [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
            break;
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    return;
}


@end













