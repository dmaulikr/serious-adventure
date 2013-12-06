//
//  SurfSlotMachineAppDelegate.m
//  SurfSlotMachine
//
//  Created by Tanut Apiwong on 10/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SurfSlotMachineAppDelegate.h"
#import "cocos2d.h"
#import "LetsSlotMainGameNode.h"
#include <sys/sysctl.h>
#import "GameVariables.h"
#import "MyStoreObserver.h"
#import "RootViewController.h"

//Change here for revmob AND chartboost id
#define REVMOB_ID               @"514a6639e64671120000004f"
#define CHARTBOOST_APPID        @"514a668816ba478f4800001b"
#define CHARTBOOST_APPSIGNATURE @"2c5a1f4c0a712a7e317a0229b1f04a8717c7a844"

@implementation SurfSlotMachineAppDelegate

@synthesize window, viewController;
@synthesize cb;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
    CC_ENABLE_DEFAULT_GL_STATES();
    CCDirector *director = [CCDirector sharedDirector];
    CGSize size = [director winSize];
    CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
    sprite.position = ccp(size.width/2, size.height/2);
    sprite.rotation = -90;
    [sprite visit];
    [[director openGLView] swapBuffers];
    CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController
}

-(void)initiAdBanner
{
    if (!iAdBannerView)
    {
        // Get the size of the banner in portrait mode
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        // Create a new bottom banner, will be slided into view
        iAdBannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(0.0,
                                                                      self.window.frame.size.height,
                                                                      bannerSize.width,
                                                                      bannerSize.height)];
        iAdBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        iAdBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        
        iAdBannerView.delegate = self;
        iAdBannerView.hidden = TRUE;
        [self.viewController.view addSubview:iAdBannerView];
    }
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
    [RevMobAds startSessionWithAppID:REVMOB_ID];

	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
    
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;

	// Check is we will be in HD
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *name = malloc(size);
	sysctlbyname("hw.machine", name, &size, NULL, 0);
	NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
	free(name);
	
	if ([machine isEqualToString:@"i386"] || [machine isEqualToString:@"iPhone3,1"]) {
		//[[CCDirector sharedDirector] setContentScaleFactor:2.0];
	}
	
	NSLog(@"We are running on %@", machine);
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	
	// Turn on display FPS
	[director setDisplayFPS:NO];
	
	// Turn on multiple touches
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#endif

    [viewController setView:view];

    [self.window setRootViewController: viewController];

	//Register In-App Purchase transaction observer.
	MyStoreObserver *observer = [[MyStoreObserver alloc] init];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
	
	
	//Load money and sound setting
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults objectForKey:KEY_BET] == nil) {
		mBet = 0;
		mCredit = STARTUP_CREDIT;
		mPaid = 0;
		bSoundOn = YES;
	} else {
		mBet = [userDefaults integerForKey:KEY_BET];
		mCredit = [userDefaults integerForKey:KEY_CREDIT];
		mPaid = [userDefaults integerForKey:KEY_PAID];
		bSoundOn = [userDefaults boolForKey:KEY_SOUND];
	}
	//Payout Locking...
	if ([userDefaults objectForKey:KEY_PAYOUTLOCKED] == nil) {
		bPayoutLocked = YES;
	} else {
		bPayoutLocked = [userDefaults boolForKey:KEY_PAYOUTLOCKED];
	}
	
	NSLog(@"Loading... Bet %d, Credit %d, Paid %d, Sound %d", mBet, mCredit, mPaid, bSoundOn);
	NSLog(@"Payout Locking is %d", bPayoutLocked);
	
    iAdBannerView = nil;
    [self initiAdBanner];

	[[CCDirector sharedDirector] runWithScene: [LetsSlotMainGameNode scene]];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
    
    cb = [Chartboost sharedChartboost];
    
    //change here
    cb.appId = CHARTBOOST_APPID;
    cb.appSignature = CHARTBOOST_APPSIGNATURE;
    
    [cb startSession];
    [cb cacheInterstitial];
    [cb cacheMoreApps];
    [cb showInterstitial];
    [[RevMobAds session] showFullscreen];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) saveGameVariable {
	//Save money and sound setting
	NSLog(@"Save game....");
	
	mCredit += mBet;
	mBet = 0;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setInteger:mBet forKey:KEY_BET];
	[userDefaults setInteger:mCredit forKey:KEY_CREDIT];
	[userDefaults setInteger:mPaid forKey:KEY_PAID];
	[userDefaults setBool:bSoundOn forKey:KEY_SOUND];
	[userDefaults synchronize];
	
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	
	[self saveGameVariable];
	
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [viewController release];
	
	[window release];

	[self saveGameVariable];
	
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}
#pragma mark - iAd Banner

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAdBanner loaded");
    
    [self showBanner:iAdBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAdBanner failed");
    NSLog(@"iAdBanner Failed to receive ad with error: %@", [error localizedFailureReason]);
    
    // Only request adMob when iAd did fail
    [self hideBanner:iAdBannerView];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view action begins");
    
    return YES;
    
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"Banner view action did finish");
    
}

-(void) hideADS:(BOOL) flag
{
    if (iAdBannerView == nil)
        return;
    
    if (flag == YES) {
        CGRect curRect = iAdBannerView.frame;
        iAdBannerView.frame = CGRectMake(self.window.frame.size.width, curRect.origin.y, curRect.size.width, curRect.size.height);
    }
    else {
        CGRect curRect = iAdBannerView.frame;
        iAdBannerView.frame = CGRectMake(0, curRect.origin.y, curRect.size.width, curRect.size.height);
    }
}

-(void)hideBanner:(UIView*)banner
{
    if (banner &&
        ![banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOff" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = TRUE;
    }
}
-(void)showBanner:(UIView*)banner
{
    if (banner &&
        [banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOn" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = FALSE;
    }
}

#pragma mark REVMOB delegate
- (void) dispAds {
    [cb cacheInterstitial];
    RevMobFullscreen *fullscreen = [[RevMobAds session] fullscreenWithPlacementId:@"your placementId"];
    [fullscreen showAd];
}

- (void)revmobAdDidFailWithError:(NSError *)error {

}

- (void)revmobUserClosedTheAd {

}

- (void)installDidFail {

}

#pragma mark chartboost delegate
- (void) dispMoreApps {
    [cb showMoreApps];
}
- (void)didFailToLoadInterstitial:(NSString *)location {
    
//    [[RevMobAds session] showFullscreen];

}

// Called when the user dismisses the interstitial
// If you are displaying the add yourself, dismiss it now.
- (void)didDismissInterstitial:(NSString *)location {
    
//    [[RevMobAds session] showFullscreen];
    
}

// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(NSString *)location {
    
//    [[RevMobAds session] showFullscreen];
    
}

@end