//
//  ScoreDetector.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreDetector : SKSpriteNode

@property (nonatomic) int value;

+ (ScoreDetector *)newScoreDetectorWithSize:(CGSize)size;

@end
