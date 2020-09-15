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

- (CardMatchingGame* )createGame;
- (void)updateUI;

@end

