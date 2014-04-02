//
//  ScoreDetector.m
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "ScoreDetector.h"

@implementation ScoreDetector

+ (ScoreDetector *)newScoreDetectorWithSize:(CGSize)size {
    ScoreDetector *detector = [ScoreDetector spriteNodeWithColor:[UIColor redColor] size:size];
    detector.name  = kIOScoreDetectorName;
    detector.color = [SKColor clearColor];
    detector.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:detector.size];
    detector.physicsBody.dynamic = NO;
    detector.physicsBody.collisionBitMask = 0x0;
    detector.physicsBody.categoryBitMask  = kPKScoreDetectorCategory;
    detector.value = 0;
    
    return detector;
}



@end
