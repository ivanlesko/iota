//
//  ScoreIndicators.h
//  Iota
//
//  Created by Ivan Lesko on 3/10/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreIndicators : SKSpriteNode

@property (nonatomic, strong) NSMutableArray *placeholders;

+ (ScoreIndicators *)createNewScoreIndicators;

/// Inserts a new score indicator at a given index with the current ball color.
- (void)insertIndicatorAtIndex:(NSUInteger)index withColor:(SKColor *)color;

/// Removes all indicators from the placeholders after the round is over.
- (void)clearAllIndicators;

@end
