//
//  MainMenuViewController.m


#import "MainMenuViewController.h"
#import "Chartboost.h"
#import "GamePlayVC.h"
#import "Constants.h"
#import "HighScoresViewController.h"

#import "Flurry.h"


@interface MainMenuViewController () <MFMailComposeViewControllerDelegate>

@property(nonatomic, retain)IBOutlet UIButton *quickplayBtn;
@property(nonatomic, retain)IBOutlet UIButton *challengeBtn;
@property(nonatomic, retain)IBOutlet UIButton *highscoreBtn;
@property(nonatomic, retain)IBOutlet UIButton *closeBtn;
@property(nonatomic, retain)IBOutlet UIButton *infoBtn;
@property(nonatomic, retain)IBOutlet UIImageView *appIcon;
@property(nonatomic, retain)IBOutlet UIView *settingsView;
@property(nonatomic, retain)IBOutlet UIView *alertView;

@end

@implementation MainMenuViewController 
@synthesize quickplayBtn, challengeBtn, highscoreBtn, appIcon, infoBtn, settingsView, alertView, closeBtn;

#pragma mark 
-(void)purchaseSuccessful{
    
    Boolean isPurchased =  [[NSUserDefaults standardUserDefaults] boolForKey:kInAppAdsRemoval];
    if (isPurchased) {
        [btn_remove_ads setHidden:YES];
    }
}



#pragma makr -

