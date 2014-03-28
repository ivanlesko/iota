//
//  CreditsScene.m
//  iota
//
//  Created by Ivan Lesko on 3/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "CreditsScene.h"

@implementation CreditsScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKButton *credits = [[SKButton alloc] initWithImageNamed:@"creditsScreen"];
        credits.position  = CGPointMake(size.width / 2.0, size.height / 2.0);
        [self addChild:credits];
        [credits setTouchUpTarget:self action:@selector(presentMainMenu)];
    }
    
    return self;
}

- (void)presentMainMenu {
    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.5];
    [self.view presentScene:self.mainMenu transition:transition];
}

@end
