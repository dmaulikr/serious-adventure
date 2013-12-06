//
//  EndLevelVC.m
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import "EndLevelVC.h"
#import "GameCenterManager.h"
//#import "FBPermssionConstants.h"
//#import "FacebookManager.h"
#import "Constants.h"
#import "Chartboost.h"
#import "Flurry.h"
#import "InAppPurchaseManager.h"
@interface EndLevelVC()<GameCenterManagerDelegate>
@property (strong,nonatomic) GameCenterManager *gameCenterManager;
@property (strong, nonatomic) NSArray *permissions;
@end


@implementation EndLevelVC
@synthesize delegate;
@synthesize totalPointsLabel;
@synthesize mainMenuButton;

@synthesize score = _score;
@synthesize category = _category;
#pragma mark - 
-(void)setFonts{
    if(IS_IPHONE){
        [totalPointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [tf_name setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
    }else{
        [totalPointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [tf_name setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
    }
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL didSave = [sharedDataManager didSaveScore:_score ForCategoryNamed:_category ForUserNamed:[textField text]];
    
    [textField resignFirstResponder];
    
    [delegate returnToMainMenu];
    return didSave;   
}
- (BOOL) reportScore:(NSUInteger)paramScore
       toLeaderboard:(NSString *)paramLeaderboard{
    
    __block BOOL result = NO;
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if ([localPlayer isAuthenticated] == NO){
        NSLog(@"You must authenticate the local player first.");
        return NO;
    }
    
    if ([paramLeaderboard length] == 0){
        NSLog(@"Leaderboard identifier is empty.");
        return NO;
    }
    
    GKScore *score = [[GKScore alloc]
                       initWithCategory:paramLeaderboard];
    
    score.value = (int64_t)paramScore;
    
    NSLog(@"Attempting to report the score...");
    [score reportScoreWithCompletionHandler:^(NSError *error) {
        if (error == nil){
            NSLog(@"Succeeded in reporting the error.");
            result = YES;
        } else {
            NSLog(@"Failed to report the error. Error = %@", error);
        }
    }];
    
    return result;
    
}

- (IBAction)submitScore:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:totalPointsLabel.text forKey:@"current_score"];
    [prefs synchronize];
    
    //This is the same category id you set in your itunes connect GameCenter LeaderBoard
//    GKScore *myScoreValue = [[GKScore alloc] initWithCategory:@"Gamer_Trivia"];
//    myScoreValue.value = self.totalPointsLabel.text;
    [self reportScore:[self.totalPointsLabel.text integerValue] toLeaderboard:@"Gamer_Trivia"];
//    [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
//        if(error != nil){
//            NSLog(@"Score Submission Failed");
//        } else {
//            NSLog(@"Score Submitted");
//        }
//        
//    }];
}

- (void)setScoreLabel:(int)theScore {
    
    [self.totalPointsLabel setText:[NSString stringWithFormat:@"%i", theScore]];
    
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFonts];
    Boolean isPurchased =  [[NSUserDefaults standardUserDefaults] boolForKey:kInAppAdsRemoval];
    if (!isPurchased) {
        Chartboost *cb = [Chartboost sharedChartboost];
        [cb showInterstitial];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
    [self submitScore:nil];
}

- (void)viewDidUnload
{
    [self setTotalPointsLabel:nil];
    [self setMainMenuButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didClickMainMenu {
    [delegate returnToMainMenu];
}
-(void)checkFBLogin{
    //    [UIAppDelegate openSessionWithAllowLoginUI:YES];
    if (!FBSession.activeSession.isOpen) {
        // if the session isn't open, we open it here, which may cause UX to log in the user
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if (!error) {
                                              NSArray *permissions = [[NSArray alloc] initWithObjects:
                                                                      @"publish_actions",
                                                                      nil];
                                              if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                                                  // if we don't already have the permission, then we request it now
                                                  [FBSession.activeSession requestNewPublishPermissions:permissions
                                                                                        defaultAudience:FBSessionDefaultAudienceFriends
                                                                                      completionHandler:^(FBSession *session, NSError *error) {
                                                                                          if (!error) {
                                                                                              [self postAtFacebook];
                                                                                              //                                                        action();
                                                                                          }
                                                                                          //For this example, ignore errors (such as if user cancels).
                                                                                      }];
                                              } else {
                                                  [self postAtFacebook];
                                                  //            action();
                                              }
                                          } else {
                                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:error.localizedDescription
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil]
                                               show];
                                          }
                                      }];
    }else{
        [self postAtFacebook];
    }
}

-(void)postAtFacebook{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    nil];
    [params setObject:[NSString stringWithFormat:@"%@   is The Highest Scores                   See if you can beat my high score in Ultimate Trivia: Impossible Video Game Trivia",totalPointsLabel.text] forKey:@"message"];
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"test completoin");
    }];
}


- (IBAction)btnShareScorePressed:(UIButton *)sender {
    [Flurry logEvent:@"FB_share"];
    
    [self checkFBLogin];
}

- (IBAction)btnUpdateScore:(UIButton *)sender {

    self.gameCenterManager = [[GameCenterManager alloc ]init];
    self.gameCenterManager.delegate = self;
    
    
    if ([GameCenterManager isGameCenterAvailable ]) {
        [self.gameCenterManager authenticateLocalUser];
        
    }

}



#pragma mark - 
#pragma mark - GameCenterManagerDelegate methods implementation
- (void) processGameCenterAuth: (NSError*) error{
 
    if (!error) {
            // update score here
        [self.gameCenterManager reportScore:self.score forCategory:self.category];
    }
}
- (void) scoreReported: (NSError*) error{
    if (!error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"App Name" message:@"Your scores have been published successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"App Name" message:@"Your scores have not published successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

@end
