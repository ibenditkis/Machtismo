//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "PlayingCardGameViewController.h"

#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (UIButton *)createCardViewForCard:(Card *)card {
    PlayingCardView *cardView = [[PlayingCardView alloc] init];
    PlayingCard *playingCard = (PlayingCard *)card;
    cardView.suit = playingCard.suit;
    cardView.rank = playingCard.rank;
    return cardView;
}

- (void)updateCardAppearance:(UIButton *)cardView fromCard:(Card *)card {
    [super updateCardAppearance:cardView fromCard:card];
    PlayingCardView *playingCardView = (PlayingCardView *)cardView;
    playingCardView.alpha = card.matched ? 0.5 : 1.0;
    playingCardView.faceUp = card.chosen;
}

@end
