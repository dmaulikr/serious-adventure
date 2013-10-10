//
//  FavoriteViewController.m
//  FastLaugh
//
//  Created by admin on 8/25/13.
//  Copyright (c) 2013 BrightNewt Apps. All rights reserved.
//

#import "FavoriteViewController.h"
#import "GUIHelper.h"

#import <Twitter/Twitter.h>
#import "DETweetComposeViewController.h"
#import "UIDevice+DETweetComposeViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "FacebookManager.h"
#import <UIKit/UIKit.h>

@interface FavoriteViewController ()
{
    EFacebookAPICall _currentAPICall;
}

@property (nonatomic, strong) UIButton *shareFavouriteBtn;
@property (nonatomic, assign) BOOL isShareFavouriteBtnPressed;
@property (nonatomic, strong) UIImageView  *shareFavouriteBtnView;
@property (nonatomic, strong) UITableView *tv;

@property (nonatomic, assign) CGFloat cellIndex;
@property (nonatomic, assign) CGFloat  cellDeleted;

@property (nonatomic, assign) int  indexRow;

@property (nonatomic, assign) NSString *shareString;

@property (nonatomic, retain) NSMutableArray *arrayFromFile;


-(void) getBack;
@end



@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].applicationFrame];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.cellIndex = -1;
    self.indexRow = 0;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame: self.view.bounds];
    
    bgImageView.image = [UIImage imageNamed: @"background-Favorites-ipad.png"];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: bgImageView];
    
    //Label start
    [self createFarvoriteLabel];
    
    
    self.arrayFromFile = NULL;
    self.arrayFromFile = [[NSMutableArray alloc] initWithContentsOfFile:self.favouritePath];//[self insultsFromFileNamed];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.tv = [[UITableView alloc]initWithFrame:CGRectMake(127,137,520,820)];
    }
    
    else{
        if([GUIHelper isPhone5])
        {
           self.tv = [[UITableView alloc]initWithFrame:CGRectMake(55,70,213,450)];
            
            
        }
        else{
            
            self.tv = [[UITableView alloc]initWithFrame:CGRectMake(55,60,213,378)];
        }
        
    }
    self.tv.scrollEnabled = YES;
    
    
    self.tv.backgroundColor = [UIColor clearColor];
    [self.tv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tv setDelegate:self];
    [self.tv setDataSource:self];
    //[tv reloadData];
    [self.view addSubview:self.tv];
    
    UIImage *buttonImage = [UIImage imageNamed: @"back-Arrow-ipad.png"];
    UIImage *buttonPressedImage = [UIImage imageNamed: @"back-Arrow-ipad-pressed.png"];
	
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [button setBackgroundImage: buttonImage forState: UIControlStateNormal];
    [button setBackgroundImage: buttonPressedImage forState: UIControlStateHighlighted];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        button.frame= CGRectMake(90, 0,
                                 buttonImage.size.width, buttonImage.size.height);
    }else{
        button.frame= CGRectMake(25, 0,
                                 0.4*buttonImage.size.width, 0.4*buttonImage.size.height);
    }
	
    [button addTarget:self action:@selector(getBack) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview: button];
}

