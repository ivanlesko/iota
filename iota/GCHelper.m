//
//  GCHelper.m
//  Iota
//
//  Created by Ivan Lesko on 2/25/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper

@synthesize gameCenterAvailable;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (void)authenticateLocalUser {
    if (!gameCenterAvailable) {
        return;
    }
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
    }
}

- (BOOL)isGameCenterAvailable {
    // Check for the presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // Checking if the device is running 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if (self = [super init]) {
        gameCenterAvailable = [self isGameCenterAvailable];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(authenticationChanged)
                   name:GKPlayerAuthenticationDidChangeNotificationName
                 object:nil];
    }
    
    return self;
}

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
//        NSLog(@"Authentication changed.");
        userAuthenticated = TRUE;
    } else {
//        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
}

@end












