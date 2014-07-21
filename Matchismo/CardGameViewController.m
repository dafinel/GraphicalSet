//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 07/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"
#import "GameResult.h"
#import "GameSettings.h"
#import "PlayingCardGame.h"
#import "PlayingCards.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (nonatomic, strong) IBOutletCollection(PlayingCardGame) NSArray *playingCardView;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic, weak  ) IBOutlet UILabel *scoreLabel;
@property (nonatomic        ) BOOL enable;
@property (nonatomic, weak  ) IBOutlet UILabel *stringLabel;
@property (nonatomic, strong) NSMutableArray *flipsHistory;
@property (nonatomic, strong) GameResult *gameResult;
@property (nonatomic, strong) GameSettings *gameSettings;
@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation CardGameViewController

#pragma mark - Proprieties

- (GameSettings *)gameSettings {
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

- (GameResult *)gameResult {
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

- (CardMatchingGame *)game {
    if(!_game) {
        _game=[[CardMatchingGame alloc]initWithCardCount:[self.playingCardView count]
                                               usingDeck:[self createDeak]];
        _game.MATCH_BONUS = self.gameSettings.mathBonus;
        _game.MISMATCH_PENALITY = self.gameSettings.mathPenality;
        _game.COST_TO_CHOOSE = self.gameSettings.flipCost;
        [_game setCardsForSet:self.cards];
    }
    
    return _game;
}

- (Deck *)createDeak{
    self.gameType = @"CardsGame";
    return [[PlayingCardDeck alloc] init];
}

- (Deck *)deck{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
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

- (IBAction)slideAction:(UISlider *)sender {
    int slideValue = sender.value;
    self.stringLabel.text = [[self.flipsHistory objectAtIndex:slideValue] string];
}

- (IBAction)redealAction:(UIButton *)sender {
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.playingCardView count]
                                                  usingDeck:[self createDeak]];
    [self.game setNumberOfCards:2];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.stringLabel.text = @"Play again";
    [self.flipsHistory removeAllObjects];
    for (PlayingCardGame *playingSetView in self.playingCardView){
        playingSetView.faceUp = NO;
    }
    [self setInitialCards];
}

- (void)drawRandomPlayingCard:(NSUInteger) indexOfCard {
    Card *card = [self.deck drowRandomCard];
    if ([card isKindOfClass:[PlayingCards class]]) {
        PlayingCards *playingCard = (PlayingCards *)card;
        PlayingCardGame *playingcardView = [self.playingCardView objectAtIndex:indexOfCard];
        [self.cards setObject:playingCard atIndexedSubscript:indexOfCard];
        [self.game setCardsForSet:self.cards];
        playingcardView.rank = playingCard.rank;
        playingcardView.suit = playingCard.suit;
    }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    int indexOfCard = [ self.playingCardView indexOfObject:[sender view]];
    PlayingCardGame *playingSetView = [self.playingCardView objectAtIndex:indexOfCard];
    if (!playingSetView.faceUp) {
        //[self drawRandomPlayingCard:indexOfCard];
        playingSetView.faceUp = !playingSetView.faceUp;
        [self.game chooseCardAtIndex:indexOfCard];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
        self.gameResult.score = self.game.score;
        self.stringLabel.attributedText = self.game.rezult;
        [self.flipsHistory addObject:self.game.rezult];
        [self updateUI];
    } else {
        playingSetView.faceUp = !playingSetView.faceUp;
    }
    
    
    
}

- (void)updateUI {
    for(PlayingCardGame *cardView in self.playingCardView){
        int cardIndex = [self.playingCardView indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (card.isMatched) {
            cardView.alpha = 0.2;
            cardView.faceUp = YES;
        } else {
            PlayingCardGame *playingcardView = [self.playingCardView objectAtIndex:self.game.dontMathFlipCard];
            playingcardView.faceUp = NO;
        }
    }
}

#pragma mark - Functions

- (void)setNumberOfCardsForGame:(NSUInteger)nr {
    self.game.numberOfCards = nr;
}

#pragma mark - Initialization

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.game.MATCH_BONUS = self.gameSettings.mathBonus;
    self.game.MISMATCH_PENALITY = self.gameSettings.mathPenality;
    self.game.COST_TO_CHOOSE = self.gameSettings.flipCost;
}

- (void)setInitialCards {
    for (PlayingCardGame *playingcardView in self.playingCardView){
        int indexOfCard = [ self.playingCardView indexOfObject:playingcardView];
        if (!playingcardView.faceUp) {
            [self drawRandomPlayingCard:indexOfCard];
        }
        //playingcardView.faceUp = !playingSetView.faceUp;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.game.numberOfCards = 2;
    [self setInitialCards];
}

@end
