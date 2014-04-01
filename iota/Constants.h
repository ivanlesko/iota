//
//  Constants.h
//  iota
//
//  Created by Luda on 4/1/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

// Physics body category names
#define kPKBallName @"ball"
#define kPKPegName  @"peg"
#define kPKDividername @"dividerBar"
#define kPKScoreDetectorname @"scoreDetector"

// Gamecenter leaderboard name
#define kIotaMainLeaderboard @"iotaLeaderboard"

// Parse constants
#define kPKScoreClassName     @"Score"
#define kPKScoreTotalScoreKey @"totalScore"
#define kPKScoreMultiplierKey @"multiplier"
#define kPkScoreScoreKey      @"score"
#define kPkScoreValuesKey     @"values"

// Local high score
#define kPKLocalHighScoreKey  @"localHighScore"

// Running Tally constants
// These are used to track user's stats
extern NSString *const kIORunningTallyDict;
extern NSString *const kIOBallsPlayedKey;
extern NSString *const kIOTotalPointsEarnedKey;
extern NSString *const kIOTotalGamesPlayedKey;
extern NSString *const kIOLowestScoreKey;
extern NSString *const kIOHighestMultiplierKey;
extern NSString *const kIOTotalPegsLitKey;

// The Accuracy dictionary contains information about how accurate the user is.
// Lists out how many times they have hit 250, 75, 50, 25, and 0.
extern NSString *const kIOAccuracyDictKey;
extern NSString *const kIOAccuracy250Key;
extern NSString *const kIOAccuracy75Key;
extern NSString *const kIOAccuracy50Key;
extern NSString *const kIOAccuracy25key;
extern NSString *const kIOAccuracy0key;

typedef enum {
    kPKGameStatePreRound = 0,
    kPkGameStateInRound,
    kPkGameStatePostRound
} kPKGameState;


// Physics body contact bitmasks
typedef enum : uint32_t {
    kPKBallCategory          = 0x1 << 0,
    kPKPegCategory           = 0x1 << 1,
    kPKScoreDetectorCategory = 0x1 << 2,
    kPKFloatingPanel         = 0x1 << 3
} kPKCategory;

@end











