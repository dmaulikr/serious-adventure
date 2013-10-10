//
//  StartScreenViewController.m
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/16/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "StartScreenViewController.h"
#import "CategoryEntity.h"
#import "InsultEntity.h"
#import "PurchaseEntity.h"
#import "GUIHelper.h"
#import "InfoViewController.h"
#import "PurchaseViewController.h"
#import "DETweetComposeViewController.h"
#import "UIDevice+DETweetComposeViewController.h"
#import "iRate.h"

//#import "FacebookManager.h"
#import "PlayHavenSDK.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "FacebookManager.h"
#import "FavoriteViewController.h"

@interface StartScreenViewController ()
{
    EFacebookAPICall _currentAPICall;
}

@property (nonatomic, strong) UILabel *insultLabel;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, assign) BOOL isShareButtonPressed;
@property (nonatomic, strong) UIImageView  *shareButtonsView;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) SegmentedSortBar *segmentedControl;
@property (nonatomic, strong) CategoryEntity *currentCategory;

@property (nonatomic, strong) UIButton *removeBannerAdButton;

@property (nonatomic, strong) RevMobBannerView *revMobBannerView;
@property (nonatomic, assign) BOOL isRevMobBannerShown;
@property (nonatomic, assign) BOOL isRevMobBannerLoaded;
@property (nonatomic, assign) BOOL isSubscrubiedToRevMobKVO;

//Sun
@property (nonatomic, strong) UIImageView  *addedFavortiteView;
@property (nonatomic, assign) BOOL isFavoriteButtonPressed;
@property (nonatomic, retain) NSMutableArray *dataArray;


- (void) didShake;
- (void) goInfo;
- (void) goPurchase;
- (void) removeShareBtn;
- (void) addTweetContent: (id)tcvc;
- (void) removeBanner: (id)sender;
- (void) createSegmentedControl;

@end


@implementation StartScreenViewController

@synthesize insultLabel = _insultLabel;
@synthesize segmentedControl = _segmentedControl;
@synthesize currentCategory = _currentCategory;


@synthesize shareButton = _shareButton;
@synthesize isShareButtonPressed = _isShareButtonPressed;
@synthesize moreButton = _moreButton;
@synthesize shareButtonsView = _shareButtonsView;

@synthesize removeBannerAdButton = _removeBannerAdButton;


@synthesize revMobBannerView = _revMobBannerView;
@synthesize isRevMobBannerShown = _isRevMobBannerShown;
@synthesize isRevMobBannerLoaded = _isRevMobBannerLoaded;
@synthesize isSubscrubiedToRevMobKVO = _isSubscrubiedToRevMobKVO;
//@synthesize delegate = _delegate;

