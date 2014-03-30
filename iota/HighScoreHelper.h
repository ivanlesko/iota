//
//  HighScoreHelper.h
//  iota
//
//  Created by Ivan Lesko on 3/29/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighScoreHelper : NSObject

+ (HighScoreHelper *)sharedInstance;

- (void)updateHighScoreWithScore:(int64_t)score;

- (int64_t)localHighScore;

@end
