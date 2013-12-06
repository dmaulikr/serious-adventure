//
//  AppDelegate.mm
//  Mighty Possum World
//
//  Created by Luiz Menezes on 18/10/12.
//  Copyright Thetis Games 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "LogoLayer.h"
#import "MainMenu.h"
#import "GameScene.h"
#import "MKStoreManager.h"

#ifdef  FREE_ELE_VERSION
#define REVMOB_ID  @"52893a764f4ca611ef000024"
#elif   PAID_ELE_VERSION
#define REVMOB_ID  @"52893a764f4ca611ef000024"
#elif   FREEHD_ELE_VERSION
#define REVMOB_ID  @"52893a764f4ca611ef000024"
#elif   PAIDHD_ELE_VERSION
#define REVMOB_ID  @"52893a764f4ca611ef000024"
#else
#define REVMOB_ID  @"52893a764f4ca611ef000024"
#endif

#ifdef FREE_ELE_VERSION
#define kLeaderboardID @"au.com.incredibleadventure.mightypossum.free.leaderboard"
#elif PAID_ELE_VERSION
#define kLeaderboardID @"au.com.incredibleadventure.mightypossum.paid.leaderboard"
#elif FREEHD_ELE_VERSION
#define kLeaderboardID @"au.com.incredibleadventure.mightypossum.freehd.leaderboard"
#elif PAIDHD_ELE_VERSION
#define kLeaderboardID @"au.com.incredibleadventure.mightypossum.paidhd.leaderboard"
#endif

@implementation MyNavigationController



// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskLandscape;
	
	// iPad only
	return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[ director runWithScene: [ LogoLayer scene ] ];
//		[director runWithScene: [GameScene scene]];
	}
}
@end


@implementation AppController

@synthesize cb;
@synthesize ad;
@synthesize window=window_, navController=navController_, director=director_;
@synthesize gameCenterManager;
@synthesize currentLeaderBoard;
@synthesize m_nPrevPageofCoin;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MKStoreManager sharedManager];
    
#ifdef PAID_ELE_VERSION
    [MKStoreManager makePaidVersion];
#endif

#ifdef PAIDHD_ELE_VERSION
    [MKStoreManager makePaidVersion];
#endif
    
    [RevMobAds startSessionWithAppID:REVMOB_ID];

	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	// Enable multiple touches
	[glView setMultipleTouchEnabled:YES];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices

//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
//        if( ! [director_ enableRetinaDisplay:YES ] )
//            CCLOG(@"Retina Display Not supported");
//    }
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
//	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
#pragma GameCenter
    self.currentLeaderBoard = kLeaderboardID;
    
    if ([GameCenterManager isGameCenterAvailable]) {
        isGameCenterAvailable = YES;
        self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
        [self.gameCenterManager setDelegate:self];
        [self.gameCenterManager authenticateLocalUser];
        
    } else {
        isGameCenterAvailable = NO;
        // The current device does not support Game Center.
        
    }

	return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
    
    self.cb = [Chartboost sharedChartboost];
    
#ifdef FREE_ELE_VERSION
    self.cb.appId = @"5267294516ba47bf16000003";
    self.cb.appSignature = @"33bdd1bb70e37da66baa5d3e2c7ea0d4dd2b3761";
#elif PAID_ELE_VERSION
    self.cb.appId = @"526729ad17ba47ed79000006";
    self.cb.appSignature = @"c493e144fbe0850dcaeaef340aa26fc7c7a3b01f";
#elif FREEHD_ELE_VERSION
    self.cb.appId = @"52672a3516ba47ff19000000";
    self.cb.appSignature = @"3bde84d4fd2abb97faa64d73858623025aa9e9e8";
#elif PAIDHD_ELE_VERSION
    self.cb.appId = @"52672a9c16ba47c216000013";
    self.cb.appSignature = @"a00a41e361805a792df91ac0b1329f34ca61086a";
#endif
    [self.cb startSession];
    
    [self.cb cacheInterstitial];
    [self.cb cacheMoreApps];

}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
    [gameCenterManager release];
    [currentLeaderBoard release];

	[window_ release];
	[navController_ release];
	
	[super dealloc];
}

#pragma mark REBMOV

-(void)dispMoreGames
{
    [cb showMoreApps];
}

-(void)dispFreeGames
{
    ad = [[RevMobAds session] adLink]; // you must retain this object
    ad.delegate = self;
    [ad loadAd];
    [ad openLink];
}
-(void)dispAdvertise
{
    
    if ( ! [ MKStoreManager featurePaidVersionPurchase ] )
    {

      //  [cb showInterstitial];
        [[RevMobAds session] showFullscreen];
        [self dispAppLovinPopup];
    }
    
}

+( AppController* )get{
    return ( AppController *)[ [ UIApplication sharedApplication ] delegate ];
}

#pragma GameCenter

#pragma mark setLastError

-(void) setLastError:(NSError*)error
{
	[lastError release];
	lastError = [error copy];
	
	if (lastError)
	{
		NSLog(@"GCHelper ERROR: %@", [[lastError userInfo] description]);
	}
}

#pragma mark Player Authentication

-(void) authenticate
{
	if (isGameCenterAvailable == NO)
		return;
	
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	if (localPlayer.authenticated == NO)
	{
		[localPlayer authenticateWithCompletionHandler:^(NSError* error)
		 {
			 [self setLastError:error];
			 
			 if (error == nil)
			 {
			 }
		 }];
	}
}

- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [navController_ presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [navController_ dismissModalViewControllerAnimated: YES];
    [viewController release];
}

- (void) submitScore : (int) curScore
{
    if(curScore > 0)
    {
        [self.gameCenterManager reportScore: curScore forCategory: self.currentLeaderBoard];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
    [navController_ dismissModalViewControllerAnimated: YES];
    [viewController release];
}


-(void)dispAppLovinPopup
{
    [ALInterstitialAd showOver:self.window];
}

@end

