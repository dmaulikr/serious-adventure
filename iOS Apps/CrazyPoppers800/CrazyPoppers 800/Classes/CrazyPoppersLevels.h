//
//  CrazyPoppersLevels.h
//  CrazyPlay
//
//  Created by Alan Trippe on 2/6/12.
//  Copyright (c) 2012 Trippin' Software. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RootViewController.h"
#import "Chartboost.h"
#import "GADBannerView.h"
#import "TapjoyConnect.h"
#import "StoreKit/StoreKit.h"

// CrazyPoppers Scene
@interface CrazyPoppersLevelScene : CCScene {}
@end

// CrazyPoppers Layer
@interface CrazyPoppersLevelLayer : CCLayer <GADBannerViewDelegate, TJCAdDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate> {
    
    Chartboost *cb;
    
    CGSize screenSize;
    
 	CCSpriteBatchNode *spriteSheet;
   	NSMutableArray *_allPoppers;
   	NSMutableArray *_removePoppers;
   	NSMutableArray *_allSpinners;
   	NSMutableArray *_allHints;
   	NSMutableArray *_allRicochetWalls;
    NSMutableArray *_undoArray;
    
    int popometerCnt;
	int popometerPurple;
	int popometerBlue;
	int popometerGreen;
	int popometerRed;
	int popometerYellow;
    int popperStartLocation;
    int pauseButtonStatus;
    int maxTaps;
    int currentTaps;
    int currentLevel;
    int menuSelectionNo;
    int levelSelectionPage;
    int highestLevel;
    int totalHintsRemaining;
    int totalHintsDisplayed;
    int counter;
    int popperScore;
    int doubleScore;
    int powerUp1Value;
    int powerUp2Value;
    int powerUp3Value;
    int powerUp4Value;
    int levelsPlayed;
    
    float popPitch;
    
    BOOL levelComplete;
    BOOL firstPass;
    BOOL levelFail;
    BOOL displayHint;
    BOOL hintsActive;
    BOOL bannerDisplayed;
    BOOL needAHintDisplayed;
    BOOL buyGoldDisplayed;
    BOOL buyGemsDisplayed;
    BOOL notEnoughGemsDisplayed;
    BOOL notEnoughGoldDisplayed;
    BOOL playScreenDisplayed;
    BOOL rewardGem;
    BOOL newHighScore;
    BOOL powerUpInfoDisplayed;
    BOOL appLovinActive;
    
    CCSprite *pop1;
	CCSprite *pop2;
	CCSprite *pop3;
	CCSprite *pop4;
	CCSprite *pop5;
    
    BOOL playSound;
	BOOL playMusic;
    
    UIAlertView *freeHint;
    UIAlertView *hintConfirm;
	UIAlertView *hintAlert;
	UIAlertView *hintPrompt;
	UIAlertView *miscError;
    UIAlertView *oneHintUnlock;
    UIAlertView *tenHintsUnlock;
    UIAlertView *handfulGoldUnlock;
    UIAlertView *stackGoldUnlock;
    UIAlertView *bagGoldUnlock;
    UIAlertView *bucketGoldUnlock;
    UIAlertView *gem22Unlock;
    UIAlertView *gem48Unlock;
    UIAlertView *gem125Unlock;
    UIAlertView *gem270Unlock;
    UIAlertView *msgiOS5;
    UIAlertView *msgiOS6;
    UIAlertView *miscMsg;
    
    RootViewController *controller;
    
	NSString *currentIdentifier;
    
    NSSet *productIdentifiers;
	NSSet *invalidProductIdentifiers;
    
    GADBannerView *bannerView;
}
@end