//Sun
@synthesize dataArray = _dataArray;
@synthesize addedFavortiteView = _addedFavortiteView;
@synthesize isFavoriteButtonPressed = _isFavoriteButtonPressed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
        self.isRevMobBannerLoaded = NO;
        self.isRevMobBannerShown = NO;
        self.isSubscrubiedToRevMobKVO = NO;
 
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView
{
	self.view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].applicationFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.navigationController.navigationBarHidden = YES;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // BG image
    UIImageView *bgImageVIew = [[UIImageView alloc] initWithFrame: self.view.bounds];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        bgImageVIew.image = [UIImage imageNamed: @"Default-ipad.png"];
    }
    else if ( [GUIHelper isPhone5] ) {
        bgImageVIew.image = [UIImage imageNamed: @"background_home_568h.png"];
    }
    else {
        bgImageVIew.image = [UIImage imageNamed: @"background_home.png"];
    }
    [self.view addSubview: bgImageVIew];
        
    [[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(didShake)
												 name: @"DID_SHAKE_NOTIFICATION"
											   object: nil];
    CGFloat insultX = 32,insultY = 75, insultW = 260, insultH = 160;
    CGFloat insultFontSize = 14;
    //iPad
    if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
        
        insultX = 2.4 * insultX;
        insultY = 2.7 * insultY;
        insultW = 2.4 * insultW;
        insultH = 1.8 * insultH;
        insultFontSize += 12;
    }
    else if ( [GUIHelper isPhone5] ) {
        
        insultH = 1.5 * insultH;
        insultFontSize = 16;
    }
   
    self.insultLabel = [[UILabel alloc] initWithFrame: CGRectMake(insultX, insultY , insultW, insultH)];
    self.insultLabel.backgroundColor = [UIColor clearColor];
    self.insultLabel.font =  [UIFont fontWithName: @"Eras Bold ITC" size: insultFontSize];
    self.insultLabel.textColor = [UIColor blackColor];
    self.insultLabel.textAlignment = UITextAlignmentCenter;
    self.insultLabel.numberOfLines = 0;
    [self.view addSubview: self.insultLabel];
    UIImage *glassEffect = [UIImage imageNamed: @"glass_effect.png"];
    UIImageView *glassEffectView = [[UIImageView alloc] initWithImage: glassEffect];
    //iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        glassEffectView.frame = CGRectMake(self.insultLabel.frame.origin.x - 2, self.insultLabel.frame.origin.y - 20, insultW, insultH);
        
    }
    else if ( [GUIHelper isPhone5] ) {
        glassEffectView.frame = CGRectMake(32, 133, 260, 157);
    }
    else
    {
        glassEffectView.frame = CGRectMake(self.insultLabel.frame.origin.x - 2, self.insultLabel.frame.origin.y + 13, glassEffect.size.width, glassEffect.size.height);
    }
        
    [self.view addSubview: glassEffectView];
    
    [self createSegmentedControl];
    
    self.currentCategory = [[DataModel sharedInstance] categoryWithName: [self.segmentedControl titleForSegmentAtIndex: 0]];
    
    UIImage *newInsultButtonImage = [UIImage imageNamed: @"shake_active.png"];
    UIButton *newInsultButton = [UIButton buttonWithType: UIButtonTypeCustom];
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        newInsultButton.frame = CGRectMake(0, 0, 1.5*newInsultButtonImage.size.width, 1.5*newInsultButtonImage.size.height);
        newInsultButton.center = CGPointMake(0.5 * self.view.frame.size.width, self.view.frame.size.height - 5 - 2.8 * newInsultButton.frame.size.height);
        
    }
    else{
        newInsultButton.frame = CGRectMake(0, 0, newInsultButtonImage.size.width, newInsultButtonImage.size.height);
        newInsultButton.center = CGPointMake(0.5 * self.view.frame.size.width, self.view.frame.size.height - 5 - 2 * newInsultButton.frame.size.height);
    }
    
    
    [newInsultButton setBackgroundImage: newInsultButtonImage forState: UIControlStateNormal];
    [newInsultButton addTarget: self action: @selector(didShake) forControlEvents: UIControlEventTouchUpInside];
    [newInsultButton addTarget: self action: @selector(removeShareBtn) forControlEvents: UIControlEventTouchUpInside];
    

    [self.view addSubview: newInsultButton];
    
    
    UIImage *infoButtonImage = [UIImage imageNamed: @"info_normal.png"];
    UIImage *infoButtonActiveImage = [UIImage imageNamed: @"info_active.png"];    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
