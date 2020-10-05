//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 07/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "Grid.h"



@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *deck;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) BOOL piled;
@property (nonatomic, strong) NSArray<UIAttachmentBehavior *> *attachements;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, strong) Grid *grid;
//@property (nonatomic, strong) NSMutableArray<Card *> *viewedCards;

@end

static const NSUInteger DEFAULT_CARD_COUNT = 12;

@implementation CardGameViewController

- (void)viewDidLoad {
    self.grid = [[Grid alloc] init];
    self.animator = [[UIDynamicAnimator alloc] init];
    self.cardViews = [NSMutableArray array];
    
    [self.grid setCellAspectRatio:2.5 / 3.5];
    //self.viewedCards = [NSMutableArray array];
    [self.board addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchBoard:)]];
}

- (CardMatchingGame *)createGame {
    return [self createGameWithCount:DEFAULT_CARD_COUNT];
}

- (CardMatchingGame *)createGameWithCount:(NSUInteger)count {
    CardMatchingGame *game = [[CardMatchingGame alloc]
            initWithCardCount:count
            usingDeck:[self createDeck]];
    game.matchedAreRemoved = YES;
    return game;
}

- (Deck *)createDeck {
    return nil;
}

- (UIButton *)createCardViewForCard:(Card *)card {
    return nil;
}

- (void)addCardView:(UIButton *)cardView atIndex:(NSUInteger)index {
    if (index < self.cardViews.count && self.cardViews[index] != cardView) {
        [self removeCardViewFaiding:cardView];
    }
    
    cardView.bounds = self.cardBounds;
    cardView.center = self.dealCenter;
    self.cardViews[index] = cardView;
    [self.board addSubview:cardView];
    [cardView addTarget:self action:@selector(touchCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [cardView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCard:)]];
}

- (void)removeCardViewFaiding:(UIButton *)cardView {
    [self removeCardView:cardView duration:1.0 delay:1.0 animations:^{ cardView.alpha = 0.0; }];
}

- (void)removeCardViewFlying:(UIButton *)cardView {
    [self removeCardView:cardView duration:1.0 delay:0.5 animations:^{ cardView.center = CGPointMake(10000, 100); }];
}

- (void)removeCardView:(UIButton *)cardView duration:(NSUInteger)duration delay:(NSUInteger)delay animations:(void (^) (void))animations {
    NSUInteger cardIndex = [self.cardViews indexOfObject:cardView];
    if (cardIndex == NSNotFound) return;
    self.cardViews[cardIndex] = [NSNull null];
    [UIView animateWithDuration:duration delay:delay options:0
                     animations:animations
                     completion:^(BOOL finished) { if (finished) { [cardView removeFromSuperview]; }}];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear: animated=%d", animated);
    if (!self.game) {
        self.game = [self createGame];
        [self updateUI];
    }
}

- (void)viewDidLayoutSubviews {
    [self updateUI];
}


- (CGFloat)distance:(CGPoint)p1 and:(CGPoint)p2 {
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    return sqrt(dx * dx + dy * dy);
}

static const CGFloat ANIMATION_START_DURATION = 0.01;
static const CGFloat ANIMATION_SPEED = 4000;
static const CGFloat ANIMATION_DELAY = 0.15;
static const CGFloat ANIMATION_DELAY_JITTER = 0.05;

- (void)updateGrid {
    [self.grid setSize:self.board.bounds.size];
    [self.grid setMinimumNumberOfCells:self.game.cardCount];
}

- (CGPoint)dealCenter {
    return CGPointMake(self.deck.center.x - self.board.frame.origin.x,
                       self.deck.center.y - self.board.frame.origin.y);
}

- (CGRect)cardBounds {
    return CGRectMake(0, 0,
                      self.grid.cellSize.width - 10,
                      self.grid.cellSize.height - 10);
}

