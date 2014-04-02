//
//  FingerSprite.h
//  iota
//
//  Created by Ivan on 4/2/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FingerSprite : SKSpriteNode

+ (FingerSprite *)drawFingerAtPostion:(CGPoint)position;

- (void)moveDownFadeIn;
- (void)moveUpFadeOut;

@end
