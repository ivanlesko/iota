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
        NSFileManager *myFileManager = [NSFileManager defaultManager];
        
        if (![myFileManager fileExistsAtPath:[Stats statsFilePath]]) {
            NSString *mainBundleSourcePathString = [[NSBundle mainBundle] pathForResource:@"Stats" ofType:@"plist"];
            [myFileManager copyItemAtPath:mainBundleSourcePathString toPath:[Stats statsFilePath] error:nil];
        } else {
            self.statsDict         = [NSMutableDictionary dictionaryWithContentsOfFile:[Stats statsFilePath]];
            
            self.localHighScore    = [self.statsDict objectForKey:kIOLocalHighScoreKey];
            self.remoteHighScore   = [self.statsDict objectForKey:kIORemoteHighScoreKey];
            self.ballsPlayed       = [self.statsDict objectForKey:kIOTotalBallsPlayedKey];
            self.totalPointsEarned = [self.statsDict objectForKey:kIOTotalPointsEarnedKey];
            self.totalGamesPlayed  = [self.statsDict objectForKey:kIOTotalGamesPlayedKey];
            self.lowestScore       = [self.statsDict objectForKey:kIOLowestScoreKey];
            self.highestMultiplier = [self.statsDict objectForKey:kIOHighestMultiplierKey];
            self.totalPegsLitUp    = [self.statsDict objectForKey:kIOTotalPegsLitKey];
            self.accuracy250       = [self.statsDict objectForKey:kIOAccuracy250Key];
            self.accuracy75        = [self.statsDict objectForKey:kIOAccuracy75Key];
            self.accuracy50        = [self.statsDict objectForKey:kIOAccuracy50Key];
            self.accuracy25        = [self.statsDict objectForKey:kIOAccuracy25key];
            self.accuracy0         = [self.statsDict objectForKey:kIOAccuracy0key];
            self.totalScoreDetectorsHit = [self.statsDict objectForKey:kIOAccuracyScoreDetectorsHit];
        }
    }
    
    return self;
}

- (void)saveStatsDict {
    [self.statsDict writeToFile:[Stats statsFilePath] atomically:YES];
}

- (void)setLocalHighScore:(NSNumber *)localHighScore {
    _localHighScore = localHighScore;
    [self.statsDict setObject:_localHighScore forKey:kIOLocalHighScoreKey];
    [self saveStatsDict];
}

- (void)setRemoteHighScore:(NSNumber *)remoteHighScore {
    _remoteHighScore = remoteHighScore;
    
    if (self.localHighScore.longLongValue < _remoteHighScore.longLongValue) {
        self.localHighScore = _remoteHighScore;
    }
    
    [self.statsDict setObject:_remoteHighScore forKey:kIORemoteHighScoreKey];
    [self saveStatsDict];
}

- (void)setBallsPlayed:(NSNumber *)ballsPlayed {
    _ballsPlayed = ballsPlayed;
    [self.statsDict setObject:_ballsPlayed forKey:kIOTotalBallsPlayedKey];
    [self saveStatsDict];
}

- (void)setTotalPointsEarned:(NSNumber *)totalPointsEarned {
    _totalPointsEarned = totalPointsEarned;
    [self.statsDict setObject:_totalPointsEarned forKey:kIOTotalPointsEarnedKey];
    [self saveStatsDict];
}

- (void)setTotalGamesPlayed:(NSNumber *)totalGamesPlayed {
    _totalGamesPlayed = totalGamesPlayed;
    [self.statsDict setObject:_totalGamesPlayed forKey:kIOTotalGamesPlayedKey];
    [self saveStatsDict];
}

- (void)setLowestScore:(NSNumber *)lowestScore {
    _lowestScore = lowestScore;
    [self.statsDict setObject:_lowestScore forKey:kIOLowestScoreKey];
    [self saveStatsDict];
}

- (void)setHighestMultiplier:(NSNumber *)highestMultiplier {
    _highestMultiplier = highestMultiplier;
    [self.statsDict setObject:_highestMultiplier forKey:kIOHighestMultiplierKey];
    [self saveStatsDict];
}

- (void)setTotalPegsLitUp:(NSNumber *)totalPegsLitUp {
    _totalPegsLitUp = totalPegsLitUp;
    [self.statsDict setObject:_totalPegsLitUp forKey:kIOTotalPegsLitKey];
    [self saveStatsDict];
}

- (void)setTotalScoreDetectorsHit:(NSNumber *)totalScoreDetectorsHit {
    _totalScoreDetectorsHit = totalScoreDetectorsHit;
    [self.statsDict setObject:_totalScoreDetectorsHit forKey:kIOAccuracyScoreDetectorsHit];
    [self saveStatsDict];
}

- (void)updateRemoteHighScoreWithScore:(int64_t)highScore {
    self.remoteHighScore = [NSNumber numberWithLongLong:[self.remoteHighScore longLongValue] + highScore];
    [self.statsDict setObject:self.remoteHighScore forKey:kIORemoteHighScoreKey];
    [self saveStatsDict];
}

- (void)incrementBallsPlayed {
    self.ballsPlayed = [NSNumber numberWithLongLong:[self.ballsPlayed longLongValue] + 1];
    [self.statsDict setObject:self.ballsPlayed forKey:kIOTotalBallsPlayedKey];
    [self saveStatsDict];
}

- (void)updateTotalScoreWithScore:(int64_t)totalScore {
    self.totalPointsEarned = [NSNumber numberWithLongLong:[self.totalPointsEarned longLongValue] + totalScore];
    [self.statsDict setObject:self.totalPointsEarned forKey:kIOTotalPointsEarnedKey];
    [self saveStatsDict];
}

- (void)incrementGamesPlayedCount {
    self.totalGamesPlayed = [NSNumber numberWithLongLong:[self.totalGamesPlayed longLongValue] + 1];
    [self.statsDict setObject:self.totalGamesPlayed forKey:kIOTotalGamesPlayedKey];
    [self saveStatsDict];
}

- (void)incrementPegsLitUpCount {
    self.totalPegsLitUp = [NSNumber numberWithLongLong:[self.totalPegsLitUp longLongValue] + 1];
    [self.statsDict setObject:self.totalPegsLitUp forKey:kIOTotalPegsLitKey];
    [self saveStatsDict];
}

- (void)incrementScoreDetectorsHitCount {
    self.totalScoreDetectorsHit = [NSNumber numberWithLongLong:[self.totalScoreDetectorsHit longLongValue] + 1];
    [self.statsDict setObject:self.totalScoreDetectorsHit forKey:kIOAccuracyScoreDetectorsHit];
    [self saveStatsDict];
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

+ (NSString *)statsFilePath {
    return [[NSString documentsDirectory] stringByAppendingPathComponent:@"Stats.plist"];
}

@end


































