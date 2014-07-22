//
//  PlayingCards.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 07/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PlayingCards.h"

@implementation PlayingCards

@synthesize suit = _suit;

- (int)match:(NSArray *)othercards {
    int score = 0;
    int matchAll = 1;
    
    if([othercards count] == 1){
        PlayingCards *othercard = [othercards firstObject];
        
        if(othercard.rank == self.rank){
            score = 4;
        } else if([othercard.suit isEqualToString:self.suit]){
            score = 1;
        }
    } else {
        for(PlayingCards *othercard in othercards){
            // PlayingCards *othercard=[othercards firstObject];
            if(othercard.rank == self.rank){
                score = 4;
            } else if([othercard.suit isEqualToString:self.suit]){
                score = 1;
            } else{
                matchAll = 0;
            }
        }
        if(matchAll){
            score = 12;
        }
    }
    
    return score;
}

+ (NSArray *)rankString {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

- (NSAttributedString *)contents {
    NSArray *rankString= [PlayingCards rankString];
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:[rankString[self.rank] stringByAppendingString:self.suit]];
    return text;
}

+ (NSArray *)validSuits {
    return @[@"♠︎",@"♣︎",@"♥︎",@"♦︎"];
}

- (void)setSuit:(NSString *)suit {
    if([[PlayingCards validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit:@"?";
}

+ (NSUInteger) maxRank {
    return [[self rankString]count]-1;
}

@end
