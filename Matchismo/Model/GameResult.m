//
//  GameResult.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 17/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "GameResult.h"

@implementation GameResult

#pragma mark - comparation functions

- (BOOL)compareScore:(GameResult *)game {
    if (self.score < game.score) {
        return 0;
    } else {
        return 1;
    }
}

- (BOOL)compareDuration:(GameResult *)game {
    if (self.duration < game.duration) {
        return 0;
    } else {
        return 1;
    }
}

- (BOOL)compareDate:(GameResult *)game {
    NSDate *test;
    test = [self.end earlierDate:game.end];
    if ([test isEqualToDate:self.end]) {
        return 0;
    } else {
        return 1;
    }
}


#pragma mark - proprieties

- (void)setScore:(int)score {
    _score=score;
    _end=[NSDate date];
    [self update];
}

- (NSTimeInterval)duration {
    return [self.end timeIntervalSinceDate:self.start];
}

+ (NSArray *)allscores {
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    for (id dictionary in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"allGameResult"] allValues]) {
        GameResult *result = [[GameResult alloc] initWithDictionary:dictionary];
        [allGameResults addObject:result];
    }
    
    return allGameResults;
}

#pragma mark - initialization

- (instancetype)initWithDictionary:(id)dictionary {
    self = [super init];
    if (self) {
        _start = dictionary[@"startDate"];
        _end = dictionary[@"endDate"];
        _score = [dictionary[@"score"] intValue];
        _gameType = dictionary[@"gameType"];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.start = [NSDate date];
        self.end = self.start;
    }
    return self;
}

- (void)update {
    NSMutableDictionary *gameResultsFromUserDefault = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"allGameResult"] mutableCopy];
    if(!gameResultsFromUserDefault) {
        gameResultsFromUserDefault = [[NSMutableDictionary alloc] init];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"];
    [dateFormatter setLocale:usLocale];
    
    gameResultsFromUserDefault[[dateFormatter stringFromDate:self.start]] = @{@"startDate": self.start,
                                                 @"endDate": self.end,
                                                 @"score": @(self.score),
                                                 @"gameType": self.gameType};
   
    [[NSUserDefaults standardUserDefaults] setObject:gameResultsFromUserDefault forKey:@"allGameResult"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
