//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 08/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@end


@implementation CardMatchingGame

- (NSUInteger)numberOfCards {
    if (!_numberOfCards) {
        _numberOfCards = 2;
    }
    return _numberOfCards;
}

- (void)setNewScore:(NSInteger)newScore {
    self.score = 0;
}

- (void)unchooseCards {
    for(Card *otherCard in self.cards) {
        otherCard.matched = NO;
        otherCard.chosen = NO;
    }
}

- (NSMutableArray *)cards {
    if(!_cards){
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (void)setCardsForSet:(NSMutableArray *)cards {
    self.cards=cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck
{
    self = [super init];
    if(self){
        for(int i = 0; i<count; i++){
            Card *card = [deck drowRandomCard];
            if(card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}
/*
static const int MISMATCH_PENALITY=2;
static const int MATCH_BONUS=4;
static const int COST_TO_CHOOSE=1;
 */

// Too large, should refactor
- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = self.cards[index];
    self.rezult = [[NSMutableAttributedString alloc] initWithAttributedString:card.contents];
    NSMutableAttributedString *otherCardsContets = [[NSMutableAttributedString alloc] init];
     NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
    
    if(!card.isMatched){
        if(card.isChosen) {
            card.chosen = NO;
        } else {
            NSMutableArray *otherCards=[[NSMutableArray alloc]init];
            
            for(Card *otherCard in self.cards){
                if(otherCard.isChosen && !otherCard.isMatched){
                    [otherCards addObject:otherCard];
                }
            }
            
            // The following code should be included into another method
            if([otherCards count] == self.numberOfCards-1) {
                int matchScore = [card match:otherCards];
                self.dontMathFlipCard = [self.cards indexOfObject:otherCards[0]];
                if(matchScore) {
                    self.score += matchScore *self.MATCH_BONUS;
                    for(Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                        [otherCardsContets appendAttributedString: space];
                        [otherCardsContets appendAttributedString: otherCard.contents];
                    }
                    card.matched = YES;
                    NSAttributedString *match = [[NSAttributedString alloc] initWithString:@" matched"];
                    NSAttributedString *points = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points",matchScore * self.MATCH_BONUS]];
                    [self.rezult appendAttributedString: otherCardsContets];
                    [self.rezult appendAttributedString: match];
                    [self.rezult appendAttributedString: points];
                    
                } else {
                    self.score -= self.MISMATCH_PENALITY;
                    for(Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                        [otherCardsContets appendAttributedString: space];
                        [otherCardsContets appendAttributedString: otherCard.contents];
                    }
                    NSAttributedString *dontMatch = [[NSAttributedString alloc] initWithString:@" don't match"];
                    NSAttributedString *penality = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" penality %d points",self.MISMATCH_PENALITY]];
                    [self.rezult appendAttributedString: otherCardsContets];
                    [self.rezult appendAttributedString: dontMatch];
                    [self.rezult appendAttributedString: penality];
                }
            }
            self.score -= self.COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
