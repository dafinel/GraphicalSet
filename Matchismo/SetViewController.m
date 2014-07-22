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
#import "Grid.h"

@interface SetViewController ()
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) CardMatchingGame *game;
@property (nonatomic, weak  ) IBOutlet UILabel *stringLabel;
@property (nonatomic, strong) IBOutletCollection(PlayingSetCardView) NSArray *playingSetCardView;
@property (nonatomic, strong) NSMutableArray *cardsView;
@property (nonatomic, weak  ) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) NSMutableArray *flipsHistory;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic, strong) GameSettings *gameSettings;
@property (nonatomic, strong) Grid *grid;
@property (nonatomic, weak  ) IBOutlet UIView *gridView;
@property (nonatomic, weak  ) IBOutlet UIButton *addCardButton;
@end

@implementation SetViewController

#pragma mark - Proprieties

- (NSMutableArray *)cardsView {
    if(!_cardsView) {
        _cardsView = [[NSMutableArray alloc] init];
    }
    return _cardsView;
}

- (Grid*)grid {
    if(!_grid) {
        _grid = [[Grid alloc] init];
        _grid.cellAspectRatio = self.maxCardSize.width/self.maxCardSize.height;
        _grid.size = self.gridView.frame.size;
        _grid.minimumNumberOfCells = self.numberOfStartingCards;
    }
    return _grid;
}

- (GameSettings *)gameSettings {
    if (!_gameSettings)  {
       _gameSettings = [[GameSettings alloc] init];
    }
    return _gameSettings;
}

- (GameResult *)gameResult{
    if (!_gameResult){
        _gameResult = [[GameResult alloc] init];
    }
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
        [_game setNumberOfCards:3];
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
- (IBAction)addNew3CardsActions:(UIButton *)sender {
    if ([self.deck.cards count] < 3) {
        self.addCardButton.enabled = NO;
        self.addCardButton.alpha = 0.0;
    }
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (int i = 0; i < 3; i++) {
                             [self drawNewCard];
                         }
                         [self updateGrid];
                     }];
   
}

- (void)drawNewCard {
    Card *card = [self.deck drowRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        [self.cards addObject:setCard];
        [self.game setCardsForSet:self.cards];
        CGRect frame;
        frame.size = self.grid.cellSize;
       /* frame.size.width -= 5;
        frame.size.height -=5;*/
        PlayingSetCardView * newCardView = [[PlayingSetCardView alloc] initWithFrame:frame];
        newCardView.rank = setCard.rank;
        newCardView.symbol = setCard.symbol;
        newCardView.faceUp = YES;
        [newCardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [self.cardsView addObject:newCardView];
        [self.gridView addSubview:newCardView ];
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
    [UIView animateWithDuration:2.0
                     animations:^{
                         self.game =nil;
                         self.deck = nil;
                         [self.game setNumberOfCards:3];
                         self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
                         self.stringLabel.text = @"Play again";
                         [self.flipsHistory removeAllObjects];
                         self.addCardButton.enabled = YES;
                         self.addCardButton.alpha = 1.0;
                         for (int i= 0; i < [self.cardsView count]; i++) {
                             [self.cardsView[i] removeFromSuperview];
                         }
                         [self.cardsView removeAllObjects];
                         [self.cards removeAllObjects];
                         [self setInitialCards];

                     }];
    }

- (void)tap:(UITapGestureRecognizer *)sender {
    int indexOfCard = [ self.cardsView indexOfObject:[sender view]];
    [self.game chooseCardAtIndex:indexOfCard];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.gameResult.score = self.game.score;
    self.stringLabel.attributedText = self.game.rezult;
    [self.flipsHistory addObject:self.game.rezult];
    [self updateUI];
    
}

- (void)updateUI {
    for (PlayingSetCardView *playingSetView in self.cardsView){
        int cardIndex = [self.playingSetCardView indexOfObject:playingSetView];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (card.isMatched) {
           [UIView animateWithDuration:1.0
                            animations:^{
                                playingSetView.center = CGPointMake(-self.gridView.bounds.size.width, -self.gridView.bounds.size.height);
                            }
                            completion:^(BOOL finished) {
                                [self.game.cards removeObjectAtIndex:cardIndex];
                                [playingSetView removeFromSuperview];
                            }];
            
        }
    }
    [self updateGrid];
}

#define CARDSPACINGINPERCENT 0.09

- (void)updateGrid {
    self.grid.minimumNumberOfCells = [self.cardsView count];
    for (int viewIndex = 0; viewIndex < [self.cardsView count]; viewIndex++) {
        //CGPoint center = [self.grid centerOfCellAtRow:viewIndex / self.grid.columnCount
                                           //  inColumn:viewIndex % self.grid.columnCount];
        //center.y += 55.0;
        //((PlayingSetCardView *)self.cardsView[viewIndex]).center = center;
        CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                          inColumn:viewIndex % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
        ((PlayingSetCardView *)self.cardsView[viewIndex]).frame = frame;
    }
}

#pragma mark - Initialization

- (void)setInitialCards {
   /* for (PlayingSetCardView *playingSetView in self.playingSetCardView){
        int indexOfCard = [ self.playingSetCardView indexOfObject:playingSetView];
        if (!playingSetView.faceUp) {
            [self drawRandomPlayingCard:indexOfCard];
        }
        playingSetView.faceUp = !playingSetView.faceUp;
    }
    */
    for (int i = 0; i < self.numberOfStartingCards; i++) {
        [self drawNewCard];
    }
    [self updateGrid];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.game.numberOfCards = 3;
    self.numberOfStartingCards = 12;
    self.maxCardSize = CGSizeMake(90.0, 120.0);
    self.gridView.backgroundColor = nil;
    self.gridView.opaque = NO;
    self.gridView.contentMode = UIViewContentModeRedraw;
    [self setInitialCards];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.game.MATCH_BONUS = self.gameSettings.mathBonus;
    self.game.MISMATCH_PENALITY = self.gameSettings.mathPenality;
    self.game.COST_TO_CHOOSE = self.gameSettings.flipCost;
    [self updateGrid];
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
