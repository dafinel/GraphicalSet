//
//  SetViewController.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 15/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "SetViewController.h"
#import "PlayingSetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"
#import "GameResult.h"
#import "GameSettings.h"

@interface SetViewController ()
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic, weak  ) IBOutlet UILabel *stringLabel;
@property (nonatomic, strong) IBOutletCollection(PlayingSetCardView) NSArray *playingSetCardView;
@property (nonatomic, weak  ) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) NSMutableArray *flipsHistory;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic, strong) GameSettings *gameSettings;
@end

@implementation SetViewController

#pragma mark - Proprieties

- (GameSettings *)gameSettings {
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

- (GameResult *)gameResult{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = self.gameType;
    return _gameResult;
}

- (NSMutableArray *)flipsHistory {
    if(!_flipsHistory) {
        _flipsHistory = [[NSMutableArray alloc]init];
    }
    return _flipsHistory;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (Deck *)deck{
    if (!_deck) _deck = [[SetCardDeck alloc] init];
    return _deck;
}

- (Deck *)createDeak {
     self.gameType = @"SetCards";
    return [[SetCardDeck alloc] init];
}

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.playingSetCardView count]
                                                  usingDeck:[self createDeak]];
        [_game setCardsForSet:self.cards];
    }
    return _game;
}

#pragma mark - IBActions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController *historyViewController = (HistoryViewController *)segue.destinationViewController;
            historyViewController.history = self.flipsHistory;
        }
    }
}

- (void)drawRandomPlayingCard:(NSUInteger) indexOfCard {
    Card *card = [self.deck drowRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        PlayingSetCardView *playingSetView = [self.playingSetCardView objectAtIndex:indexOfCard];
        [self.cards setObject:setCard atIndexedSubscript:indexOfCard];
        [self.game setCardsForSet:self.cards];
        playingSetView.rank = setCard.rank;
        playingSetView.symbol = setCard.symbol;
    }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    int indexOfCard = [ self.playingSetCardView indexOfObject:[sender view]];
    PlayingSetCardView *playingSetView = [self.playingSetCardView objectAtIndex:indexOfCard];
    if (!playingSetView.faceUp) {
        [self drawRandomPlayingCard:indexOfCard];
    }
    playingSetView.faceUp = !playingSetView.faceUp;
    
}

- (IBAction)redealAction:(id)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.playingSetCardView count]
                                              usingDeck:[self createDeak]];
    [self.game setNumberOfCards:3];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.stringLabel.text = @"Play again";
     [self.flipsHistory removeAllObjects];
    for (PlayingSetCardView *playingSetView in self.playingSetCardView){
        playingSetView.faceUp = NO;
    }
    [self setInitialCards];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    int indexOfCard = [ self.playingSetCardView indexOfObject:[sender view]];
    [self.game chooseCardAtIndex:indexOfCard];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.gameResult.score = self.game.score;
    self.stringLabel.attributedText = self.game.rezult;
    [self.flipsHistory addObject:self.game.rezult];
    [self updateUI];
    


}

- (void)updateUI {
    for (PlayingSetCardView *playingSetView in self.playingSetCardView){
        int cardIndex = [self.playingSetCardView indexOfObject:playingSetView];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (card.isMatched) {
           [self drawRandomPlayingCard:cardIndex];
          //  playingSetView.faceUp = NO;
        }
    }
}



#pragma mark - Initialization

- (void)setInitialCards {
    for (PlayingSetCardView *playingSetView in self.playingSetCardView){
        int indexOfCard = [ self.playingSetCardView indexOfObject:playingSetView];
        if (!playingSetView.faceUp) {
            [self drawRandomPlayingCard:indexOfCard];
        }
        playingSetView.faceUp = !playingSetView.faceUp;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.game.numberOfCards = 3;
    [self setInitialCards];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.game.MATCH_BONUS = self.gameSettings.mathBonus;
    self.game.MISMATCH_PENALITY = self.gameSettings.mathPenality;
    self.game.COST_TO_CHOOSE = self.gameSettings.flipCost;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
