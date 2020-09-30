//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 13/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "SetCardGameViewController.h"

#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (CardMatchingGame *)createGameWithCount:(NSUInteger)count {
    CardMatchingGame* game = [super createGameWithCount:count];
    game.matchAmount = 3;
    return game;
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (void)createCardViewsFromGame:(CardMatchingGame *)game {
    for(NSUInteger cardIndex = 0; cardIndex < game.cardCount; cardIndex++) {
        SetCardView *cardView = [[SetCardView alloc] init];
        SetCard *card = (SetCard *)[game cardAtIndex:cardIndex];
        cardView.color = [SetCardGameViewController convertColor:card.color];
        cardView.count = card.shapeCount;
        cardView.shape = [SetCardGameViewController convertShape:card.shape];
        cardView.shading = [SetCardGameViewController convertShading:card.shading];
        cardView.chosen = card.chosen;
        [self.board addSubview:cardView];
    }
}

- (void)updateCardView:(UIView *)cardView fromCard:(Card *)card {
    [super updateCardView:cardView fromCard:card];
    SetCardView *setCardView = (SetCardView *)cardView;
    setCardView.chosen = card.chosen;
}

+ (SetCardViewColor)convertColor:(SetCardColor)color {
    switch(color) {
        case SetCardColorRed: return SetCardViewColorRed;
        case SetCardColorGreen: return SetCardViewColorGreen;
        case SetCardColorPurple: return SetCardViewColorPurple;
    }
    NSAssert(false, @"wrong card color=%lu", (unsigned long)color);
}

+ (SetCardViewShape)convertShape:(SetCardShape)shape {
    switch(shape) {
        case SetCardShapeDiamond: return SetCardViewShapeDiamond;
        case SetCardShapeOval: return SetCardViewShapeOval;
        case SetCardShapeSquiggle: return SetCardViewShapeSquiggle;
    }
    NSAssert(false, @"wrong card shape=%lu", (unsigned long)shape);
}

+ (SetCardViewShading)convertShading:(SetCardShading)shading {
    switch (shading) {
        case SetCardShadingOpen: return SetCardViewShadingOpen;
        case SetCardShadingSolid: return SetCardViewShadingSolid;
        case SetCardShadingStriped: return SetCardViewShadingStriped;
    }
    NSAssert(false, @"wrong card shading=%lu", (unsigned long)shading);
}

@end
