//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 07/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) NSString *gameType;

- (Deck *)createDeak;
- (void)setNumberOfCardsForGame:(NSUInteger)nr;
@end
