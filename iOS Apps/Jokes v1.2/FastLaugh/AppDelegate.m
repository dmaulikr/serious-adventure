//
//  AppDelegate.m
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/16/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "StartScreenViewController.h"
#import "DataModel.h"
#import "FlurryAnalytics.h"
#import "TapjoyConnect.h"
#import <RevMobAds/RevMobAds.h>
#import "PlayHavenSDK.h"


@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *jokesArray;

- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;
- (void)showNagScreen: (NSString*)nagScreenName;

- (void)loadNotificationsJokes;
- (NSString*)randomJoke;
- (void)scheduleNotificationWithTimeInterval: (NSTimeInterval)timeInterval text: (NSString*)text;
- (void)scheduleNotifications;

@end



@implementation AppDelegate

@synthesize window = _window;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize iTunesURL = _iTunesURL;
@synthesize jokesArray = _jokesArray;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DataModel sharedInstance].managedObjectContext = self.managedObjectContext;
    
    if ( 0 == [DataModel sharedInstance].categoriesCount ) {
        debug(@"importing insults");
        [[DataModel sharedInstance] importInsults];
    }
    
    // start Flurry
    [FlurryAnalytics startSession: FLURRY_ANALYTICS_SESSION_ID];//]@"GZQ283ZYTP7W9P9R73RP"];
    
    self.window = [[ShakingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    
    
    StartScreenViewController *startScreenViewController =
    [[StartScreenViewController alloc] initWithNibName: nil bundle: nil];
    
    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController: startScreenViewController];
    

    [FlurryAnalytics logAllPageViews: navController];
    
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    // configure iRate
    iRate *rate = [iRate sharedInstance];
    rate.appStoreID = APPSTORE_RATE_ID;//553235582;
    rate.debug = NO;
    rate.remindButtonLabel = nil;
    rate.message = NSLocalizedString(@"Are you enjoying this app?", @"iRate alert text");
    rate.rateButtonLabel = NSLocalizedString(@"Yes!", @"iRate alert - YES");
    rate.cancelButtonLabel = NSLocalizedString(@"No :(", @"iRate alert - NO");
    //rate.applicationName = NSLocalizedString(@"Fast Laugh Jokes", @"App name in iRate Alert");
    rate.applicationName = NSLocalizedString(@"Best Stupid Jokes and Puns Free", @"App name in iRate Alert");    
    
    rate.daysUntilPrompt = 1.0f/24.0f/60.0f/2.0f; // 30 secs
    rate.usesUntilPrompt = 3;
    rate.eventsUntilPrompt = 3;
    
    //Facebook
    [FacebookManager sharedInstance];
    // RevMob
    [RevMobAds startSessionWithAppID:REVMOB_APP_ID];//]@"519aedce15c11c6b8700017c"];
    [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
    
    RevMobFullscreen *revMobFullScreen = [[RevMobAds session] fullscreenWithPlacementId: REVMOB_FULLSCREEN_PLACEMENT_ID];//]@"519aedce15c11c6b87000181"];
    revMobFullScreen.delegate = self;
    [revMobFullScreen showAd];
    
    //
    [[PHPublisherOpenRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret] send];
    
    [[PHPublisherContentRequest requestForApp:[DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret placement: @"nag_on_start_up" delegate: self] send];
    
    [self preloadPlayHaven];
    
    // TapjoyConnect
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
	
	[TapjoyConnect requestTapjoyConnect:@"ab2832fb-2ea6-4b05-b253-98e34c7303e0" secretKey:@"5KFSoIZjCKa2l368BEoz"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   [[PHPublisherOpenRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret] send];    
    
    [[PHPublisherContentRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret placement: @"nag_on_start_up" delegate: self] send];    
    
    if ([[iRate sharedInstance] shouldPromptForRating])
         [[iRate sharedInstance] performSelector:@selector(promptIfNetworkAvailable) withObject:self afterDelay:2.0f];
     
}   


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //Facebook
    [[FacebookManager sharedInstance].facebook extendAccessTokenIfNeeded];
    
    [self scheduleNotifications];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

// Process a URL to something iPhone can handle
- (void)openReferralURL:(NSURL *)referralURL
{
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:referralURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [conn start];
}

// Save the most recent URL in case multiple redirects occur
// "iTunesURL" is an NSURL property in your class declaration
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response) {
        NSMutableURLRequest *r = [request mutableCopy]; // original request
        [r setURL: [request URL]];
        
        self.iTunesURL = [r URL];
        if ([self.iTunesURL.host hasSuffix:@"itunes.apple.com"]) {
            [[UIApplication sharedApplication] openURL:self.iTunesURL];
        }
        
        return r;
    }   
    else {
        return request;
    }
    
}

#pragma mark - Local Notifications

- (void)loadNotificationsJokes
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource: @"JokesLocalNotification.txt"  ofType: nil];
    NSError *error = nil;
    NSString *jokesString = [NSString stringWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: &error];
    
    if ( nil != error ) {
        error(@"error reading file '%@': %@", filePath, error);
    }
    
    self.jokesArray = [NSMutableArray arrayWithArray: [jokesString componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]]];
}


- (NSString*)randomJoke
{
    int randomIndex = arc4random() % [self.jokesArray count];
    NSString *joke = [self.jokesArray objectAtIndex: randomIndex];
    [self.jokesArray removeObjectAtIndex: randomIndex];
    
    return joke;
}


- (void)scheduleNotificationWithTimeInterval: (NSTimeInterval)timeInterval text: (NSString*)text
{
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    
    if ( nil == text ) {
        text = @"We've missed you!";
    }
    
    notif.fireDate = [NSDate dateWithTimeIntervalSinceNow: timeInterval];
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = text;
    notif.alertAction = @"PLAY";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification: notif];
}