- (void)getBack
{
    
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyReuseIdentifier";
    //UITableViewCell
    UITableViewCell *cell = nil;
    
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)])
    {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *favouriteLabel;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            favouriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 400, 120)];
        }else{
            favouriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 160, 60)];
        }
        favouriteLabel.backgroundColor = [UIColor clearColor];
        
        favouriteLabel.text = [self.arrayFromFile objectAtIndex:indexPath.row];
        NSLog(@"Row alloc %d", indexPath.row);
        NSLog(@"Load label %@", favouriteLabel.text);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            favouriteLabel.font = [UIFont fontWithName: @"Eras Bold ITC" size: 18];
        }else if([GUIHelper  isPhone5]){
            favouriteLabel.font = [UIFont fontWithName: @"Eras Bold ITC" size: 12];
        }
        else
            favouriteLabel.font = [UIFont fontWithName: @"Eras Bold ITC" size: 12];
        favouriteLabel.textColor = [UIColor blackColor];
        favouriteLabel.textAlignment = UITextAlignmentLeft;
        favouriteLabel.numberOfLines = 0;
        [cell.contentView addSubview:favouriteLabel];
        
        UIImage *lineImg = [UIImage imageNamed:@"section-Line-ipad.png"];
        CGRect lineImageFrame;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            lineImageFrame = CGRectMake(0, 110, lineImg.size.width, lineImg.size.height);
        }else{
            lineImageFrame = CGRectMake(0, 62, 0.4*lineImg.size.width, 0.4*lineImg.size.height);
        }
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:lineImageFrame];
        lineImageView.image = lineImg;
        // set the tag myImageView.tag = 1010;
        [cell.contentView addSubview:lineImageView];
        
        // share button
        UIImage *buttonImage = [UIImage imageNamed: @"share-Favorites-ipad.png"];
        UIImage *buttonPressedImage = [UIImage imageNamed: @"share-Favorites-ipad-press.png"];
        self.shareFavouriteBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.shareFavouriteBtn setBackgroundImage: buttonImage forState: UIControlStateNormal];
        [self.shareFavouriteBtn setBackgroundImage: buttonPressedImage forState: UIControlStateHighlighted];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.shareFavouriteBtn.frame= CGRectMake(400, 0,
                                                     buttonImage.size.width + 15,
                                                     buttonImage.size.height + 15);
        }
        else{
            self.shareFavouriteBtn.frame= CGRectMake(160, 0,
                                                     0.5*buttonImage.size.width,
                                                     0.7*buttonImage.size.height);
            
        }
        
        [self.shareFavouriteBtn addTarget: self action: @selector(showShareOptions:) forControlEvents: UIControlEventTouchUpInside];
        self.shareFavouriteBtn.tag = indexPath.row;
        [cell.contentView addSubview:self.shareFavouriteBtn];
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    return cell;
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayFromFile count];
}



-(CGFloat)tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 125;
//    else if ([GUIHelper isPhone5]){
//        return 90;
//    }
    else
        return 70;
}


-(void)removeShareFavouriteBtnView:(CGFloat )indexes{
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexes inSection:0];
    
    UITableViewCell *cell = (UITableViewCell *)[self.tv cellForRowAtIndexPath:path];
    [[cell.contentView viewWithTag:777] removeFromSuperview];
    
}