infoButton.frame = CGRectMake(0, 0, 1.5*infoButtonImage.size.width, 1.5*infoButtonImage.size.height);
    }
    else{
        infoButton.frame = CGRectMake(0, 0, infoButtonImage.size.width, infoButtonImage.size.height);
    }
    
    [infoButton setBackgroundImage: infoButtonImage forState: UIControlStateNormal];
    [infoButton setBackgroundImage: infoButtonActiveImage forState: UIControlStateSelected];
    [infoButton addTarget: self action: @selector(goInfo) forControlEvents: UIControlEventTouchUpInside];
    [infoButton addTarget: self action: @selector(removeShareBtn) forControlEvents: UIControlEventTouchUpInside];
    
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        infoButton.center = CGPointMake(10 + 0.85 * infoButton.frame.size.width, self.view.frame.size.height - 0.5* infoButton.frame.size.height);
    }
    else
    {
        infoButton.center = CGPointMake(10 + 0.5 * infoButton.frame.size.width, self.view.frame.size.height - 0.5 * infoButton.frame.size.height);
    }

    
    [self.view addSubview: infoButton];

    UIImage *purchaseButtonImage = [UIImage imageNamed: @"shop_normal.png"];
    UIImage *purchaseButtonActiveImage = [UIImage imageNamed: @"shop_active.png"];    
    UIButton *purchaseButton = [UIButton buttonWithType: UIButtonTypeCustom];
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        purchaseButton.frame = CGRectMake(0, 0, 1.5*purchaseButtonImage.size.width, 1.5*purchaseButtonImage.size.height);
    }
    else{
        purchaseButton.frame = CGRectMake(0, 0, purchaseButtonImage.size.width, purchaseButtonImage.size.height);
    }

    
    [purchaseButton setBackgroundImage: purchaseButtonImage forState: UIControlStateNormal];
    [purchaseButton setBackgroundImage: purchaseButtonActiveImage forState: UIControlStateSelected];
    [purchaseButton addTarget: self action: @selector(goPurchase) forControlEvents: UIControlEventTouchUpInside];
    [purchaseButton addTarget: self action: @selector(removeShareBtn) forControlEvents: UIControlEventTouchUpInside];
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        purchaseButton.center = CGPointMake([GUIHelper getRightXForView: infoButton] + purchaseButton.frame.size.width, self.view.frame.size.height - 0.5 * purchaseButton.frame.size.height);
    }
    else
    {
        purchaseButton.center = CGPointMake([GUIHelper getRightXForView: infoButton] + 0.5 * purchaseButton.frame.size.width - 5, self.view.frame.size.height - 0.5 * purchaseButton.frame.size.height);
    }
    
    [self.view addSubview: purchaseButton];
    
    UIImage *moreButtonImage = [UIImage imageNamed: @"more_normal.png"];
    UIImage *moreButtonActiveImage = [UIImage imageNamed: @"more_active.png"];    
    UIButton *moreButton = [UIButton buttonWithType: UIButtonTypeCustom];
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        moreButton.frame = CGRectMake(0, 0, 1.5*moreButtonImage.size.width, 1.5*moreButtonImage.size.height);
    }
    else{
        moreButton.frame = CGRectMake(0, 0, moreButtonImage.size.width, moreButtonImage.size.height);
    }

    
    [moreButton setBackgroundImage: moreButtonImage forState: UIControlStateNormal];
    [moreButton setBackgroundImage: moreButtonActiveImage forState: UIControlStateSelected];
    [moreButton addTarget: self action: @selector(showMore) forControlEvents: UIControlEventTouchUpInside];
    [moreButton addTarget: self action: @selector(removeShareBtn) forControlEvents: UIControlEventTouchUpInside];
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        moreButton.center = CGPointMake([GUIHelper getRightXForView: purchaseButton] +  moreButton.frame.size.width , self.view.frame.size.height - 0.5 * moreButton.frame.size.height);
    }
    else{
        moreButton.center = CGPointMake([GUIHelper getRightXForView: purchaseButton] + 0.5 * moreButton.frame.size.width  - 5, self.view.frame.size.height - 0.5 * moreButton.frame.size.height);
   }
    
    [self.view addSubview: moreButton];
    self.moreButton = moreButton;
   
    CGFloat xShift = 16.0, fontMore = 15;
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        xShift += 9;
        fontMore += 9;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, -8 , self.moreButton.frame.size.width - xShift, self.moreButton.frame.size.height)];
    titleLabel.font = [UIFont fontWithName:@"Eras Bold ITC" size: fontMore];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.shadowColor = [GUIHelper defaultShadowColor];
    titleLabel.shadowOffset = [GUIHelper defaultShadowOffset];
    titleLabel.text = NSLocalizedString(@"more", @"More button");
    titleLabel.textColor = [UIColor colorWithRed: 0.84 green: 0.00 blue: 0.85 alpha: 1.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.moreButton addSubview: titleLabel];
    
    
    UIImage *shareButtonImage = [UIImage imageNamed: @"share_normal.png"];
    UIImage *shareButtonActiveImage = [UIImage imageNamed: @"share_active.png"];    
    UIButton *shareButton = [UIButton buttonWithType: UIButtonTypeCustom];
    //iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
        shareButton.frame = CGRectMake(0, 0, 1.5*shareButtonImage.size.width, 1.5*shareButtonImage.size.height);
        shareButton.center = CGPointMake([GUIHelper getRightXForView: moreButton] + shareButton.frame.size.width  , self.view.frame.size.height - 0.5 * shareButton.frame.size.height);        
    }
    else{
        shareButton.frame = CGRectMake(0, 0, shareButtonImage.size.width, shareButtonImage.size.height);
        shareButton.center = CGPointMake([GUIHelper getRightXForView: moreButton] + 0.5 * shareButton.frame.size.width  - 5, self.view.frame.size.height - 0.5 * shareButton.frame.size.height);
    }

    
    [shareButton setBackgroundImage: shareButtonImage forState: UIControlStateNormal];
    [shareButton setBackgroundImage: shareButtonActiveImage forState: UIControlStateSelected];
    [shareButton addTarget: self action: @selector(showShareOptions) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: newInsultButton];
    self.shareButton = shareButton;
