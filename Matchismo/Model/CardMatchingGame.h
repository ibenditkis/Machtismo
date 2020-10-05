//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ilia Benditkis on 08/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"
#import "CardGameRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSUInteger cardCount;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger matchAmount;
@property (nonatomic, strong) NSMutableArray<CardGameRecord *> *records;
@property (nonatomic) BOOL matchedAreRemoved;

@end

NS_ASSUME_NONNULL_END
