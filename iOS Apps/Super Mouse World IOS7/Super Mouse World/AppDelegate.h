//
//  AppDelegate.h
//  Super Mouse World
//
//  Created by Luiz Menezes on 18/10/12.
//  Copyright Thetis Games 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import <RevMobAds/RevMobAdsDelegate.h>
#import <RevMobAds/RevMobAds.h>
#import "Chartboost.h"
#import "GameKit/GameKit.h"
#import "GameCenterManager.h"
#import "ALSdk.h"
#import "ALInterstitialAd.h"


// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate,
RevMobAdsDelegate, ChartboostDelegate,
GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate,
GameCenterManagerDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref
    
    Chartboost *cb;
    RevMobAdLink *ad;

    //GameCenter
    GameCenterManager *gameCenterManager;
    NSString* currentLeaderBoard;
    
    NSError* lastError;
    bool isGameCenterAvailable;
    int64_t  currentScore;
    
    int     m_nPrevPageofCoin;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) Chartboost *cb;
@property (nonatomic, retain) RevMobAdLink *ad;

@property int   m_nPrevPageofCoin;

-(void)dispMoreGames;
-(void)dispAdvertise;
-(void)dispFreeGames;

+( AppController *)get;

#pragma GameCenter
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

- (void) submitScore : (int) curScore;
- (void) showLeaderboard;
-(void) authenticate;

#pragma mark
-(void) dispAppLovinPopup;


@end
