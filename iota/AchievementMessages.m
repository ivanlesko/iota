//
//  AchievementMessages.m
//  iota
//
//  Created by Ivan on 4/9/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "AchievementMessages.h"

@implementation AchievementMessages

+ (AchievementMessages *)sharedInstances {
    static AchievementMessages *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (NSDictionary *)messages {
    NSDictionary *values = @{
                              iotaAchievementHighScore40k: @"You are a part of the 40k club!",
                              iotaAchievementHighScore50k: @"You are a part of the 50k club!",
                              iotaAchievementHighScore60k: @"You are a part of the 60k club!",
                              iotaAchievementHighScore65k: @"You are a part of the 65k club!",
                              iotaAchievementHighScore70k: @"You are a part of the 70k club!",
                              iotaAchievementTotalPoints1m: @"You have earned 1 million total points!",
                              iotaAchievementTotalPoints5m: @"You have earned 5 million total points!",
                              iotaAchievementTotalPoints10m: @"You have earned 10 million total points!",
                              iotaAchievementTotalPoints25m: @"You have earned 25 million total points!",
                              iotaAchievementTotalPoints100m: @"You have earned 100 million total points! OMG!!!",
                              iotaAchievementMultiplier80: @"You reached an 80x multiplier!",
                              iotaAchievementMultiplier85: @"You reached an 85x multiplier!",
                              iotaAchievementMultiplier90: @"You reached a 90x multiplier!",
                              iotaAchievementMultiplier95: @"You reached a 95x multiplier!",
                              iotaAchievementMultiplier100: @"You reaached a 100x multiplier, what a stud!",
                              iotaAchievementFeedDeveloper: @"Thanks for the support!",
                              iotaAchievementTwitter: @"Say hi to us on Twitter!",
                              iotaAchievementFacebook: @"Check us out on Facebook!"
                              };
    
    return values;
}

@end
