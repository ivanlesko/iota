//
//  PegColors.m
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/21/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "PegColors.h"

@implementation PegColors

+ (NSArray *)iotaColors {
    NSMutableArray *colors = [NSMutableArray new];
    
    for (int i = 1; i < 6; i++) {
        SKTexture *texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"peg_ios_%d", i]];
        [colors addObject:texture];
    }
    
    return [NSArray arrayWithArray:colors];
}

+ (NSArray *)iotaColorValues {
    return @[
             [SKColor colorWithRed:25.0/255.0  green:157.0/255.0 blue:200.0/255.0 alpha:1.0], // Blue
             [SKColor colorWithRed:69.0/255.0  green:178.0/255.0 blue:157.0/255.0 alpha:1.0], // Cyan/Green
             [SKColor colorWithRed:226.0/255.0 green:121.0/255.0 blue:63.0/255.0  alpha:1.0], // Orange
             [SKColor colorWithRed:223.0/255.0 green:90.0/255.0  blue:73.0/255.0  alpha:1.0], // Red
             [SKColor colorWithRed:239.0/255.0 green:201.0/255.0 blue:76.0/255.0  alpha:1.0]  // Yellow
             ];
}

@end
