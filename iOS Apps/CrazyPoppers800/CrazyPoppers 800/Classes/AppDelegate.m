//
//  AppDelegate.m
//  CrazyPlay
//
//  Created by Alan on 3/23/10.
//  Copyright Trippin' Software 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "cocos2d.h"
#import "CrazyPoppers.h"
#import "CrazyPoppersLevels.h"
#import "RootViewController.h"
#import "Appirater.h"
#import "Reachability.h"
#import "HTMLParser.h"
#import "Flurry.h"
#import "GameKit/GameKit.h"
#import "Chartboost.h"
#import "StoreKit/StoreKit.h"
#import <RevMobAds/RevMobAds.h>
#import "TapjoyConnect.h"
#import "ALSdk.h"
#import "ALInterstitialAd.h"


@implementation AppDelegate

@synthesize window;

//- (void) applicationDidFinishLaunching:(UIApplication*)application {
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Init RevMob
    [RevMobAds startSessionWithAppID:@"523fea96bedae988af00001c"];
    
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
    
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        if( ! [director enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
    }
    else { // iPad - do not support retina at this time
        if( ! [director enableRetinaDisplay:NO] )
            CCLOG(@"Retina Display Not supported");
    }
	
	// Tapjoy Integration
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [TapjoyConnect requestTapjoyConnect:@" " secretKey:@" "];	
    }
    else {
        [TapjoyConnect requestTapjoyConnect:@" " secretKey:@" "];	
    }
    
    /**VIEW SPECIFIC CALLS**/
    [TapjoyConnect setTransitionEffect:TJCTransitionBottomToTop];
    
    // Don't display if the user has paid to remove the ads
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if (removeAds != YES) {
    }
    
    // Retrieve Tap Points
 	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(getUpdatedPoints:) 
												 name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(getUpdatedPoints:) 
												 name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(getUpdatedPointsError:) 
												 name:TJC_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(getUpdatedPointsError:) 
												 name:TJC_SPEND_TAP_POINTS_RESPONSE_NOTIFICATION_ERROR 
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(awardedPoints:) 
                                                 name:TJC_AWARD_TAP_POINTS_RESPONSE_NOTIFICATION 
                                               object:nil];
	[TapjoyConnect getTapPoints];

    
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
 	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif

	// Flurry Analytics
	[Flurry startSession:@" "];
	[Flurry logEvent:@"Crazy Poppers Started"];
    
	// cocos2d will inherit these values
    //	[window setUserInteractionEnabled:YES];	
    //	[window setMultipleTouchEnabled:YES];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
    //t	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
	//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	//	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
	
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];  // This is 60
	[[CCDirector sharedDirector] setDisplayFPS:NO];
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
    //	[window addSubview: viewController.view];  // Removed to fix iOS 6 orientation bug
	    
    /////// Added to fix iOS 6 & Cocos2d Orientation Bug
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        [window setRootViewController:viewController];
    } else
    {
        [window addSubview: viewController.view];
    }
    ///////

	// create an openGL view inside a window
	[window makeKeyAndVisible];     
        
    // Set the orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if ((orientation == UIDeviceOrientationFaceUp) || (orientation == UIDeviceOrientationFaceDown) ||
        (orientation == UIDeviceOrientationPortrait) || (orientation == UIDeviceOrientationUnknown)) {
        orientation = UIDeviceOrientationLandscapeLeft;
    }
    
    // *** Ad Colony ***
    [AdColony initAdColonyWithDelegate:self];

    // *** Game Center ***
    [self authenticateLocalPlayer];
    
    // *** Configure Chartboost ***
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.appId = @"5252235917ba477d49000005";
    cb.appSignature = @"b77a1adb636b84bc04e2f890e477a457f479b258";
    
    // Notify the beginning of a user session
    [cb startSession];
    
    // Cache an Interstitial
    [cb cacheInterstitial:@"App launch"];
    [cb cacheInterstitial:@"Game Paused"];
    [cb cacheInterstitial:@"Level Summary Every 5"];
    [cb cacheInterstitial:@"Level Summary Every 5th"];
    [cb cacheInterstitial:@"Level Summary Every 8th"];
    
    // Cache more apps
    [cb cacheMoreApps];
    
    // AppLovin
    [ALSdk initializeSdk];
    
	// initialize defaults
	NSString *dateKey = @"dateKey";
	NSDate *lastRead = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
	if (lastRead == nil)     // App first run: set up user defaults.
	{
		NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
		
		// do any other initialization you want to do here - e.g. the starting default values.    
		[[NSUserDefaults standardUserDefaults] setInteger:280 forKey:@"version"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_music"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"goober_gold"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"gold"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"high_score"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highest_level"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"current_level"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"level_started_from_menu"];
        [[NSUserDefaults standardUserDefaults] setFloat:1.0 forKey:@"multiplier"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"launched_from"];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"level_flipped"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"theme"];
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"gaming_network"];

		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level1_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level2_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level3_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level4_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level5_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level6_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level7_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level8_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level9_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level10_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level11_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level12_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level13_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level14_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level15_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level16_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level17_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level18_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level19_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level20_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level21_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level22_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level23_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level24_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level25_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level26_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level27_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level28_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level29_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level30_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level31_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level32_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level33_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level34_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level35_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level36_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level37_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level38_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level39_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level40_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level41_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level42_highScore"];

        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level43_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level44_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level45_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level46_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level47_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level48_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level49_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level50_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level51_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level52_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level53_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level54_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level55_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level56_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level57_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level58_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level59_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level60_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level61_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level62_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level63_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level64_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level65_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level66_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level67_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level68_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level69_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level70_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level71_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level72_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level73_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level74_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level75_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level76_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level77_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level78_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level79_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level80_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level81_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level82_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level83_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level84_highScore"];

        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level85_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level86_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level87_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level88_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level89_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level90_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level91_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level92_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level93_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level94_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level95_highScore"];
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level96_highScore"];
        
        // Crazy Poppers defaults
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"remove_ads"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popometer_pack_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mega_pack_1_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mega_bundle_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popper_pack_2_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popper_pack_3_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popper_pack_4_unlocked"];
      
        // Set the free hints offer to yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"offer_free_hints"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"offer_4free_hints"];
        // Set the free hints offer to yes
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"offer_free_fblike_hints"];
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"popper_hints"];
        
        // Add Gems - 2.0
		[[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"gems"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGoldDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGemsDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needAHintDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"undoPowerUp"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tap+1PowerUp"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"x2PowerUp"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"noAdsPowerUp"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"crazy_poppers_menu_selection"];
        
        
		// sync the defaults to disk
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];

    // Add Appirater for popping up the rate dialog box
    [Appirater appLaunched:YES];

    // Update for new install
    [self newInstallUpdate];

    int highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper1_highest_level"];
    if (highestLevel <= 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"popper_current_level"];
        CrazyPoppersLevelScene * cpls = [CrazyPoppersLevelScene node];
        [[CCDirector sharedDirector] runWithScene:cpls];
    }
    else {

        // Display RevMob
        BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
        if (removeAds != YES) {
            RevMobFullscreen *fullscreen = [[RevMobAds session] fullscreenWithPlacementId:@"5253aa6563fd764c89000062"];
            [fullscreen showAd];
        }
        
        CrazyPoppersMenuScene *cpls = [CrazyPoppersMenuScene node];
        [[CCDirector sharedDirector] runWithScene:cpls];
    }

    return YES;
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void) retrieveInAppData {
    
    // Start the IAP Store
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        productIdentifiers =[NSSet setWithObjects:
                             @"au.com.incredibleadventure.PoppingBlowfish.handfulofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.stackofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.bagofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.bucketofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.22gems",
                             @"au.com.incredibleadventure.PoppingBlowfish.48gems",
                             @"au.com.incredibleadventure.PoppingBlowfish.125gems1",
                             @"au.com.incredibleadventure.PoppingBlowfish.270gems",nil];
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            NSLog(@"No internet connection!");
        } else {
            SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
            request.delegate = self;
            [request start];
        }
	}
	else {
        productIdentifiers =[NSSet setWithObjects:
                             @"au.com.incredibleadventure.PoppingBlowfish.handfulofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.stackofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.bagofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.bucketofgold",
                             @"au.com.incredibleadventure.PoppingBlowfish.22gems",
                             @"au.com.incredibleadventure.PoppingBlowfish.48gems",
                             @"au.com.incredibleadventure.PoppingBlowfish.125gems1",
                             @"au.com.incredibleadventure.PoppingBlowfish.270gems",nil];
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            NSLog(@"No internet connection!");
        } else {
            SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
            request.delegate = self;
            [request start];
        }
	}
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse: (SKProductsResponse *)response {
	
	SKProduct *product;
    invalidProductIdentifiers = response.invalidProductIdentifiers;
    if (invalidProductIdentifiers.count != 0) return;
    
    for (product in response.products) {
        
        //	product = [response.products objectAtIndex:0];
        currentIdentifier = [NSString stringWithFormat:@"%@", product.productIdentifier];
        NSLog(@"Purchase request for: %@", product.productIdentifier);
        
        // format the price for the location
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        
        // See if the was a purchase request or a product info request
        productPrice = formattedPrice;
        NSLog(@"%@",formattedPrice);
        NSString *formattedPriceStr = [formattedPrice substringWithRange: NSMakeRange (1, 1)];

        // Store the price
        [[NSUserDefaults standardUserDefaults] setObject:formattedPrice forKey:product.productIdentifier];
    }
    
    // Compare the Bag of Gold to the Stack of Gold.  If the prices are the same, the a sale is active.
    NSString *bagPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];
    NSString *stackPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];

    if ([bagPrice isEqualToString:stackPrice]) {
        // Set flag
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sale_today"];
        
        // Send an alert
        [self sendSaleAlert];
    }
    else {
        // Reset the flag
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sale_today"];        
    }
}

