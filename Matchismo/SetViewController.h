//
//  SetViewController.h
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 15/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController

@property (nonatomic, strong) NSString *gameType;
@property (nonatomic        ) NSUInteger numberOfStartingCards;
@property (nonatomic        ) CGSize maxCardSize;

-(void)tap:(UITapGestureRecognizer *)sender;

@end
