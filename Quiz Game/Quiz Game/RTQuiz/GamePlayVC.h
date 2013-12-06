//
//  GamePlayVC.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "GamePlayDelegate.h"
#import "BaseViewController.h"
@class GamePlayController;

@class EndStageVC;
@class EndLevelVC;

@interface GamePlayVC : BaseViewController <GamePlayDelegate> {

@private
    GamePlayController *sharedGamePlayController;
    __weak IBOutlet UILabel *lbl_time;
    __weak IBOutlet UILabel *lbl_points;
    __weak IBOutlet UILabel *lbl_answer1;
    __weak IBOutlet UILabel *lbl_answer2;
    __weak IBOutlet UILabel *lbl_answer3;
    __weak IBOutlet UILabel *lbl_answer4;
}

@property (strong, nonatomic) IBOutlet UILabel *currentPointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentWordLabel;
@property (strong, nonatomic) IBOutlet UIView *warningView;
@property (strong, nonatomic) IBOutlet UILabel *timeRemainingLabel;

@property (strong, nonatomic) IBOutlet UIButton *firstWordButton;
@property (strong, nonatomic) IBOutlet UIButton *secondWordButton;
@property (strong, nonatomic) IBOutlet UIButton *thirdWordButton;
@property (strong, nonatomic) IBOutlet UIButton *fourthWordButton;

@property (strong, nonatomic) EndStageVC *thePointsAlertView;
@property (strong, nonatomic) EndLevelVC *theEndLevelAlertView;

- (void)notifyAnswerWasCorrect:(BOOL)answer;
- (void)updatePointsLabelWithPoints:(int)points;

- (IBAction)didClickWordButtonWithID:(id)sender;
- (IBAction)didClickReturnToMainMenu;

@end
