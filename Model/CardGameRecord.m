//
//  MatchDetails.m
//  Matchismo
//
//  Created by Ilia Benditkis on 14/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "CardGameRecord.h"

@implementation CardGameRecord

- (instancetype)init{
    if (self = [super init]) {
        self.cards = [NSMutableArray array];
    }
    return self;
}

@end