-(void) displayChartBoost {
    
    Chartboost *cb = [Chartboost sharedChartboost];
    
    // Don't display if the user has paid to remove the ads
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if (removeAds != YES) {
        
        // Show an interstitial
        [cb showInterstitial:@"App launch"];
    }
}

-(void) displayAppLovin {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"applovin_active"];
    
    // First, check to see if there is an internet connection
	Reachability *reach = [Reachability reachabilityForInternetConnection];
	NetworkStatus netStatus = [reach currentReachabilityStatus];
	if (netStatus == NotReachable) {
		NSLog(@"No internet connection!");
	}
	else {
        
        // Set swtch to "on" (AppLovin always displays) or "startUpOnly" (AppLovin startup/Chartboost elsewhere), otherwise only Chartboost will display
        NSString *swtch = @"startUpOnly";
        if ([swtch isEqualToString:@"on"]) {
            [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
            
            // Set active flag
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"applovin_active"];
        }
        else if ([swtch isEqualToString:@"startUpOnly"]) {
            [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
            
            // Set active flag
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"applovin_active"];
        }
        else {
            
            // Display Chartboost if AppLovin isn't active
            [self displayChartBoost];
            
            // Set active flag
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"applovin_active"];
            return;
        }
    }
}

-(void) sendSaleAlert {
    
    // Send a message
    msg = nil;
    msg = [[UIAlertView alloc] initWithTitle: @"Huge Sale TODAY!" message: @"Check out the HUGE SALE Today! Save over 50% on Gold & Gems! Click buttons above for details!" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [msg show];
    [msg release];
}

-(void) freeHintCheck {
    
    NSDate *eligibleDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"free_hint_eligible_date"];
    NSLog(@"Eligible:%@",eligibleDate);
    NSDate *renewalDate = [NSDate date];  // Set it to current date
    renewalDate = [renewalDate dateByAddingTimeInterval:60*60*24];
    //////// for testing make it 1 hour
    // renewalDate = [renewalDate dateByAddingTimeInterval:60*1*1];
    ///////
    NSLog(@"Renewal:%@",renewalDate);
    
    // First, check to see if the hint date is empty.  If it is, then put in the current date + 24 hours
    if (eligibleDate == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:renewalDate forKey:@"free_hint_eligible_date"];
    }
    else {
        // If the date is not empty, see if it has been at least 24 hours.  If it has, then award the user 1 free hint, send them
        // a message, and update the hint date to the next eligible date.
        
        if ([eligibleDate timeIntervalSinceNow] < 0.0) {  // Date has passed
            
            // Give them 1 free hint
            int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
            hintCnt = hintCnt + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
            
            // Save next eligible date
            [[NSUserDefaults standardUserDefaults] setObject:renewalDate forKey:@"free_hint_eligible_date"];
            
            // Send a message
            msg = nil;
            msg = [[UIAlertView alloc] initWithTitle: @"1 FREE Hint Awarded!" message: @"Congratulations! You've have received 1 FREE hint. You will be eligible for your next free hint in 24 hours!  Keep poppin!" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [msg show];
            [msg release];
            
            //Refresh the header
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"update_goldGemsHints"];
        }
    }
    // Send the free hint notification
    [self scheduleNotification:1 days:1];
}

