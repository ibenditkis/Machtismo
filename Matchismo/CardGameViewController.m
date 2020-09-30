//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 07/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "Grid.h"



@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

static const NSUInteger DEFAULT_CARD_COUNT = 12;

@implementation CardGameViewController

- (void)viewDidLoad {
    self.game = [self createGameWithCount: DEFAULT_CARD_COUNT];
}

- (CardMatchingGame *)createGameWithCount:(NSUInteger)count {
    CardMatchingGame *game = [[CardMatchingGame alloc]
            initWithCardCount:count
            usingDeck:[self createDeck]];
    [self createCardViewsFromGame:game];
    for (UIButton* cardView in self.board.subviews) {
        [cardView addTarget:self action:@selector(touchCardButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return game;
}

- (void)createCardViewsFromGame:(CardMatchingGame *)game {
}

- (Deck *)createDeck {
    return nil;
}

- (void)viewDidLayoutSubviews {
    [self layoutCards];
}

- (void)layoutCards {
    Grid *grid = [[Grid alloc] init];
    [grid setSize:self.board.bounds.size];
    [grid setCellAspectRatio:2.5 / 3.5];
    [grid setMinimumNumberOfCells:self.board.subviews.count];
    
    int cardIndex = 0;
    int animationIndex = 0;
    for (UIView *cardView in self.board.subviews) {
        NSUInteger row = cardIndex / grid.columnCount;
        NSUInteger column = cardIndex % grid.columnCount;
        CGRect frame = CGRectInset([grid frameOfCellAtRow:row inColumn:column], 5, 5);
        if (!CGRectEqualToRect(cardView.frame, frame)) {
            cardView.frame = CGRectInset([grid frameOfCellAtRow:grid.rowCount inColumn:1], 5, 5);
            [UIView animateWithDuration:0.3 delay:0.05 * animationIndex + arc4random_uniform(5) * 0.01
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                             animations:^{
                cardView.frame = frame;
                }
                             completion:nil];
            animationIndex++;
        }
        cardIndex++;
    }
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger cardIndex = [self.board.subviews indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI {
    [self layoutCards];
    for (PlayingCardView *cardView in self.board.subviews) {
        NSUInteger cardIndex = [self.board.subviews indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        [self updateCardView:cardView fromCard:card];
        cardView.alpha = card.matched ? 0.5 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)updateCardView:(UIView *)cardView fromCard:(Card *)card {
    cardView.alpha = card.matched ? 0.5 : 1.0;
}

- (IBAction)touchDealButton:(UIButton *)sender {
    for (UIView* view in self.board.subviews) {
        [view removeFromSuperview];
    }
    self.game = [self createGameWithCount: DEFAULT_CARD_COUNT];
    [self updateUI];
}

@end
