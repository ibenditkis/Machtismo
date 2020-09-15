//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init {
    self = [super init];
    if (self) {
        for (NSArray *combinations in [SetCardDeck genCombinations:[SetCard validValues]]) {
            SetCard *card = [[SetCard alloc] init];
            card.features = combinations;
            [self addCard:card];
        }
    }
    return self;
}

+ (NSArray<NSArray *> *)genCombinations:(NSArray *)values {
    NSMutableArray *combinations = [NSMutableArray array];
    for (id value in [values lastObject]) {
        if (values.count > 1) {
            NSArray *subValues = [values subarrayWithRange:NSMakeRange(0, values.count - 1)];
            NSArray *subCombinations = [self genCombinations:subValues];
            for (NSArray *combination in subCombinations) {
                [combinations addObject:[combination arrayByAddingObject:value]];
            }
        } else {
            [combinations addObject:@[value]];
        }
    }
    return combinations;
}
@end
