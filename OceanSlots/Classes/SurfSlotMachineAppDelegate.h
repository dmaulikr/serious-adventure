//
//  SurfSlotMachineAppDelegate.h
//  SurfSlotMachine
//
//  Created by Tanut Apiwong on 10/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chartboost.h"
#import <RevMobAds/RevMobAds.h>
#import <iAd/iAd.h>

@class RootViewController;

@interface SurfSlotMachineAppDelegate : NSObject <UIApplicationDelegate, RevMobAdsDelegate, ADBannerViewDelegate, ChartboostDelegate> {
	UIWindow *window;
	RootViewController	*viewController;

    ADBannerView *iAdBannerView;
}
@property (nonatomic, retain) RootViewController *viewController;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) Chartboost *cb;

#pragma mark ads
-(void) hideADS:(BOOL) flag;

-(void) dispAds;
-(void) dispMoreApps;
@end
