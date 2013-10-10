//
//  StartScreenViewController.h
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/16/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//#import "MobclixAds.h"
#import "SegmentedSortBar.h"
#import "DataModel.h"
//#import "ChartBoost.h"
//Sun
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>
#import "FacebookManager.h"

@interface StartScreenViewController : BaseViewController
<UIActionSheetDelegate,
MFMailComposeViewControllerDelegate,
//MobclixAdViewDelegate,
DataModelPurchaseDelegate,
RevMobAdsDelegate,
SegmentedSortBarDelegate,
FacebookManagerLoginDelegate>
//ChartboostDelegate>


// Favourite
@property (strong, nonatomic) NSString *favouritePath;

- (void) updatePackView: (NSNotification *)notification;




@end
