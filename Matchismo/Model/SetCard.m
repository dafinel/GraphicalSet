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
    numberOfSymbol += [[SetCard validSymbols] indexOfObject: [self.symbol string]]+1;
    numberOfNumber += self.rank;
    UIColor *thisColor = [self.symbol attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
    CGFloat alpha = 0;
    [thisColor getHue:nil
             saturation:nil
             brightness:nil
                  alpha:&alpha];
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

    
    if ([othercards count] == 2) {
        for (SetCard *otherCard in othercards) {
            numberOfSymbol += [[SetCard validSymbols] indexOfObject: [otherCard.symbol string]]+1;
            numberOfNumber += otherCard.rank;
            
            
            UIColor *symbolColor = [otherCard.symbol attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
            CGFloat alpha = 0;
            [symbolColor getHue:nil
                     saturation:nil
                     brightness:nil
                          alpha:&alpha];
            if (alpha == 0) {
                numberOfShade += 1;
            } else if (alpha == 0.5) {
                 numberOfShade += 2;
            } else {
                 numberOfShade += 3;
            }
            if (symbolColor == [UIColor redColor]) {
                numberOfColor += 1;
            } else if(symbolColor == [UIColor greenColor]) {
                 numberOfColor += 2;
            } else if (symbolColor == [UIColor purpleColor]) {
                numberOfColor += 3;
            }
        }
        if ((numberOfSymbol %3 == 0)&&(numberOfShade %3 == 0)&&
            (numberOfNumber %3 == 0)&&(numberOfColor %3 == 0)) {
                score = 1;
        }
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
