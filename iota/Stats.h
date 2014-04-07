//
//  StatsDictionary.h
//  iota
//
//  Created by Ivan on 4/1/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSNumber+DefaultNumbers.h"
#import "GameCenterManager.h"
#import "IotaGameScene.h"

@class StatsDictionary;

@interface Stats : NSObject

/*
 * Returns a shared copy of the stats model class.
 * There only needs to be one instance of the stats at any given time.
 */
+ (Stats *)sharedInstance;

@property (nonatomic, strong) NSMutableDictionary *statsDict;

@property (nonatomic, strong) NSNumber *localHighScore;
@property (nonatomic, strong) NSNumber *remoteHighScore;
@property (nonatomic, strong) NSNumber *ballsPlayed;
@property (nonatomic, strong) NSNumber *totalPointsEarned;
@property (nonatomic, strong) NSNumber *totalGamesPlayed;
@property (nonatomic, strong) NSNumber *lowestScore;
@property (nonatomic, strong) NSNumber *totalPegsLitUp;
@property (nonatomic, strong) NSNumber *highestMultiplier;

@property (nonatomic, strong) NSNumber *totalScoreDetectorsHit;
@property (nonatomic, strong) NSNumber *accuracy250;
@property (nonatomic, strong) NSNumber *accuracy75;
@property (nonatomic, strong) NSNumber *accuracy50;
@property (nonatomic, strong) NSNumber *accuracy25;
@property (nonatomic, strong) NSNumber *accuracy0;

@property (nonatomic, strong) NSNumber *accuracy250Hits;
@property (nonatomic, strong) NSNumber *accuracy75Hits;
@property (nonatomic, strong) NSNumber *accuracy50Hits;
@property (nonatomic, strong) NSNumber *accuracy25Hits;
@property (nonatomic, strong) NSNumber *accuracy0Hits;

@property (nonatomic, strong)IotaGameScene *gameScene;

@property (nonatomic) BOOL canReportScores;

- (void)incrementBallsPlayed;
- (void)incrementPegsLitUpCount;
- (void)incrementScoreDetectorsHitCount;
- (void)updateTotalScoreWithScore:(int64_t)totalScore;
- (void)incrementGamesPlayedCount;
- (void)incrementAccuracyWithValue:(int)value;

+ (NSString *)statsFilePath;

@end