- (void) showShareOptions: (id)sender
{
        
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tv];
    NSIndexPath *path = [self.tv indexPathForRowAtPoint:buttonPosition];
        
    UITableViewCell *cellSelected = (UITableViewCell *)[self.tv cellForRowAtIndexPath:path];
    self.cellDeleted = path.row;
    self.shareString = [self.arrayFromFile objectAtIndex:path.row];
    //NSLog(@"share string %@",self.shareString);
    [[cellSelected.contentView viewWithTag:777] removeFromSuperview];
    if (self.cellIndex != path.row){
        if (self.cellIndex != -1)
            [self removeShareFavouriteBtnView:self.cellIndex];
        //self.shareString = [self.arrayFromFile objectAtIndex:path.row];
        UIImage *shareButtonActiveImage = [UIImage imageNamed: @"share-Popup-ipad.png"];
        self.shareFavouriteBtnView = [[UIImageView alloc] initWithImage: shareButtonActiveImage];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.shareFavouriteBtnView.frame = CGRectMake(0, 0, shareButtonActiveImage.size.width + 20, 80);
        }else{
            self.shareFavouriteBtnView.frame = CGRectMake(0, 0, shareButtonActiveImage.size.width/2 + 20, 40);
        }
        self.shareFavouriteBtnView.userInteractionEnabled = YES;
        
        UIImage *emailButtonImage = [UIImage imageNamed: @"share-Email-ipad.png"];
        UIImage *emailButtonActiveImage = [UIImage imageNamed: @"share-Email-ipad-pressed.png"];
        UIButton *emailButton = [UIButton buttonWithType: UIButtonTypeCustom];
        //iPad
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            emailButton.frame = CGRectMake(0, 0, emailButtonImage.size.width, emailButtonImage.size.height);
            emailButton.center = CGPointMake(self.shareFavouriteBtnView.center.x + 100, self.shareFavouriteBtnView.center.y);
        }
        else{
            emailButton.frame = CGRectMake(0, 0, emailButtonImage.size.width/2, emailButtonImage.size.height/2);
            emailButton.center = CGPointMake(self.shareFavouriteBtnView.center.x + 50,  self.shareFavouriteBtnView.center.y);
        }
        
        [emailButton setBackgroundImage: emailButtonImage forState: UIControlStateNormal];
        [emailButton setBackgroundImage: emailButtonActiveImage forState: UIControlStateSelected];
        [emailButton addTarget: self action: @selector(shareEmail) forControlEvents: UIControlEventTouchUpInside];
        
        
        [self.shareFavouriteBtnView addSubview: emailButton];
        
        
        UIImage *facebookButtonImage = [UIImage imageNamed: @"share-Facebook-ipad.png"];
        UIImage *facebookButtonActiveImage = [UIImage imageNamed: @"share-Facebook-ipad-pressed.png"];
        UIButton *facebookButton = [UIButton buttonWithType: UIButtonTypeCustom];
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            facebookButton.frame = CGRectMake(0, 0, facebookButtonImage.size.width, facebookButtonImage.size.height);
            facebookButton.center = CGPointMake(self.shareFavouriteBtnView.center.x + 30, self.shareFavouriteBtnView.center.y);
        }
        else{
            facebookButton.frame = CGRectMake(0, 0, facebookButtonImage.size.width/2, facebookButtonImage.size.height/2);
            facebookButton.center = CGPointMake(self.shareFavouriteBtnView.center.x + 15,  self.shareFavouriteBtnView.center.y);
        }
        [facebookButton setBackgroundImage: facebookButtonImage forState: UIControlStateNormal];
        [facebookButton setBackgroundImage: facebookButtonActiveImage forState: UIControlStateSelected];
        [facebookButton addTarget: self action: @selector(shareFacebook:) forControlEvents: UIControlEventTouchUpInside];
        
        
        [self.shareFavouriteBtnView addSubview: facebookButton];
        
        UIImage *twitterButtonImage = [UIImage imageNamed: @"share-Twitter-ipad.png"];
        UIImage *twitterButtonActiveImage = [UIImage imageNamed: @"share-Twitter-ipad-pressed.png"];
        UIButton *twitterButton = [UIButton buttonWithType: UIButtonTypeCustom];
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            twitterButton.frame = CGRectMake(0, 0, twitterButtonImage.size.width, twitterButtonImage.size.height);
            twitterButton.center = CGPointMake(self.shareFavouriteBtnView.center.x - 40, self.shareFavouriteBtnView.center.y);
        }
        else{
            twitterButton.frame = CGRectMake(0, 0, twitterButtonImage.size.width/2, twitterButtonImage.size.height/2);
            twitterButton.center = CGPointMake(self.shareFavouriteBtnView.center.x - 20,  self.shareFavouriteBtnView.center.y);
        }
        
        [twitterButton setBackgroundImage: twitterButtonImage forState: UIControlStateNormal];
        [twitterButton setBackgroundImage: twitterButtonActiveImage forState: UIControlStateSelected];
        [twitterButton addTarget: self action: @selector(shareTwitter) forControlEvents: UIControlEventTouchUpInside];
        
        
        [self.shareFavouriteBtnView addSubview: twitterButton];
        
        
        
        UIImage *deleteButtonImage = [UIImage imageNamed: @"delete-Favorites-ipad.png"];
        UIImage *deleteButtonActiveImage = [UIImage imageNamed: @"delete-Favorites-ipad-pressed.png"];
        UIButton *deleteButton = [UIButton buttonWithType: UIButtonTypeCustom];

        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            deleteButton.frame = CGRectMake(0, 0, deleteButtonImage.size.width, deleteButtonImage.size.height);
            deleteButton.center = CGPointMake(self.shareFavouriteBtnView.center.x - 110, self.shareFavouriteBtnView.center.y);
        }
        else{
            deleteButton.frame = CGRectMake(0, 0, twitterButtonImage.size.width/2, deleteButtonImage.size.height/2);
            deleteButton.center = CGPointMake(self.shareFavouriteBtnView.center.x - 55,  self.shareFavouriteBtnView.center.y);
        }
        
        [deleteButton setBackgroundImage: deleteButtonImage forState: UIControlStateNormal];
        [deleteButton setBackgroundImage: deleteButtonActiveImage forState: UIControlStateSelected];
        [deleteButton addTarget: self action: @selector(favouriteDelete:) forControlEvents: UIControlEventTouchUpInside];
        
        
        [self.shareFavouriteBtnView addSubview: deleteButton];
        
        
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.shareFavouriteBtnView.center = CGPointMake(self.shareFavouriteBtn.center.x - 170,self.shareFavouriteBtn.center.y );
        }else{
            self.shareFavouriteBtnView.center = CGPointMake(self.shareFavouriteBtn.center.x - 85, self.shareFavouriteBtn.center.y);
        }
        [self.shareFavouriteBtnView setTag:777];
        self.shareFavouriteBtnView.hidden = NO;
        
        [cellSelected.contentView addSubview:self.shareFavouriteBtnView];
        self.cellIndex = path.row;
    }
    else{
        [[cellSelected.contentView viewWithTag:777] removeFromSuperview];
        self.cellIndex = -1;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)shareEmail
{
    [FlurryAnalytics logEvent: @"AppEmailToFriend"];
    
    if ( [self canSendMail] ) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        //[controller setSubject: NSLocalizedString(@"Funny joke from Fast Laugh Jokes", @"Share joke by email - subject")];
        [controller setSubject: NSLocalizedString(@"Funny joke from Best Stupid Jokes and Puns Free", @"Share joke by email - subject")];
        
        //[controller setMessageBody: [NSString stringWithFormat:@"%@ \n\n %@  \n\n %@", NSLocalizedString(@"Thought you would get a kick out of this joke...", @"Share joke by email - body"), self.insultLabel.text, NSLocalizedString(@"You can get Fast Laugh Jokes for iPhone, iPod, and iPad here: http://glob.ly/2pU.", @"Share joke by email - body - part 2")]
        //                  isHTML: NO];
        [controller setMessageBody: [NSString stringWithFormat:@"%@ \n\n %@  \n\n %@", NSLocalizedString(@"Thought you would get a kick out of this joke...", @"Share joke by email - body"), self.shareString, NSLocalizedString(@"You can get Best Stupid Jokes and Puns Free for iPhone, iPod, and iPad here: http://glob.ly/2pU.", @"Share joke by email - body - part 2")]
                            isHTML: NO];
        
        [controller setMailComposeDelegate: self];
        
        [self presentModalViewController: controller animated: YES];
    }
}



