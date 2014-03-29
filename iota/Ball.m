//
//  Ball.m
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "Ball.h"
#import "PegColors.h"

@implementation Ball

+ (Ball *)newBall {
    Ball *ball = [Ball spriteNodeWithImageNamed:@"ball"];
    
    // Ball Physics
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(ball.size.width / 2) * 0.85];
    ball.physicsBody.dynamic = YES;
    ball.physicsBody.categoryBitMask = kPKBallCategory;
    ball.physicsBody.collisionBitMask = kPKPegCategory | kPKFloatingPanel | kPKBallCategory;
    ball.physicsBody.contactTestBitMask = kPKPegCategory | kPKScoreDetectorCategory ;
    ball.physicsBody.mass = 0.1;
    ball.physicsBody.friction = 0.1;
    ball.physicsBody.restitution = 0.6;
    ball.xScale = 0.85;
    ball.yScale = 0.85;
    ball.name = kPKBallName;
    ball.isDead = NO;
    ball.currentColor = 4;
    
    return ball;
}

- (void)setCurrentColor:(int)currentColor {
    _currentColor = currentColor;
    self.texture = [[PegColors iotaColors] objectAtIndex:_currentColor - 1];
}

@end
