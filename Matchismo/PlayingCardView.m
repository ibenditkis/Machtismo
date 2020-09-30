//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Ilia Benditkis on 17/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

typedef NS_ENUM(NSInteger, Direction) {
    RIGHT, LEFT, UP, DOWN
};

static const CGFloat STANDARD_HEIGHT = 180.0;
static const CGFloat CORNER_RADIUS = 12.0;
static const CGFloat CORNER_HORIZ_OFFSET = 12.0;
static const CGFloat CORNER_VERT_OFFSET = 24.0;
static const CGFloat CORNER_FONT_SIZE = 30;
static const CGFloat CORNER_LINE_HEIGHT = 22;
static const CGFloat PIP_FONT_SIZE = 40;
static const CGFloat PIP_HORIZ_STEP = 35;
static const CGFloat PIP_VERT_STEP = 20;
static const CGFloat ACE_FONT_SIZE = 80;
static const CGFloat ROYAL_RECT_WIDTH = 10;
static const CGFloat ROYAL_RECT_GAP = 3;
static const CGFloat BACK_STRIP_WIDTH = 15;
static const CGFloat BACK_STRIP_GAP = 5;
static const CGFloat BACK_BORDER = 2;

#pragma mark - Initialization

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - Updaters

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    if (_faceUp == faceUp) return;
    _faceUp = faceUp;
    [UIView transitionWithView:self duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft\
                    animations:nil
                    completion:nil];
    [self setNeedsDisplay];
}

#pragma mark - Calculated

- (CGFloat)scaleFactor {
    return MIN(self.bounds.size.height, self.bounds.size.width) / STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
    return CORNER_RADIUS * self.scaleFactor;
}

- (CGPoint)cornerOffset {
    return CGPointMake(CORNER_HORIZ_OFFSET * self.scaleFactor, CORNER_VERT_OFFSET * self.scaleFactor);
}

- (UIFont *)textFont {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

- (NSString *)rankAsString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

+ (NSDictionary<NSString *, UIColor *> *)colorsMap {
    return @{
        @"♣︎": [UIColor colorWithRed:0.93 green:0.41 blue:0.13 alpha:1.0],
        @"♦︎": [UIColor colorWithRed:0.85 green:0.70 blue:0.17 alpha:1.0],
        @"♥︎": [UIColor colorWithRed:0.81 green:0.20 blue:0.28 alpha:1.0],
        @"♠︎": [UIColor colorWithRed:0.16 green:0.48 blue:0.75 alpha:1.0]
    };
}
    
- (UIColor*)color {
    UIColor *color = PlayingCardView.colorsMap[self.suit];
    if (!color) {
        color = [UIColor whiteColor];
    }
    
    return color;
}

- (CGPoint)mid {
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [roundedRect addClip];
    [[UIColor colorWithRed:0.05 green:0.05 blue:0.1 alpha:1.0] setFill];
    UIRectFill(self.bounds);
    
    if (self.faceUp) {
        [self drawCorners];
        switch(self.rank) {
            case 1: [self drawAce]; break;
            case 11: [self drawJack]; break;
            case 12: [self drawQueen]; break;
            case 13: [self drawKing]; break;
            default: [self drawPips];
        }
    } else {
        [self drawBack];
    }
}

- (void)drawCorners {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.maximumLineHeight = CORNER_LINE_HEIGHT * self.scaleFactor;
    NSString *content = [NSString stringWithFormat:@"%@\n%@", self.rankAsString, self.suit];
    NSDictionary *attributes = @{
        NSFontAttributeName:[self.textFont fontWithSize:CORNER_FONT_SIZE * self.scaleFactor],
        NSParagraphStyleAttributeName:paragraph,
        NSForegroundColorAttributeName:self.color
    };
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:content
                                                                attributes:attributes];
    
    CGRect textBounds;
    textBounds.origin = self.cornerOffset;
    textBounds.size = text.size;
    [text drawInRect:textBounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [text drawInRect:textBounds];
    CGContextRestoreGState(context);
}

- (void)drawPips {
    NSNumber *rank = [NSNumber numberWithUnsignedInteger:self.rank];
    if ([@[@2, @3] containsObject:rank]) {
        [self drawPipAtCol:0 inRow:-2 withRotation:0];
        [self drawPipAtCol:0 inRow:2 withRotation:M_PI];
    }
    if ([@[@3, @5, @7, @9] containsObject:rank]) {
        [self drawPipAtCol:0 inRow:0 withRotation:0];
    }
    if ([@[@4, @5, @6, @7, @8, @9, @10] containsObject:rank]) {
        [self drawPipAtCol:-1 inRow:-2 withRotation:0];
        [self drawPipAtCol:-1 inRow:2 withRotation:M_PI];
        [self drawPipAtCol:1 inRow:-2 withRotation:0];
        [self drawPipAtCol:1 inRow:2 withRotation:M_PI];
    }
    if ([@[@6, @7, @8, @9, @10] containsObject:rank]) {
        [self drawPipAtCol:0 inRow:-3 withRotation:0];
        [self drawPipAtCol:0 inRow:3 withRotation:M_PI];
    }
    if ([@[@8, @9, @10] containsObject:rank]) {
        [self drawPipAtCol:-1 inRow:0 withRotation:-M_PI_2];
        [self drawPipAtCol:1 inRow:0 withRotation:M_PI_2];
    }
    if ([@[@10] containsObject:rank]) {
        [self drawPipAtCol:0 inRow:-1 withRotation:0];
        [self drawPipAtCol:0 inRow:1 withRotation:M_PI];
    }
}

- (void)drawCenteredText:(NSAttributedString *)text x:(CGFloat)x y:(CGFloat)y rotation:(CGFloat)rotation {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, x, y);
    CGContextRotateCTM(context, rotation);
    [text drawAtPoint:CGPointMake(- text.size.width / 2, - text.size.height / 2)];
    CGContextRestoreGState(context);
}

