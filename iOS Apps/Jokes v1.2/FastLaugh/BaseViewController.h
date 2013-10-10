//
//  BaseViewController.h
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 2/12/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FlurryAnalytics.h"
#import "FacebookManager.h"
@interface BaseViewController : UIViewController

@property (strong, nonatomic) UIImageView *navBar;
@property (strong, nonatomic) UIImageView *toolbar;
@property (strong, nonatomic) UILabel *navBarTitleLabel;


- (BOOL)canSendMail;

#pragma Navigation bar
- (void)createNavBar;
- (void)createLeftNavBarButtonWithTitle: (NSString*)title target: (id)target action: (SEL)action;
- (void)createRightNavBarButtonWithTitle: (NSString*)title target: (id)target action: (SEL)action;
- (void)createNavBarTitleWithText: (NSString*)text;

@end
