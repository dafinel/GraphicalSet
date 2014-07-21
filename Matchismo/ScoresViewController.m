//
//  ScoresViewController.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 17/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "ScoresViewController.h"
#import "GameResult.h"

@interface ScoresViewController ()
@property (nonatomic, weak  ) IBOutlet UITextView *scoresTextView;
@property (nonatomic, strong) NSArray *scores;

@end

@implementation ScoresViewController

#pragma mark - IBActions

- (IBAction)byScoreAction:(UIButton *)sender {
    self.scores = [self.scores sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateUI];
}

- (IBAction)byDateAction:(UIButton *)sender {
    self.scores = [self.scores sortedArrayUsingSelector:@selector(compareDate:)];
    [self updateUI];
}

- (IBAction)byDurationAction:(UIButton *)sender {
    self.scores = [self.scores sortedArrayUsingSelector:@selector(compareDuration:)];
    [self updateUI];
}

#pragma mark - update

-(void)changeScore:(GameResult *)game toColor:(UIColor *)color {
    NSRange range = [self.scoresTextView.text rangeOfString:[self stringForGameResult:game]];
    [self.scoresTextView.textStorage addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)updateUI {
    NSString *text = [[NSString alloc] init];
    for(GameResult *game in self.scores) {
        text = [text stringByAppendingString:[self stringForGameResult:game]];
    }
    self.scoresTextView.text=text;
    NSArray *sortedScores = [self.scores sortedArrayUsingSelector:@selector(compareScore:)];
    [self changeScore:[sortedScores firstObject] toColor:[UIColor redColor]];
    [self changeScore:[sortedScores lastObject] toColor:[UIColor greenColor]];
    sortedScores = [sortedScores sortedArrayUsingSelector:@selector(compareDuration:)];
    [self changeScore:[sortedScores firstObject] toColor:[UIColor blueColor]];
    [self changeScore:[sortedScores lastObject] toColor:[UIColor purpleColor]];
    
    
}

- (NSString *)stringForGameResult:(GameResult *)game {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"];
    [dateFormatter setLocale:usLocale];
    NSString *text = [NSString stringWithFormat:@"%@: %d, (%@, %.0f)\n",game.gameType,game.score,[dateFormatter stringFromDate:game.end],game.duration];
    return text;
}

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scores = [GameResult allscores];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scores = [GameResult allscores];
    [self updateUI];
}

@end
