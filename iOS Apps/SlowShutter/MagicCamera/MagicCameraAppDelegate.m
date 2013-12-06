//
//  AppDelegate.m
//  MagicCamera
//
//  Created by i Pro on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MagicCameraAppDelegate.h"
#import "MagicCameraViewController.h"
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
#import "MKStoreManager.h"
#import "MenuViewController.h"
#import "Appirater.h"
#import "Flurry.h"


@implementation MagicCameraAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize cb;


+ (MagicCameraAppDelegate *)sharedDelegate
{
    return (MagicCameraAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];


#ifdef PAID_VERSION
    [MKStoreManager makePaidVersion];
#endif
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[MenuViewController alloc] initWithNibName:@"MenuViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[MenuViewController alloc] initWithNibName:@"MenuViewController_iPad" bundle:nil] autorelease];
    }
	navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
	navigationController.navigationBarHidden = YES;
	// Override point for customization after app launch. 
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
    
    [RevMobAds startSessionWithAppID:REVMOB_ID];
    [Appirater appLaunched:YES];
    
    [Flurry startSession:FLURRY_ID];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
//    [self.viewController appWillResignActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [Appirater appEnteredForeground:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
   // [PFPush storeDeviceToken:deviceToken];
  //  [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
 //   [PFPush handlePush:userInfo];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    cb = [Chartboost sharedChartboost];
    
    cb.appId = CB_APPID;
    cb.appSignature = CB_APPSIG;

    [cb startSession];
    
       
    if (![MKStoreManager featureAPurchased])
    {
        [cb showInterstitial];
        [[RevMobAds session] showFullscreen];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - sound method
- (void)playSE:(int)type {
    NSString* str;
    if (type == SE_SHUTTERSTART) {
        str = @"shutterstart";
    }
    else
        str = @"shutterend";
	[self stopSE];
	NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"mp3"];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSError *error = nil;
	m_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: (NSError**)&error];
	if (error != nil)
	{
		m_audioPlayer = nil;
		return;
	}
    //	m_audioPlayer.delegate = self;
	[m_audioPlayer play];
}

- (BOOL)isPlayingSE {
	return (m_audioPlayer != nil) ? TRUE : FALSE;
}
- (void)stopSE
{
	if (m_audioPlayer != nil) {
		[m_audioPlayer stop];
		[m_audioPlayer release];
		m_audioPlayer = nil;
	}	
}

#pragma mark audio
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)thePlayer successfully:(BOOL)flag {
	if (thePlayer == m_audioPlayer) {
		[self stopSE];
	}
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)thePlayer{
}

#pragma mark RevMobAdsDelegate methods

- (void)revmobAdDidReceive {
    NSLog(@"[RevMob Sample App] Ad loaded.");
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Ad failed: %@", error);
}

- (void)revmobAdDisplayed {
    NSLog(@"[RevMob Sample App] Ad displayed.");
}

- (void)revmobUserClosedTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the close button.");
}

- (void)revmobUserClickedInTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the Ad.");
}

- (void)installDidReceive {
    NSLog(@"[RevMob Sample App] Install did receive.");
}

- (void)installDidFail {
    NSLog(@"[RevMob Sample App] Install did fail.");
}

#pragma mark REBMOV

-(void)dispMoreGames
{
    [cb showMoreApps];
//    [RevMobAds openAdLink];
}


@end