//    //iPad
//    if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
//        shareButton.center = CGPointMake([GUIHelper getRightXForView: moreButton] + shareButton.frame.size.width  , self.view.frame.size.height - 0.5 * shareButton.frame.size.height);
//    }
//    else
//    {
//        shareButton.center = CGPointMake([GUIHelper getRightXForView: moreButton] + 0.5 * shareButton.frame.size.width  - 5, self.view.frame.size.height - 0.5 * shareButton.frame.size.height);
//   }
    
    [self.view addSubview: shareButton];
    self.isShareButtonPressed = NO;  
    
    if ( [DataModel sharedInstance].shouldShowBannerAds ) {
        
        CGFloat bannerWidth, bannnerHeight;
        //iPad
        if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            bannerWidth = 768;
            bannnerHeight = 66;
        }
        else{//iPhone
            bannerWidth = 320;
            bannnerHeight = 50;
        }
        if ( nil == [RevMobAds session] ) {
            
            debug(@"initializing rev mob");
            [RevMobAds startSessionWithAppID:REVMOB_APP_ID];//]@"519aedce15c11c6b8700017c"];
            
        }
        
        //self.revMobBannerView = [[RevMobAds session] bannerView];
        self.revMobBannerView = [[RevMobAds session] bannerViewWithPlacementId: REVMOB_BANNER_ID];//@"519aedce15c11c6b8700017f"];
        self.revMobBannerView.delegate = self;
        [self.revMobBannerView loadAd];
        [self.revMobBannerView setFrame:CGRectMake(0, 0, bannerWidth, bannnerHeight)];
        [self.view addSubview: self.revMobBannerView];
        [self subscribeToRevMobBannerKVO];
        self.removeBannerAdButton = [UIButton buttonWithType: UIButtonTypeCustom];
        UIImage *closeImage = [UIImage imageNamed: @"RedXButton.png"];
        self.removeBannerAdButton.frame = CGRectMake(0, 0, 30, 30);
        [self.removeBannerAdButton setImage: closeImage forState: UIControlStateNormal];
        [self.removeBannerAdButton addTarget: self action: @selector(removeBanner:) forControlEvents: UIControlEventTouchUpInside];
    }
        
   
    
    [self didShake];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updatePackView:)
                                                 name: @"UserDidPurchasePack"
                                               object: nil];
    if ([[iRate sharedInstance] shouldPromptForRating])
        [[iRate sharedInstance] performSelector:@selector(promptIfNetworkAvailable) withObject:self afterDelay:2.0f];
    // Favourite
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *parentDir = [paths objectAtIndex:0];
    self.favouritePath = [parentDir stringByAppendingPathComponent:@"addedJokesFavourite.txt"];

}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    [self addRevMobBanner];
    
    
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //Quang Start
    [DataModel sharedInstance].purchaseDelegate = nil;
    [self unsubscribeFromRevMobBannerKVO];
    //End
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDidPurchasePack" object:nil];
    
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    //[self addRevMobBanner];
    [DataModel sharedInstance].purchaseDelegate = self;
    //Facebook
    [FacebookManager sharedInstance].loginDelegate = self;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:self.favouritePath] == YES)
    {
        self.dataArray = [[NSMutableArray alloc] initWithContentsOfFile:self.favouritePath];
    }

    [self didShake];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self removeRevMobBanner];
    
    [DataModel sharedInstance].purchaseDelegate = nil;    
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Actions

- (void)didShake
{
    debug(@"did shake notification received");
    
    InsultEntity *insult = [[DataModel sharedInstance] randomInsultInCategory: self.currentCategory];
    self.insultLabel.text = insult.insult;
    
    [insult incShowCount];
    
    NSError *error = nil;
    if (![[DataModel sharedInstance].managedObjectContext save: &error]) {
        abort();
        //[[DataModel sharedInstance] handleSaveContextError: error];
    }
    [self removeShareBtn];
    if (self.isFavoriteButtonPressed){
        [self.addedFavortiteView removeFromSuperview];
        self.isFavoriteButtonPressed = NO;
    }
}



