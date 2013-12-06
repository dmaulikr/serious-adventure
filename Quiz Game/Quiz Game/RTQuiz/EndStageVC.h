//
//  EndStageVC.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GamePlayDelegate.h"
#import "BaseViewController.h"
@interface EndStageVC : BaseViewController{

    __weak IBOutlet UILabel *lbl_points;
    __weak IBOutlet UILabel *lbl_time;

}

@property (strong, nonatomic) IBOutlet UILabel *currentStageLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeBonusLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPointsLabel;

@property (strong, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *nextStageButton;

@property (strong) id<GamePlayDelegate> delegate;

- (IBAction)didClickMainMenu;
- (IBAction)didClickNextStage;

- (void)setLabelsForStage:(int)stage withPoints:(int)points withBonus:(int)bonus;

@end
