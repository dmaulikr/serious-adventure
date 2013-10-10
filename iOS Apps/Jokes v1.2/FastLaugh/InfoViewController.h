//
//  InfoViewController.h
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 1/27/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"
#import "WebViewController.h"
//#import "ChartBoost.h"

@interface InfoViewController : BaseViewController
    <MFMailComposeViewControllerDelegate,
    WebViewControllerDelegate>

//    ChartboostDelegate>
@property (strong, nonatomic) NSString *favouritePath;

@end
