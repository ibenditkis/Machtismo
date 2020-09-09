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

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)setMatchAmmount:(NSUInteger)matchAmmount {
    if (matchAmmount >= 2 && matchAmmount <= 3) {
        _matchAmmount = matchAmmount;
    }
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        self.matchAmmount = 3;
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
        if (card.chosen) {
            card.chosen = NO;
            NSLog(@"close %@", card.contents);
            self.message = @"";
        } else {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            
            for (Card* otherCard in self.cards) {
                if (otherCard.chosen && !otherCard.matched) {
                    [otherCards addObject:otherCard];
                }
            }
            NSString *cardNames = formatCards([otherCards arrayByAddingObject:card]);
            
            if ([otherCards count] >= self.matchAmmount - 1) {
                int matchScore = [card match:otherCards];
                int scoreGain = 0;
                if (matchScore) {
                    scoreGain = matchScore * MATCH_BONUS;
                    for (Card *otherCard in otherCards) otherCard.matched = YES;
                    card.matched = YES;
                    self.message = [NSString stringWithFormat: @"Matched %@ for %d point%@",
                                    cardNames, scoreGain, scoreGain > 1 ? @"s" : @""];
                } else {
                    scoreGain = -MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards) otherCard.chosen = NO;
                    self.message = [NSString stringWithFormat: @"%@ don't match! %d point penalty!",
                                    cardNames, -scoreGain];
                }
                self.score += scoreGain;
                NSLog(@"match %@ with %@ matchScore=%d", card.contents, formatCards(otherCards), matchScore);
            } else {
                self.message = cardNames;
                NSLog(@"open %@", card.contents);
            }
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
        }
        self.stepCount++;
    }
}

@end
