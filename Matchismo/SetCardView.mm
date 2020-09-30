// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Ilia Benditkis.

#import "SetCardView.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat STANDARD_HEIGHT = 140.0;
static const CGFloat STANDARD_WIDTH = 80.0;
static const CGFloat CORNER_RADIUS = 12.0;
static const CGFloat SHAPE_WIDTH = 60.0;
static const CGFloat SHAPE_HEIGHT = 30.0;
static const CGFloat LINE_WIDTH = 2.0;
static const CGFloat STRIP_LINE_WIDTH = 1.2;
static const CGFloat SHAPE_INTERVAL = 40;
static const CGFloat SQUIGGLE_FACTOR = 0.8;
static const CGFloat SQUIGGLE_ADJ_X = 0.7;
static const CGFloat SQUIGGLE_ADJ_Y = 0.8;

@implementation SetCardView

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

- (void)setColor:(SetCardViewColor)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShape:(SetCardViewShape)shape {
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setCount:(NSUInteger)count {
    _count = count;
    [self setNeedsDisplay];
}

- (void)setShading:(SetCardViewShading)shading {
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen {
    if (_chosen == chosen) return;
    _chosen = chosen;
    CGFloat scale = self.chosen ? 2 : 1;
    self.transform = CGAffineTransformMakeScale(scale, scale);
    [self setNeedsDisplay];
}

#pragma mark - Calculated

- (CGFloat)cornerRadius {
    return CORNER_RADIUS * self.scaleFactor;
}

- (CGFloat)scaleFactor {
    return MIN(self.bounds.size.height / STANDARD_HEIGHT, self.bounds.size.width / STANDARD_WIDTH);
}

- (CGFloat)shapeWidth {
    return self.scaleFactor * SHAPE_WIDTH;
}

- (CGFloat)shapeHeight {
    return self.scaleFactor * SHAPE_HEIGHT;
}

- (CGFloat)lineWidth {
    return self.scaleFactor * LINE_WIDTH;
}

- (CGFloat)stripLineWidth {
    return self.scaleFactor * STRIP_LINE_WIDTH;
}

- (CGFloat)shapeInterval {
    return self.scaleFactor * SHAPE_INTERVAL;
}

- (CGPoint)mid {
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    [roundedRect addClip];
    [self.backgroundFillColor setFill];
    UIRectFill(self.bounds);
    roundedRect.lineWidth = self.lineWidth * 2;
    [self.backgroundBorderColor setStroke];
    [roundedRect stroke];
    
    [self.shapeFill setFill];
    [self.shapeColor setStroke];

    CGContextTranslateCTM(context, self.mid.x, self.mid.y);

    UIBezierPath *path = self.shapePath;
    
    if (self.count == 1 || self.count == 3) {
        [self drawShape:path atPlace:0];
    }
    if (self.count == 2) {
        [self drawShape:path atPlace:-0.5];
        [self drawShape:path atPlace:0.5];
    }
    if (self.count == 3) {
        [self drawShape:path atPlace:-1];
        [self drawShape:path atPlace:1];
    }

    CGContextRestoreGState(context);
}

- (UIColor *) backgroundFillColor {
    return [UIColor colorWithRed:0.9 green:0.88 blue:0.85 alpha:1.0];
}

- (UIColor*) backgroundBorderColor {
    if (self.chosen) {
        return self.tintColor;
    }
    
    return [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
}

- (UIColor *)shapeColor {
    UIColor* color;
    switch (self.color) {
        case SetCardViewColorRed: color = [UIColor redColor]; break;
        case SetCardViewColorGreen: color = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1.0]; break;
        case SetCardViewColorPurple: color = [UIColor purpleColor]; break;
    }
    return color;
}

- (UIColor *)shapeFill {
    UIColor* color;
    switch (self.shading) {
        case SetCardViewShadingOpen: break;
        case SetCardViewShadingSolid: color = self.shapeColor; break;
        case SetCardViewShadingStriped: color = [UIColor colorWithPatternImage:self.stripesImage]; break;
    }
    return color;
}

- (UIImage *)stripesImage {
    CGFloat width = MAX(1, floor(self.stripLineWidth + 0.5));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2 * width, width), NO, 0.0);
    UIBezierPath *stripe = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, width)];
    [self.shapeColor setFill];
    [stripe fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIBezierPath *)shapePath {
    UIBezierPath *path;
    switch (self.shape) {
        case SetCardViewShapeDiamond: path = self.shapePathDiamond; break;
        case SetCardViewShapeOval: path = self.shapePathOval; break;
        case SetCardViewShapeSquiggle: path = self.shapePathSquiggle; break;
    }
    path.lineWidth = self.lineWidth;
    return path;
}

- (UIBezierPath *)shapePathDiamond {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(-self.shapeWidth/2, 0)];
    [path addLineToPoint:CGPointMake(0, -self.shapeHeight/2)];
    [path addLineToPoint:CGPointMake(self.shapeWidth/2, 0)];
    [path addLineToPoint:CGPointMake(0, self.shapeHeight/2)];
    [path closePath];
    
    return path;
}

- (UIBezierPath *)shapePathOval {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat radius = self.shapeHeight/2;
    CGFloat rect_x = self.shapeWidth/2 - radius;
    
    [path moveToPoint:CGPointMake(-rect_x, -radius)];
    [path addLineToPoint:CGPointMake(rect_x, -radius)];
    [path addArcWithCenter:CGPointMake(rect_x, 0) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(-rect_x, radius)];
    [path addArcWithCenter:CGPointMake(-rect_x, 0) radius:radius startAngle:M_PI_2 endAngle:-M_PI_2 clockwise:YES];
    return path;
}

- (UIBezierPath *)shapePathSquiggle {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat dx = self.shapeWidth/2 * SQUIGGLE_ADJ_X;
    CGFloat dy = self.shapeHeight/2 * SQUIGGLE_ADJ_Y;
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    
    [path moveToPoint:CGPointMake(-dx, dy)];
    [path addQuadCurveToPoint:CGPointMake(-dx, -dy)
                 controlPoint:CGPointMake(-dx - dsqx, dsqy)];
    [path addCurveToPoint:CGPointMake(dx, -dy)
            controlPoint1:CGPointMake(-dx + dsqx, -dy - dsqy)
            controlPoint2:CGPointMake(dx - dsqx, -dy + dsqy)];
    [path addQuadCurveToPoint:CGPointMake(dx, dy)
                 controlPoint:CGPointMake(dx + dsqx, -dsqy)];
    [path addCurveToPoint:CGPointMake(-dx, dy)
            controlPoint1:CGPointMake(dx - dsqx, dy + dsqy)
            controlPoint2:CGPointMake(-dx + dsqx, dy - dsqy)];

    return path;
}

- (void)drawShape:(UIBezierPath *)shape atPlace:(CGFloat)place {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.shapeInterval * place);
    [shape fill];
    [shape stroke];
    CGContextRestoreGState(context);
}

@end

NS_ASSUME_NONNULL_END
