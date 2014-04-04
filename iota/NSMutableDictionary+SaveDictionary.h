//
//  NSMutableDictionary+SaveDictionary.h
//  iota
//
//  Created by Luda on 4/3/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stats.h"

@interface NSMutableDictionary (SaveDictionary)

- (void)updateStatsDictPlistAndSetObject:(id)object forKey:(NSString *)key;

@end
