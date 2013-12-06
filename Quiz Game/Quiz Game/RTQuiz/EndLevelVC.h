//
//  EndLevelVC.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GamePlayDelegate.h"
#import "BaseViewController.h"
//#import <Accounts/Accounts.h>
#import <GameKit/GameKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface EndLevelVC : BaseViewController <UITextFieldDelegate,GKLeaderboardViewControllerDelegate> {
    
    __weak IBOutlet UITextField *tf_name;
@private
    SharedDataManager *sharedDataManager;
}

@property (strong) id<GamePlayDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel *totalPointsLabel;
@property (nonatomic, strong) IBOutlet UIButton *mainMenuButton;
- (IBAction)showMoreApps:(id)sender;

@property (nonatomic) int score;
@property (nonatomic, strong) NSString *category;

- (IBAction)submitScore:(id)sender;
- (void)setScoreLabel:(int)theScore;
- (IBAction)didClickMainMenu;
- (IBAction)btnShareScorePressed:(UIButton *)sender;
- (IBAction)btnUpdateScore:(UIButton *)sender;
- (IBAction)showLeatherboards:(id)sender;

@end
