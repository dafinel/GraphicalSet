//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 08/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "SetCard.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;

@end

@implementation CardMatchingGame

- (NSArray *)findCombination {
    NSMutableArray *combinationOf3Cards = [NSMutableArray array];
    for (int i = 0; i < self.numberOfCards; i++) {
        [combinationOf3Cards addObject:@(i)];
    }
    NSMutableArray *foundCombination;
    NSArray *next3Cards = combinationOf3Cards;
    while ((next3Cards = [self nextCombinationOf3Cards:next3Cards])) {
        Card *card = self.cards[[next3Cards[0] intValue]];
        SetCard *setcard = (SetCard *)card;
        if ([setcard match:[self otherCardFromCombinationOf3Cards:next3Cards]]) {
            [foundCombination addObject:[self cardsFromCombination:next3Cards]];
        }
    }
    return foundCombination;
}

- (NSArray *)cardsFromCombination: (NSArray *)next3Cards {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        [returnArray addObject:self.cards[[next3Cards[i] intValue]]];
    }
    return returnArray;
}

- (NSArray *)nextCombinationOf3Cards:(NSArray *)next3Cards{
    NSMutableArray *returnArray = [next3Cards mutableCopy];
    int n = [self.cards count];
    if(([returnArray[2] intValue] == n-1) && ([returnArray[1] intValue] == n-2) && ([returnArray[0] intValue] == n-3)) {
        return nil;
    }
    if ([returnArray[2] intValue] < n-1) {
        returnArray[2] = @([returnArray[2] intValue]+1);
    } else if ([returnArray[1] intValue] < n-2) {
        returnArray[1] = @([returnArray[1] intValue]+1);
        returnArray[2] = @([returnArray[1] intValue]+1);
    } else if ([returnArray[0] intValue] < n-3) {
        returnArray[0] = @([returnArray[0] intValue]+1);
        returnArray[1] = @([returnArray[0] intValue]+1);
        returnArray[2] = @([returnArray[0] intValue]+2);
    }
    return returnArray;
}

- (NSArray *)otherCardFromCombinationOf3Cards:(NSArray *)next3Cards {
    NSMutableArray *returnArray = [NSMutableArray array];
    for (int i = 1; i < 3; i++) {
        [returnArray addObject:self.cards[[next3Cards[i] intValue]]];
    }
    return returnArray;}

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
