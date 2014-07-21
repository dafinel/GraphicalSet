//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 15/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init{
    self = [super init];
    if (self) {
       // NSDictionary *symbolPallette = @{@"diamond":@"▲",@"squiggle":@"■",@"oval":@"●"};
        for (NSString *symbol in [[SetCard class] validSymbols]) {
            for (int i=1;i<=3;i++) {
                for (NSString *color in [[SetCard class] validColors]) {
                    for (NSString *shading in [[SetCard class] validShadings]) {
                        SetCard *card =[[SetCard alloc] init];
                        card.rank = i;
                        UIColor *colorForSymbol = [self setColorForSymbol:color];
                        UIColor *colorForOutlineSymbol = [self setColorForSymbol:color];
                        colorForSymbol = [colorForSymbol colorWithAlphaComponent:[self setAlphaForSymbol:shading]];
                        card.symbol = [[NSMutableAttributedString alloc] initWithString:symbol
                                                                             attributes:@{ NSForegroundColorAttributeName:colorForSymbol,
                                                                                           NSStrokeColorAttributeName:colorForOutlineSymbol,
                                                                                           NSStrokeWidthAttributeName: @-2,}];
                         
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

- (UIColor *)setColorForSymbol:(NSString *)color {
    if ([color isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([color isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else {
        return [UIColor purpleColor];
    }
}

- (CGFloat)setAlphaForSymbol:(NSString *)shading {
    if ([shading isEqualToString:@"open"]) {
        return 0.0;
    } else if ([shading isEqualToString:@"striped"]) {
        return 0.5;
    } else {
        return 1.0;
    }

}

@end
