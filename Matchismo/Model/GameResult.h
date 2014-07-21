//
//  GameResult.h
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 17/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject\

@property (nonatomic, strong) NSString *gameType;
@property (nonatomic        ) int score;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic        ) NSTimeInterval duration;

+ (NSArray *)allscores;

- (BOOL)compareDate:(GameResult *)game;
- (BOOL)compareDuration:(GameResult *)game;
- (BOOL)compareScore:(GameResult *)game;

@end
