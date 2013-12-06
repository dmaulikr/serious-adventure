//
//  MainMenuViewController.h


#import <UIKit/UIKit.h>
#import "GamePlayController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BaseViewController.h"
#import "PickerAlertView.h"
#import <GameKit/GameKit.h>
#import "InAppPurchaseManager.h"

typedef enum {
    NONE_SELECTED,
    START_TRIVIA_SELECTED,
    MORE_TRIVIA_SELECTED,
    WHOS_WHO_SELECTED
}GameSelected;

@interface MainMenuViewController : BaseViewController <UIAlertViewDelegate, GKLeaderboardViewControllerDelegate, SKPaymentTransactionObserver>{
    
    __weak IBOutlet UILabel *lbl_icon;
    __weak IBOutlet UILabel *lbl_version;
    __weak IBOutlet UILabel *lbl_developer;
    __weak IBOutlet UILabel *lbl_graphics;
    __weak IBOutlet UILabel *lbl_music;
    __weak IBOutlet UITextView *tv_feedback1;
    __weak IBOutlet UITextView *tv_feedback2;
    __weak IBOutlet UIButton *btn_rateQuizApp;
    __weak IBOutlet UIButton *btn_sendEmail;
    __weak IBOutlet UIButton *btn_remove_ads;
    __weak IBOutlet UILabel *lbl_sel_title;
    __weak IBOutlet UIButton *btn_sel_easy;
    __weak IBOutlet UIButton *btn_sel_medium;
    __weak IBOutlet UIButton *btn_sel_hard;
    __weak IBOutlet UIButton *btn_sel_elite;
    __weak IBOutlet UIView *levelView;
    __weak IBOutlet UIButton *btnRestore;
    
@private
    GameSelected gameSelected;
    __weak IBOutlet UILabel *lbl_submitFeedback;
    SharedDataManager *sharedDataManager;
    GamePlayController *sharedGamePlayController;
}
- (IBAction)easySelected:(id)sender;
- (IBAction)performRestoreAction:(id)sender;
- (IBAction)mediumSelected:(id)sender;
- (IBAction)hardSelected:(id)sender;
- (IBAction)eliteSelected:(id)sender;
- (IBAction)makePurchase:(id)sender;
- (IBAction)showMoreApps:(id)sender;
- (IBAction)testAds:(id)sender;
- (IBAction)didClickWhoisWho:(id)sender;
- (IBAction)didClickHighScores;

@end
