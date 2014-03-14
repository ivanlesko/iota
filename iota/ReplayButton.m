//
//  ReplayButton.m
//  Iota
//
//  Created by Ivan Lesko on 3/11/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "ReplayButton.h"

@implementation ReplayButton

+ (ReplayButton *)createNewReplayButtonAtPosition:(CGPoint)position {
    ReplayButton *button = [[ReplayButton alloc] initWithImageNamedNormal:@"replay" selected:@"replay"];
    button.position = position;
    button.name     = @"replayButton";
    
    return button;
}

@end
