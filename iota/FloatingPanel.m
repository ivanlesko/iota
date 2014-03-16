//
//  FloatingPanel.m
//  iota
//
//  Created by Ivan Lesko on 3/15/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "FloatingPanel.h"

@implementation FloatingPanel

- (id)init {
    self = [super init];
    if (self) {
        
        SKShapeNode *node = [[SKShapeNode alloc] init];
        
        UIBezierPath *triangle = [UIBezierPath bezierPath];
        [triangle moveToPoint:CGPointZero];
        [triangle moveToPoint:CGPointMake(100, 0)];
        [triangle moveToPoint:CGPointMake(50, 100)];
        [triangle closePath];
        
        node.path        = triangle.CGPath;
        node.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:triangle.CGPath];
        node.fillColor   = [SKColor redColor];
        node.strokeColor = [SKColor blueColor];
        node.lineWidth   = 2;
        node.physicsBody.affectedByGravity = NO;
        node.physicsBody.dynamic = NO;
        node.physicsBody.restitution = 0.4;
        node.physicsBody.friction    = 0.1;
        node.physicsBody.categoryBitMask = kPKFloatingPanel;
        node.physicsBody.collisionBitMask = kPKPegCategory;
        node.physicsBody.contactTestBitMask = 0;
        
        [self addChild:node];
    }
    
    return self;
}

@end
