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
    
    SKButton *playButton = [[SKButton alloc] initWithImageNamedNormal:@"play" selected:@"play"];
    playButton.anchorPoint = CGPointZero;
    playButton.position    = CGPointMake(269, 570);
    [playButton setTouchUpInsideTarget:self action:@selector(playGame)];
    [self addChild:playButton];
    
    SKButton *leaderboardButton = [[SKButton alloc] initWithImageNamedNormal:@"leaderboard" selected:@"leaderboard"];
    leaderboardButton.anchorPoint = CGPointZero;
    leaderboardButton.position    = CGPointMake(435, 570);
    [leaderboardButton setTouchUpInsideTarget:self action:@selector(showLeaderboard)];
    [self addChild:leaderboardButton];
    
    SKButton *rateButton = [[SKButton alloc] initWithImageNamed:@"rate"];
    rateButton.anchorPoint = CGPointMake(0.5, 0);
    rateButton.position    = CGPointMake(CGRectGetMidX(self.frame), 250);
    [rateButton setTouchUpInsideTarget:self action:@selector(rateTheApp)];
    [self addChild:rateButton];
    
    SKButton *creditsButton = [[SKButton alloc] initWithImageNamed:@"creditsButton"];
    creditsButton.anchorPoint = CGPointMake(0.5, 0);
    creditsButton.position    = CGPointMake(CGRectGetMidX(self.frame), 50);
    [creditsButton setTouchDownTarget:self action:@selector(presentCreditsScreen)];
    [self addChild:creditsButton];
}

- (void)playGame {
    [self.view presentScene:self.gameScene transition:[SKTransition fadeToBlackOneSecondDuration]];
}

- (void)showLeaderboard {
    GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
    if (leaderboardController != NULL) {
        leaderboardController.gameCenterDelegate = self.mainMenuViewController;
        [self.view.window.rootViewController presentViewController:leaderboardController animated:YES completion:nil];
    }
}   

- (void)rateTheApp {
    UIAlertView *rateAlert = [[UIAlertView alloc] initWithTitle:@"Fan of iota?"
                                                        message:@"Show some love by rating this app."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Rate iota!", nil];
    
    [rateAlert show];
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

- (void)presentCreditsScreen {
    CreditsScene *creditsScene = [[CreditsScene alloc] initWithSize:self.frame.size];
    creditsScene.mainMenu      = self;
    [self.view presentScene:creditsScene transition:[SKTransition fadeToBlackOneSecondDuration]];
}

@end