-(void) clearNotifications {
    
    // First, set the badge number to 0, so that it resets all notifications
    // Note:  To ensure the messages clear, there must be a change with the badge numbers
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++) {
        NSLog(@"Total Notifications:%d",[eventArray count]);
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        
        //Cancelling local notification
        [app cancelLocalNotification:oneEvent];
    }
}

-(void) updateNotifications {
    
    // Note: We will reset and rebuild ALL notifications each time the application is launched
    
    // Set 2 days message
    [self scheduleNotification:2 days:2];
    
    // Set 1 week message
    [self scheduleNotification:3 days:7];
    
    // Set 30 days message
    [self scheduleNotification:4 days:30];
}

-(void) scheduleNotification:(int)message days:(int)days {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    // Calculate the fire date
    NSDate *fireDate = [NSDate date];  // Set it to current date
    fireDate = [fireDate dateByAddingTimeInterval:60*60*24*days];
    ///// For testing, I will set it for hours, instead of days
    // fireDate = [fireDate dateByAddingTimeInterval:60*1*days];
    //    NSLog (@"Fire Date: %@",fireDate);
    //////
    
    // Override fire date for FREE hint based on Free Hint Eligible date
    if (message == 1) {
        fireDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"free_hint_eligible_date"];
    }
    
    localNotif.fireDate = fireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
	// Notification alert body
    switch (message) {
        case 1:
            localNotif.alertBody = @"You have just earned another FREE daily Hint! Come have some fun popping Poppers!"; break;
        case 2:
            localNotif.alertBody = @"Time sure does fly by! The Crazy Poppers are ready to take on more levels. Come join them!"; break;
        case 3:
            localNotif.alertBody = @"The Crazy Poppers are missing you! They left a message and said, 'Please come back. We promise to pop like crazy!!"; break;
        case 4:
            localNotif.alertBody = @"Want to have some Crazy Fun?! The Poppers are ready to pop some levels with you!"; break;
        default:
            break;
    }
	// Set the action button
    localNotif.alertAction = @"View";
    localNotif.applicationIconBadgeNumber = 1;
    
    [localNotif setHasAction:YES];
	
	// Specify custom data for the notification
    NSDictionary *infoDict;
    if (message ==1) {
        infoDict = [NSDictionary dictionaryWithObject:@"YES" forKey:@"free_hint"];
    }
    else {
        infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    }
    localNotif.userInfo = infoDict;
    
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}

