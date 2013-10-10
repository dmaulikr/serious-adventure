//
//  AppDelegate.h
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/16/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakingWindow.h"
#import <RevMobAds/RevMobAds.h>
#import "iRate.h"
#import "PlayHavenSDK.h"
#import <RevMobAds/RevMobAdsDelegate.h>

//Flurry startSession
#define FLURRY_ANALYTICS_SESSION_ID @"GZQ283ZYTP7W9P9R73RP"

#define FACEBOOK_APP_ID @"497960190288577"
//rate.appStoreID
#define APPSTORE_RATE_ID 553235582

//Revmob app ID

#define REVMOB_APP_ID @"519aedce15c11c6b8700017c"

//RevMobFullscreen
#define REVMOB_FULLSCREEN_PLACEMENT_ID @"519aedce15c11c6b87000181"

//revMobBannerView
#define REVMOB_BANNER_ID @"519aedce15c11c6b8700017f"

//playHavenToken
#define PLAYHAVEN_TOKEN @"799fa1340b0040b8a47347756cbace78"
//playHavenSecret
#define PLAYHAVEN_SECRET @"2089fcfb27a5485a85f607762c3b8a3b"





@interface AppDelegate : UIResponder
<UIApplicationDelegate,
    RevMobAdsDelegate>

@property (strong, nonatomic) ShakingWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSURL *iTunesURL;

- (void)openReferralURL:(NSURL *)referralURL;


@end
