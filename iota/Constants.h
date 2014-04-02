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

/*
 * Parse constants
 */
extern NSString *const kIOScoreClassName;
extern NSString *const kIOScoreTotalScoreKey;
extern NSString *const kIOScoreMultiplierKey;
extern NSString *const kIOScoreScoreKey;
extern NSString *const kIOScoreValuesKey;

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











