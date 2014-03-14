//
//  ScoreIndicators.m
//  Iota
//
//  Created by Ivan Lesko on 3/10/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "ScoreIndicators.h"

@interface ScoreIndicators()

@property (nonatomic) int indicatorZPos;

@end

@implementation ScoreIndicators

+ (ScoreIndicators *)createNewScoreIndicators {
    ScoreIndicators *indicators = [ScoreIndicators node];
    indicators.anchorPoint = CGPointZero;
    indicators.zPosition = 0;
    
    indicators.placeholders = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        NSMutableArray *placeholder = [NSMutableArray new];
        [indicators.placeholders addObject:placeholder];
    }
    
    return indicators;
}

- (void)insertIndicatorAtIndex:(NSUInteger)index withColor:(SKColor *)color {
    SKSpriteNode *indicator = [self indicatorWithColor:color];
    indicator.zPosition = self.indicatorZPos;
    self.indicatorZPos--;
    
    [[self.placeholders objectAtIndex:index] addObject:indicator];
    
    NSUInteger yIndex = [[self.placeholders objectAtIndex:index] indexOfObject:indicator];
    
    indicator.position = CGPointMake(50 * index, 10 * yIndex);
    
    [self addChild:indicator];
    
    indicator.position = CGPointMake(indicator.position.x, indicator.position.y - 10);
    
    SKAction *moveUp = [SKAction moveBy:CGVectorMake(0, 10) duration:0.1];
    moveUp.timingMode = SKActionTimingEaseIn;
    
    [indicator runAction:moveUp];
}

- (void)clearAllIndicators {
    // Remove the indicator from the scene.
    for (NSMutableArray *placeHolder in self.placeholders) {
        for (SKSpriteNode *indicator in placeHolder) {
            [indicator removeFromParent];
        }
    }
    
    // Remove each indicator from the placeholders.
    for (NSMutableArray *placeHolder in self.placeholders) {
        [placeHolder removeAllObjects];
    }
    
    self.indicatorZPos = 5;
}

/// Returns a new indicator with some default values.
- (SKSpriteNode *)indicatorWithColor:(SKColor *)color {
    SKSpriteNode *indicator = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(50, 10)];
    indicator.anchorPoint = CGPointZero;
    indicator.name = @"indicator";
    
    return indicator;
}

@end
