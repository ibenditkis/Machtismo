//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Ilia Benditkis on 17/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : UIButton

@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) BOOL faceUp;

@end

NS_ASSUME_NONNULL_END