- (void)drawPipAtCol:(CGFloat)col inRow:(CGFloat)row withRotation:(CGFloat)rotation {
    [self drawPipAtCol:col inRow:row withRotation:rotation fontSize:PIP_FONT_SIZE];
}

- (void)drawPipAtCol:(CGFloat)col inRow:(CGFloat)row withRotation:(CGFloat)rotation fontSize:(CGFloat)fontSize {
    CGFloat x = CGRectGetMidX(self.bounds) + col * self.scaleFactor * PIP_HORIZ_STEP;
    CGFloat y = CGRectGetMidY(self.bounds) + row * self.scaleFactor * PIP_VERT_STEP;
    
    NSDictionary *attributes = @{
        NSFontAttributeName:[self.textFont fontWithSize:fontSize * self.scaleFactor],
        NSForegroundColorAttributeName:self.color
    };
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self.suit
                                                               attributes:attributes];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, x, y);
    CGContextRotateCTM(context, rotation);
    [text drawAtPoint:CGPointMake(- text.size.width / 2, - text.size.height / 2)];
    CGContextRestoreGState(context);
}

- (void)drawAce {
    [self drawPipAtCol:0 inRow:0 withRotation:0 fontSize:ACE_FONT_SIZE];
}

- (void)drawJack {
    [self drawRectInCol:0 row:1 size:CGSizeMake(2, 1)];
    [self drawRectInCol:2 row:1 size:CGSizeMake(2, 1)];

    [self drawRectInCol:0 row:2 size:CGSizeMake(1, 2.5)];
    [self drawRectInCol:1 row:2 size:CGSizeMake(1, 3.5)];
    [self drawRectInCol:2 row:2 size:CGSizeMake(1, 3.0)];
    [self drawRectInCol:3 row:2 size:CGSizeMake(1, 2.0)];
}

- (void)drawQueen {
    [self drawRectInCol:0 row:1 size:CGSizeMake(1, 1)];
    [self drawRectInCol:1 row:1 size:CGSizeMake(1, 1)];
    [self drawRectInCol:2 row:1 size:CGSizeMake(2, 1)];

    [self drawRectInCol:0 row:2 size:CGSizeMake(2, 1)];

    [self drawRectInCol:0 row:3 size:CGSizeMake(1, 3.5)];
    [self drawRectInCol:1 row:3 size:CGSizeMake(1, 2.5)];
    
    [self drawRectInCol:2 row:2 size:CGSizeMake(1, 2.5)];
    [self drawRectInCol:3 row:2 size:CGSizeMake(1, 2.0)];
}