// AdColony
-(NSString*)adColonyApplicationID {
    NSLog(@"AdColonyAppID");
    return @"appb488b842b1c0405b91b13f";
}

-(NSDictionary*)adColonyAdZoneNumberAssociation {
    NSLog(@"AdColony ZoneNumber");
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"vzd178141ac9ba4b82acb46b", [NSNumber numberWithInt:1], //Menu Screen
            @"vze2d7072456ab4bcf82798a", [NSNumber numberWithInt:2], //Buy Gold Screen
            nil];
}

-(void) adColonyVirtualCurrencyAwardedByZone:(NSString *)zone currencyName:(NSString *)name
                              currencyAmount:(int)amount {
    //Increase the user’s virtual currency balance here by the amount passed in
    //NOTE: This callback can be executed by AdColony at any time
    //NOTE: This is the ideal place for an alert about the successful reward
    
    [Flurry logEvent:@"AdColony gold added"];
    int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
    gold = gold + amount;
    [[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"gold"];
    
    int localGoldPlusTapjoyGold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
    localGoldPlusTapjoyGold = localGoldPlusTapjoyGold + amount;
    [[NSUserDefaults standardUserDefaults] setInteger:localGoldPlusTapjoyGold forKey:@"localGoldPlusTapjoyGold"];

    //Refresh the header
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"update_goldGemsHints"];
    
}

