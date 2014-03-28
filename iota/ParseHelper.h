//
//  ParseHelper.h
//  iota
//
//  Created by Ivan Lesko on 3/27/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseHelper : NSObject

+ (ParseHelper *)sharedHelper;

- (void)setApplicationId;

- (void)reportScoreWithTotalScore:(int64_t)totalScore multiplier:(int)multiplier score:(int)score;

@end
