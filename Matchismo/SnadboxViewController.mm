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
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;
//@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) NSArray<UIAttachmentBehavior *> *attachements;
@property (nonatomic) BOOL grabbed;
@end

@implementation SnadboxViewController

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] init];
        [_animator setValue:[NSNumber numberWithBool:YES] forKey:@"debugEnabled"];
    }
    return _animator;
}

- (UIDynamicItemBehavior *)itemBehavior {
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc] init];
        _itemBehavior.friction = 1.0;
        [self.animator addBehavior:_itemBehavior];
    }
    return _itemBehavior;
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.scale < 1.0) {
            if (!self.grabbed) {
                self.grabbed = YES;
                [UIView animateWithDuration:1.0 animations:^{
                    for(UIView *cardView in self.board.subviews) {
                        cardView.center = CGPointMake(
                            arc4random_uniform(self.board.bounds.size.width/2) + self.board.bounds.size.width/4,
                            arc4random_uniform(self.board.bounds.size.height/2) + self.board.bounds.size.height/4);
                    }
                }
                completion: ^(BOOL finished) {
                    for (UIView *cardView in self.board.subviews) {
                        [self.itemBehavior addItem:cardView];
                    }
                }];
            }
        } else {
            if (self.grabbed) {
                self.grabbed = NO;
                for (UIView *cardView in self.board.subviews) {
                    [self.itemBehavior removeItem:cardView];
                }
                [self.animator removeAllBehaviors];
                [self layoutCards];
            }
        }
    }
}

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
        1, 2, 3, 1, 1, 1, 2, 2, 2, 3, 3, 3
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
        
        [cardView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCard:)]];

    }
}

- (void)panCard:(UIPanGestureRecognizer *)gesture {
    if (!self.grabbed) return;
    
    CGPoint location = [gesture locationInView:self.board];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSMutableArray<UIAttachmentBehavior *> *attachments = [NSMutableArray array];
//        UIView *cardView = gesture.view;
//        self.attachment.frictionTorque = 0.0;
//        self.attachment.attachmentRange = UIFloatRangeZero;
        for (UIView *cardView in self.board.subviews) {
            UIOffset offset = UIOffsetMake(location.x - cardView.center.x, location.y - cardView.center.y);
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView offsetFromCenter:offset attachedToAnchor:location];
            [self.animator addBehavior:attachment];
            [attachments addObject:attachment];
        }
        self.attachements = attachments;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        for (UIAttachmentBehavior *attachment in self.attachements) {
            attachment.anchorPoint = location;
        }
    } else {
        for (UIAttachmentBehavior *attachment in self.attachements) {
            [self.animator removeBehavior:attachment];
        }
        //self.attachment = nil;
        self.attachements = nil;
    }
}

- (void)viewDidLayoutSubviews {
    if (!self.grabbed) [self layoutCards];
}

- (void)layoutCards {
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
