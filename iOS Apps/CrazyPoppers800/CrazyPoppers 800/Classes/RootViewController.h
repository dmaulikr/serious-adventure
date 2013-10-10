//
//  RootViewController.h
//  test5
//
//  Created by Alan on 6/17/11.
//  Copyright Trippin' Software 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "TapjoyConnect.h"
#import "AdColonyPublic.h"

@interface RootViewController : UIViewController  {

    GADBannerView *gADBbannerView;
}

-(void) addAdMobBanner:(CGSize)adSize;
-(void)removeAdMobBanner;
-(void)shareTwitter5;
-(void)shareTwitter6;
-(void)shareFacebook6;

@end

