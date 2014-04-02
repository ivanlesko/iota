//
//  Ball.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface Ball : SKSpriteNode

/// The ball's current color.
@property (nonatomic) int currentColor;

/*
 * When a ball hits a score detector, it becomes dead.
 * A ball can't hit another score detector if it is dead.
 */
@property (nonatomic) BOOL isDead;

/// Creates a new instance of a ball with default values.
+ (Ball *)newBall;

@end
