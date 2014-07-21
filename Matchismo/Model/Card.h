//
//  Card.h
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 07/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, weak              ) NSAttributedString *contents;
@property (nonatomic, getter = isChosen ) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)othercards;


@end
