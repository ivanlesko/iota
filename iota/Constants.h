//
//  Constants.h
//  SpriteWalkthrough
//
//  Created by Ivan Lesko on 2/20/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

// Physics body category names
#define kPKBallName @"ball"
#define kPKPegName  @"peg"
#define kPKDividername @"dividerBar"
#define kPKScoreDetectorname @"scoreDetector"

// Gamecenter leaderboard name

#define kIotaMainLeaderboard @"1"


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

