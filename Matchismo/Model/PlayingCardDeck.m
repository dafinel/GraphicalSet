//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 07/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCards.h"

@implementation PlayingCardDeck

-(instancetype)init {
    if(self = [super init]) {
        for(NSString *suit in [PlayingCards validSuits]) {
            
            for(NSUInteger rank = 1; rank <= [PlayingCards maxRank]; rank++)  {
                PlayingCards *card = [[PlayingCards alloc]init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
