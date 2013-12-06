//
//  AppDelegate.h
//  MagicCamera
//
//  Created by i Pro on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "Chartboost.h"
#import <RevMobAds/RevMobAdsDelegate.h>

#import "Configuration.h"

@class MenuViewController;

enum SE_TYPE {
    SE_SHUTTERSTART = 0,
    SE_SHUTTEREND,
};

@interface MagicCameraAppDelegate : UIResponder <UIApplicationDelegate, RevMobAdsDelegate, ChartboostDelegate> {
 	UINavigationController	*navigationController;
    AVAudioPlayer*		m_audioPlayer;
    NSArray*    _permissions;
    
    Chartboost *cb;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MenuViewController *viewController;
@property (nonatomic, retain) Chartboost *cb;

+ (MagicCameraAppDelegate *)sharedDelegate;

- (void)playSE:(int)type;
- (void)stopSE;
- (BOOL)isPlayingSE;

#pragma mark REBMOV

-(void)dispMoreGames;

#pragma mark Facebook
- (void)    FacebookLogin;
- (void)    FacebookLogOut;
- (void)    UploadPhotoToFacebook;

@end