- (void) showShareOptions
{
    if (!self.isShareButtonPressed){
        UIImage *shareButtonActiveImage = [UIImage imageNamed: @"active-ipad.png"];
        self.shareButtonsView = [[UIImageView alloc] initWithImage: shareButtonActiveImage];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.shareButtonsView.frame = CGRectMake(0, 0, 115, 0.6 *shareButtonActiveImage.size.height);
        }else{
            if([GUIHelper isPhone5])
                self.shareButtonsView.frame = CGRectMake(0, 0, 72, 0.3 *shareButtonActiveImage.size.height);
            else
                self.shareButtonsView.frame = CGRectMake(0, 0, 72, 0.3 *shareButtonActiveImage.size.height);
            
        }
        self.shareButtonsView.userInteractionEnabled = YES;
        
        UIImage *favouriteButtonImage = [UIImage imageNamed: @"favorites-share-ipad.png"];
        UIImage *favouriteButtonActiveImage = [UIImage imageNamed: @"favorite-share-ipad-pressed.png"];
        UIButton *favouriteButton = [UIButton buttonWithType: UIButtonTypeCustom];
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            favouriteButton.frame = CGRectMake(0, 0, 0.7 *favouriteButtonImage.size.width, 0.6 *favouriteButtonImage.size.height);
            favouriteButton.center = CGPointMake(self.shareButtonsView.center.x, 0.5 * favouriteButtonImage.size.height - 10);
        }
        else{
            favouriteButton.frame = CGRectMake(0, 0, 0.3*favouriteButtonImage.size.width, 0.3*favouriteButtonImage.size.height);
            favouriteButton.center = CGPointMake(self.shareButtonsView.center.x, 0.2 * favouriteButtonImage.size.height);
        }
        [favouriteButton setBackgroundImage: favouriteButtonImage forState: UIControlStateNormal];
        [favouriteButton setBackgroundImage: favouriteButtonActiveImage forState: UIControlStateSelected];
        [favouriteButton addTarget: self action: @selector(showFavorite) forControlEvents: UIControlEventTouchUpInside];
        
        [self.shareButtonsView addSubview: favouriteButton];
        
        
        
        UIImage *facebookButtonImage = [UIImage imageNamed: @"facebook-ipad.png"];
        UIImage *facebookButtonActiveImage = [UIImage imageNamed: @"facebook-ipad-pressed.png"];
        UIButton *facebookButton = [UIButton buttonWithType: UIButtonTypeCustom];
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            facebookButton.frame = CGRectMake(0, 0, 0.7* favouriteButtonImage.size.width, 0.7 *favouriteButtonImage.size.height);
            facebookButton.center = CGPointMake(self.shareButtonsView.center.x, [GUIHelper getBottomYForView:favouriteButton]+ facebookButtonImage.size.height - 60 );
        }
        else{
            facebookButton.frame = CGRectMake(0, 0, 0.3*facebookButtonImage.size.width, 0.3*facebookButtonImage.size.height);
            facebookButton.center = CGPointMake(self.shareButtonsView.center.x, [GUIHelper getBottomYForView:favouriteButton] + 15);
        }
        [facebookButton setBackgroundImage: facebookButtonImage forState: UIControlStateNormal];
        [facebookButton setBackgroundImage: facebookButtonActiveImage forState: UIControlStateSelected];
        [facebookButton addTarget: self action: @selector(shareFacebook:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.shareButtonsView addSubview: facebookButton];
        
        
        
        UIImage *twitterButtonImage = [UIImage imageNamed: @"twitter-ipad.png"];
        UIImage *twitterButtonActiveImage = [UIImage imageNamed: @"twitter_pressed.png"];
        UIButton *twitterButton = [UIButton buttonWithType: UIButtonTypeCustom];
        
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            twitterButton.frame = CGRectMake(0, 0, 0.7*twitterButtonImage.size.width, 0.6*twitterButtonImage.size.height);
            twitterButton.center = CGPointMake(self.shareButtonsView.center.x, [GUIHelper getBottomYForView:facebookButton]+ twitterButtonImage.size.height - 65);
        }
        else{
            twitterButton.frame = CGRectMake(0, 0, 0.3*twitterButtonImage.size.width, 0.3*twitterButtonImage.size.height);
            twitterButton.center = CGPointMake(self.shareButtonsView.center.x, [GUIHelper getBottomYForView:twitterButton]+ 45);
        }
        
        
        [twitterButton setBackgroundImage: twitterButtonImage forState: UIControlStateNormal];
        [twitterButton setBackgroundImage: twitterButtonActiveImage forState: UIControlStateSelected];
        [twitterButton addTarget: self action: @selector(shareTwitter) forControlEvents: UIControlEventTouchUpInside];
        
        
        [self.shareButtonsView addSubview: twitterButton];
        
        UIImage *emailButtonImage = [UIImage imageNamed: @"email-ipad.png"];
        UIImage *emailButtonActiveImage = [UIImage imageNamed: @"mail_pressed.png"];
        UIButton *emailButton = [UIButton buttonWithType: UIButtonTypeCustom];
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            emailButton.frame = CGRectMake(0, 0, 0.7 *emailButtonImage.size.width, 0.6*emailButtonImage.size.height);
            emailButton.center = CGPointMake(self.shareButtonsView.center.x, [GUIHelper getBottomYForView:twitterButton]+ emailButtonImage.size.height - 68);
        }
        else{
            emailButton.frame = CGRectMake(0, 0, 0.3*emailButtonImage.size.width, 0.3*emailButtonImage.size.height);
            emailButton.center = CGPointMake(self.shareButtonsView.center.x, [GUIHelper getBottomYForView:twitterButton]+ 13);
        }
        [emailButton setBackgroundImage: emailButtonImage forState: UIControlStateNormal];
        [emailButton setBackgroundImage: emailButtonActiveImage forState: UIControlStateSelected];
        [emailButton addTarget: self action: @selector(shareEmail) forControlEvents: UIControlEventTouchUpInside];
        
        [self.shareButtonsView addSubview: emailButton];
        
              
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.shareButtonsView.center = CGPointMake(self.shareButton.center.x - 3, self.view.frame.size.height - 167);
        }else{
            self.shareButtonsView.center = CGPointMake(self.shareButton.center.x - 3, self.view.frame.size.height - 97);
        }
        [self.view addSubview: self.shareButtonsView];
        
        
        
        UIImage *shareButtonImage = [UIImage imageNamed: @"share_active.png"];
        [self.shareButton setBackgroundImage: shareButtonImage forState: UIControlStateNormal];
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            self.shareButton.frame = CGRectMake(0, 0, 1.5*shareButtonImage.size.width, 1.5* shareButtonImage.size.height);
            self.shareButton.center = CGPointMake([GUIHelper getRightXForView: self.moreButton] + self.shareButton.frame.size.width  , self.view.frame.size.height - 0.5*self.shareButton.frame.size.height);
        }
        else
        {
            self.shareButton.frame = CGRectMake(0, 0, shareButtonImage.size.width, shareButtonImage.size.height);
            self.shareButton.center = CGPointMake([GUIHelper getRightXForView: self.moreButton] + 0.5 * self.shareButton.frame.size.width  - 5, self.view.frame.size.height - 0.5 * self.shareButton.frame.size.height);
        }
        
        [self.view bringSubviewToFront:self.shareButton];
    }
    else {
        [self.shareButtonsView removeFromSuperview];
        UIImage *shareButtonImage = [UIImage imageNamed: @"share_normal.png"];
        //UIImage *shareButtonImageActive = [UIImage imageNamed: @"share_active.png"];
        [self.shareButton setBackgroundImage: shareButtonImage forState: UIControlStateNormal];
        //iPad
        if (UI_USER_INTERFACE_IDIOM()  == UIUserInterfaceIdiomPad){
            self.shareButton.frame = CGRectMake(0, 0, 1.5*shareButtonImage.size.width, 1.5* shareButtonImage.size.height);
            self.shareButton.center = CGPointMake([GUIHelper getRightXForView: self.moreButton] + self.shareButton.frame.size.width , self.view.frame.size.height - 0.5*(self.shareButton.frame.size.height) + 3);
        }
        else
        {
            self.shareButton.frame = CGRectMake(0, 0, shareButtonImage.size.width, shareButtonImage.size.height);
            self.shareButton.center = CGPointMake([GUIHelper getRightXForView: self.moreButton] + 0.5 * self.shareButton.frame.size.width  - 5, self.view.frame.size.height - 0.5 * (self.shareButton.frame.size.height + 3));
        }
        
        
    }
    self.isShareButtonPressed = !self.isShareButtonPressed;
}



