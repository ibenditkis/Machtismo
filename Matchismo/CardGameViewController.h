//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Ilia Benditkis on 07/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *board;

- (CardMatchingGame *)createGame;
- (CardMatchingGame *)createGameWithCount:(NSUInteger)count;
- (UIButton *)createCardViewForCard:(Card *)card;
- (void)updateUI;
- (void)updateCardAppearance:(UIButton *)cardView fromCard:(Card *)card;

@end

