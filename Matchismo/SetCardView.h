// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Ilia Benditkis.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SetCardViewColor) {
    SetCardViewColorRed,
    SetCardViewColorGreen,
    SetCardViewColorPurple
};

typedef NS_ENUM(NSUInteger, SetCardViewShape) {
    SetCardViewShapeDiamond,
    SetCardViewShapeSquiggle,
    SetCardViewShapeOval
};

typedef NS_ENUM(NSUInteger, SetCardViewShading) {
    SetCardViewShadingSolid,
    SetCardViewShadingStriped,
    SetCardViewShadingOpen
};

@interface SetCardView : UIButton

@property (nonatomic) SetCardViewColor color;
@property (nonatomic) NSUInteger count;
@property (nonatomic) SetCardViewShape shape;
@property (nonatomic) SetCardViewShading shading;
@property (nonatomic) BOOL chosen;

@end

NS_ASSUME_NONNULL_END