- (CGPoint)cardCenterFor:(UIButton *)cardView {
    NSUInteger cardIndex = [self.cardViews indexOfObject:cardView];
    NSUInteger row = cardIndex / self.grid.columnCount;
    NSUInteger column = cardIndex % self.grid.columnCount;
    return [self.grid centerOfCellAtRow:row inColumn:column];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardViews indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI {
    [self updateGrid];

    NSUInteger animationOrder = 0;
    for (NSUInteger cardIndex = 0; cardIndex < self.game.cardCount; cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        UIButton *cardView = (cardIndex < self.cardViews.count) ? cardView = self.cardViews[cardIndex] : nil;
        
        if (!cardView || cardView == (id)[NSNull null]) {
            if (card.matched && self.game.matchedAreRemoved) {
                continue;
            }
            cardView = [self createCardViewForCard:card];
            [self addCardView:cardView atIndex:cardIndex];
        }
        
        BOOL frameChanged = [self updateCardFrame:cardView withAnimationOrder:animationOrder];
        if (frameChanged) animationOrder++;

        [self updateCardAppearance:cardView fromCard:card];
        if (card.matched && self.game.matchedAreRemoved) {
            [self removeCardViewFaiding:cardView];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (BOOL)updateCardFrame:(UIButton*)cardView withAnimationOrder:(NSUInteger)animationOrder {
    CGRect cardBounds = self.cardBounds;
    CGPoint cardCenter = [self cardCenterFor:cardView];
    if (CGRectEqualToRect(cardView.bounds, cardBounds) &&
            CGPointEqualToPoint(cardView.center, cardCenter) &&
            CGAffineTransformIsIdentity(cardView.transform)) {
        return NO;
    }
    
    CGFloat duration = ANIMATION_START_DURATION +
            [self distance:cardView.center and:cardCenter] / ANIMATION_SPEED;
    CGFloat delay = ANIMATION_DELAY * animationOrder +
            ((CGFloat)arc4random_uniform(10) - 5) * (ANIMATION_DELAY_JITTER / 10);
    
    [UIView animateWithDuration: duration delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:^{
        cardView.transform = CGAffineTransformIdentity;
        cardView.bounds = cardBounds;
        cardView.center = cardCenter;
    }
                     completion:nil];
    return YES;
}

- (void)updateCardAppearance:(UIButton *)cardView fromCard:(Card *)card {
}

- (IBAction)touchDealButton:(UIButton *)sender {
    self.piled = NO;
    for (UIButton* cardView in [NSArray arrayWithArray:self.cardViews]) {
        if (cardView != (id)[NSNull null]) {
            [self removeCardViewFlying:cardView];
        }
    }
    self.game = [self createGame];
    [self updateUI];
}

static const CGFloat PILE_SIZE_FACTOR = 0.1;

- (IBAction)pinchBoard:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.scale < 1.0) {
            if (!self.piled) {
                self.piled = YES;
                [UIView animateWithDuration:1.0 animations:^{
                    CGSize pileSize = CGSizeMake(self.board.bounds.size.width * PILE_SIZE_FACTOR, self.board.bounds.size.height * PILE_SIZE_FACTOR);
                    for(UIView *cardView in self.board.subviews) {
                        cardView.center = CGPointMake(
                            arc4random_uniform(pileSize.width) - pileSize.width/2 + self.board.bounds.size.width/2,
                            arc4random_uniform(pileSize.height) - pileSize.height/2 + self.board.bounds.size.height/2);
                    }
                }];
            }
        } else {
            if (self.piled) {
                self.piled = NO;
                [self.animator removeAllBehaviors];
                [self updateUI];
            }
        }
    }
}



- (void)panCard:(UIPanGestureRecognizer *)gesture {
    if (!self.piled) return;
    
    CGPoint location = [gesture locationInView:self.board];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSMutableArray<UIAttachmentBehavior *> *attachments = [NSMutableArray array];
        for (UIView *cardView in self.board.subviews) {
            UIOffset offset = UIOffsetMake(location.x - cardView.center.x, location.y - cardView.center.y);
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView offsetFromCenter:offset attachedToAnchor:location];
            if (cardView == gesture.view) {
                attachment.length = 0;
            }
            [self.animator addBehavior:attachment];
            [attachments addObject:attachment];
        }
        self.attachements = attachments;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        for (UIAttachmentBehavior *attachment in self.attachements) {
            attachment.anchorPoint = location;
        }
    } else {
        [self stopDynamics];
    }
}

- (void) stopDynamics {
    [self.animator removeAllBehaviors];
    self.attachements = nil;
}


@end
