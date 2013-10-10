//
//  AppDelegate.h
//  CrazyPlay
//
//  Created by Alan on 3/23/10.
//  Copyright Trippin' Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flurry.h"
#import "GameKit/GameKit.h"
#import "AdColonyPublic.h"
#import <RevMobAds/RevMobAds.h>
#import "TapjoyConnect.h"
#import "StoreKit/StoreKit.h"

@class RootViewController;

    @interface AppDelegate : NSObject <UIApplicationDelegate, TJCAdDelegate, GKLeaderboardViewControllerDelegate, AdColonyDelegate, RevMobAdsDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver> {
    
	UIWindow *window;
	RootViewController	*viewController;
    
    NSSet *productIdentifiers;
	NSSet *invalidProductIdentifiers;
	NSString *currentIdentifier;
    NSString *productPrice;
    NSString *title, *message, *buttonLabel;

    UIAlertView *msg;
    UIAlertView *promoMsg;
}

@property (nonatomic, retain) UIWindow *window;

-(void)displayGoogleAd:(CGSize)adSize;
-(void)removeGoogleAd;
-(void)displayTapjoyAd;
-(void)displayTwitter5;
-(void)displayTwitter6;
-(void)displayFacebook6;

@end
