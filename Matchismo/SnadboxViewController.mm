//
//  SnadboxViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 17/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "SnadboxViewController.h"
#import "SetCardView.h"
#import "Grid.h"

#include <vector>

@interface SnadboxViewController ()
@property (weak, nonatomic) IBOutlet UIView *board;
@end

@implementation SnadboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    std::vector<SetCardViewShape> shapes {
        SetCardViewShapeDiamond,
        SetCardViewShapeOval,
        SetCardViewShapeSquiggle
    };
    std::vector<SetCardViewColor> colors {
        SetCardViewColorRed,
        SetCardViewColorGreen,
        SetCardViewColorPurple
    };
    std::vector<SetCardViewShading> shadings {
        SetCardViewShadingOpen,
        SetCardViewShadingStriped,
        SetCardViewShadingSolid
    };
    std::vector<NSUInteger> counts {
        1, 2, 3
    };
    
    NSUInteger cardCount = MAX(MAX(MAX(shapes.size(), colors.size()), shadings.size()), counts.size());

    for(NSUInteger cardIndex = 0; cardIndex < cardCount; cardIndex++) {
        SetCardView *cardView = [[SetCardView alloc] init];
        cardView.count = counts[cardIndex % counts.size()];
        cardView.shape = shapes[cardIndex % shapes.size()];
        cardView.color = colors[cardIndex % colors.size()];
        cardView.shading = shadings[cardIndex % shadings.size()];
        [self.board addSubview:cardView];
        
        [cardView addTarget:self action:@selector(handleCardTouch:) forControlEvents:UIControlEventTouchUpInside];

    }
}

- (void)viewDidLayoutSubviews {
    Grid *grid = [[Grid alloc] init];
    [grid setSize:self.board.bounds.size];
    [grid setCellAspectRatio:2.0 / 3.5];
    [grid setMinimumNumberOfCells:self.board.subviews.count];
    
    int cardIndex = 0;
    for (UIView *cardView in self.board.subviews) {
        NSUInteger row = cardIndex / grid.columnCount;
        NSUInteger column = cardIndex % grid.columnCount;
        cardView.frame = CGRectInset([grid frameOfCellAtRow:row inColumn:column], 5, 5);
        cardIndex++;
    }
}

- (void)handleCardTouch:(SetCardView *)sender {
    sender.chosen = !sender.chosen;
}

@end
