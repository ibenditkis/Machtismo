//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card {
    if (!card.chosen) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    PlayingCard *playingCard = (PlayingCard *)card;
    UIColor *color = [UIColor blackColor];
    if ([playingCard.suit isEqualToString:@"♥︎"] ||
        [playingCard.suit isEqualToString:@"♦︎"]) {
        color = [UIColor redColor];
    }
    
    return [[NSAttributedString alloc] initWithString:card.contents
                                           attributes:@{NSForegroundColorAttributeName: color}];
}

@end
