//
//  Peg.m
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "Peg.h"

#import "PegColors.h"

@implementation Peg

+ (Peg *)newPeg {
    Peg *peg = [Peg spriteNodeWithImageNamed:@"peg"];
    peg.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:peg.size.width / 2.0];
    peg.physicsBody.dynamic = NO;
    peg.physicsBody.categoryBitMask = kPKPegCategory;
    peg.name = kIOPegName;
    peg.multiplier = NO;
    peg.wasHitThisRound = NO;
    
    return peg;
}

- (void)setColorCount:(int)colorCount {
    _colorCount = colorCount;
    
    if (colorCount == 8) {
        self.texture = [SKTexture textureWithImageNamed:@"peg"];
        return;
    }
    
    SKAction *scaleUp = [SKAction scaleBy:1.15 duration:0.05];
    SKAction *scaleUpReverse = [scaleUp reversedAction];
    scaleUp.timingMode = SKActionTimingEaseInEaseOut;
    [self runAction:[SKAction sequence:@[scaleUp, scaleUpReverse]]];
    
    self.texture = [[PegColors iotaColors] objectAtIndex:_colorCount -1];
}



@end