- (void)goInfo
{
    debug(@"INFO pressed");
    
    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName: nil bundle: nil];
    infoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: infoViewController];
    navController.navigationBarHidden = YES;
    //Favourite
    infoViewController.favouritePath = self.favouritePath;
    
    [self.navigationController presentModalViewController: navController animated: YES];
}


- (void)goPurchase
{
    debug(@"Purchase pressed");
    
    PurchaseViewController *purchaseViewController = [[PurchaseViewController alloc] initWithNibName: nil bundle: nil];
    purchaseViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: purchaseViewController];
    navController.navigationBarHidden = YES;
    
    
    [self.navigationController presentModalViewController: navController animated: YES];
}


- (void) showMore
{
    [FlurryAnalytics logEvent: @"MoreAppsOnStartScreen"];
    
    [[PHPublisherContentRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret placement: @"more_games" delegate: (AppDelegate*)[UIApplication sharedApplication].delegate] send];
        
}


- (void)removeBanner: (id)sender
{
    debug(@"remove banner pressed");
    [[DataModel sharedInstance] removeBannerAd];
    
}

- (void) removeShareBtn
{
    if (self.isShareButtonPressed){
        [self.shareButtonsView removeFromSuperview];
    
        UIImage *shareButtonImage = [UIImage imageNamed: @"share_normal.png"];    
        [self.shareButton setBackgroundImage: shareButtonImage forState: UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom]  == UIUserInterfaceIdiomPad){
            self.shareButton.center = CGPointMake([GUIHelper getRightXForView: self.moreButton] + self.shareButton.frame.size.width  , self.view.frame.size.height - 0.5 * (self.shareButton.frame.size.height+3));
        }
        else
        {
            self.shareButton.center = CGPointMake([GUIHelper getRightXForView: self.moreButton] + 0.5 * self.shareButton.frame.size.width  - 5, self.view.frame.size.height - 0.5 * (self.shareButton.frame.size.height) + 5);
        }


        self.isShareButtonPressed = !self.isShareButtonPressed;
    }
}



#pragma mark - Sharing functionality 

