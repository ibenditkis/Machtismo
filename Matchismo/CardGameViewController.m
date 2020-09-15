//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 07/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "MessagesViewController.h"


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
            usingDeck:[self createDeck]];
    return game;
}

- (Deck *)createDeck {
    return nil;
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
        [cardButton setAttributedTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    if (self.game.records.count) {
        self.messageLabel.attributedText = [self textForMessage:[self.game.records lastObject]];
    } else {
        self.messageLabel.text = @"Game started";
    }
}

- (NSAttributedString *)textForCard:(Card *)card {
    return [[NSAttributedString alloc] initWithString:card.contents];
}

- (NSAttributedString *)titleForCard:(Card *)card {
    return card.chosen ? [self textForCard:card] : [[NSAttributedString alloc] init];
}

- (NSAttributedString *)textForMessage:(CardGameRecord *)record {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *cardText = [[NSMutableAttributedString alloc] init];
    for (Card* card in record.cards) {
        if ([cardText string].length > 0) {
            [cardText appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        [cardText appendAttributedString:[self textForCard:card]];
    }
    
    if (record.step == CardGameStepMatch) {
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"Matched "]];
        [text appendAttributedString:cardText];
        NSString *message = [NSString stringWithFormat:@" for %lld point%@",
                                  (long long)record.score, record.score > 1 ? @"s" : @""];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:message]];
    } else if (record.step == CardGameStepMismatch) {
        [text appendAttributedString:cardText];
        NSString *message = [NSString stringWithFormat: @" don't match! %lld point penalty!", (long long)-record.score];
        [text appendAttributedString:[[NSMutableAttributedString alloc] initWithString:message]];
    } else {
        [text appendAttributedString:cardText];
    }
    
    return text;
}

- (UIImage *)backgroundImageForCard:(Card *) card {
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

- (IBAction)touchDealButton:(UIButton *)sender {
    self.game = [self createGame];
    [self updateUI];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowHistory"]) {
        if ([segue.destinationViewController isKindOfClass:[MessagesViewController class]]) {
            MessagesViewController *viewController = (MessagesViewController *)segue.destinationViewController;
            NSMutableArray<NSAttributedString *> *messages = [NSMutableArray array];
            for (CardGameRecord *record in self.game.records) {
                if (record.step != CardGameStepChangeChosen) {
                    [messages addObject:[self textForMessage:record]];
                }
            }
            viewController.messages = messages;
        }
    }
}

@end
