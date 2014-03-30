//
//  HighScoreHelper.m
//  iota
//
//  Created by Ivan Lesko on 3/29/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "HighScoreHelper.h"

@implementation HighScoreHelper

+ (HighScoreHelper *)sharedInstance {
    static HighScoreHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (void)updateHighScoreWithScore:(int64_t)score {
    [[NSUserDefaults standardUserDefaults] setSecureLongLong:score forKey:kPKLocalHighScoreKey];
}

- (int64_t)localHighScore {
    BOOL valid = YES;
    return [[NSUserDefaults standardUserDefaults] secureLongLongForKey:kPKLocalHighScoreKey valid:&valid];
}

@end