- (void)shareEmail
{
    [FlurryAnalytics logEvent: @"AppEmailToFriend"];
    
    if ( [self canSendMail] ) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        //[controller setSubject: NSLocalizedString(@"Funny joke from Fast Laugh Jokes", @"Share joke by email - subject")];
        [controller setSubject: NSLocalizedString(@"Funny joke from Best Stupid Jokes and Puns Free", @"Share joke by email - subject")];
        
        //[controller setMessageBody: [NSString stringWithFormat:@"%@ \n\n %@  \n\n %@", NSLocalizedString(@"Thought you would get a kick out of this joke...", @"Share joke by email - body"), self.insultLabel.text, NSLocalizedString(@"You can get Fast Laugh Jokes for iPhone, iPod, and iPad here: http://glob.ly/2pU.", @"Share joke by email - body - part 2")]
          //                  isHTML: NO];
        [controller setMessageBody: [NSString stringWithFormat:@"%@ \n\n %@  \n\n %@", NSLocalizedString(@"Thought you would get a kick out of this joke...", @"Share joke by email - body"), self.insultLabel.text, NSLocalizedString(@"You can get Best Stupid Jokes and Puns Free for iPhone, iPod, and iPad here: http://glob.ly/2pU.", @"Share joke by email - body - part 2")]
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
    
    //[tcvc setInitialText: NSLocalizedString(@"Check out this hilarious jokes app for iPhone, Fast Laugh Jokes (from @brightnewt) http://glob.ly/2pU", @"Info screen - share app via twitter - tweet text") ];
    //[tcvc setInitialText: NSLocalizedString(@"Check out this hilarious jokes app for iPhone, Best Stupid Jokes and Puns Free (from @brightnewt) http://glob.ly/2pU", @"Info screen - share app via twitter - tweet text") ];
    [tcvc setInitialText: self.insultLabel.text];
    [tcvc addImage: [UIImage imageNamed: @"Icon.png"]];
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



#pragma mark - Views creation

- (void)createSegmentedControl
{
    self.segmentedControl = [[SegmentedSortBar alloc] initWithFrame: CGRectZero];
    
    //iPad
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        self.segmentedControl.center = CGPointMake(0.5 * self.view.frame.size.width, [GUIHelper getBottomYForView: self.insultLabel] + self.segmentedControl.frame.size.height + 120);
    }
    else{
        self.segmentedControl.center = CGPointMake(0.5 * self.view.frame.size.width, [GUIHelper getBottomYForView: self.insultLabel] + self.segmentedControl.frame.size.height + 10);
    }
    
    
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.delegate = self;
    
    [self.view addSubview: self.segmentedControl];
}


#pragma mark - SegmentedSortBarDelegate

- (void)didChangeSelectedIndex: (SegmentedSortBar*)sender
{
    self.currentCategory = [[DataModel sharedInstance] categoryWithName: [self.segmentedControl titleForSegmentAtIndex: self.segmentedControl.selectedSegmentIndex]];
    [self didShake];
        
}



- (void)updatePackView: (NSNotification *)notification

{
    if([[notification object] isKindOfClass:[PurchaseEntity class]]){
        PurchaseEntity *pack = [notification object];
        if (pack != nil)
            [self.segmentedControl updatePurchased: pack withCompletion: ^(BOOL finished) {
                debug(@"in block");
                [self didShake];
            }];
        if ([pack.iap_id isEqualToString: @"com.brightnewt.fastlaughjokes.remove_banner_ad"])
        {
            //[self removeMobclixAd];
            [self.removeBannerAdButton removeFromSuperview];
        }
    }
}



/*******************************************************************************
 MobclixAdViewDelegate Optional Targeting Parameters
 - (NSString*)mcKeywords { }
 - (NSString*)query { }
 
 ******************************************************************************/
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
//    Chartboost *cb = [Chartboost sharedChartboost];
//
//    [cb cacheMoreApps];

}

// Same as above, but only called when dismissed for a click
- (void)didClickMoreApps
{
    
}

// Called when a more apps page has failed to come back from the server
- (void)didFailToLoadMoreApps
{
   [UIApplication sharedApplication].statusBarHidden = NO;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error loading more apps", @"")
                                                    message: NSLocalizedString(@"Something wrong with loading more apps.", @"")
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                          otherButtonTitles: nil];
    [alert show];
    
    
}

// Called when the More Apps page has been received and cached
- (void)didCacheMoreApps
{

}


#pragma mark - RevMobAdsDelegate

- (void)revmobAdDidReceive
{
    NSLog(@"[RevMob Delegate] Ad loaded.");
    
    if ( nil == self.revMobBannerView.superview ) {
        [self.view addSubview: self.revMobBannerView];
    }
    
    self.isRevMobBannerLoaded = YES;
    self.isRevMobBannerShown = YES;
}

- (void)revmobAdDidFailWithError:(NSError *)error
{
    NSLog(@"[RevMob Delegate] Ad failed: %@", error);
    
    self.isRevMobBannerLoaded = NO;
    self.isRevMobBannerShown = NO;
}

- (void)revmobAdDisplayed
{
    NSLog(@"[RevMob Delegate] Ad displayed.");
}

- (void)revmobUserClosedTheAd
{
    NSLog(@"[RevMob Delegate] User clicked in the close button.");
}

- (void)revmobUserClickedInTheAd
{
    NSLog(@"[RevMob Delegate] User clicked in the Ad.");
}

- (void)addRevMobBanner
{
    if ( [DataModel sharedInstance].shouldShowBannerAds && nil == self.revMobBannerView.superview ) {
       [self.view addSubview: self.revMobBannerView];
        if ( self.isRevMobBannerLoaded ) {
            self.isRevMobBannerShown = YES;
            //[self.view addSubview: self.removeBannerAdButton];
        }
        [self.view addSubview: self.removeBannerAdButton];
        [self.view bringSubviewToFront: self.removeBannerAdButton];
    }
    
}