-(void)adColonyVideoAdsReadyInZone:(NSString *)zone {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"video_available"];
}

-(void)adColonyVideoAdsNotReadyInZone:(NSString *)zone {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"video_available"];
}

-(void) getUpdatedPoints:(NSNotification*)notifyObj {
    NSNumber *tapPoints = notifyObj.object;
    NSString *tapPointsStr = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
    // Print out the updated points value.
    NSLog(@"%@", tapPointsStr);
    
    // As of 1.5, only update the local gold once with Tapjoy's.  @"gold" will store all gold value, except Tapjoy's
    BOOL updateGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"update_gold_with_tapjoy"];
    if (updateGold == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"update_gold_with_tapjoy"];
        [[NSUserDefaults standardUserDefaults] setInteger:[tapPoints intValue] forKey:@"gold"];
    }
    
    // Update the local gold value + tapjoy
    int localGold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
    int localGoldPlusTapjoyGold = localGold + [tapPoints intValue];
    [[NSUserDefaults standardUserDefaults] setInteger:localGoldPlusTapjoyGold forKey:@"localGoldPlusTapjoyGold"];
}

- (void)getUpdatedPointsError:(NSNotification*)notifyObj {
}

-(void)awardedPoints:(NSNotification*)notifyObj {
    NSLog(@"Points awarded");
    NSNumber *tapPoints = notifyObj.object;
    NSString *tapPointsStr = [NSString stringWithFormat:@"Tap Points: %d", [tapPoints intValue]];
    // Print out the updated points value.
    NSLog(@"%@", tapPointsStr);
    
    // Update the local gold value
    [[NSUserDefaults standardUserDefaults] setInteger:[tapPoints intValue] forKey:@"gold"];
}

// Update user's currency in this method.
- (void)videoAdClosed {
    [TapjoyConnect getTapPoints];
}


- (void) authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            // Perform additional tasks for the authenticated player.
        }
    }];
}

// Implement to resume control when the video viewing was not completed // Currently just output log message
- (void)videoDidNotFinish:(NSString *)hook {
	NSLog(@"Flurry video did not finish for hook %@", hook);
}

// Implement to reward user (if reward was not passed as nil) and resume // flow of control // Currently just output log message
- (void)videoDidFinish:(NSString *)hook withUserCookies:(NSDictionary *)cookies {
	NSLog(@"Flurry video completed for hook %@", hook);
	int gooberGoldCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"goober_gold"];
	gooberGoldCnt = gooberGoldCnt + 50;
	[[NSUserDefaults standardUserDefaults] setInteger:gooberGoldCnt forKey:@"goober_gold"];
}