- (void)shareTwitter
{
    [FlurryAnalytics logEvent: @"AppShareToTw"];
    
    Class tweeterClass = NSClassFromString(@"TWTweetComposeViewController");
    
    if ( nil != tweeterClass ) {   // iOS5.0 twitter
        if ( [TWTweetComposeViewController canSendTweet] ) {
            TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
            [self addTweetContent: tweetViewController];
            
            tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                if( TWTweetComposeViewControllerResultDone == result ) {
                    // the user finished composing a tweet
                }
                else if( TWTweetComposeViewControllerResultCancelled == result ) {
                    // the user cancelled composing a tweet
                }
                [self dismissModalViewControllerAnimated: YES];
            };
            
            [self presentViewController: tweetViewController animated: YES completion: nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error" , @"")
                                                            message: NSLocalizedString(@"You need to setup at least 1 twitter account or allow the app to send tweets on your behalf. Please check Twitter in Settings application", @"Info screen - share via twitter - error alert text")
                                                           delegate: nil
                                                  cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
    else { // DETweeter
        DETweetComposeViewControllerCompletionHandler completionHandler = ^(DETweetComposeViewControllerResult result) {
            switch (result) {
                case DETweetComposeViewControllerResultCancelled:
                    debug(@"Twitter Result: Cancelled");
                    break;
                case DETweetComposeViewControllerResultDone:
                    debug(@"Twitter Result: Sent");
                    break;
            }
            [self dismissModalViewControllerAnimated: YES];
        };
        
        DETweetComposeViewController *tcvc = [[DETweetComposeViewController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self addTweetContent: tcvc];
        tcvc.completionHandler = completionHandler;
        [self presentModalViewController: tcvc animated: YES];
    }
}


- (void)addTweetContent: (id)tcvc
{
    if ( nil == tcvc ) {
        error(@"nil twitter controller supplied");
        return;
    }
    
    //[tcvc setInitialText: NSLocalizedString(@"Check out this hilarious insults app for iPhone - Cheap Shot Insults Shaker (from @brightnewt)", @"Info screen - share app via twitter - tweet text") ];
    [tcvc setInitialText: self.shareString];
    
    [tcvc addImage: [UIImage imageNamed: @"Icon.png"]];
    //[tcvc addURL: [NSURL URLWithString: @"http://glob.ly/2o4"]];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController: (MFMailComposeViewController*)controller
          didFinishWithResult: (MFMailComposeResult)result
                        error: (NSError*)error
{
	[self dismissModalViewControllerAnimated: YES];
	
	if ( MFMailComposeResultFailed == result ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error" , @"")
														message: [NSString stringWithFormat: NSLocalizedString(@"Error sending email: %@", @""), [error localizedDescription]]
													   delegate: nil
											  cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
											  otherButtonTitles: nil];
		[alert show];
	}
	else if ( MFMailComposeResultSent == result ) {
        debug(@"email SENT");
	}
}


- (void)shareFacebook: (id)sender
{
    //    [Flurry logEvent: @"AppShareToFb"];
    if ( ![[FacebookManager sharedInstance] isFacebookReachable] ) {
        error(@"no route to Facebook - cannot share");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error" , @"")
                                                        message: NSLocalizedString(@"You need to be connected to Internet to interact with Facebook.", @"Info screen - share facebook - no connection error alert text")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    debug(@"sharing to facebook");
    if ( [[FacebookManager sharedInstance] isLoggedIn] ) {
        [FacebookManager sharedInstance].shareTextFB = self.shareString;
        [[FacebookManager sharedInstance] performSelector: @selector(apiDialogFeedUser)
                                               withObject: nil
                                               afterDelay: 0.05];
    }
    else {
        debug(@"share to facebook - initiating login");
        _currentAPICall = kDialogFeedUser; //commented by thesun
        
        [FacebookManager sharedInstance].loginDelegate = self;
        [[FacebookManager sharedInstance] logIn];
    }
    
    
    
}

- (void)facebookDidLogIn
{
    debug(@"did LOG IN. _currentAPICall: %d", _currentAPICall);
    switch ( _currentAPICall ) {
        case kDialogFeedUser:
            [self performSelector: @selector(shareFacebook:) withObject: self afterDelay: 0.1f];
            break;
            //        case kDialogRequestsSendToMany:
            //            [self performSelector: @selector(inviteFriends:) withObject: self afterDelay: 0.1f];
            //            break;
        default:
            error(@"unsupported _currentAPICall: %d", _currentAPICall);
            break;
    }
    //self.facebookLogout.button.enabled = YES;
}


- (void)facebookDidNotLogin: (BOOL)cancelled;
{
    if ( !cancelled ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                        message: NSLocalizedString(@"Failed to authorize with Facebook", @"")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)facebookDidLogOut
{
    debug(@"did LOG OUT");
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    //    [self.mobclixAdView resumeAdAutoRefresh];
    //[self addRevMobBanner];
    
}
- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    //FB
    [FacebookManager sharedInstance].loginDelegate = self;
}

-(void)favouriteDelete : (id)sender{
    
       NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:self.favouritePath];
    [array removeObjectAtIndex:self.cellDeleted];
    NSError *error;
    if([fileManager fileExistsAtPath:self.favouritePath] == YES)
    {
        NSLog(@"Delete file exist");
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:self.favouritePath error:&error];
        
        NSLog(@"error:%@", error);
    }
   [array writeToFile:self.favouritePath atomically:YES];
    [self viewDidLoad];
    
}


- (void)createFarvoriteLabel
{
    // TITLE label
    UILabel *favoLabel;
    CGFloat fontSize = 24;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        favoLabel = [[UILabel alloc] initWithFrame:
                                 CGRectMake(245, 0,
                                            250, 85)];
        fontSize = 40;
        
        
    }else
    {
        favoLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(105, 0,
                                130, 50)];
    }
    
    favoLabel.font = [UIFont fontWithName:@"Forte" size: fontSize];
    
    favoLabel.textColor = [UIColor whiteColor];
    favoLabel.backgroundColor = [UIColor clearColor];
    favoLabel.shadowOffset = CGSizeMake(0, -0.5);
    favoLabel.shadowColor = [UIColor colorWithRed: 0.94 green: 0.90 blue: 0.75 alpha: 1.0];
    favoLabel.text = @"Favorites";
    
    [self.view addSubview: favoLabel];
}


@end
