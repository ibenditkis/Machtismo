//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ilia Benditkis on 08/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readwrite) NSUInteger stepCount;
@end

@implementation CardMatchingGame

- (void)setMatchAmount:(NSUInteger)matchAmount {
    if (matchAmount >= 2 && matchAmount <= 3) {
        _matchAmount = matchAmount;
    }
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        self.cards = [NSMutableArray array];
        self.records = [NSMutableArray array];
        self.matchAmount = 2;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

NSString *formatCards(NSArray *cards) {
    return [[cards valueForKey:@"contents"] componentsJoinedByString:@" "];
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.matched) {
        CardGameRecord *record = [[CardGameRecord alloc] init];
        NSMutableArray *otherCards = [[NSMutableArray alloc] init];
        
        for (Card* otherCard in self.cards) {
            if (otherCard != card && otherCard.chosen && !otherCard.matched) {
                [otherCards addObject:otherCard];
            }
        }
        
        [record.cards addObjectsFromArray:otherCards];

        if (card.chosen) {
            card.chosen = NO;
            NSLog(@"close %@", card.contents);
        } else {
            [record.cards addObject:card];
            
            if ([otherCards count] >= self.matchAmount - 1) {
                int matchScore = [card match:otherCards];
                int scoreGain = 0;
                if (matchScore) {
                    scoreGain = matchScore * MATCH_BONUS;
                    for (Card *otherCard in otherCards) otherCard.matched = YES;
                    card.matched = YES;
                    record.step = CardGameStepMatch;
                } else {
                    scoreGain = -MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards) otherCard.chosen = NO;
                    record.step = CardGameStepMismatch;
                }
                record.score = scoreGain;
                self.score += scoreGain;
                NSLog(@"match %@ with %@ matchScore=%d", card.contents, formatCards(otherCards), matchScore);
            } else {
                NSLog(@"open %@", card.contents);
            }
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
        }
        [self.records addObject:record];
    }
}

@end
