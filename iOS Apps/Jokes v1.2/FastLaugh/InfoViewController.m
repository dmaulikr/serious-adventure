//
//  InfoViewController.m
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 1/27/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "InfoViewController.h"
#import "GUIHelper.h"
#import "DETweetComposeViewController.h"
#import "UIDevice+DETweetComposeViewController.h"
#import "HighlightedButton.h"
#import "InfoScreenButton.h"
//#import "ChartBoost.h"
#import "AppDelegate.h"
#import "UIDeviceHardware.h"
#import "StartScreenViewController.h"
#import "FavoriteViewController.h"

@interface InfoViewController ()
{
}

@property (strong, nonatomic) InfoScreenButton *shareEmailButton;
@property (strong, nonatomic) InfoScreenButton *shareTwitterButton;
@property (strong, nonatomic) InfoScreenButton *contactSupportButton;
@property (strong, nonatomic) InfoScreenButton *reviewOnAppstoreButton;
@property (strong, nonatomic) InfoScreenButton *followFbButton;
@property (strong, nonatomic) InfoScreenButton *followTwButton;
@property (strong, nonatomic) InfoScreenButton *legalButton;
@property (strong, nonatomic) InfoScreenButton *moreAppsButton;
//Sun add
@property (strong, nonatomic) InfoScreenButton *favouriteButton;

- (UIButton*)buttonWithImageNamed: (NSString*)imageName target: (id)target action: (SEL)action;
- (void)drawInfoButtons: (NSArray*)buttons withCenterHeight: (CGFloat)centerHeight;

- (void)goBack: (id)sender;

- (void)shareEmail: (id)sender;
- (void)contactSupport: (id)sender;
- (void)shareTwitter: (id)sender;
- (void)reviewOnAppstore: (id)sender;
- (void)followFacebook: (id)sender;
- (void)followTwitter: (id)sender;
- (void)addTweetContent: (id)tcvc;
- (void)openLegal: (id)sender;
- (void)moreApps: (id)sender;
// Sun
- (void)favouriteShow: (id)sender;
@end


@implementation InfoViewController

@synthesize shareEmailButton = _shareEmailButton;
@synthesize shareTwitterButton = _shareTwitterButton;
@synthesize contactSupportButton = _contactSupportButton;
@synthesize reviewOnAppstoreButton = _reviewOnAppstoreButton;
@synthesize followFbButton = _followFbButton;
@synthesize followTwButton = _followTwButton;
@synthesize legalButton = _legalButton;
@synthesize moreAppsButton = _moreAppsButton;
//Sun
@synthesize favouriteButton = _favouriteButton;

