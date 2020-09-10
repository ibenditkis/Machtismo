//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 07/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelect;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [self createGame];
    return _game;
}

- (CardMatchingGame *)createGame {
    CardMatchingGame *game = [[CardMatchingGame alloc]
            initWithCardCount:[self.cardButtons count]
            usingDeck:[[PlayingCardDeck alloc] init]];
    game.matchAmmount = [self matchAmountFromSelect: self.modeSelect];
    return game;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImgaeForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    self.modeSelect.enabled = self.game.messages.count == 0;
    self.messageLabel.text = [self.game.messages lastObject];
    self.messageLabel.alpha = 1.0;
    self.historySlider.value = self.historySlider.maximumValue = self.game.messages.count - 1;
}

- (NSString *)titleForCard:(Card *)card {
    return card.chosen ? card.contents : @"";
}

- (UIImage *)backgroundImgaeForCard:(Card *) card {
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

- (IBAction)touchDealButton:(UIButton *)sender {
    self.game = [self createGame];
    [self updateUI];
}

- (NSUInteger) matchAmountFromSelect:(UISegmentedControl *)select {
    return self.modeSelect.selectedSegmentIndex == 1 ? 3 : 2;
}

- (IBAction)touchModeSelect:(UISegmentedControl *)sender {
    self.game.matchAmmount = [self matchAmountFromSelect: sender];
}

- (IBAction)changeHistorySlider:(UISlider *)sender {
    long sliderValue = lroundf(sender.value);
    self.messageLabel.text = self.game.messages[sliderValue];
    self.messageLabel.alpha = sliderValue < self.game.messages.count - 1 ? 0.5 : 1.0;
}

- (IBAction)touchHistorySlider:(UISlider *)sender {
    long sliderValue = lroundf(sender.value);
    [sender setValue:sliderValue animated:YES];
}

@end
