//
//  CrazyPoppers.h
//  CrazyPlay
//
//  Created by Alan Trippe on 2/6/12.
//  Copyright (c) 2012 Trippin' Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "AdColonyPublic.h"
#import "StoreKit/StoreKit.h"

// CrazyPoppers Menu Scene
@interface CrazyPoppersMenuScene : CCScene {}
@end

// CrazyPoppers Menu Layer
    @interface CrazyPoppersMenuLayer : CCLayer <AdColonyTakeoverAdDelegate, SKPaymentTransactionObserver> {
    
    UIViewController *tempVC;

    CGSize screenSize;

    CCSpriteBatchNode *spriteSheet;
    CCLayer *menuSelection1;
    CCLayer *menuSelection2;
    CCLayer *menuSelection3;
    CCLayer *menuSelection4;
    CCLayer *menuSelection5;
    CCLayer *popometerSelection;
    CCLayer *megaPack1Selection;;
    
    int menuSelectionNo;
    int totalHighScore;
    int totalHighScore1;
    int totalHighScore2;
    int totalHighScore3;
    int totalHighScore4;
    int totalHighScore11;
    int totalHighScore12;
    int randomUnlockCurrency;

    
	BOOL playSound;
	BOOL playMusic;
    BOOL popperPack2Unlock;
    BOOL popperPack3Unlock;
    BOOL popperPack4Unlock;
    BOOL popperPack5Unlock;
    BOOL touchMoved;
    BOOL popometerPackUnlock;
    BOOL megaPack1Unlock;
    BOOL needAHintDisplayed;
    BOOL buyGoldDisplayed;
    BOOL buyGemsDisplayed;
    BOOL notEnoughGemsDisplayed;
    BOOL notEnoughGoldDisplayed;
    BOOL settingsDisplayed;
    
    UITouch *touchCheck;	
    
    UIAlertView *fullVersionConfirm;
    UIAlertView *pack2Error;
    UIAlertView *pack3Error;
    UIAlertView *pack4Error;
    UIAlertView *gooberGoldError;
    UIAlertView *miscError;
    UIAlertView *popometerPackError;
    UIAlertView *megaPackError;
    UIAlertView *gameCenterSignIn;

    
    NSString *currentIdentifier;
    
    NSSet *productIdentifiers;
	NSSet *invalidProductIdentifiers;

    NSMutableArray *selectionArray;
}

@end


// CrazyPlay Scene
@interface CrazyPoppersScene : CCScene {}
@end

// CrazyPlay Layer
@interface CrazyPoppersLayer : CCLayer {
    CGSize screenSize;

    CCSpriteBatchNode *spriteSheet;
    CCLayer *selection1;
    CCLayer *selection2;
    CCLayer *selection3;
    CCLayer *selection4;
    CCLayer *selection5;
    CCLayer *selection6;
    CCLayer *selection7;
    CCLayer *selection8;
    CCLayer *selection9;
    CCLayer *selection10;
    CCLayer *selection11;
    CCLayer *selection12;
    CCLayer *selection13;
    CCLayer *selection14;
    CCLayer *selection15;
    
    int currentLevel;
    int menuSelectionNo;
    int offset;
    int highScore;
    int levelCounter;
    int levelSelectionPage;
    int highestLevel;
    
    
    BOOL playSound;
	BOOL playMusic;
    BOOL selectLevel;
    BOOL touchMoved;
    
    CGRect levelSelect1;
	CGRect levelSelect2;
	CGRect levelSelect3;
	CGRect levelSelect4;
	CGRect levelSelect5;
	CGRect levelSelect6;
	CGRect levelSelect7;
	CGRect levelSelect8;
	CGRect levelSelect9;
	CGRect levelSelect10;
	CGRect levelSelect11;
	CGRect levelSelect12;
	CGRect levelSelect13;
	CGRect levelSelect14;
	CGRect levelSelect15;
	CGRect levelSelect16;
	CGRect levelSelect17;
	CGRect levelSelect18;
	CGRect levelSelect19;
	CGRect levelSelect20;
	CGRect levelSelect21;
    
    UITouch *touchCheck;	
}
@end