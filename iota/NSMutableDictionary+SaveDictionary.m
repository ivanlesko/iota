//
//  NSMutableDictionary+SaveDictionary.m
//  iota
//
//  Created by Luda on 4/3/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "NSMutableDictionary+SaveDictionary.h"

@implementation NSMutableDictionary (SaveDictionary)

- (void)updateStatsDictPlistAndSetObject:(id)object forKey:(NSString *)key {
    NSLog(@"object: %@ key: %@", object, key);
    [self setObject:object forKey:key];
    [self writeToFile:[Stats statsFilePath] atomically:YES];
    NSLog(@"stats pegs: %@", [self objectForKey:key]);
}

@end