- (id)initWithNibName: (NSString*)nibNameOrNil bundle: (NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].applicationFrame];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame: self.view.bounds];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bgImageView.image = [UIImage imageNamed: @"background_rest-ipad.png"];
    }
    
    else if ( [GUIHelper isPhone5] ) {
        bgImageView.image = [UIImage imageNamed: @"background_rest_568h.png"];
    }
    else {
        bgImageView.image = [UIImage imageNamed: @"background_rest.png"];
    }
    
    bgImageView.userInteractionEnabled = YES;
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: bgImageView];

    [self createNavBar];
    
    // SHARE by TWITTER button
    self.shareTwitterButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Share-to-TW"
                                                                  target: self
                                                                  action: @selector(shareTwitter:)]
                                        text: NSLocalizedString(@"Share to Twitter", @"Info screen button title")
                         labelWidthExtension: 0.0];
    
    //follow Twitter
    self.followTwButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Follow-on-TW"
                                                                  target: self
                                                                  action: @selector(followTwitter:)]
                                        text: NSLocalizedString(@"Follow on Twitter", @"Info screen button title")
                         labelWidthExtension: 0.0];

    
    //follow FaceBook
    self.followFbButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Follow-on-FB"
                                                                  target: self
                                                                  action: @selector(followFacebook:)]
                                        text: NSLocalizedString(@"Follow on Facebook", @"Info screen button title")
                         labelWidthExtension: 0.0];

    
    // REVIEW on APPSTORE button
    self.reviewOnAppstoreButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Review-App"
                                                                  target: self
                                                                  action: @selector(reviewOnAppstore:)]
                                        text: NSLocalizedString(@"Review on App Store", @"Info screen button title")
                         labelWidthExtension: 10.0];

    // SHARE by EMAIL button
    self.shareEmailButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Email-Friends"
                                                                  target: self
                                                                  action: @selector(shareEmail:)]
                                        text: NSLocalizedString(@"Email to Friends", @"Info screen button title")
                         labelWidthExtension: 0.0];

    
    // More Apps button
    self.moreAppsButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"More-Apps"
                                                                  target: self
                                                                  action: @selector(moreApps:)]
                                        text: NSLocalizedString(@"More Apps", @"Info screen button title")
                         labelWidthExtension: -10.0];
    
    // Favorite button
    self.favouriteButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Favorites"
                                                                  target: self
                                                                  action: @selector(favouriteShow:)]
                                        text: NSLocalizedString(@"Favorites", @"Info screen button title")
                         labelWidthExtension: 0.0];
    [self.view addSubview: self.favouriteButton];

    
    // Legal button
    self.legalButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Legal"
                                                                  target: self
                                                                  action: @selector(openLegal:)]
                                        text: NSLocalizedString(@"Legal", @"Info screen button title")
                         labelWidthExtension: 0.0];
    [self.view addSubview: self.legalButton];

    
    // CONTACT SUPPORT button
    self.contactSupportButton =
    [[InfoScreenButton alloc] initWithButton: [self buttonWithImageNamed: @"Contact-Support"
                                                                  target: self
                                                                  action: @selector(contactSupport:)]
                                        text: NSLocalizedString(@"Contact Support", @"Info screen button title")
                         labelWidthExtension: 0.0];

    

    // DRAW rows
    CGFloat firstRowY = 140;
    CGFloat rowDelta = 125;
    CGFloat fontSize = 10;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        firstRowY += 150;
        rowDelta += 150;
        fontSize += 10;
    }else if([GUIHelper isPhone5]){
        firstRowY = 160;
        rowDelta = 150;
    }
    
    
    NSArray *row1 = [NSArray arrayWithObjects: self.shareTwitterButton, self.followTwButton, self.followFbButton, nil];
    [self drawInfoButtons: row1 withCenterHeight: firstRowY];
    
    NSArray *row2 = [NSArray arrayWithObjects: self.reviewOnAppstoreButton, self.shareEmailButton, self.moreAppsButton, nil];
    [self drawInfoButtons: row2 withCenterHeight: firstRowY + rowDelta];
    
    NSArray *row3 = [NSArray arrayWithObjects: self.favouriteButton,self.legalButton, self.contactSupportButton, nil];
    [self drawInfoButtons: row3 withCenterHeight: firstRowY + 2 * rowDelta];
    
    
    // Copyright label
    UILabel *copyrightLabel;
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
         copyrightLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake( 0 + 210, self.view.frame.size.height - 60, 320, 2*20)];
     }
    else
    {
      copyrightLabel = [[UILabel alloc] initWithFrame:
                               CGRectMake( 0, self.view.frame.size.height - 30, 320, 20)];
    }
    copyrightLabel.font = [UIFont systemFontOfSize: fontSize];
    //copyrightLabel.textColor = [UIColor colorWithRed: 0.17 green: 0.1 blue: 0.04 alpha: 1.0];
    copyrightLabel.textColor = [UIColor whiteColor];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    copyrightLabel.text = NSLocalizedString( @"© BrightNewt 2013", @"Info screen copyright");
    copyrightLabel.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview: copyrightLabel];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    debug(@"Facebook share: did unload");
}


- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
  
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark View

