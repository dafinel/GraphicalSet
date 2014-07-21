//
//  PlayingCardGame.h
//  SuperCard
//
//  Created by Andrei-Daniel Anton on 14/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardGame : UIView

@property (nonatomic, strong) NSString *suit;
@property (nonatomic,       ) NSUInteger rank;
@property (nonatomic,       ) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
