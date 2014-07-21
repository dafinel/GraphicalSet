//
//  GameSettings.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 18/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

@synthesize mathBonus = _mathBonus;
@synthesize mathPenality = _mathPenality;
@synthesize flipCost = _flipCost;

- (void)setMathBonus:(NSInteger)mathBonus {
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults]
                                      dictionaryForKey:@"gameSettings"] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[@"matchBonus"] = @(mathBonus);
    [[NSUserDefaults standardUserDefaults] setObject:settings
                                              forKey:@"gameSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setMathPenality:(NSInteger)mathPenality {
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults]
                                      dictionaryForKey:@"gameSettings"] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[@"matchPenality"] = @(mathPenality);
    [[NSUserDefaults standardUserDefaults] setObject:settings
                                              forKey:@"gameSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setFlipCost:(NSInteger)flipCost {
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults]
                                      dictionaryForKey:@"gameSettings"] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[@"flipCost"] = @(flipCost);
    [[NSUserDefaults standardUserDefaults] setObject:settings
                                              forKey:@"gameSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSInteger)mathBonus {
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults]
                              dictionaryForKey:@"gameSettings"];
    if (!settings) {
        _mathBonus = 4;
    } else {
        _mathBonus = [settings[@"matchBonus"]intValue];
    }
    return _mathBonus;
}

- (NSInteger)mathPenality {
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults]
                              dictionaryForKey:@"gameSettings"];
    if (!settings) {
        _mathPenality = 2;
    } else {
        _mathPenality = [settings[@"matchPenality"]intValue];
    }
    return _mathPenality;
}

- (NSInteger)flipCost {
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults]
                              dictionaryForKey:@"gameSettings"];
    if (!settings) {
        _flipCost = 1;
    } else {
        _flipCost = [settings[@"flipCost"]intValue];
    }

    return _flipCost;
}

@end