- (void)createNavBar
{
    [super createNavBar];
    
    [self createLeftNavBarButtonWithTitle: NSLocalizedString(@"", @"Info screen nav bar button") target: self action: @selector(goBack:)];
    [self createNavBarTitleWithText: [NSString stringWithFormat: NSLocalizedString(@"Info", @"Info screen nav bar title"),
                                      [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]]];
    
    CGRect navBarTitleLabelFrame = self.navBarTitleLabel.frame;
    
    self.navBarTitleLabel.frame = navBarTitleLabelFrame;
    self.navBarTitleLabel.textColor = [UIColor whiteColor];
    CGFloat fontSize = 20;
    if (([[UIDevice currentDevice] userInterfaceIdiom]) == UIUserInterfaceIdiomPad)
    {
        fontSize += 15;
    }
    self.navBarTitleLabel.font = [UIFont fontWithName:@"Forte" size: fontSize];
    self.navBarTitleLabel.textAlignment = UITextAlignmentCenter;
}

- (UIButton*)buttonWithImageNamed: (NSString*)imageName
                           target: (id)target
                           action: (SEL)action
{
    if ( nil == imageName ) {
        error(@"nil image supplied");
        return nil;
    }
    
    UIImage *buttonImage = [UIImage imageNamed: imageName];
    UIImage *buttonPressedImage = [UIImage imageNamed: [NSString stringWithFormat: @"%@-pressed", imageName]];
    
    // Sun - iPad support
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        buttonImage = [UIImage imageNamed: [NSString stringWithFormat: @"%@-ipad", imageName]];
        buttonPressedImage = [UIImage imageNamed: [NSString stringWithFormat: @"%@-ipad-pressed", imageName]];
    }
	
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [button setImage: buttonImage forState: UIControlStateNormal];
    [button setImage: buttonPressedImage forState: UIControlStateHighlighted];
    button.frame= CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    if([imageName isEqual: @"Favorites"]){
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
            buttonImage = [UIImage imageNamed: @"Favorites-ipad.png"];
            buttonPressedImage = [UIImage imageNamed: @"Favorites-ipad-pressed"];
            button = [UIButton buttonWithType: UIButtonTypeCustom];
            
            [button setImage: buttonImage forState: UIControlStateNormal];
            [button setImage: buttonPressedImage forState: UIControlStateHighlighted];
            button.frame= CGRectMake(0, 0, 71, 84);
        }
    }

  	
	[button addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];

    return button;
}


- (void)drawInfoButtons: (NSArray*)buttons withCenterHeight: (CGFloat)centerHeight
{
    if ( [buttons count] < 1 || 3 < [buttons count] ) {
        error(@"inappropriate number of buttons supplied: %d", [buttons count]);
        return;
    }
    
    int count = [buttons count];
    switch ( count ) {
        case 3:
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
//                UIView *btn1 = [buttons objectAtIndex: 0];
//                btn1.center = CGPointMake(round(5*25.0 + 0.5 * btn1.bounds.size.width), centerHeight);
//                
//                UIView *btn2 = [buttons objectAtIndex: 1];
//                btn2.center = CGPointMake(2.3*160, centerHeight);
//                
//                UIView *btn3 = [buttons objectAtIndex: 2];
//                btn3.center = CGPointMake(round(2.3*320 - 3*25.0 - 0.5 * btn3.bounds.size.width), centerHeight);
                UIView *btn1 = [buttons objectAtIndex: 0];
                btn1.center = CGPointMake(round(70.0 + 0.5 * btn1.bounds.size.width), centerHeight);
                
                UIView *btn2 = [buttons objectAtIndex: 1];
                btn2.center = CGPointMake(390, centerHeight);
                
                UIView *btn3 = [buttons objectAtIndex: 2];
                btn3.center = CGPointMake(round(790 - 70.0 - 0.5 * btn1.bounds.size.width), centerHeight);
            }
            else
            {
               UIView *btn1 = [buttons objectAtIndex: 0];
               btn1.center = CGPointMake(round(25.0 + 0.5 * btn1.bounds.size.width), centerHeight);
            
               UIView *btn2 = [buttons objectAtIndex: 1];
               btn2.center = CGPointMake(160, centerHeight);
            
               UIView *btn3 = [buttons objectAtIndex: 2];
               btn3.center = CGPointMake(round(320 - 25.0 - 0.5 * btn3.bounds.size.width), centerHeight);
            }
            break;
        }
        case 2:
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
//                UIView *btn1 = [buttons objectAtIndex: 0];
//                btn1.center = CGPointMake(round(3*25.0 + 0.5 * btn1.bounds.size.width), centerHeight);
//                
//                UIView *btn2 = [buttons objectAtIndex: 1];
//                btn2.center = CGPointMake(2.3*160, centerHeight);
                UIView *btn1 = [buttons objectAtIndex: 0];
                btn1.center = CGPointMake(round(70.0 + 0.5 * btn1.bounds.size.width), centerHeight);
                
                UIView *btn2 = [buttons objectAtIndex: 1];
                btn2.center = CGPointMake(390, centerHeight);

            }
            else
            {
                UIView *btn1 = [buttons objectAtIndex: 0];
                btn1.center = CGPointMake(round(25.0 + 0.5 * btn1.bounds.size.width), centerHeight);
                
                UIView *btn2 = [buttons objectAtIndex: 1];
                btn2.center = CGPointMake(160, centerHeight);
            }
           
            
            break;
        }
        case 1:
        {
            UIView *btn1 = [buttons objectAtIndex: 0];
            btn1.center = CGPointMake(160, centerHeight);
            
            break;
        }   
        default:
            error(@"unsupported count: %d", count);
            break;
    }
    
    for ( UIView *btn in buttons ) {
        [self.view addSubview: btn];
    }
}


