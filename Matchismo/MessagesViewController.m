//
//  MessagesViewController.m
//  Matchismo
//
//  Created by Ilia Benditkis on 14/09/2020.
//  Copyright © 2020 Ilia Benditkis. All rights reserved.
//

#import "MessagesViewController.h"

@interface MessagesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *text;

@end

@implementation MessagesViewController

- (void)setMessages:(NSArray<NSAttributedString *> *)messages {
    _messages = messages;
    if (self.view.window) [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    NSMutableAttributedString* contents = [[NSMutableAttributedString alloc] init];
    for (NSAttributedString *message in self.messages) {
        if (contents.string.length) {
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
        [contents appendAttributedString:message];
    }
    
    self.text.attributedText = contents;
}

@end
