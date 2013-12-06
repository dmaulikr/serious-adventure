//
//  AppDelegate.h
//  tweejump
//
//  Created by Johannes Strydom on 5/11/2013.
//  Copyright Incredible Adventure 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewContrroller;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow            *window;
    RootViewContrroller *viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
