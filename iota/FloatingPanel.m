//
//  FloatingPanel.m
//  iota
//
//  Created by Ivan Lesko on 3/15/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "FloatingPanel.h"

@implementation FloatingPanel

+ (FloatingPanel *)createFloatingPanelAtYPosition:(CGPoint)point {
    FloatingPanel *newPanel = [FloatingPanel spriteNodeWithImageNamed:@"floatingPanel"];
    newPanel.position    = point;
    newPanel.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newPanel.size];
    newPanel.physicsBody.affectedByGravity = NO;
    newPanel.physicsBody.dynamic = NO;
    newPanel.physicsBody.restitution = 0.4;
    newPanel.physicsBody.friction    = 0.1;
    newPanel.physicsBody.categoryBitMask = kPKFloatingPanel;
    newPanel.physicsBody.collisionBitMask = kPKPegCategory;
    newPanel.physicsBody.contactTestBitMask = 0;
    
    return newPanel;
}

@end
