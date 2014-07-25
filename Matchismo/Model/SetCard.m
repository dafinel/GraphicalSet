//
//  SetCard.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 15/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray *)validSymbols {
    return @[@"▲",@"■",@"●"];
}

+ (NSArray *)validShadings {
    return @[@"open", @"striped", @"solid" ];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"purple"];
}

- (int)match:(NSArray *)othercards {
    int score = 0;
    int numberOfSymbol = 0;
    int numberOfShade = 0;
    int numberOfColor = 0;
    int numberOfNumber = 0;
    
   // numberOfSymbol += [[SetCard validSymbols] indexOfObject: [self.symbol string]]+1;
    //numberOfNumber += self.rank;
   /*
   
    if (alpha == 0) {
        numberOfShade += 1;
    } else if (alpha == 0.5) {
        numberOfShade += 2;
    } else {
        numberOfShade += 3;
    }
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    [thisColor getRed:&red green:&green blue:&blue alpha:nil];
    if ((red == 0.5) && (blue == 0.5)) {
        numberOfColor += 3;
    } else if(green == 1.0) {
        numberOfColor += 2;
    } else if (red == 1.0) {
        numberOfColor += 1;
    }
*/
    
    if ([othercards count] == 2) {
        NSMutableArray *symbol = [ NSMutableArray array];
        NSMutableArray *number = [ NSMutableArray array];
        NSMutableArray *color = [ NSMutableArray array];
        NSMutableArray *shade = [ NSMutableArray array];
        
        UIColor *thisColor = [self.symbol attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        
        [symbol addObject:[self.symbol string]];
        [number addObject:@(self.rank)];
        [color addObject:[thisColor colorWithAlphaComponent:1.0]];
        
        CGFloat alpha = 0;
        [thisColor getHue:nil
               saturation:nil
               brightness:nil
                    alpha:&alpha];
        
        [shade addObject:@(alpha)];

        
        for (SetCard *otherCard in othercards) {
           // numberOfSymbol += [[SetCard validSymbols] indexOfObject: [otherCard.symbol string]]+1;
            //numberOfNumber += otherCard.rank;
            if (![symbol containsObject:[otherCard.symbol string]]) {
                [symbol addObject:[otherCard.symbol string]];
            }
            if (![number containsObject:@(otherCard.rank)]) {
                [number addObject:@(otherCard.rank)];
            }
            
            UIColor *symbolColor = [otherCard.symbol attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            CGFloat alpha = 0;
            [symbolColor getHue:nil
                     saturation:nil
                     brightness:nil
                          alpha:&alpha];
            if (![color containsObject:[symbolColor colorWithAlphaComponent:1.0]]) {
                [color addObject:[symbolColor colorWithAlphaComponent:1.0]];
            }
            if (![shade containsObject:@(alpha)]) {
                [shade addObject:@(alpha)];
            }
            
            /*
            if (alpha == 0) {
                numberOfShade += 1;
            } else if (alpha == 0.5) {
                 numberOfShade += 2;
            } else {
                 numberOfShade += 3;
            }
            [symbolColor getRed:&red green:&green blue:&blue alpha:nil];
            if ((red == 0.5) && (blue == 0.5)) {
                numberOfColor += 3;
            } else if(green == 1.0) {
                numberOfColor += 2;
            } else if (red == 1.0) {
                numberOfColor += 1;
            }
             */
            if (([color count] == 1 || [color count] == 3)
                && ([symbol count] == 1 || [symbol count] == 3)
                && ([shade count] == 1 || [shade count] == 3)
                && ([number count] == 1 || [number count] == 3)) {
                score = 1;
            }
            
        }
        /*
        if ((numberOfSymbol %3 == 0) && (numberOfShade %3 == 0) &&
            (numberOfNumber %3 == 0) && (numberOfColor %3 == 0)) {
                score = 1;
        }*/
    }
    return score;
}

- (NSAttributedString *)contents {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.symbol];
    if (self.rank == 2) {
        [text appendAttributedString:self.symbol];
    } else if (self.rank == 3) {
         [text appendAttributedString:self.symbol];
         [text appendAttributedString:self.symbol];
    }
    return text;
}

@end
