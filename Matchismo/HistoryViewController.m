//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 16/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HistoryViewController

- (void)setHistory:(NSMutableArray *)history {
    _history=history;
    if (self.view.window) {
        [self updateUI];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    NSMutableAttributedString *text= [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.textStorage ];
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@"\n"];
    for (NSAttributedString *string in self.history) {
        [text appendAttributedString: space];
        [text appendAttributedString: string];
    }
    //self.textView.text = [text string];
    [self.textView.textStorage setAttributedString:text];
    
}

@end
