//
//  PlayingCards.h
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 07/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Card.h"

@interface PlayingCards : Card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic        ) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger) maxRank;

@end