-(void)setFonts{
    if (IS_IPHONE) {
        [lbl_sel_title setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [lbl_developer setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [lbl_graphics setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [lbl_music setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [lbl_icon setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:18]];
        [lbl_version setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:18]];
        
        [lbl_submitFeedback setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:24]];
        [tv_feedback1 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
        [tv_feedback2 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
        [btn_rateQuizApp.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
        [btn_sendEmail.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
        [btnRestore.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
    }else{
        [lbl_sel_title setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_developer setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_graphics setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_music setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_icon setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_version setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        
        [lbl_submitFeedback setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
        [tv_feedback1 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [tv_feedback2 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [btn_rateQuizApp.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [btn_sendEmail.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [btnRestore.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
    }
    [btn_sel_easy.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
    [btn_sel_medium.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
    [btn_sel_hard.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
    [btn_sel_elite.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sharedDataManager = [SharedDataManager sharedDataManager];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark -
-(void)openGameWithDifficultyLevel:(int)missCount reward:(int)reward andPanelty:(int)panelty{
    [self hideLevelSelectionView];
    // set up game controller
    sharedGamePlayController = [GamePlayController sharedGamePlayController];
    [sharedGamePlayController newGame];
    [sharedGamePlayController setErrorsAllowed:missCount];
    [sharedGamePlayController setReward:reward];
    [sharedGamePlayController setPanelty:panelty];

    
    if (gameSelected==START_TRIVIA_SELECTED) {
        // set up game data
        [Flurry logEvent:@"Start_Trivia_Played"];
        [sharedGamePlayController setCurrentTopic:@"german-all"];
        [sharedGamePlayController setCurrentTopicLevelsList:[sharedDataManager getArrayFromTopic:sharedGamePlayController.currentTopic]];
    
    }else if (gameSelected == MORE_TRIVIA_SELECTED){
        // set up game data
        [Flurry logEvent:@"More_Trivia_Played"];
        [sharedGamePlayController setCurrentTopic:@"game-pack1-topic"];
        [sharedGamePlayController setCurrentTopicLevelsList:[sharedDataManager getArrayFromTopic:sharedGamePlayController.currentTopic]];
    
    }else if (gameSelected == WHOS_WHO_SELECTED){
        // set up game data
        [Flurry logEvent:@"Who's_Who_Played"];
        [sharedGamePlayController setCurrentTopic:@"who-is-who-topic"];
        [sharedGamePlayController setCurrentTopicLevelsList:[sharedDataManager getArrayFromTopic:sharedGamePlayController.currentTopic]];
    
    }
    // set up game view
    GamePlayVC *gamePlayVC = [[GamePlayVC alloc] initWithNibName:@"GamePlayVC" bundle:nil];
    [self addChildViewController:gamePlayVC];
    [gamePlayVC.view setFrame:self.view.frame];
    [self.view addSubview:gamePlayVC.view];
    
    [sharedGamePlayController setCurrentGameScene:gamePlayVC];
    [sharedGamePlayController startGame];
    

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

  [self discardObjects];
  [self rearrangeViews];    
  [self rearrangeAlertAnimated:NO];
  [super viewDidLoad];
    [self setFonts];
    gameSelected=NONE_SELECTED;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(purchaseSuccessful)
                                                 name:kInAppPurchaseManagerTransactionSucceededNotification
                                               object:nil];
    
    Boolean isRemoveAds =  [[NSUserDefaults standardUserDefaults] boolForKey:kInAppAdsRemoval];
    if (isRemoveAds) {
        [btn_remove_ads setHidden:YES];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [Flurry logEvent:@"Main_Menu_Shown"];
}
- (void)viewDidUnload
{
    lbl_sel_title = nil;
    btn_sel_easy = nil;
    btn_sel_medium = nil;
    btn_sel_hard = nil;
    btn_sel_elite = nil;
    levelView = nil;
    btnRestore = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
    // set up game controller
    sharedGamePlayController = [GamePlayController sharedGamePlayController];
    [sharedGamePlayController newGame];

    // set up game data
    [sharedGamePlayController setCurrentTopic:@"spanish-1"];
    [sharedGamePlayController setCurrentTopicLevelsList:[sharedDataManager getArrayFromTopic:sharedGamePlayController.currentTopic]];
    
    // set up game view
    GamePlayVC *gamePlayVC = [[GamePlayVC alloc] initWithNibName:@"GamePlayVC" bundle:nil];
    [self addChildViewController:gamePlayVC];
    [self.view addSubview:gamePlayVC.view];
    
    [sharedGamePlayController setCurrentGameScene:gamePlayVC];
    [sharedGamePlayController startGame];
  */  

#pragma makr - IBActions
-(void)openPickerView{
    PickerAlertView *pickerAlertView = [[PickerAlertView alloc] initWithTitle:@"Select Game Level" message:@" " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[pickerAlertView show];
}
-(void)showLeveSelectionView{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         [levelView setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                     }];

}
-(void)hideLevelSelectionView{
    levelView.alpha=0;
}
// open game view
- (IBAction)didClickChallenge {
    gameSelected=START_TRIVIA_SELECTED;
    [self showLeveSelectionView];
}
-(void)purchaseWithProductId:(NSString*)productId{
    InAppPurchaseManager *purchaseManager = [[InAppPurchaseManager alloc] init];
    purchaseManager.kPurchasedProduct = productId;
    if ([purchaseManager canMakePurchases]) {
        [purchaseManager loadStore];
        [purchaseManager purchaseProUpgrade];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In-App Purchases"
                                                        message:@"This device is not able or allowed to make In-App Purchases."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}
//open hight scores view
- (IBAction)easySelected:(id)sender {
    int missCount = 20;
    int reward=1;
    int panelty=1;
    
    [self openGameWithDifficultyLevel:missCount reward:reward andPanelty:panelty];
}

- (IBAction)performRestoreAction:(id)sender {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//    InAppPurchaseManager *inAppPurchaseManager = [[[InAppPurchaseManager alloc]init] autorelease];
//    [inAppPurchaseManager restoreItems];
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"%@",queue );
    NSLog(@"Restored Transactions are once again in Queue for purchasing %@",[queue transactions]);
    
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productId = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productId];
        
        if ([productId isEqualToString:kInAppTriviaPack1])
        {
            
            // enable the pro features
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInAppTriviaPack1 ];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([productId isEqualToString:kInAppAdsRemoval])
        {
            // enable the pro features
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInAppAdsRemoval];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // send out a notification that we’ve finished the transaction
            [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:nil];
        }
        if ([productId isEqualToString:kInAppTriviaPack2])
        {
            // enable the pro features
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInAppTriviaPack2];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        // here put an if/then statement to write files based on previously purchased items
        // example if ([productID isEqualToString: @"youruniqueproductidentifier]){write files} else { nslog sorry}
    }
}

- (IBAction)mediumSelected:(id)sender {
    int missCount = 15;
    int reward=2;
    int panelty=2;
    
    [self openGameWithDifficultyLevel:missCount reward:reward andPanelty:panelty];
}

- (IBAction)hardSelected:(id)sender {
    int missCount = 10;
    int reward=4;
    int panelty=4;
    
    [self openGameWithDifficultyLevel:missCount reward:reward andPanelty:panelty];
}

- (IBAction)eliteSelected:(id)sender {
    int missCount = 5;
    int reward=10;
    int panelty=10;

    [self openGameWithDifficultyLevel:missCount reward:reward andPanelty:panelty];
}

- (IBAction)makePurchase:(UIButton*)btn {
    if (btn.tag == 1001) {
        Boolean isPurchased =  [[NSUserDefaults standardUserDefaults] boolForKey:kInAppTriviaPack1];
        if (isPurchased) {
            gameSelected=MORE_TRIVIA_SELECTED;
            [self showLeveSelectionView];
        }else{
            [Flurry logEvent:@"TriviaPack1_IAP_Menu_served"];
            [self purchaseWithProductId:kInAppTriviaPack1];
        }
    
    }else if (btn.tag==1002){
        Boolean isPurchased =  [[NSUserDefaults standardUserDefaults] boolForKey:kInAppTriviaPack2];
        if (isPurchased) {
            // set up game controller
            gameSelected=WHOS_WHO_SELECTED;
            [self showLeveSelectionView];
        }else{
            [Flurry logEvent:@"Who's_Who_IAP_Menu_served"];
            [self purchaseWithProductId:kInAppTriviaPack2];
        }
    }else if(btn.tag==1003){
        Boolean isPurchased =  [[NSUserDefaults standardUserDefaults] boolForKey:kInAppAdsRemoval];
        if (isPurchased) {
            
        }else{
            [Flurry logEvent:@"RemoveAds_IAP_Menu_served"];
            [self purchaseWithProductId:kInAppAdsRemoval];
        }
    }
    
    
}

- (IBAction)showMoreApps:(id)sender {
    [Flurry logEvent:@"Show_more_games"];
    [[Chartboost sharedChartboost] showMoreApps];
}


- (IBAction)didClickHighScores {
    
    HighScoresViewController *highScoresVC = [[HighScoresViewController alloc] initWithNibName:@"HighScoresViewController" bundle:nil category:@"german-all"];
    [highScoresVC.view setFrame:self.view.frame];
    [self addChildViewController:highScoresVC];
    [self.view addSubview:highScoresVC.view];
    
}

//open settings view
- (IBAction)didClickSettings {
    [settingsView setFrame:self.view.frame];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                         forView:[self view]
                           cache:YES];

	[[self view] addSubview:settingsView];
	[UIView commitAnimations];
}

// back to main menu view
- (IBAction)returnView:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                         forView:[self view]
                           cache:YES];
	[settingsView removeFromSuperview];
	[UIView commitAnimations];
}

-(void)rearrangeViews {
  
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    appIcon.alpha =
    infoBtn.alpha =
    highscoreBtn.alpha =
    quickplayBtn.alpha = 
    challengeBtn.alpha = 1.0;
    
    [UIView commitAnimations];
  }

-(void)rearrangeAlertAnimated:(BOOL) animated {
  if (animated) {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
  
  alertView.alpha = 1.0;
  closeBtn.enabled = NO;
  [UIView commitAnimations];

  } else {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    alertView.alpha = 0.0;
    closeBtn.enabled = YES;
    [UIView commitAnimations];
  }
}

-(void)discardObjects {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
  appIcon.alpha =
  infoBtn.alpha =
  highscoreBtn.alpha =
  quickplayBtn.alpha = 
  challengeBtn.alpha = 0.0;
    [UIView commitAnimations];
}

-(IBAction)didClickAlert:(id)sender {

  [self rearrangeAlertAnimated:YES];
  }

-(IBAction)dismissAlert:(id)sender {
  [self rearrangeAlertAnimated:NO];

}

//open rate app view from settings view
-(IBAction)rateApp:(id)sender {
  NSURL *siteURL = [NSURL URLWithString:@"http://itunes.apple.com/us/app/ultimate-trivia-impossible/id672841048?ls=1&mt=8"]; // Application link goes Here!
	[[UIApplication sharedApplication] openURL:siteURL];
}

//open mail composer for sending feedback
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)reportBug:(id)sender {
    NSLog(@"reportBug called");
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"support@forthrightentertainment.com"]];
    
    NSString *bundleDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *reportTitle = NSLocalizedString(@"Send feedback", nil);
    NSString *subject = [NSString stringWithFormat:@"%@ %@: %@", bundleDisplayName, bundleVersion, reportTitle];
    [picker setSubject:subject];
    
    NSString *emailBody = @"";
    [picker setMessageBody:emailBody isHTML:YES];
    
    picker.navigationBar.barStyle = UIBarStyleBlack;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
  }


#pragma mark Game Center
- (void)leaderboardViewControllerDidFinish:
(GKLeaderboardViewController *)viewController{
    
    /* We are finished here */
    [self dismissModalViewControllerAnimated:YES];
    
}
- (IBAction)showLeatherboards:(id)sender{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        
        if (error == nil){
            
            GKLeaderboardViewController *controller =
            [[GKLeaderboardViewController alloc] init];
            
            /* The category for our leaderboard. We created this before */
            [controller setCategory:@"Gamer_Trivia"];
            /* Only show the scores that were submitted this week */
            [controller setTimeScope:GKLeaderboardTimeScopeWeek];
            [controller setLeaderboardDelegate:self];
            [self presentModalViewController:controller
                                    animated:YES];
            
        } else {
            NSLog(@"Could not authenticate the local player. Error = %@", error);
        }
        
    }];
}
//#pragma mark - AlertView Delegate
//- (void)alertView:(PickerAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex !=0) {
//        
//    }else{
//        gameSelected=NONE_SELECTED;
//    }
//	
//}
@end
