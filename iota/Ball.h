//
//  Ball.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface Ball : SKSpriteNode

@property (nonatomic) int currentColor;
@property (nonatomic) BOOL isDead; // When a ball hits a score detector, it becomes dead.
                                   // A ball can't hit another score detector if it is dead.

+ (Ball *)newBall;

@end
