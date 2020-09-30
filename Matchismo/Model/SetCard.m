//
//  SetCard.m
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray<NSArray<NSNumber *> *> *)validValues {
    return @[@[
                 @1,
                 @2,
                 @3],
             @[
                 [NSNumber numberWithUnsignedInteger:SetCardShadingOpen],
                 [NSNumber numberWithUnsignedInteger:SetCardShadingSolid],
                 [NSNumber numberWithUnsignedInteger:SetCardShadingStriped]],
             @[
                 [NSNumber numberWithUnsignedInteger:SetCardColorRed],
                 [NSNumber numberWithUnsignedInteger:SetCardColorGreen],
                 [NSNumber numberWithUnsignedInteger:SetCardColorPurple]],
             @[
                 [NSNumber numberWithUnsignedInteger:SetCardShapeDiamond],
                 [NSNumber numberWithUnsignedInteger:SetCardShapeOval],
                 [NSNumber numberWithUnsignedInteger:SetCardShapeSquiggle]]
             ];
}

+ (NSArray<NSArray<NSString *> *> *)validValueStrings {
    return @[@[@"1", @"2", @"3"],
             @[@"solid", @"stripped", @"open"],
             @[@"red", @"green", @"purple"],
             @[@"diamond", @"oval", @"squiggle"]];
}

- (NSUInteger)shapeCount {
    return [self.features[0] unsignedIntegerValue];
}

- (SetCardShading)shading {
    return (SetCardShading)self.features[1].unsignedIntegerValue;
}

- (SetCardColor)color {
    return (SetCardColor)self.features[2].unsignedIntegerValue;
}

- (SetCardShape)shape {
    return (SetCardShape)self.features[3].unsignedIntegerValue;
}

- (NSString *)contents {
    return [NSString stringWithFormat:@"%@-%@-%@-%@",
            self.features[0],
            SetCard.validValueStrings[1][self.features[1].unsignedIntegerValue],
            SetCard.validValueStrings[2][self.features[2].unsignedIntegerValue],
            SetCard.validValueStrings[3][self.features[3].unsignedIntegerValue]];
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    int same = 0;
    BOOL matchViolated = NO;
    for(int i = 0; i < self.features.count; i++) {
        NSMutableSet *values = [NSMutableSet setWithObject:self.features[i]];
        for (SetCard* otherCard in otherCards) {
            [values addObject:otherCard.features[i]];
        }
        if (values.count > 1) {
            if (values.count < otherCards.count + 1) {
                matchViolated = YES;
                break;
            }
        } else {
            same++;
        }
    }
    
    if (!matchViolated) {
        switch(same) {
            case 0: score = 2; break;
            case 1: score = 4; break;
            case 2: score = 3; break;
            case 3: score = 1; break;
        }
    }
    return score;
}

@end
