//
//  Scorezone.h
//  Iota
//
//  Created by Ivan Lesko on 3/13/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SKButton.h"
#import "PegColors.h"
#import "IotaGameScene.h"

@interface Scorezone : SKNode

@property (nonatomic, strong) SKButton *soundToggle;
@property (nonatomic, strong) SKButton *exitButton;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) SKLabelNode *totalScoreLabel;
@property (nonatomic, strong) SKLabelNode *highScoreLabel;
@property (nonatomic, strong) SKButton *shareButton;
@property (nonatomic, strong) SKButton *replayButton;
@property (nonatomic, strong) NSMutableArray *ballLivesSprites;

/// The divider bar that displays below the score.
/// We need this sprite to be publicly visible to determine
/// the highest point on the screen that the ball can be dropped.
@property (nonatomic, strong) SKSpriteNode *dividerBar;

/// The ending Y position of the share and replay button.
@property (nonatomic) CGFloat buttonEndingY;

/// The starting Y position of the share and replay button.
@property (nonatomic) CGFloat buttonStartingY;

/// The starting Y position of the total score label.
@property (nonatomic) CGFloat totalScoreStartingY;

/// The ending Y position of the total score label.
@property (nonatomic) CGFloat totalScoreEndingY;

/// If the replay screen buttons are currently presented.
@property (nonatomic) BOOL replayScreenPresented;

/// The game scene the score zone belongs to.
@property (nonatomic, strong) IotaGameScene *gameScene;

+ (Scorezone *)createNewScoreZoneAtPosition:(CGPoint)position withGameScene:(IotaGameScene *)gameScene;

/// Share the current game via sms, email, or twitter.
- (void)share;

/// Restart the current game.
- (void)replay;

/// Toggle's the game scene's sound on and off.
- (void)toggleSound;

/// Exits to the main menu.
- (void)exit;

/// Creates the ball lives sprites in the top left corner.
/// Indicates to the user how many balls are left in the current round.
- (void)setupBallLivesSprites;

/// When the user ran out of lives, present the total score, share, and replay button.
- (void)presentGameOverButtonsWithScore:(int64_t)score andCachedHighScore:(int64_t)highScore;

/// Resets the ball live sprites when entering the iota game scene.
- (void)clearBallLivesSprites;

- (void)setScoreLabel:(SKLabelNode *)scoreLabel withMultiplier:(int)multiplier withScore:(int)score;

@end







