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
        }
        
        self.statsDict         = [NSMutableDictionary dictionaryWithContentsOfFile:[Stats statsFilePath]];
        
        self.localHighScore    = [self.statsDict objectForKey:kIOLocalHighScoreKey];
        self.remoteHighScore   = [self.statsDict objectForKey:kIORemoteHighScoreKey];
        self.ballsPlayed       = [self.statsDict objectForKey:kIOTotalBallsPlayedKey];
        self.totalPointsEarned = [self.statsDict objectForKey:kIOTotalPointsEarnedKey];
        self.totalGamesPlayed  = [self.statsDict objectForKey:kIOTotalGamesPlayedKey];
        self.lowestScore       = [self.statsDict objectForKey:kIOLowestScoreKey];
        self.highestMultiplier = [self.statsDict objectForKey:kIOHighestMultiplierKey];
        self.totalPegsLitUp    = [self.statsDict objectForKey:kIOTotalPegsLitKey];
        
        self.totalScoreDetectorsHit = [self.statsDict objectForKey:kIOAccuracyScoreDetectorsHit];
        
        self.accuracy250       = [self.statsDict objectForKey:kIOAccuracy250Key];
        self.accuracy75        = [self.statsDict objectForKey:kIOAccuracy75Key];
        self.accuracy50        = [self.statsDict objectForKey:kIOAccuracy50Key];
        self.accuracy25        = [self.statsDict objectForKey:kIOAccuracy25key];
        self.accuracy0         = [self.statsDict objectForKey:kIOAccuracy0key];
        
        self.accuracy250Hits   = [self.statsDict objectForKey:kIOAccuracy250HitsKey];
        self.accuracy75Hits    = [self.statsDict objectForKey:kIOAccuracy75HitsKey];
        self.accuracy50Hits    = [self.statsDict objectForKey:kIOAccuracy50HitsKey];
        self.accuracy25Hits    = [self.statsDict objectForKey:kIOAccuracy25HitsKey];
        self.accuracy0Hits     = [self.statsDict objectForKey:kIOAccuracy0HitsKey];
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

#pragma mark - Accuracy Percentages

- (void)setAccuracy250:(NSNumber *)accuracy250 {
    _accuracy250 = accuracy250;
    [self.statsDict setObject:_accuracy250 forKey:kIOAccuracy250Key];
    [self saveStatsDict];
}

- (void)setAccuracy75:(NSNumber *)accuracy75 {
    _accuracy75 = accuracy75;
    [self.statsDict setObject:_accuracy75 forKey:kIOAccuracy75Key];
    [self saveStatsDict];
}

- (void)setAccuracy50:(NSNumber *)accuracy50 {
    _accuracy50 = accuracy50;
    [self.statsDict setObject:_accuracy50 forKey:kIOAccuracy50Key];
    [self saveStatsDict];
}

- (void)setAccuracy25:(NSNumber *)accuracy25 {
    _accuracy25 = accuracy25;
    [self.statsDict setObject:_accuracy25 forKey:kIOAccuracy25key];
    [self saveStatsDict];
}

- (void)setAccuracy0:(NSNumber *)accuracy0 {
    _accuracy0 = accuracy0;
    [self.statsDict setObject:_accuracy0 forKey:kIOAccuracy0key];
    [self saveStatsDict];
}

#pragma mark - Accuracy Hit Amounts

- (void)setAccuracy250Hits:(NSNumber *)accuracy250Hits {
    _accuracy250Hits = accuracy250Hits;
    [self.statsDict setObject:_accuracy250Hits forKey:kIOAccuracy250HitsKey];
    [self saveStatsDict];
}

- (void)setAccuracy75Hits:(NSNumber *)accuracy75Hits {
    _accuracy75Hits = accuracy75Hits;
    [self.statsDict setObject:accuracy75Hits forKey:kIOAccuracy75HitsKey];
    [self saveStatsDict];
}

- (void)setAccuracy50Hits:(NSNumber *)accuracy50Hits {
    _accuracy50Hits = accuracy50Hits;
    [self.statsDict setObject:accuracy50Hits forKey:kIOAccuracy50HitsKey];
    [self saveStatsDict];
}

- (void)setAccuracy25Hits:(NSNumber *)accuracy25Hits {
    _accuracy25Hits = accuracy25Hits;
    [self.statsDict setObject:accuracy25Hits forKey:kIOAccuracy25HitsKey];
    [self saveStatsDict];
}

- (void)setAccuracy0Hits:(NSNumber *)accuracy0Hits {
    _accuracy0Hits = accuracy0Hits;
    [self.statsDict setObject:accuracy0Hits forKey:kIOAccuracy0HitsKey];
    [self saveStatsDict];
}

- (void)incrementAccuracyWithValue:(int)value {
    switch (value) {
        case 250: {
            self.accuracy250Hits = [NSNumber numberWithLongLong:self.accuracy250Hits.longLongValue + 1];
            break;
        }
            
        case 75: {
            self.accuracy75Hits = [NSNumber numberWithLongLong:self.accuracy75Hits.longLongValue + 1];
            break;
        }
            
        case 50: {
            self.accuracy50Hits = [NSNumber numberWithLongLong:self.accuracy50Hits.longLongValue + 1];
            break;
        }
            
        case 25: {
            self.accuracy25Hits = [NSNumber numberWithLongLong:self.accuracy25Hits.longLongValue + 1];
            break;
        }
            
        case 0: {
            self.accuracy0Hits = [NSNumber numberWithLongLong:self.accuracy0Hits.longLongValue + 1];
            break;
        }
    }
    
    self.accuracy250 = [NSNumber numberWithFloat:((self.accuracy250Hits.floatValue / self.totalScoreDetectorsHit.floatValue) * 100)];
    self.accuracy75 = [NSNumber numberWithFloat:((self.accuracy75Hits.floatValue / self.totalScoreDetectorsHit.floatValue) * 100)];
    self.accuracy50 = [NSNumber numberWithFloat:((self.accuracy50Hits.floatValue / self.totalScoreDetectorsHit.floatValue) * 100)];
    self.accuracy25 = [NSNumber numberWithFloat:((self.accuracy25Hits.floatValue / self.totalScoreDetectorsHit.floatValue) * 100)];
    self.accuracy0 = [NSNumber numberWithFloat:((self.accuracy0Hits.floatValue / self.totalScoreDetectorsHit.floatValue) * 100)];
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


































