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
#import "TapjoyConnect.h"
#import "AdColonyPublic.h"
#import "GADBannerView.h"
#import "StoreKit/StoreKit.h"

// BuyGoldGemsHints Scene
@interface BuyGoldGemsHintsScene : CCScene {}
@end

// BuyGoldGemsHints Layer

@interface BuyGoldGemsHintsLayer : CCLayer <AdColonyTakeoverAdDelegate, SKPaymentTransactionObserver,SKProductsRequestDelegate> {
    GADBannerView *bannerView;
    
    CGSize screenSize;

 	CCSpriteBatchNode *spriteSheet;
   	NSMutableArray *_allPoppers;
   	NSMutableArray *_removePoppers;
   	NSMutableArray *_allSpinners;
   	NSMutableArray *_allHints;
   	NSMutableArray *_allRicochetWalls;
    
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
    int gemsNeeded;
    int goldNeeded;
    
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
    UIAlertView *promoMsg;
    
    RootViewController *controller;
    
	NSString *currentIdentifier;
    
    NSSet *productIdentifiers;
	NSSet *invalidProductIdentifiers;
}

-(void) notEnoughGold:(int)diff;
-(void) notEnoughGems:(int)diff;
-(BOOL) notEnoughGemsGoldDisplayed;
-(void) hideHeader:(int)toggle;

@end
