//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Andrei-Daniel Anton on 18/07/14.
//  Copyright (c) 2014 Andrei-Daniel Anton. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameSettings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mismatchPenalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *costToChooselabel;
@property (nonatomic, weak  ) IBOutlet UISlider *mathBonusSlider;
@property (nonatomic, weak  ) IBOutlet UISlider *mismathPenalitySlider;
@property (nonatomic, weak  ) IBOutlet UISlider *costToChooseSlider;
@property (nonatomic ,strong) GameSettings *gameSettings;
@end

@implementation SettingsViewController

#pragma mark - IBAction

- (IBAction)mathBonusSliderAction:(UISlider *)sender {
    self.gameSettings.mathBonus = (int)sender.value;
    self.matchBonusLabel.text = [NSString stringWithFormat:@"%d",self.gameSettings.mathBonus];
}

- (IBAction)mismathPenalitySliderAction:(UISlider *)sender {
    self.gameSettings.mathPenality = (int)sender.value;
    self.mismatchPenalityLabel.text = [NSString stringWithFormat:@"%d",self.gameSettings.mathPenality];
}

- (IBAction)costToChoseSliderAction:(UISlider *)sender {
    self.gameSettings.flipCost = (int)sender.value;
    self.costToChooselabel.text = [NSString stringWithFormat:@"%d",self.gameSettings.flipCost];
}

#pragma mark - Initialization

- (GameSettings *)gameSettings
{
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mathBonusSlider.value = self.gameSettings.mathBonus;
    self.mismathPenalitySlider.value = self.gameSettings.mathPenality;
    self.costToChooseSlider.value = self.gameSettings.flipCost;
    self.matchBonusLabel.text = [NSString stringWithFormat:@"%d",self.gameSettings.mathBonus];
    self.mismatchPenalityLabel.text = [NSString stringWithFormat:@"%d",self.gameSettings.mathPenality];
    self.costToChooselabel.text = [NSString stringWithFormat:@"%d",self.gameSettings.flipCost];

    
}


@end
