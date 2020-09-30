//
//  SetCard.h
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SetCardColor) {
    SetCardColorRed,
    SetCardColorGreen,
    SetCardColorPurple
};

typedef NS_ENUM(NSUInteger, SetCardShape) {
    SetCardShapeDiamond,
    SetCardShapeSquiggle,
    SetCardShapeOval
};

typedef NS_ENUM(NSUInteger, SetCardShading) {
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen
};


@interface SetCard : Card

@property (nonatomic, strong) NSArray<NSNumber *> *features;

@property (nonatomic, readonly) NSUInteger shapeCount;
@property (nonatomic, readonly) SetCardShape shape;
@property (nonatomic, readonly) SetCardColor color;
@property (nonatomic, readonly) SetCardShading shading;

+ (NSArray<NSArray<NSNumber *> *> *)validValues;

@end

NS_ASSUME_NONNULL_END
