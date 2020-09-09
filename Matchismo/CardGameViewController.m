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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

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
    game.matchAmmount = self.modeSwitch.isOn ? 3 : 2;
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
    self.modeSwitch.enabled = self.game.stepCount == 0;
    self.messageLabel.text = self.game.message.length ? self.game.message : @"Game started";
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

- (IBAction)touchModeSwitch:(UISwitch *)sender {
    self.game.matchAmmount = sender.isOn ? 3 : 2;
}

@end
