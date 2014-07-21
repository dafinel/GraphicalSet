//
//  PlayingSetCardView.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 15/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "PlayingSetCardView.h"

@interface PlayingSetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingSetCardView


#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSMutableAttributedString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        [self drawSymbol];
    } else {
        [[UIImage imageNamed:@"backcard"] drawInRect:self.bounds];
    }
}

- (NSDictionary *)cardAtribute {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *symbolFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    symbolFont = [symbolFont fontWithSize:symbolFont.pointSize * self.bounds.size.height /75.0];
    
    UIColor *cardColor = [self.symbol attribute:NSForegroundColorAttributeName
                                        atIndex:0
                                 effectiveRange:nil];
    UIColor *cardOutlineColor= [cardColor colorWithAlphaComponent:1.0];
    NSDictionary *cardAttributes = @{NSForegroundColorAttributeName : cardColor,
                                     NSStrokeColorAttributeName : cardOutlineColor,
                                     NSStrokeWidthAttributeName: @-1,
                                     NSFontAttributeName: symbolFont,
                                     NSParagraphStyleAttributeName : paragraphStyle};
    return cardAttributes;
}

-(NSString *)diplayText {
    NSString *textToDiplay;
    if (self.rank == 2) {
        textToDiplay = [NSString stringWithFormat:@"%@\n%@",[self.symbol string],[self.symbol string]];
    } else if (self.rank == 3) {
         textToDiplay = [NSString stringWithFormat:@"%@\n%@\n%@",[self.symbol string],[self.symbol string],[self.symbol string]];
    } else {
        textToDiplay = [self.symbol string];
    }
    return textToDiplay;
}

- (void)drawSymbol {
    NSAttributedString *symbolText = [[NSAttributedString alloc] initWithString: [self diplayText] attributes: [self cardAtribute]];
    
    CGRect textBounds = CGRectInset(self.bounds, 0, (self.bounds.size.height - symbolText.size.height) / 2);
    [symbolText drawInRect:textBounds];
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}
@end
