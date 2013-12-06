//
//  RootViewController.m
//  test5
//
//  Created by Alan on 6/17/11.
//  Copyright Trippin' Software 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "Reachability.h"
#import "Twitter/Twitter.h"
#import "Social/Social.h"

@implementation RootViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}
 */


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
 	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
  	return ( interfaceOrientation == UIInterfaceOrientationPortrait );

	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect;
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)removeAdMobBanner{
    NSLog(@"calling removeadbanner");
    //NSLog(@"remove google ad");
    [gADBbannerView removeFromSuperview];
    [gADBbannerView release];
    //gADBbannerView=nil;
}

-(void) addAdMobBanner:(CGSize)adSize{
    //NSLog(@"adding Admob");
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    // Create a view of the standard size at the bottom of the screen.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        gADBbannerView = [[GADBannerView alloc]
                          initWithFrame:CGRectMake(winSize.width/2-160,
                                                   winSize.height -
                                                   GAD_SIZE_320x50.height*3 + 76,
                                                   GAD_SIZE_320x50.width,
                                                   GAD_SIZE_320x50.height)];

        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        gADBbannerView.adUnitID = @"pub-1270442553974838";
    }
    
    else {
        gADBbannerView = [[GADBannerView alloc]
                          initWithFrame:CGRectMake(winSize.width/2-364,
                                                   winSize.height -
                                                   GAD_SIZE_728x90.height*3 + 178,
                                                   GAD_SIZE_728x90.width,
                                                   GAD_SIZE_728x90.height)];
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        gADBbannerView.adUnitID = @"pub-1270442553974838";        
    }

    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    gADBbannerView.rootViewController = self;
    
    [self.view addSubview:gADBbannerView];
    
    [gADBbannerView loadRequest:[GADRequest request]];
    
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  bannerView.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];
}

// This method is called after Ad data has been successfully received from the server. 
- (void)didReceiveAd:(TJCAdView*)adView {
	adView.frame = CGRectMake(0, 0, 320, 50);    
    
}

// This method is called if an error has occurred while requesting Ad data. 
- (void)didFailWithMessage:(NSString*)msg {
    
}

// This method must return one of TJC_AD_BANNERSIZE_320X50, TJC_AD_BANNERSIZE_640X100, or TJC_AD_BANNERSIZE_768X90. 
- (NSString*)adContentSize {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return TJC_AD_BANNERSIZE_320X50;
    }
    else {
        return TJC_AD_BANNERSIZE_768X90;
    }
}

// This method must return a boolean indicating whether the Ad will automatically refresh itself.
- (BOOL)shouldRefreshAd {
	return YES;
}

// AdColony
-(NSString*)adColonyApplicationID {
    NSLog(@"RVC: AdColonyAppID");
    return @"appb488b842b1c0405b91b13f";
}

-(NSDictionary*)adColonyAdZoneNumberAssociation {
    
    NSLog(@"RVC: AdColony ZoneNumber");
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"vzd178141ac9ba4b82acb46b", [NSNumber numberWithInt:1], //Menu Screen
            @"vze2d7072456ab4bcf82798a", [NSNumber numberWithInt:2], //Buy Gold Screen
            nil];
}

-(void) shareTwitter5 {
    if ([TWTweetComposeViewController canSendTweet]) {
        
        // Retrieve saved image
        NSString* imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/screenShot.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText: @"Help! Anyone know the solution to this level on #CrazyBlowfishPoppers? Try it yourself for FREE http://tinyurl.com/keh63lj"];
        [tweetSheet addImage:image];
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) shareTwitter6 {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        // Retrieve saved image
        NSString* imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/screenShot.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Help! Anyone know the solution to this level on #CrazyBlowfishPoppers? Try it yourself for FREE http://tinyurl.com/keh63lj"];
        [tweetSheet addImage:image];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) shareFacebook6 {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        // Retrieve saved image
        NSString* imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/screenShot.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:@ "I need help! Does anyone know the solution to this level on Crazy Poppers? Try it yourself for FREE http://tinyurl.com/keh63lj #CrazyBlowfishPoppers"];
        [facebookSheet addImage:image];
        
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send to Facebook right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)dealloc {
    [super dealloc];
}

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#endif
#endif

@end

