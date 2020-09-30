//
//  MatchDetails.h
//  Matchismo
//
//  Created by Ilia Benditkis on 14/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardGameRecord : NSObject

typedef NS_ENUM(NSInteger, CardGameStep) {
    CardGameStepChangeChosen,
    CardGameStepMatch,
    CardGameStepMismatch
};

@property (nonatomic, strong) NSMutableArray<Card *> *cards;
@property (nonatomic) CardGameStep step;
@property (nonatomic) NSInteger score;

@end

NS_ASSUME_NONNULL_END