- (void)scheduleNotifications
{
	//LOCAL NOTIFICATIONS
    
    //Cancel all previous Local Notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self loadNotificationsJokes];
    
    //Set new Local Notifications
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil) {
        
        debug(@"scheduling local notification");
        
        CGFloat oneDay = 60.0f*60.0f*24.0f;
        //CGFloat oneDay = 10.0f;
        [self scheduleNotificationWithTimeInterval: oneDay * 3 text: [self randomJoke]];
        [self scheduleNotificationWithTimeInterval: oneDay * 7  text: [self randomJoke]];
        [self scheduleNotificationWithTimeInterval: oneDay * 15  text: [self randomJoke]];
        [self scheduleNotificationWithTimeInterval: oneDay * 30  text: [self randomJoke]];
        [self scheduleNotificationWithTimeInterval: oneDay * 60  text: [self randomJoke]];
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"InsultShake" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"InsultShake.sqlite"];
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Custom View
- (void)showNagScreen: (NSString*)nagScreenName;
{
    
    if ( 0 == [nagScreenName length] ) {
        error(@"empty nag screen name supplied");
        return;
    }
    
    [FlurryAnalytics logEvent: @"ShowNagScreen"];
}


#pragma mark - ChartboostDelegate <NSObject>

// Called before requesting an interstitial from the back-end
- (BOOL)shouldRequestInterstitial:(NSString *)location
{
    debug(@"should request Interstitial: %@", location);
    return YES;
}

// Called when an interstitial has been received, before it is presented on screen
// Return NO if showing an interstitial is currently inappropriate, for example if the user has entered the main game mode
- (BOOL)shouldDisplayInterstitial:(NSString *)location
{
    debug(@"should display interstitial: %@", location);
    return YES;
}

// Called when an interstitial has failed to come back from the server
// This may be due to network connection or that no interstitial is available for that user
- (void)didFailToLoadInterstitial:(NSString *)location
{
    debug(@"failed loading Interstitial: %@", location);
}

// Called when the user dismisses the interstitial
//- (void)didDismissInterstitial:(NSString *)location;

// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(NSString *)location
{
    debug(@"did close: %@, cache again!", location);
    //[[Chartboost sharedChartboost] cacheInterstitial: location];
}

// Same as above, but only called when dismissed for a click
//- (void)didClickInterstitial:(NSString *)location;


// Called when an interstitial has been received and cached.
- (void)didCacheInterstitial:(NSString *)location
{
    debug(@"didCache: %@", location);
}


- (BOOL)shouldRequestInterstitialsInFirstSession
{
    return NO;
}


// Called when an more apps page has been received, before it is presented on screen
// Return NO if showing the more apps page is currently inappropriate
- (BOOL)shouldDisplayMoreApps
{
    debug(@"shouldDisplayMoreApps ?");
    return YES;
}


// Called before requesting the more apps view from the back-end
// Return NO if when showing the loading view is not the desired user experience
- (BOOL)shouldDisplayLoadingViewForMoreApps
{
    debug(@"shouldDisplayLoadingViewForMoreApps ?");
    return YES;
}

// Called when the user dismisses the more apps view
//- (void)didDismissMoreApps;

// Same as above, but only called when dismissed for a close
- (void)didCloseMoreApps
{
    //[[Chartboost sharedChartboost] cacheMoreApps];
}

// Same as above, but only called when dismissed for a click
- (void)didClickMoreApps
{
    debug(@"DID click more apps");
}

// Called when a more apps page has failed to come back from the server
- (void)didFailToLoadMoreApps
{
    error(@"didFailToLoadMoreApps");
}

// Called when the More Apps page has been received and cached
- (void)didCacheMoreApps
{
    debug(@"didCacheMoreApps");
}


- (void)preloadPlayHaven
{
    [[PHPublisherContentRequest requestForApp:[DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret placement: @"more_games" delegate: (AppDelegate*)[UIApplication sharedApplication].delegate] preload];
    
    [[PHPublisherContentRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret placement: @"nag_on_return_to_front" delegate: (AppDelegate*)[UIApplication sharedApplication].delegate] preload];
}


#pragma mark - RevMobAdsDelegate


- (void)revmobAdDidReceive
{
    debug(@"did receive RevMob Ad");
}


- (void)revmobAdDidFailWithError:(NSError *)error
{
    error(@"did fail to receive RevMob Ad with error: %@", error);
}


- (void)revmobUserClickedInTheCloseButton
{
    debug(@"user closed RevMob AD");
}


- (void)revmobUserClickedInTheAd
{
    debug(@"user clicked in RevMob AD");
}


#pragma mark TapjoyConnect Observer methods

-(void) tjcConnectSuccess:(NSNotification*)notifyObj
{
	debug(@"Tapjoy Connect Succeeded");
}

-(void) tjcConnectFail:(NSNotification*)notifyObj
{
	debug(@"Tapjoy Connect Failed");
}


#pragma mark - External URLS opening

// Pre 4.2 support
- (BOOL)application: (UIApplication*)application handleOpenURL: (NSURL*)url {
    
    //  return [[FacebookManager sharedInstance].facebook handleOpenURL: url];
    return [FBSession.activeSession handleOpenURL:url];
}


// For 4.2+ support
- (BOOL)application: (UIApplication*)application
            openURL: (NSURL*)url
  sourceApplication: (NSString*)sourceApplication
         annotation: (id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
    //   return [[FacebookManager sharedInstance].facebook handleOpenURL: url];
}




@end