- (void)drawKing {
    [self drawRectInCol:0 row:1 size:CGSizeMake(3, 1)];
    [self drawRectInCol:3 row:1 size:CGSizeMake(1, 1)];

    [self drawRectInCol:0 row:2 size:CGSizeMake(1, 4.5)];
    [self drawRectInCol:1 row:2 size:CGSizeMake(1, 3.5)];
    [self drawRectInCol:2 row:2 size:CGSizeMake(1, 2.5)];
    [self drawRectInCol:3 row:2 size:CGSizeMake(1, 3.5)];
}

- (void)drawRectInCol:(CGFloat)col row:(CGFloat)row size:(CGSize)dimensions {
    CGFloat width = self.scaleFactor * ROYAL_RECT_WIDTH;
    CGFloat gap = self.scaleFactor * ROYAL_RECT_GAP;
    CGFloat step = width + gap;
    CGSize size = CGSizeMake(dimensions.width * step - gap, dimensions.height * step - gap);
    CGPoint offset = CGPointMake(step * (col - 1) + gap + width/2, step * (row - 1) + gap + width/2);
    
    [self.color setFill];
    UIRectFill(CGRectMake(self.mid.x + offset.x, self.mid.y + offset.y, size.width, size.height));
    UIRectFill(CGRectMake(self.mid.x - offset.x - size.width, self.mid.y + offset.y, size.width, size.height));
    UIRectFill(CGRectMake(self.mid.x + offset.x, self.mid.y - offset.y - size.height, size.width, size.height));
    UIRectFill(CGRectMake(self.mid.x - offset.x - size.width, self.mid.y - offset.y - size.height, size.width, size.height));
}

- (void)drawBack {
    CGFloat stripWidth = self.scaleFactor * BACK_STRIP_WIDTH;
    CGFloat gap = self.scaleFactor * BACK_STRIP_GAP;
    CGFloat border = self.scaleFactor * BACK_BORDER;
    CGPoint offset = CGPointMake(gap/2, gap/2);
    BOOL even = NO;
    for (NSString *suit in @[@"♣︎", @"♥︎", @"♦︎", @"♠︎"]) {
        [PlayingCardView.colorsMap[suit] setFill];
        
        if (even) {
            CGFloat horizontalLength = self.bounds.size.width - (self.mid.x + offset.x) - border;
            CGFloat verticalLength = self.bounds.size.height - (self.mid.y + offset.x) - border;
            UIRectFill(CGRectMake(self.mid.x + offset.x, self.mid.y + offset.y, horizontalLength, stripWidth));
            UIRectFill(CGRectMake(border, self.mid.y - offset.y - stripWidth, horizontalLength, stripWidth));
            UIRectFill(CGRectMake(self.mid.x - offset.y - stripWidth, self.mid.y + offset.x, stripWidth, verticalLength));
            UIRectFill(CGRectMake(self.mid.x + offset.y, border, stripWidth, verticalLength));
            offset.y += stripWidth + gap;
        } else {
            CGFloat horizontalLength = self.bounds.size.width - (self.mid.x + offset.y) - border;
            CGFloat verticalLength = self.bounds.size.height - (self.mid.y + offset.y) - border;
            UIRectFill(CGRectMake(self.mid.x + offset.x, self.mid.y - offset.y - stripWidth, horizontalLength, stripWidth));
            UIRectFill(CGRectMake(border, self.mid.y + offset.y, horizontalLength, stripWidth));
            UIRectFill(CGRectMake(self.mid.x + offset.x, self.mid.y + offset.y, stripWidth, verticalLength));
            UIRectFill(CGRectMake(self.mid.x - offset.x - stripWidth, border, stripWidth, verticalLength));
            offset.x += stripWidth + gap;
        }
        even = !even;
    }
}

@end
