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
        [self drawSymbolImage];
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

- (void)drawSymbolImage {
    CGRect drawingRect = CGRectInset(self.bounds,
                                   self.bounds.size.width * (1.0-self.faceCardScaleFactor),
                                   self.bounds.size.height * (1.0-self.faceCardScaleFactor));
    if ([[self.symbol string] isEqualToString:@"▲"]) {
        [self drawDiamondImage:drawingRect];
    } else if ([[self.symbol string] isEqualToString:@"●"]) {
        [self drawOvalImage:drawingRect];
    } else {
        [self drawSquiggleImage:drawingRect];
    }
    
}

- (UIBezierPath *)drawSquiggle:(CGRect)drawingRect withDimension:(CGFloat)dimension {
    UIBezierPath *squiggle = [[UIBezierPath alloc] init];
  
  /*  CGRect miniRect =CGRectMake(drawingRect.origin.x, drawingRect.origin.y, drawingRect.size.width, drawingRect.size.height/3);
    UIBezierPath *rect =[UIBezierPath bezierPathWithRect:miniRect];
    [[UIColor blackColor] setStroke ];
    [rect stroke];
    */
    CGFloat x = drawingRect.origin.x;
    CGFloat y = drawingRect.origin.y;
    CGFloat width = drawingRect.size.width;
    CGFloat height = drawingRect.size.height;
    [squiggle moveToPoint:CGPointMake(x + width/9 , y + height/6+dimension)];
    [squiggle addCurveToPoint:CGPointMake(x+width-width/9, y + height /9 +dimension)
                controlPoint1:CGPointMake(x + width/2, y+dimension)
                controlPoint2:CGPointMake(x+width/2, y+height/3+dimension)];
    [squiggle moveToPoint:CGPointMake(x + width/9 , y + height/6+dimension)];
    [squiggle addArcWithCenter:CGPointMake(x + width/9, y + height/3-height/9+dimension)
                        radius:width/12
                    startAngle:M_PI
                      endAngle:0
                     clockwise:NO];
    [squiggle moveToPoint:CGPointMake(x + width/9, y + height/3-height/9+dimension)];
    [squiggle addCurveToPoint:CGPointMake(x+width-width/9, y + 2 *height /9+dimension)
                controlPoint1:CGPointMake(x + width/2, y+height/9+dimension)
                controlPoint2:CGPointMake(x+width/2, y+height/3+height/9+dimension)];
    
    return squiggle;
}

- (void)drawSquiggleImage:(CGRect)drawingRect {
    if (self.rank ==1) {
        UIBezierPath *squiggle = [self drawSquiggle:drawingRect withDimension:drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [squiggle fill];
        [squiggle stroke];
    } else if (self.rank == 2) {
        UIBezierPath *squiggle1 = [self drawSquiggle:drawingRect withDimension:0.0];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [squiggle1 fill];
        [squiggle1 stroke];
        UIBezierPath *squiggle2 = [self drawSquiggle:drawingRect withDimension:2 * drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [squiggle2 fill];
        [squiggle2 stroke];
    } else {
        UIBezierPath *squiggle1 = [self drawSquiggle:drawingRect withDimension:0.0];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [squiggle1 fill];
        [squiggle1 stroke];
        UIBezierPath *squiggle2 = [self drawSquiggle:drawingRect withDimension:drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [squiggle2 fill];
        [squiggle2 stroke];
        UIBezierPath *squiggle3 = [self drawSquiggle:drawingRect withDimension:2 * drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [squiggle3 fill];
        [squiggle3 stroke];
    }
}

- (void)drawOvalImage:(CGRect)drawingRect {
    if (self.rank ==1) {
        UIBezierPath *oval = [self drawOval:drawingRect withDimension:drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [oval fill];
        [oval stroke];
    } else if (self.rank == 2) {
        UIBezierPath *oval1 = [self drawOval:drawingRect withDimension:0.0];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [oval1 fill];
        [oval1 stroke];
        UIBezierPath *oval2 = [self drawOval:drawingRect withDimension:2 * drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [oval2 fill];
        [oval2 stroke];
    } else {
        UIBezierPath *oval1 = [self drawOval:drawingRect withDimension:0.0];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [oval1 fill];
        [oval1 stroke];
        UIBezierPath *oval2 = [self drawOval:drawingRect withDimension:drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [oval2 fill];
        [oval2 stroke];
        UIBezierPath *oval3 = [self drawOval:drawingRect withDimension:2 * drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [oval3 fill];
        [oval3 stroke];
    }
}

- (UIBezierPath *)drawOval:(CGRect)drawingRect withDimension:(CGFloat)dimension {
    UIBezierPath *oval = [[UIBezierPath alloc] init];
    CGRect ovalRect = CGRectMake(drawingRect.origin.x,
                                 drawingRect.origin.y + dimension,
                                 drawingRect.size.width,
                                 drawingRect.size.height/3);
    oval = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    return oval;
}

- (void)drawDiamondImage:(CGRect)drawingRect {
    if (self.rank ==1) {
        UIBezierPath *diamond = [self drawDiamond:drawingRect withDimension:drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [diamond fill];
        [diamond stroke];
    } else if (self.rank == 2) {
        UIBezierPath *diamond1 = [self drawDiamond:drawingRect withDimension:0.0];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [diamond1 fill];
        [diamond1 stroke];
        UIBezierPath *diamond2 = [self drawDiamond:drawingRect withDimension:2 * drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [diamond2 fill];
        [diamond2 stroke];
    } else {
        UIBezierPath *diamond1 = [self drawDiamond:drawingRect withDimension:0.0];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [diamond1 fill];
        [diamond1 stroke];
        UIBezierPath *diamond2 = [self drawDiamond:drawingRect withDimension:drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [diamond2 fill];
        [diamond2 stroke];
        UIBezierPath *diamond3 = [self drawDiamond:drawingRect withDimension:2 * drawingRect.size.height/3];
        [[ self getCardColor] setFill];
        [[[ self getCardColor] colorWithAlphaComponent:1.0] setStroke];
        [diamond3 fill];
        [diamond3 stroke];
    }
}

- (UIBezierPath *)drawDiamond: (CGRect) drawingRect  withDimension:(CGFloat)dimension{
   
    UIBezierPath *diamond = [[UIBezierPath alloc] init];
    [diamond moveToPoint:CGPointMake(drawingRect.size.width/2+drawingRect.origin.x,
                                     drawingRect.origin.y +dimension)];
    [diamond addLineToPoint:CGPointMake(drawingRect.origin.x,
                                        drawingRect.origin.y + drawingRect.size.height/3/2 + dimension)];
    [diamond addLineToPoint:CGPointMake(drawingRect.size.width/2+drawingRect.origin.x,
                                        drawingRect.origin.y + drawingRect.size.height/3 + dimension)];
    [diamond addLineToPoint:CGPointMake(drawingRect.origin.x +  drawingRect.size.width ,
                                        drawingRect.origin.y + drawingRect.size.height/3/2 +dimension)];
    [diamond closePath];
    
    return diamond;
}

-(UIColor*) getCardColor {
    UIColor *cardColor = [self.symbol attribute:NSForegroundColorAttributeName
                                        atIndex:0
                                 effectiveRange:nil];
    return cardColor;
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
