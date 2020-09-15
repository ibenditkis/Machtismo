//
//  SetCard.h
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCard : Card

@property (nonatomic, strong) NSArray *features;

@property (nonatomic, readonly) NSUInteger shapeCount;
@property (nonatomic, readonly) NSString *shapeSymbol;
@property (nonatomic, readonly) NSString *colorName;
@property (nonatomic, readonly) NSString *shading;

+ (NSArray<NSArray *> *)validValues;

@end

NS_ASSUME_NONNULL_END
