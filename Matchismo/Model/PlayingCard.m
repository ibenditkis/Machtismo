//
//  PlayingCard.m
//  Matchismo
//
//  Created by Ilia Benditkis on 07/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    BOOL sameSuit = YES;
    BOOL sameRank = YES;
    for (PlayingCard *otherCard in otherCards) {
        if (![self.suit isEqualToString:otherCard.suit]) {
            sameSuit = NO;
        }
        if (self.rank != otherCard.rank) {
            sameRank = NO;
        }
    }
    if ([otherCards count] == 1) {
        if (sameSuit) {
            score = 1;
        } else if (sameRank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        if (sameSuit) {
            score = 4;
        } else if (sameRank) {
            score = 16;
        } else {
            return MAX(MAX([self match:@[otherCards[0]]],
                           [self match:@[otherCards[1]]]),
                           [otherCards[0] match:@[otherCards[1]]]);
            
        }
    }
        
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *) validSuits {
    return @[@"♥︎", @"♦︎", @"♠︎", @"♣︎"];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *) rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger) maxRank {
    return [[PlayingCard rankStrings] count] - 1;
}

@end
