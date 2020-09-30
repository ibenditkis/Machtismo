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

- (CardMatchingGame *)createGameWithCount:(NSUInteger)count;
- (void)createCardViewsFromGame:(CardMatchingGame *)game;
- (void)updateUI;
- (void)updateCardView:(UIView *)cardView fromCard:(Card *)card;

@end