- (void)removeRevMobBanner
{
    debug(@"removing RevMob banner");
    if ( nil != self.revMobBannerView ) {
        [self.revMobBannerView removeFromSuperview];
        self.isRevMobBannerShown = NO;
        [self.removeBannerAdButton removeFromSuperview];
        
    }
}

#pragma mark - RevMob support methods

- (void)subscribeToRevMobBannerKVO
{
    if ( !self.isSubscrubiedToRevMobKVO ) {
        [self addObserver: self
               forKeyPath: @"isRevMobBannerShown"
                  options: (NSKeyValueObservingOptionNew |
                            NSKeyValueObservingOptionOld)
                  context: NULL];
        self.isSubscrubiedToRevMobKVO = YES;
    }
}

- (void)unsubscribeFromRevMobBannerKVO
{
    if ( self.isSubscrubiedToRevMobKVO ) {
        [self removeObserver: self
                  forKeyPath: @"isRevMobBannerShown"];
        self.isSubscrubiedToRevMobKVO = NO;
    }
}
- (void)supportBannerStatuChange: (BOOL)bannerShown withBannerView: (UIView*)view
{
    if ( bannerShown ) {
                if ( nil == self.removeBannerAdButton.superview ) {
            
            if ( nil != view ) {
                self.removeBannerAdButton.center =
                CGPointMake(self.view.frame.size.width - self.removeBannerAdButton.frame.size.width,
                            view.frame.size.height * 0.5);
            }
            else {
                self.removeBannerAdButton.center =
                CGPointMake(self.view.frame.size.width - self.removeBannerAdButton.frame.size.width, 25);
            }
            
            
            [self.view addSubview: self.removeBannerAdButton];
         }
    }
    else {
                [self.removeBannerAdButton removeFromSuperview];

    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"isRevMobBannerShown"]) {
        
        [self supportBannerStatuChange: self.isRevMobBannerShown withBannerView: self.revMobBannerView];
    }
}


- (void)removeAdBanner
{
    
    [self removeRevMobBanner];
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
        [FacebookManager sharedInstance].shareTextFB = self.insultLabel.text;
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

- (void)showFavorite
{
    debug(@"Add to Favourite pressed");
    
        [self udateFavoritePopup];
}

-(void)udateFavoritePopup
{
    if (!self.isFavoriteButtonPressed){
        NSString *data;
        data = self.insultLabel.text;
       
        if (self.dataArray == NULL)
            self.dataArray = [[NSMutableArray alloc] init];
        [self.dataArray insertObject:data atIndex:0];
        
        [self.dataArray writeToFile:self.favouritePath atomically:YES];
        
        UIImage *shareButtonActiveImage = [UIImage imageNamed: @"Favorites-popupJ-ipad@2x~ipad.png"];
        self.addedFavortiteView = [[UIImageView alloc] initWithImage: shareButtonActiveImage];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.addedFavortiteView.frame = CGRectMake((self.view.frame.size.width/2) - (shareButtonActiveImage.size.width/6), 75, shareButtonActiveImage.size.width/3, shareButtonActiveImage.size.height/3);
        }else{
            if([GUIHelper isPhone5]){

                self.addedFavortiteView.frame = CGRectMake((self.view.frame.size.width/2) - (shareButtonActiveImage.size.width/10), 72, shareButtonActiveImage.size.width/5, shareButtonActiveImage.size.height/5);

            }else{
                self.addedFavortiteView.frame = CGRectMake((self.view.frame.size.width/2) - (shareButtonActiveImage.size.width/12), 54, shareButtonActiveImage.size.width/6, shareButtonActiveImage.size.height/6);

            }
        }
               
        [self.view addSubview: self.addedFavortiteView];
        self.addedFavortiteView.hidden = NO;
        self.addedFavortiteView.alpha = 1.0f;
        // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
        [UIView animateWithDuration:0.5 delay:2.0 options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)    animations:^{
            // Animate the alpha value of your imageView from 1.0 to 0.0 here
            self.addedFavortiteView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
            self.addedFavortiteView.hidden = YES;
        }];

        self.isFavoriteButtonPressed = YES;
    }
       
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if ([self.addedFavortiteView.layer.presentationLayer hitTest:touchLocation])
    {
        debug(@"Added to Favourite tapped");
        // The button was hit whilst moving
        [self goFavorite:self];
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

- (void)goFavorite: (id)sender{
    
    FavoriteViewController *favoriteViewController = [[FavoriteViewController alloc] initWithNibName: nil bundle: nil];
    favoriteViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: favoriteViewController];
    navController.navigationBarHidden = YES;
    favoriteViewController.favouritePath = self.favouritePath;
    
    [self.navigationController presentModalViewController: navController animated: YES];
}



@end
