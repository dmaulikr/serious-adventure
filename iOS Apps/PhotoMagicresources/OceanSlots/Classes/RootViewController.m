//
//  RootViewController.m
//  SurfSlotMachine
//
//  Created by snow on 19/03/2013.
//
//
#import "cocos2d.h"
#import "RootViewController.h"
#import "GameVariables.h"

//Change here for game center leaderboard id
#define kLeaderboardID @"au.com.incredibleadventure.ParadiseSlots.leaderboard"

//Achivement IDs
#define kAchievement1 @"Half_a_corn_Marathon_Plus"
#define kAchievement2 @"Popcorn_Marathon_Plus"
#define kAchievement3 @"Avoid_the_Harvest_Plus"
#define kAchievement4 @"A_maiz_ing_Plus"
#define kAchievement5 @"Kernel_Yes_Sir_Plus "
#define kAchievement6 @"Number_1_Crop_Plus"
#define kAchievement7 @"Post_Corn_Plus"
#define kAchievement8 @"Tweet_the_Corn_Plus"
#define kAchievement9 @"Real_simple_one_Plus"


@interface RootViewController ()

@end

@implementation RootViewController

@synthesize gameCenterManager;
@synthesize currentLeaderBoard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

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
	CGRect rect = CGRectZero;
    
	
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


- (void)dealloc {
    [super dealloc];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark game center
- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [self presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
    [viewController release];
}

- (void) showAchievements
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL)
    {
        achievements.achievementDelegate = self;
        [self presentModalViewController: achievements animated: YES];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
    [self dismissModalViewControllerAnimated: YES];
    [viewController release];
}

- (void) checkAchievements :(int)checkType
{
    NSString* identifier = NULL;
    double percentComplete = 0;
    switch(checkType)
    {
      //  case kTagHalfMarathon:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
      //      break;
      //  }
      //  case kTagPopMarathon:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
      //      break;
      //  }
      //  case kTagAvoidHarvest:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
      //      break;
      //  }
      //  case kTagAmaizing:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
      //      break;
      //  }
      //  case kTagKernelYesSir:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
      //      break;
      // }
      //  case kTagNumber1Crop:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
      //      break;
      //  }
      //  case kTagPostCorn:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
      //      break;
      //  }
      //  case kTagTweetCorn:
      //  {
      //      identifier= kAchievement1;
      //      percentComplete= 100.0;
     //     break;
     //   }
     //   case kTagRateCorn:
     //   {
    //        identifier = kAchievement9;
      //      percentComplete = 100.0;
      //      break;
      //  }
        default:
            identifier= kAchievement1;
            percentComplete= 100.0;

            break;
    }
    
    if(identifier!= NULL)
    {
        [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
    }
}

- (void) submitScore : (int) curScore
{
    if(curScore > 0)
    {
        [self.gameCenterManager reportScore: curScore forCategory: self.currentLeaderBoard];
    }
}

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

@end
