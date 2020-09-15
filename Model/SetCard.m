//
//  SetCard.m
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray *)validValues {
    return @[@[@1, @2, @3],
             @[@"solid", @"stripped", @"open"],
             @[@"red", @"green", @"purple"],
             @[@"●", @"■", @"▲"]];
}

- (NSUInteger)shapeCount {
    return [self.features[0] unsignedIntegerValue];
}

- (NSString *)shading {
    return self.features[1];
}

- (NSString *)colorName {
    return self.features[2];
}

- (NSString *)shapeSymbol {
    return self.features[3];
}

- (NSString *)contents {
    return [NSString stringWithFormat:@"%@-%@-%@-%@",
            self.features[0],
            self.features[1],
            self.features[2],
            self.features[3]];
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
        NSLog(@"i=%d values=%@", i, values);
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