#pragma mark - Actions

- (void)goBack: (id)sender
{
    [FlurryAnalytics logEvent: @"GoBackToStartPage"];
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}


- (void)shareEmail: (id)sender
{
    [FlurryAnalytics logEvent: @"AppEmailToFriend"];
    
    if ( [self canSendMail] ) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setSubject: NSLocalizedString(@"you've got to see this funny iPhone app", @"Info screen - share app by email - subject")];
        //[controller setMessageBody: NSLocalizedString(@"Hey, you've got to get Fast Laugh Jokes right now. It's got all these stupid jokes, and you just shake the app to see new ones. \n\n Check it out: http://glob.ly/2pU", @"Info screen - share app by email - body")
        //                    isHTML: NO];
        [controller setMessageBody: NSLocalizedString(@"Hey, you've got to get Best Stupid Jokes and Puns Free right now. It's got all these stupid jokes, and you just shake the app to see new ones. \n\n Check it out: http://glob.ly/2pU", @"Info screen - share app by email - body")
                            isHTML: NO];
        
        [controller setMailComposeDelegate: self];
        
        [self presentModalViewController: controller animated: YES];
    }
}


- (void)contactSupport: (id)sender 
{
    [FlurryAnalytics logEvent: @"AppContactSupport"];
    
    if ( [self canSendMail] ) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleVersion"];
        
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setToRecipients: [NSArray arrayWithObject: @"support@brightnewt.com"]];
        [controller setSubject:
        // [NSString stringWithFormat: NSLocalizedString(@"Feedback for Fast Laugh Jokes v1.0", @"Info screen - contact support - email subject"), version]];
        [NSString stringWithFormat: NSLocalizedString(@"Feedback for Best Stupid Jokes and Puns Free v1.0", @"Info screen - contact support - email subject"), version]];
        // get device properties
        UIDevice *device = [UIDevice currentDevice];
        UIDeviceHardware *hardware = [[UIDeviceHardware alloc] init];
        
        NSMutableString *deviceProperties = [[NSMutableString alloc] init];
        [deviceProperties appendFormat: NSLocalizedString(@"device: %@\n", @""), [hardware platformString]];
        [deviceProperties appendFormat: NSLocalizedString(@"system: %@ %@\n", @""), device.systemName, device.systemVersion];
        
        [controller setMessageBody: [NSString stringWithFormat: NSLocalizedString(@"Your app would be even better if...\n\n\n\n\nMy device properties are:\n%@", @"Info screen - contact support - email body"), deviceProperties] isHTML: NO];
        [controller setMailComposeDelegate: self];
        
        [self presentModalViewController: controller animated: YES];
    }
}


