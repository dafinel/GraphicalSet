//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 09/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "HistoryViewController.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

#pragma mark - initialization

- (Deck *)createDeak{
    self.gameType = @"CardsGame";
    return [[PlayingCardDeck alloc] init];
}

@end
