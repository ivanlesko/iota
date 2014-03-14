//
//  YSPlinkoSE.h
//  YSAudioEngine
//
//  Created by Yair Szarf on 2/26/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef enum YSIotaSEEvent {
    YSIotaSEEventLoose = 0,
    YSIotaSEEvent5,
    YSIotaSEEvent25,
    YSIotaSEEvent50,
    YSIotaSEEvent100,
    YSIotaSEEventPowerUp
} YSIotaSEEvent;

@interface YSIotaSE : NSObject

+ (YSIotaSE *) sharedSE;

- (void) prime;
- (void) playHit;
- (void) reset;
- (void) playEvent: (YSIotaSEEvent) event;

@end
