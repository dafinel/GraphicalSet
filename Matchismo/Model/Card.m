//
//  Card.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 07/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "Card.h"

@implementation Card

-(int)match:(NSArray *) othercards
{
    int score = 0;
    for (Card *card in othercards) {
        if([card.contents isEqualToAttributedString:self.contents])
            score = 1;
    }
    
    return score;
}

@end
