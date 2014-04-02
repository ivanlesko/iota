//
//  FingerSprite.m
//  iota
//
//  Created by Ivan on 4/2/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "FingerSprite.h"

@implementation FingerSprite

+ (FingerSprite *)drawFingerAtPostion:(CGPoint)position {
    FingerSprite *finger = [FingerSprite spriteNodeWithImageNamed:@"finger.png"];
    finger.position = position;
    finger.name = kIOFingerName;
    finger.zRotation = 45 * M_PI / 180;
    finger.alpha = 0.0;
    
    SKAction *waitShort = [SKAction waitForDuration:0.12];
    SKAction *waitLong  = [SKAction waitForDuration:0.35];
    
    SKAction *fingerUp  = [SKAction setTexture:[SKTexture textureWithImageNamed:@"finger"]];
    SKAction *fingerDown = [SKAction setTexture:[SKTexture textureWithImageNamed:@"finger_pressed"]];
    
    SKAction *anim = [SKAction sequence:@[waitShort, fingerDown, waitShort, fingerUp, waitShort, fingerDown, waitShort, fingerUp, waitLong]];
    SKAction *repeatAnim = [SKAction repeatActionForever:anim];
    
    SKAction *fadeInMoveDown = [SKAction group:@[
                                                 [SKAction moveByX:0 y:-30 duration:0.2],
                                                 [SKAction fadeInWithDuration:0.2]
                                                 ]];
    
    [finger runAction:[SKAction sequence:@[fadeInMoveDown, repeatAnim]]];
    
    return finger;
}

- (void)moveDownFadeIn {
    SKAction *waitShort = [SKAction waitForDuration:0.12];
    SKAction *waitLong  = [SKAction waitForDuration:0.35];
    
    SKAction *fingerUp  = [SKAction setTexture:[SKTexture textureWithImageNamed:@"finger"]];
    SKAction *fingerDown = [SKAction setTexture:[SKTexture textureWithImageNamed:@"finger_pressed"]];
    
    SKAction *anim = [SKAction sequence:@[waitShort, fingerDown, waitShort, fingerUp, waitShort, fingerDown, waitShort, fingerUp, waitLong]];
    SKAction *repeatAnim = [SKAction repeatActionForever:anim];
    
    SKAction *fadeInMoveDown = [SKAction group:@[
                                                 [SKAction moveByX:0 y:-30 duration:0.2],
                                                 [SKAction fadeInWithDuration:0.2]
                                                 ]];
    
    [self runAction:[SKAction sequence:@[fadeInMoveDown, repeatAnim]]];
}

- (void)moveUpFadeOut {
    SKAction *fadeOutMoveUp  = [SKAction group:@[
                                                 [SKAction moveByX:0 y:30 duration:0.1],
                                                 [SKAction fadeOutWithDuration:0.1]
                                                 ]];
    [self runAction:fadeOutMoveUp completion:^{
        [self removeFromParent];
    }];
}


@end