- (void) newInstallUpdate {

    int version = [[NSUserDefaults standardUserDefaults] integerForKey:@"version"];
    if (version < 1) {
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"version"];

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popometer_pack_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mega_pack_1_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"mega_bundle_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popper_pack_2_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popper_pack_3_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"popper_pack_4_unlocked"];
    }
    
    // Ver. 1.01
    if (version < 101) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:101 forKey:@"version"];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"offer_free_hints"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"offer_free_fb_like_hints"];

        // Give them 2 free hints
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];		
        hintCnt = hintCnt + 2;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
    }
   
    // Ver. 1.02
    if (version < 102) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:102 forKey:@"version"];

        // Give them 2 free hints due to a bug
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];		
        hintCnt = hintCnt + 2;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
    }

    // Ver. 1.1
    if (version < 110) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:110 forKey:@"version"];
        
        // Give them 100 free gold to start
        [[NSUserDefaults standardUserDefaults] setInteger:100 forKey:@"goober_gold"];
    }
        
    // Ver. 1.4
    if (version < 140) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:140 forKey:@"version"];
 
        // Add the user's earned gold to Tapjoy's servers
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"update_tapjoy_gold"];
    }
    
    // Ver. 1.4.1
    if (version < 141) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:141 forKey:@"version"];
    }

    // Ver. 2.0
    if (version < 200) {
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:200 forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"gems"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGoldDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGemsDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needAHintDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"undoPowerUp"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tap+1PowerUp"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"x2PowerUp"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"noAdsPowerUp"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"offer_4free_hints"];
        
        // As a one-time thing, transfer all of Tapjoy's gold into the "gold" value.
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"update_gold_with_tapjoy"];

    }
    
    // Ver. 2.2
    if (version < 220) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:220 forKey:@"version"];
        
        // Give them 2 free hints for the holiday
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
        hintCnt = hintCnt + 2;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
    }
    
    // Ver. 2.4
    if (version < 240) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:240 forKey:@"version"];
        
        // Give them 4 free hints for the holiday
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
        hintCnt = hintCnt + 4;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
    }
    
    // Ver. 2.5
    if (version < 250) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:250 forKey:@"version"];
        
        // Give them 5 free hints for Easter
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
        hintCnt = hintCnt + 5;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
    }

    
    // Ver. 2.8
    if (version < 280) {
        
        // First, update the version
		[[NSUserDefaults standardUserDefaults] setInteger:280 forKey:@"version"];
        
        // Give them 5 free hints
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
        hintCnt = hintCnt + 5;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
    }
    
    // This is to add test hints (i.e. set a break point and change the value of addHints)
    BOOL addHints = NO;  
    if (addHints == YES) {
        int hintCnt = 1000;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"popper_pack_2_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"popper_pack_3_unlocked"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"popper_pack_4_unlocked"];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  	[[CCDirector sharedDirector] stopAnimation];
	[[CCDirector sharedDirector] pause];
    
    // Schedule notifications
    [self updateNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
 	[[CCDirector sharedDirector] stopAnimation]; // call this to make sure you don't start a second display link!
	[[CCDirector sharedDirector] resume];
 	[[CCDirector sharedDirector] startAnimation];
    
    // Do this to update the local gold plus the Tapjoy gold
    [TapjoyConnect getTapPoints];  

    // Only display Chartboost if not first time run
    int highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper1_highest_level"];
    if (highestLevel > 1) {

        // Show RevMob
        BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
        if (removeAds != YES) {
            
            //AppLovin
            [self displayAppLovin];
            
            // Display RevMob
            RevMobFullscreen *fullscreen = [[RevMobAds session] fullscreenWithPlacementId:@"5253aa6563fd764c89000062"];
            [fullscreen showAd];
        }
        [Flurry logEvent:@"App Active"];
        
    }
    
    // Clear Notifications
    [self clearNotifications];

    // Retrieve In App data
    [self retrieveInAppData];
    
    // Each time the app becomes active, check to see if 24 hours has passed to get a new free hint
    [self freeHintCheck];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSDictionary *userDict = notification.userInfo;
    if ([[userDict objectForKey:@"free_hint"] isEqualToString:@"YES"]) {
        [self freeHintCheck];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"update_goldGemsHints"];
    }
    NSLog(@"Notification:%@",notification.userInfo);
    
    // RevMob 
    [[RevMobAds session] processLocalNotification:notification];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void)displayGoogleAd:(CGSize)adSize{
    [viewController addAdMobBanner:adSize];
}

-(void)displayTapjoyAd {
    
}

-(void)displayTwitter5 {
    [viewController shareTwitter5];
}

-(void)displayFacebook6 {
    [viewController shareFacebook6];
}

-(void)removeGoogleAd{
    [viewController removeAdMobBanner];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView == msg) {
		if (buttonIndex == 1) {
            
		}
		else {
			msg = nil;
		}
	}
    
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];

    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];  // for IAP
    
	[window release];
	[super dealloc];
}

@end
