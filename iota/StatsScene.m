//
//  StatsScene.m
//  iota
//
//  Created by Luda on 4/3/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "StatsScene.h"
#import "Stats.h"

@implementation StatsScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"statsScreenBackground"];
        background.position = CGPointMake(size.width / 2.0, size.height / 2.0);
        [self addChild:background];
        
        SKNode *container = [SKNode node];
        container.position = CGPointMake(384, 865);
        [self addChild:container];
        
        NSArray *stringValues = @[@"high score",
                                  @"lowest score",
                                  @"total points earned",
                                  @"games played",
                                  @"balls played",
                                  @"highest multiplier",
                                  @"total pegs lit"
                                  ];
        
        NSArray *statKeys     = @[kIOLocalHighScoreKey,
                                  kIOLowestScoreKey,
                                  kIOTotalPointsEarnedKey,
                                  kIOTotalGamesPlayedKey,
                                  kIOTotalBallsPlayedKey,
                                  kIOHighestMultiplierKey,
                                  kIOTotalPegsLitKey];
        
        CGFloat spacing = 60.0f;
        
        NSMutableDictionary *stats = [Stats sharedInstance].statsDict;
        
        for (int i = 0; i < stringValues.count; i++) {
            NSNumber *value = [stats objectForKey:statKeys[i]];
            [container addChild:[self createStatRowAtPosition:CGPointMake(0, -(spacing * i))
                                                    withTitle:stringValues[i]
                                               withTitleColor:[SKColor whiteColor]
                                                    withValue:[[NSNumberFormatter commaFormattedNumber] stringFromNumber:value]
                                                  withDivider:YES]];
        }
        
        SKButton *exitButton = [[SKButton alloc] initWithImageNamed:@"exit"];
        exitButton.position = CGPointMake(735, 924);
        [exitButton setTouchUpTarget:self action:@selector(presentMainMenu)];
        [self addChild:exitButton];
    }
    
    return self;
}

- (SKNode *)createStatRowAtPosition:(CGPoint)position
                          withTitle:(NSString *)title
                     withTitleColor:(SKColor *)titleColor
                          withValue:(NSString *)value
                        withDivider:(BOOL)divider {
    
    SKNode *row = [SKNode node];
    row.position = position;
    
    if (divider) {
        SKSpriteNode *dividerBar = [SKSpriteNode spriteNodeWithImageNamed:@"statsScreen_dividerBar"];
        dividerBar.position = CGPointZero;
        dividerBar.anchorPoint = CGPointMake(0.5, 1);
        [row addChild:dividerBar];
    }
    
    SKLabelNode *titleNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
    titleNode.text      = title;
    titleNode.position  = CGPointMake(-285, -32);
    titleNode.fontColor = titleColor;
    titleNode.fontSize  = 30.0f;
    titleNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [row addChild:titleNode];
    
    SKLabelNode *valueNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
    valueNode.text      = value;
    valueNode.position  = CGPointMake(285, -32);
    valueNode.fontColor = [SKColor whiteColor];
    valueNode.fontSize  = 30.0f;
    valueNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [row addChild:valueNode];
    
    return row;
}

- (void)presentMainMenu {
    [self.view presentScene:self.mainMenu transition:[SKTransition fadeToBlackOneSecondDuration]];
}

@end
