//
//  ParseHelper.m
//  iota
//
//  Created by Ivan Lesko on 3/27/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "ParseHelper.h"
#import <Parse/Parse.h>

@implementation ParseHelper

+ (ParseHelper *)sharedHelper {
    static ParseHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (void)setApplicationId {
    [Parse setApplicationId:@"icb1CIBx5iBs6iKDs8wlFQcMo4SyDKfc9aFetaFu" clientKey:@"byzTqYlggDLzB99OIgL9nlxqzpChPWVxZ7Lzje3P"];
}

- (void)reportScoreWithTotalScore:(int64_t)totalScore multiplier:(int)multiplier score:(int)score {
    PFObject *newScore = [PFObject objectWithClassName:kPKScoreClassName];
    [newScore setObject:[NSNumber numberWithLongLong:totalScore] forKey:kPKScoreTotalScoreKey];
    [newScore setObject:[NSNumber numberWithInt:multiplier]      forKey:kPKScoreMultiplierKey];
    [newScore setObject:[NSNumber numberWithInt:score]           forKey:kPkScoreScoreKey];
    
    [newScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"successfully uploaded score");
        } else {
            NSLog(@"failed up upload score");
        }
    }];
}

@end
