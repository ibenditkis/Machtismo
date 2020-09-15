//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (CardMatchingGame *)createGame {
    CardMatchingGame* game = [super createGame];
    game.matchAmount = 3;
    return game;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card {
    return [self textForCard:card];
}

- (NSAttributedString *)textForCard:(Card *)card {
    SetCard* setCard = (SetCard*)card;
    NSMutableString *title = [NSMutableString stringWithCapacity:setCard.shapeCount];

    int i;
    for (i = 0; i < setCard.shapeCount; i++) {
        [title appendString:setCard.shapeSymbol];
    }
    
    UIColor *color = [SetCardGameViewController colorByName:setCard.colorName];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = color;
    attributes[NSStrokeWidthAttributeName] = @-8;
    attributes[NSStrokeColorAttributeName] = color;
    if ([setCard.shading isEqualToString:@"open"]) {
        attributes[NSStrokeWidthAttributeName] = @8;
    } else if ([setCard.shading isEqualToString:@"stripped"]) {
        attributes[NSForegroundColorAttributeName] = [color colorWithAlphaComponent:0.2];
    }
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:attributes];
}

+ (UIColor *)colorByName:(NSString *)name {
    UIColor *color = [UIColor blackColor];
    if ([name isEqualToString:@"red"]) color = [UIColor redColor];
    else if ([name isEqualToString:@"green"]) color = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1.0];
    else if ([name isEqualToString:@"purple"]) color = [UIColor purpleColor];
    return color;
}

- (UIImage *)backgroundImageForCard:(Card *) card {
    return [UIImage imageNamed:card.chosen ? @"cardfront.landscape.selected" :  @"cardfront.landscape"];
}

@end