- (void)shareTwitter: (id)sender
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
    
    //[tcvc setInitialText: NSLocalizedString(@"Check out this hilarious jokes app for iPhone, Fast Laugh Jokes (from @brightnewt) http://glob.ly/2pU", @"Info screen - share app via twitter - tweet text")];
    [tcvc setInitialText: NSLocalizedString(@"Check out this hilarious jokes app for iPhone, Best Stupid Jokes and Puns Free (from @brightnewt) http://glob.ly/2pU", @"Info screen - share app via twitter - tweet text")];    
    [tcvc addImage: [UIImage imageNamed: @"Icon.png"]];
}


- (void)reviewOnAppstore: (id)sender
{
    [FlurryAnalytics logEvent: @"AppReviewOnStore"];
    //if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
      [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=553235582"]];
//    }else
//    
//     [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=553235582&onlyLatestVersion=false&type=Purple+Software"]];
//    [(AppDelegate*)[UIApplication sharedApplication].delegate openReferralURL: [NSURL URLWithString: @"http://glob.ly/2pU"]];
}


- (void)moreApps: (id)sender
{
   [FlurryAnalytics logEvent: @"MoreApps"];
    
    //if( [FacebookManager sharedInstance].isFacebookReachable ) {
    
    [[PHPublisherContentRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret placement: @"more_games" delegate: (AppDelegate*)[UIApplication sharedApplication].delegate] send];
 
}


- (void)followFacebook: (id)sender
{
    [FlurryAnalytics logEvent: @"AppFollowFb"];
 
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://www.facebook.com/pages/Bright-Newt/155488204529275"]];
    // FB App tied fan page
}


- (void)followTwitter: (id)sender
{
    [FlurryAnalytics logEvent: @"AppFollowTw"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"https://twitter.com/brightnewt"]];
}


- (void)openLegal: (id)sender
{
    [FlurryAnalytics logEvent: @"OpenLegal"];
    
    WebViewController *legalController = [[WebViewController alloc] initWithNibName: nil bundle: nil];
    legalController.title = NSLocalizedString(@"Terms Of Use", @"Legal screen - Nav Bar title");
    legalController.url = [NSURL URLWithString: @"http://brightnewt.com/bright-newt-apps/fast-laugh-jokes-terms-of-use/"];
    legalController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: legalController];
    [self presentModalViewController: navController animated: YES];
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


#pragma mark - WebViewControllerDelegate

- (void)cancelWebViewController: (id)sender
{
    [self.modalViewController dismissModalViewControllerAnimated: YES];
}


#pragma mark - ChartboostDelegate

// Called when an more apps page has been received, before it is presented on screen
// Return NO if showing the more apps page is currently inappropriate
- (BOOL)shouldDisplayMoreApps
{
    [UIApplication sharedApplication].statusBarHidden = YES;

    return YES;
}

// Called before requesting the more apps view from the back-end
// Return NO if when showing the loading view is not the desired user experience
- (BOOL)shouldDisplayLoadingViewForMoreApps
{
    return YES;
}

// Called when the user dismisses the more apps view
- (void)didDismissMoreApps
{
    [UIApplication sharedApplication].statusBarHidden = NO;

}

// Same as above, but only called when dismissed for a close
- (void)didCloseMoreApps
{

}

// Same as above, but only called when dismissed for a click
- (void)didClickMoreApps
{

}

// Called when a more apps page has failed to come back from the server
- (void)didFailToLoadMoreApps
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error loading more apps", @"")
                                                    message: NSLocalizedString(@"Something wrong with loading more apps.", @"")
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                          otherButtonTitles: nil];
    [alert show];
    [UIApplication sharedApplication].statusBarHidden = NO;

    
}

- (void)favouriteShow: (id)sender{
    
    FavoriteViewController *favoriteViewController = [[FavoriteViewController alloc] initWithNibName: nil bundle: nil];
    favoriteViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: favoriteViewController];
    navController.navigationBarHidden = YES;
    favoriteViewController.favouritePath = self.favouritePath;
    
    [self.navigationController presentModalViewController: navController animated: YES];
}
// Called when the More Apps page has been received and cached
- (void)didCacheMoreApps
{
}


@end
