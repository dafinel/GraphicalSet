//
//  PlayingSetCardView.h
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 15/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingSetCardView : UIView

@property (nonatomic, strong) NSMutableAttributedString *symbol;
@property (nonatomic,       ) NSUInteger rank;
@property (nonatomic,       ) BOOL faceUp;


@end
