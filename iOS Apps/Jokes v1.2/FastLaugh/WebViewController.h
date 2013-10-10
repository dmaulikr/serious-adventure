//
//  WebViewController.h
//  MustacheBash
//
//  Created by Konstantin Sokolinskyi on 2/23/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol WebViewControllerDelegate

- (void)cancelWebViewController: (id)sender;

@end

@interface WebViewController : BaseViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL* url;
@property (assign, nonatomic) id<WebViewControllerDelegate> delegate;


@end