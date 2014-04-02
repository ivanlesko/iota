//
//  StatsDictionary.m
//  iota
//
//  Created by Ivan on 4/1/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "Stats.h"

@implementation Stats

+ (Stats *)sharedInstance {
    static Stats *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (id)init {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        self.localHighScore    = [NSNumber longLongZero];
        self.remoteHighScore   = [NSNumber longLongZero];
        self.ballsPlayed       = [NSNumber longLongZero];
        self.totalPointsEarned = [NSNumber longLongZero];
        self.totalGamesPlayed  = [NSNumber longLongZero];
        self.lowestScore       = [NSNumber longLongZero];
        self.highestMultiplier = [NSNumber longLongZero];
        self.accuracy250       = [NSNumber longLongZero];
        self.totalPegsLitUp    = [NSNumber longLongZero];
        self.accuracy75        = [NSNumber longLongZero];
        self.accuracy50        = [NSNumber longLongZero];
        self.accuracy25        = [NSNumber longLongZero];
        self.accuracy0         = [NSNumber longLongZero];
        self.totalScoreDetectorsHit = [NSNumber longLongZero];
        
        NSArray *values = @[self.localHighScore, self.remoteHighScore, self.ballsPlayed,
                            self.totalPointsEarned, self.totalGamesPlayed, self.lowestScore,
                            self.totalPegsLitUp, self.highestMultiplier, self.totalScoreDetectorsHit,
                            self.accuracy250, self.accuracy75, self.accuracy50,
                            self.accuracy25, self.accuracy0];
        
        NSArray *strings = @[kIOLocalHighScoreKey, kIORemoteHighScoreKey, kIOTotalBallsPlayedKey,
                             kIOTotalPointsEarnedKey, kIOTotalGamesPlayedKey, kIOLowestScoreKey,
                             kIOTotalPegsLitKey, kIOHighestMultiplierKey, kIOAccuracyScoreDetectorsHit,
                             kIOAccuracy250Key, kIOAccuracy75Key, kIOAccuracy50Key,
                             kIOAccuracy25key, kIOAccuracy0key];
        
        BOOL valid = YES;
        int index = 0;
        
        for (NSObject __strong *value in values) {
            if ([defaults secureObjectForKey:[strings objectAtIndex:index] valid:&valid]) {
                value = [defaults secureObjectForKey:strings[index] valid:&valid];
            } else {
                [defaults setSecureObject:value forKey:strings[index]];
            }
            index++;
        }
    }
    
    return self;
}

- (void)updateRemoteHighScoreWithScore:(int64_t)highScore {
    self.remoteHighScore = [NSNumber numberWithLongLong:[self.remoteHighScore longLongValue] + highScore];
    [[NSUserDefaults standardUserDefaults] setSecureObject:self.localHighScore forKey:kIORemoteHighScoreKey];
}

- (void)incrementBallsPlayed {
    self.ballsPlayed = [NSNumber numberWithLongLong:[self.ballsPlayed longLongValue] + 1];
    [[NSUserDefaults standardUserDefaults] setSecureObject:self.ballsPlayed forKey:kIOTotalBallsPlayedKey];
}

- (void)updateTotalScoreWithScore:(int64_t)totalScore {
    self.totalPointsEarned = [NSNumber numberWithLongLong:[self.totalPointsEarned longLongValue] + totalScore];
    [[NSUserDefaults standardUserDefaults] setSecureObject:self.totalPointsEarned forKey:kIOTotalPointsEarnedKey];
}

- (void)incrementGamesPlayedCount {
    self.totalGamesPlayed = [NSNumber numberWithLongLong:[self.totalGamesPlayed longLongValue] + 1];
    [[NSUserDefaults standardUserDefaults] setSecureObject:self.totalGamesPlayed forKey:kIOTotalGamesPlayedKey];
}

- (void)incrementPegsLitUpCount {
    self.totalPegsLitUp = [NSNumber numberWithLongLong:[self.totalPegsLitUp longLongValue] + 1];
    [[NSUserDefaults standardUserDefaults] setSecureObject:self.totalPegsLitUp forKey:kIOTotalPegsLitKey];
}

- (void)incrementScoreDetectorsHitCount {
    self.totalScoreDetectorsHit = [NSNumber numberWithLongLong:[self.totalScoreDetectorsHit longLongValue] + 1];
    [[NSUserDefaults standardUserDefaults] setSecureObject:self.totalScoreDetectorsHit forKey:kIOAccuracyScoreDetectorsHit];
}

- (void)setLocalHighScore:(NSNumber *)localHighScore {
    _localHighScore = localHighScore;
    [[NSUserDefaults standardUserDefaults] setSecureObject:_localHighScore forKey:kIOLocalHighScoreKey];
}

- (void)setRemoteHighScore:(NSNumber *)remoteHighScore {
    _remoteHighScore = remoteHighScore;
    [[NSUserDefaults standardUserDefaults] setSecureObject:_remoteHighScore forKey:kIORemoteHighScoreKey];
    
    if (self.localHighScore.longLongValue < _remoteHighScore.longLongValue) {
        self.localHighScore = _remoteHighScore;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Stats:\n local high score: %@\n Remote high score: %@\n Balls played: %@\n Total points earned: %@\n Total games played: %@\n Lowest score: %@\n Total pegs lit: %@\n Highest multiplier: %@\n Total score detectors hit: %@\n",
            self.localHighScore,
            self.remoteHighScore,
            self.ballsPlayed,
            self.totalPointsEarned,
            self.totalGamesPlayed,
            self.lowestScore,
            self.totalPegsLitUp,
            self.highestMultiplier,
            self.totalScoreDetectorsHit];
}

@end


































