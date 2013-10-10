//
//  FavoriteViewController.h
//  FastLaugh
//
//  Created by admin on 8/25/13.
//  Copyright (c) 2013 BrightNewt Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FavoriteViewController : BaseViewController  <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate,FacebookManagerLoginDelegate>


@property (strong, nonatomic) NSArray *favouriteArray;
@property (strong, nonatomic) NSString *favouritePath;

@end

