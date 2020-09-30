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


- (void)createCardViewsFromGame:(CardMatchingGame *)game {
    for(NSUInteger cardIndex = 0; cardIndex < game.cardCount; cardIndex++) {
        PlayingCardView *cardView = [[PlayingCardView alloc] init];
        PlayingCard *card = (PlayingCard *)[game cardAtIndex:cardIndex];
        cardView.suit = card.suit;
        cardView.rank = card.rank;
        [self.board addSubview:cardView];
    }
}

- (void)updateCardView:(UIView *)cardView fromCard:(Card *)card {
    [super updateCardView:cardView fromCard:card];
    PlayingCardView *playingCardView = (PlayingCardView *)cardView;
    playingCardView.faceUp = card.chosen;
}

@end
