//
//  AchievementMessages.h
//  iota
//
//  Created by Ivan on 4/9/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AchievementMessages : NSObject

+ (AchievementMessages *)sharedInstances;

- (NSDictionary *)messages;

@end
