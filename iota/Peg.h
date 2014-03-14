//
//  Peg.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "IotaGameScene.h"

@interface Peg : SKSpriteNode

@property (nonatomic) BOOL multiplier;
@property (nonatomic) BOOL wasHitThisRound;
@property (nonatomic) int colorCount;

+ (Peg *)newPeg;

@end
