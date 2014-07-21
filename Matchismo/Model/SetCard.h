//
//  SetCard.h
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 15/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic, strong) NSMutableAttributedString *symbol;
@property (nonatomic        ) NSUInteger rank;

+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

@end
