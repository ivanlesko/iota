//
//  Constants.h
//  iota
//
//  Created by Ivan on 4/1/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

/*
 * Physics body category names
 */
extern NSString *const kIOBallName;
extern NSString *const kIOPegName;
extern NSString *const kIODividerName;
extern NSString *const kIOScoreDetectorName;
extern NSString *const kIOFingerName;

/*
 * Gamcenter leaderboard names
 */
extern NSString *const kIOMainLeaderboard;
extern NSString *const kIOTotalPointsEarnedLeaderboard;
extern NSString *const kIOLowestScoreLeaderboard;
extern NSString *const kIOHighestMultiplierLeaderboard;
extern NSString *const kIOTotalGamesPlayedLeaderboard;

/*
 * Parse constants
 */
extern NSString *const kIOScoreClassName;
extern NSString *const kIOScoreTotalScoreKey;
extern NSString *const kIOScoreMultiplierKey;
extern NSString *const kIOScoreScoreKey;
extern NSString *const kIOScoreValuesKey;
extern NSString *const kIOScoreGamesPlayedKey;
extern NSString *const kIOScoreTotalPointsKey;

/*
 * High score tracker constants
 * These are used to track user's stats
 */
extern NSString *const kIOLocalHighScoreKey;
extern NSString *const kIORemoteHighScoreKey;
extern NSString *const kIOTotalBallsPlayedKey;
extern NSString *const kIOTotalPointsEarnedKey;
extern NSString *const kIOTotalGamesPlayedKey;
extern NSString *const kIOLowestScoreKey;
extern NSString *const kIOHighestMultiplierKey;
extern NSString *const kIOTotalPegsLitKey;

/*
 * The Accuracy dictionary contains information about how accurate the user is.
 * Lists out how many times they have hit 250, 75, 50, 25, and 0.
 */
extern NSString *const kIOAccuracy250Key;
extern NSString *const kIOAccuracy75Key;
extern NSString *const kIOAccuracy50Key;
extern NSString *const kIOAccuracy25key;
extern NSString *const kIOAccuracy0key;

extern NSString *const kIOAccuracy250HitsKey;
extern NSString *const kIOAccuracy75HitsKey;
extern NSString *const kIOAccuracy50HitsKey;
extern NSString *const kIOAccuracy25HitsKey;
extern NSString *const kIOAccuracy0HitsKey;

/*
 * GameCenter Achievements
 */
extern NSString *const iotaAchievementHighScore40k;
extern NSString *const iotaAchievementHighScore50k;
extern NSString *const iotaAchievementHighScore60k;
extern NSString *const iotaAchievementHighScore65k;
extern NSString *const iotaAchievementHighScore70k;

extern NSString *const iotaAchievementTotalPoints1m;
extern NSString *const iotaAchievementTotalPoints5m;
extern NSString *const iotaAchievementTotalPoints10m;
extern NSString *const iotaAchievementTotalPoints25m;
extern NSString *const iotaAchievementTotalPoints100m;

extern NSString *const iotaAchievementMultiplier80;
extern NSString *const iotaAchievementMultiplier85;
extern NSString *const iotaAchievementMultiplier90;
extern NSString *const iotaAchievementMultiplier95;
extern NSString *const iotaAchievementMultiplier100;

extern NSString *const iotaAchievementFeedDeveloper;
extern NSString *const iotaAchievementTwitter;
extern NSString *const iotaAchievementFacebook;

/*
 * The total number of score detectors the user has hit.
 * We need this number to calculate the
 */
extern NSString *const kIOAccuracyScoreDetectorsHit;

// Physics body contact bitmasks
typedef enum : uint32_t {
    kPKBallCategory          = 0x1 << 0,
    kPKPegCategory           = 0x1 << 1,
    kPKScoreDetectorCategory = 0x1 << 2,
    kPKFloatingPanel         = 0x1 << 3
} kPKCategory;

@end











