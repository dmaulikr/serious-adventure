//
//  CrazyPoppersLevels.m
//  CrazyPlay
//
//  Created by Alan Trippe on 2/6/12.
//  Copyright (c) 2012 Trippin' Software. All rights reserved.
//

#import "BuyGoldGemsHints.h"
#import "SimpleAudioEngine.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "PopperPacks.h"
#import "Flurry.h"
#import "StoreKit/StoreKit.h"


#define kPauseGame	   1
#define kResumeGame    2
#define kNewGame       3
#define kMenu          4
#define kSoundToggle   5
#define kMusicToggle   6
#define kStoreSelector 7
#define kNextLevel     8
#define kNewGameSummary 9
#define kMenuSummary 10
#define kHint 11
#define kStoreSummary 12
#define kStoreSummary2 13
#define kStoreRedX 14
#define kGoldHeader 15
#define kGemHeader 16
#define kHintHeader 17
#define kRedX 18
#define k2Hints 19
#define k12Hints 20
#define kRedXNotEnoughGems 21
#define kRedXNotEnoughGold 22
#define kGold1 23
#define kGold2 24
#define kGold3 25
#define kGold4 26
#define kFreeGold 27
#define kGem22 28
#define kGem48 29
#define kGem125 30
#define kGem270 31
#define kRedXPlay 32
#define kPlayButton 33
#define kNotEnoughGems22 34
#define kNotEnoughGems48 35
#define kNotEnoughGems125 36
#define kNotEnoughGold2000 37
#define kNotEnoughGold4500 38
#define kNotEnoughGold12000 39
#define kFreeHints 40


@implementation BuyGoldGemsHintsScene

-(id) init
{
	if( (self=[super init])) {
 		[self addChild:[BuyGoldGemsHintsLayer node] z:1];
    }
    return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end

@implementation BuyGoldGemsHintsLayer

-(CGPoint) convertPoint: (CGPoint)pos {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return ccp(pos.x/2.12, pos.y/2.2);
	}
	else {
		return pos;
	}
}

-(int) cpX: (int)x {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return x/2.12;
	}
	else {
		return x;
	}
}

-(int) cpY: (int)y {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return y/2.2;
	}
	else {
		return y;
	}
}

-(id) init
{
	if( (self=[super init])) {
        
        self.isTouchEnabled = YES;
        
        // get screen size
        screenSize = [CCDirector sharedDirector].winSize;

        // Start the IAP Store
        
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
		[[CCDirector sharedDirector] resume];
		[[SimpleAudioEngine sharedEngine] setMute:NO];
		
		[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];  // This is necessary if using pvr.ccz
		
		// Add the Sprite Sheet
        
		// iPhone or iPad?
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"popper-levels-spritesheet.pvr.ccz"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"popper-levels-spritesheet.plist"];
        
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"popper-levels-spritesheet-hd.pvr.ccz"];
			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"popper-levels-spritesheet-hd.plist"];
		}
        [self addChild:spriteSheet];
        
        
		// Retrieve the current sound default
		playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_sounds"];
		
		// Retrieve the current music default
		playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_music"];
        
		// Retrieve the current level
		currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_current_level"];
        
        // Retrieve which Popper page was selected
		menuSelectionNo = [[NSUserDefaults standardUserDefaults] integerForKey:@"crazy_poppers_menu_selection"];
        
        // Retrieve which page was selected
        levelSelectionPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"crazy_poppers_level_selection"];
        
        highestLevel = 1;
        
        // If this is the first time, then set the menu selection to 1
        if (menuSelectionNo == 0) menuSelectionNo = 1;
        
		// Retrieve the highest level
        if (menuSelectionNo == 1) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper1_highest_level"];}
        else if (menuSelectionNo == 2) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper2_highest_level"];}
        else if (menuSelectionNo == 3) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper3_highest_level"];}
        else if (menuSelectionNo == 4) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper4_highest_level"];}
        else if (menuSelectionNo == 5) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper5_highest_level"];}
        else if (menuSelectionNo == 11) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popometerPack_highest_level"];}
        else if (menuSelectionNo == 12) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"megaPack1_highest_level"];}
        
        // Initialize the arrays
		_allPoppers = [[NSMutableArray alloc] init];
		_allSpinners = [[NSMutableArray alloc] init];
		_removePoppers = [[NSMutableArray alloc] init];
		_allHints = [[NSMutableArray alloc] init];
		_allRicochetWalls = [[NSMutableArray alloc] init];
        
        // Initialize the variables
        popometerCnt = 0;
        popperStartLocation = 0;
        pauseButtonStatus = 0;
        maxTaps = 0;
        currentTaps = 0;
        totalHintsRemaining = 0;
        popPitch = 1.1;
        counter = 0;
        popperScore = 0;
 
        levelComplete = NO;
		firstPass = YES;
        levelFail = NO;
        bannerDisplayed = NO;
        needAHintDisplayed = NO;
        buyGoldDisplayed = NO;
        buyGemsDisplayed = NO;
        notEnoughGemsDisplayed = NO;
        notEnoughGoldDisplayed = NO;
        playScreenDisplayed = NO;
        
        [self gameHeader];
        [self schedule: @selector(update:)];

    }
    return self;
}

- (void)gameHeader {
	
    int fontSize1, fontSize2;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 16;
		fontSize2 = 12;
	}
	else {
		fontSize1 = 34;
		fontSize2 = 24;
	}
        
    // Display the hints
	[self removeChildByTag:1003 cleanup:YES];
    int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
    NSString *hintStr = [NSString stringWithFormat:@"%d",hintCnt];
    
	CCLabelTTF *hintsLabel = [CCLabelTTF labelWithString:hintStr dimensions:CGSizeMake([self cpX:100],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
	hintsLabel.color = ccc3(0,0,0);
	[self addChild:hintsLabel z:4 tag:1003];
    
    // Display the gems
	[self removeChildByTag:1004 cleanup:YES];
    int gemCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
    NSString *gemStr = [NSString stringWithFormat:@"%d",gemCnt];
    
	CCLabelTTF *gemsLabel = [CCLabelTTF labelWithString:gemStr dimensions:CGSizeMake([self cpX:100],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
	gemsLabel.color = ccc3(0,0,0);
	[self addChild:gemsLabel z:4 tag:1004];
    
    // Display the gold
	[self removeChildByTag:1005 cleanup:YES];
    int goldCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
    NSString *goldStr = [NSString stringWithFormat:@"%d",goldCnt];
    
	CCLabelTTF *goldLabel = [CCLabelTTF labelWithString:goldStr dimensions:CGSizeMake([self cpX:110],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
	goldLabel.color = ccc3(0,0,0);
	[self addChild:goldLabel z:4 tag:1005];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		hintsLabel.position = ccp(251, 289);
		gemsLabel.position = ccp(165, 289);
		goldLabel.position = ccp(61, 289);
	}
	else {
		hintsLabel.position = ccp(527, 694);
		gemsLabel.position = ccp(347, 694);
		goldLabel.position = ccp(128, 694);
	}
    
    [self removeChildByTag:91 cleanup:YES];
    [self removeChildByTag:92 cleanup:YES];
    [self removeChildByTag:93 cleanup:YES];
    [self removeChildByTag:94 cleanup:YES];
    
    // Add Gold Header
    CCSprite *goldHeader = [CCSprite spriteWithSpriteFrameName:@"goldHeader.png"];
    [self addChild:goldHeader z:3 tag:91];
    
    // Add Gem Header
    CCSprite *gemHeader = [CCSprite spriteWithSpriteFrameName:@"gemHeader.png"];
    [self addChild:gemHeader z:3 tag:92];
    
    // Add Hints Header
    CCSprite *hintHeader = [CCSprite spriteWithSpriteFrameName:@"hintHeader.png"];
    [self addChild:hintHeader z:3 tag:93];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [goldHeader setPosition:ccp(60, 305)];
        [gemHeader setPosition:ccp(165, 305)];
        [hintHeader setPosition:ccp(253, 305)];
	}
	else {
        [goldHeader setPosition:ccp(126, 730)];
        [gemHeader setPosition:ccp(347, 730)];
        [hintHeader setPosition:ccp(531, 730)];
	}
}

-(void) hideHeader:(int)toggle {
    
    CCSprite *goldLabel = (CCSprite *)[self getChildByTag:1003];
    CCSprite *gemsLabel = (CCSprite *)[self getChildByTag:1004];
    CCSprite *hintsLabel = (CCSprite *)[self getChildByTag:1005];
    CCSprite *gold = (CCSprite *)[self getChildByTag:91];
    CCSprite *gems = (CCSprite *)[self getChildByTag:92];
    CCSprite *hints = (CCSprite *)[self getChildByTag:93];
    if (toggle == 0) {
        gold.visible = YES;
        gems.visible = YES;
        hints.visible = YES;
        goldLabel.visible = YES;
        gemsLabel.visible = YES;
        hintsLabel.visible = YES;
    }
    if (toggle == 1) {
        gold.visible = NO;
        gems.visible = NO;
        hints.visible = NO;
        goldLabel.visible = NO;
        gemsLabel.visible = NO;
        hintsLabel.visible = NO;
    }
}

-(void) expandSpriteEffect: (int)type {
	
	if (type != 0) {
 		if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:1.0 pan:1.0 gain:5.0];}
	}
	
	CCSprite *sprite;
	id actionMoveDone;
	id scaleUp = [CCScaleTo actionWithDuration:.1 scale:1.3];
	id scaleDown = [CCScaleTo actionWithDuration:.05 scale:1];
	
    
	// Gold Header
	if (type == 15) {
		sprite = (CCSprite *)[self getChildByTag:91];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displayBuyGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gem Header
	if (type == 16) {
		sprite = (CCSprite *)[self getChildByTag:92];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displayBuyGems)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Hint Header
	if (type == 17) {
		sprite = (CCSprite *)[self getChildByTag:93];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displayNeedAHint)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Red X for Gold, Gems & Hints
	if (type == 18) {
		sprite = (CCSprite *)[self getChildByTag:8100];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeGoldGemsHints)];
		[[CCDirector sharedDirector] resume];
	}
    
	// 2 Hints
	if (type == 19) {
		sprite = (CCSprite *)[self getChildByTag:8005];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(purchase2Hints)];
		[[CCDirector sharedDirector] resume];
	}
    
	// 12 Hints
	if (type == 20) {
		sprite = (CCSprite *)[self getChildByTag:8006];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(purchase12Hints)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Red X for Not Enough Gems
	if (type == 21) {
		sprite = (CCSprite *)[self getChildByTag:8201];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeNotEnoughGemsGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Red X for Not Enough Gold
	if (type == 22) {
		sprite = (CCSprite *)[self getChildByTag:8201];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeNotEnoughGemsGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gold 1
	if (type == 23) {
		sprite = (CCSprite *)[self getChildByTag:8021];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buyHandfulOfGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gold 2
	if (type == 24) {
		sprite = (CCSprite *)[self getChildByTag:8022];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buyStackOfGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gold 3
	if (type == 25) {
		sprite = (CCSprite *)[self getChildByTag:8023];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buyBagOfGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gold 4
	if (type == 26) {
		sprite = (CCSprite *)[self getChildByTag:8024];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buyBucketOfGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Free Gold
	if (type == 27) {
		sprite = (CCSprite *)[self getChildByTag:8025];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(getFreeGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gem 22
	if (type == 28) {
		sprite = (CCSprite *)[self getChildByTag:8021];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buy22Gems)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gem 48
	if (type == 29) {
		sprite = (CCSprite *)[self getChildByTag:8022];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buy48Gems)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gem 125
	if (type == 30) {
		sprite = (CCSprite *)[self getChildByTag:8023];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buy125Gems)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gem 270
	if (type == 31) {
		sprite = (CCSprite *)[self getChildByTag:8024];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buy270Gems)];
		[[CCDirector sharedDirector] resume];
	}
    
    
	// Red X for Play Background
	if (type == 32) {
		sprite = (CCSprite *)[self getChildByTag:8301];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(menu)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Play Button
	if (type == 33) {
		sprite = (CCSprite *)[self getChildByTag:8302];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removePlayScreen)];
		[[CCDirector sharedDirector] resume];
	}
    
    // Not Enough - Gem 22
	if (type == 34) {
		sprite = (CCSprite *)[self getChildByTag:8222];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buy22Gems)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Not Enough - Gem 48
	if (type == 35) {
		sprite = (CCSprite *)[self getChildByTag:8248];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buy48Gems)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Not Enough - Gem 125
	if (type == 36) {
		sprite = (CCSprite *)[self getChildByTag:82125];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buy125Gems)];
		[[CCDirector sharedDirector] resume];
	}
    
    // Not Enough - Gold 2000
	if (type == 37) {
		sprite = (CCSprite *)[self getChildByTag:832000];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buyHandfulOfGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Not Enough - Gold 4500
	if (type == 38) {
		sprite = (CCSprite *)[self getChildByTag:834500];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buyStackOfGold)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Not Enough - Gold 12000
	if (type == 39) {
		sprite = (CCSprite *)[self getChildByTag:8312000];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(buyBagOfGold)];
		[[CCDirector sharedDirector] resume];
	}
    
    // Free Hints
	if (type == 40) {
		sprite = (CCSprite *)[self getChildByTag:8007];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(reviewApp)];
		[[CCDirector sharedDirector] resume];
	}
    
	id action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[sprite runAction:action];
}

-(void) displayBuyGold {
    
    // Add semi-transparent black Background over the entire screen
    CCSprite *blackBackground = [CCSprite spriteWithSpriteFrameName:@"roundBackgroundBlack.png"];
    blackBackground.opacity = 200;
    blackBackground.scaleX = 1.7;
    blackBackground.scaleY = 2.4;
    [self addChild:blackBackground z:3 tag:101];
    
    buyGoldDisplayed = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"buyGoldDisplayed"];
    
    // Add the background
	CCSprite *buyGold = [CCSprite spriteWithSpriteFrameName:@"buyGold.png"];
    [self addChild:buyGold z:10 tag:8001];
    
    // Add the buttons
	CCSprite *gold1 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gold1 z:10 tag:8021];
	CCSprite *gold2 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gold2 z:10 tag:8022];
	CCSprite *gold3 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gold3 z:10 tag:8023];
	CCSprite *gold4 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gold4 z:10 tag:8024];
	CCSprite *freeGold = [CCSprite spriteWithSpriteFrameName:@"freeGoldButton.png"];
    [self addChild:freeGold z:10 tag:8025];
    
	// Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:11 tag:8100];

    NSString *price1 = @" ";
    NSString *price2 = @" ";
    NSString *price3 = @" ";
    NSString *price4 = @" ";

    int fontSize1;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        fontSize1 = 18;
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(screenSize.width/2+180, 300)];
		[buyGold setPosition:ccp(screenSize.width/2, 184)];
		[gold1 setPosition:ccp(screenSize.width/2-58, 213)];
		[gold2 setPosition:ccp(screenSize.width/2+118, 213)];
		[gold3 setPosition:ccp(screenSize.width/2-58, 135)];
		[gold4 setPosition:ccp(screenSize.width/2+118, 135)];
		[freeGold setPosition:ccp(screenSize.width/2, 80)];
        price1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];
        price2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];
        price3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];
        price4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"];
	}
	else {
        fontSize1 = 38;
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(screenSize.width/2+368, 710)];
		[buyGold setPosition:ccp(screenSize.width/2, 442)];
		[gold1 setPosition:ccp(screenSize.width/2-122, 505)];
		[gold2 setPosition:ccp(screenSize.width/2+228, 505)];
		[gold3 setPosition:ccp(screenSize.width/2-122, 340)];
		[gold4 setPosition:ccp(screenSize.width/2+228, 340)];
		[freeGold setPosition:ccp(screenSize.width/2, 230)];
        price1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];
        price2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];
        price3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];
        price4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"];
	}

    // Add the prices
    if ([price1 isEqualToString:@" "]) {
        price1 = @"BUY";
    }
    if ([price2 isEqualToString:@" "]) {
        price2 = @"BUY";
    }
    if ([price3 isEqualToString:@" "]) {
        price3 = @"BUY";
    }
    if ([price4 isEqualToString:@" "]) {
        price4 = @"BUY";
    }
    CCLabelTTF *price1Label = [CCLabelTTF labelWithString:price1 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price1Label.color = ccc3(0,0,0);
	[gold1 addChild:price1Label z:5];
    
    CCLabelTTF *price2Label = [CCLabelTTF labelWithString:price2 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price2Label.color = ccc3(0,0,0);
	[gold2 addChild:price2Label z:5];
    
    CCLabelTTF *price3Label = [CCLabelTTF labelWithString:price3 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price3Label.color = ccc3(0,0,0);
	[gold3 addChild:price3Label z:5];
    
    CCLabelTTF *price4Label = [CCLabelTTF labelWithString:price4 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price4Label.color = ccc3(0,0,0);
	[gold4 addChild:price4Label z:5];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        price1Label.position = ccp(35,-16);
        price2Label.position = ccp(35,-16);
        price3Label.position = ccp(35,-16);
        price4Label.position = ccp(35,-16);
    }
    else {
        price1Label.position = ccp(74,20);
        price2Label.position = ccp(74,20);
        price3Label.position = ccp(74,20);
        price4Label.position = ccp(74,20);
    }
    
    // Add Sale banner if price is lower than normal
    BOOL saleToday = [[NSUserDefaults standardUserDefaults] boolForKey:@"sale_today"];
    
    if (saleToday == YES) {
        CCSprite *saleBanner3 = [CCSprite spriteWithSpriteFrameName:@"saleBanner.png"];
        CCSprite *saleBanner4 = [CCSprite spriteWithSpriteFrameName:@"saleBanner.png"];
        [gold3 addChild:saleBanner3 z:15];
        [gold4 addChild:saleBanner4 z:15];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [saleBanner3 setPosition:ccp(38, 53)];
            [saleBanner4 setPosition:ccp(38, 53)];
        }
        else {
            [saleBanner3 setPosition:ccp(80, 127)];
            [saleBanner4 setPosition:ccp(80, 127)];
        }
    }
}

-(void) displayBuyGems {
    
    // Add semi-transparent black Background over the entire screen
    CCSprite *blackBackground = [CCSprite spriteWithSpriteFrameName:@"roundBackgroundBlack.png"];
    blackBackground.opacity = 200;
    blackBackground.scaleX = 1.7;
    blackBackground.scaleY = 2.4;
    [self addChild:blackBackground z:3 tag:101];
    
    buyGemsDisplayed = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"buyGemsDisplayed"];
    
    // Add the background
	CCSprite *buyGems = [CCSprite spriteWithSpriteFrameName:@"buyGems.png"];
    [self addChild:buyGems z:10 tag:8002];
    
    // Add the buttons
	CCSprite *gem1 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gem1 z:10 tag:8021];
	CCSprite *gem2 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gem2 z:10 tag:8022];
	CCSprite *gem3 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gem3 z:10 tag:8023];
	CCSprite *gem4 = [CCSprite spriteWithSpriteFrameName:@"blankButton.png"];
    [self addChild:gem4 z:10 tag:8024];
        
	// Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:11 tag:8100];

    NSString *price1 = @"";
    NSString *price2 = @"";
    NSString *price3 = @"";
    NSString *price4 = @"";
    
    int yOffset, fontSize1;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        fontSize1 = 18;
        yOffset = 5;
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(screenSize.width/2+180, 300)];
		[buyGems setPosition:ccp(screenSize.width/2, 180+yOffset)];
		[gem1 setPosition:ccp(screenSize.width/2-58, 210+yOffset)];
		[gem2 setPosition:ccp(screenSize.width/2+118, 210+yOffset)];
		[gem3 setPosition:ccp(screenSize.width/2-58, 135+yOffset)];
		[gem4 setPosition:ccp(screenSize.width/2+118, 135+yOffset)];
        price1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];
        price2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];
        price3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];
        price4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.270gems"];
	}
	else {
        fontSize1 = 38;
        yOffset = 12;
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(screenSize.width/2+368, 710)];
		[buyGems setPosition:ccp(screenSize.width/2, 442+yOffset)];
		[gem1 setPosition:ccp(screenSize.width/2-122, 510+yOffset)];
		[gem2 setPosition:ccp(screenSize.width/2+228, 510+yOffset)];
		[gem3 setPosition:ccp(screenSize.width/2-122, 340+yOffset)];
		[gem4 setPosition:ccp(screenSize.width/2+228, 340+yOffset)];
        price1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];
        price2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];
        price3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];
        price4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.270gems"];
	}
    
    // Add the prices
    if ([price1 isEqualToString:@" "]) {
        price1 = @"BUY";
    }
    if ([price2 isEqualToString:@" "]) {
        price2 = @"BUY";
    }
    if ([price3 isEqualToString:@" "]) {
        price3 = @"BUY";
    }
    if ([price4 isEqualToString:@" "]) {
        price4 = @"BUY";
    }
    CCLabelTTF *price1Label = [CCLabelTTF labelWithString:price1 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price1Label.color = ccc3(0,0,0);
	[gem1 addChild:price1Label z:5];

    CCLabelTTF *price2Label = [CCLabelTTF labelWithString:price2 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price2Label.color = ccc3(0,0,0);
	[gem2 addChild:price2Label z:5];

    CCLabelTTF *price3Label = [CCLabelTTF labelWithString:price3 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price3Label.color = ccc3(0,0,0);
	[gem3 addChild:price3Label z:5];

    CCLabelTTF *price4Label = [CCLabelTTF labelWithString:price4 dimensions:CGSizeMake(125,110) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	price4Label.color = ccc3(0,0,0);
	[gem4 addChild:price4Label z:5];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        price1Label.position = ccp(35,-16);
        price2Label.position = ccp(35,-16);
        price3Label.position = ccp(35,-16);
        price4Label.position = ccp(35,-16);
    }
    else {
        price1Label.position = ccp(74,20);
        price2Label.position = ccp(74,20);
        price3Label.position = ccp(74,20);
        price4Label.position = ccp(74,20);
    }

    // Add Sale banner if price is lower than normal
    BOOL saleToday = [[NSUserDefaults standardUserDefaults] boolForKey:@"sale_today"];    
    
    if (saleToday == YES) {
        CCSprite *saleBanner3 = [CCSprite spriteWithSpriteFrameName:@"saleBanner.png"];
        CCSprite *saleBanner4 = [CCSprite spriteWithSpriteFrameName:@"saleBanner.png"];
        [gem3 addChild:saleBanner3 z:15];
        [gem4 addChild:saleBanner4 z:15];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [saleBanner3 setPosition:ccp(38, 53)];
            [saleBanner4 setPosition:ccp(38, 53)];
        }
        else {
            [saleBanner3 setPosition:ccp(80, 127)];
            [saleBanner4 setPosition:ccp(80, 127)];
        }
    }
}

-(void) displayNeedAHint {
    
    int fontSize1;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 30;
	}
	else {
		fontSize1 = 42;
	}
    
    // Add semi-transparent black Background over the entire screen
    CCSprite *blackBackground = [CCSprite spriteWithSpriteFrameName:@"roundBackgroundBlack.png"];
    blackBackground.opacity = 200;
    blackBackground.scaleX = 1.7;
    blackBackground.scaleY = 2.4;
    [self addChild:blackBackground z:3 tag:101];
    
    needAHintDisplayed = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"needAHintDisplayed"];
	CCSprite *needAHint = [CCSprite spriteWithSpriteFrameName:@"needAHint.png"];
    [self addChild:needAHint z:10 tag:8003];
    
    // Display the buttons
    CCSprite *gems20 = [CCSprite spriteWithSpriteFrameName:@"20gemsButton.png"];
    [self addChild:gems20 z:11 tag:8005];
    CCSprite *gems110 = [CCSprite spriteWithSpriteFrameName:@"110gemsButton.png"];
    [self addChild:gems110 z:11 tag:8006];
    
    // Display the free hint offer
    BOOL offerFreeHints = [[NSUserDefaults standardUserDefaults] boolForKey:@"offer_4free_hints"];
    CCSprite *freeHints;
    if (offerFreeHints == YES) {
        freeHints = [CCSprite spriteWithSpriteFrameName:@"freeHints.png"];
        [self addChild:freeHints z:11 tag:8007];
    }

    // Display the hints
    int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
    NSString *hintStr = [NSString stringWithFormat:@"%d",hintCnt];
    
	CCLabelTTF *hintsLabel = [CCLabelTTF labelWithString:hintStr dimensions:CGSizeMake([self cpX:125],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	hintsLabel.color = ccc3(0,0,0);
	[self addChild:hintsLabel z:11 tag:8004];
    
	// Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:11 tag:8100];
    
    int yOffset;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        yOffset = 15;
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(screenSize.width/2+180, 300)];
		[needAHint setPosition:ccp(screenSize.width/2, 180+yOffset)];
		hintsLabel.position = ccp(screenSize.width/2-92, 85+yOffset);
		gems20.position = ccp(screenSize.width/2+120, 210+yOffset);
		gems110.position = ccp(screenSize.width/2+120, 135+yOffset);
        if (offerFreeHints == YES) {
            freeHints.position = ccp(screenSize.width/2+86, 82+yOffset);
        }
	}
	else {
        yOffset = 36;
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(screenSize.width/2+368, 710)];
		[needAHint setPosition:ccp(screenSize.width/2, 432+yOffset)];
		hintsLabel.position = ccp(screenSize.width/2-190, 215+yOffset);
		gems20.position = ccp(screenSize.width/2+242, 490+yOffset);
		gems110.position = ccp(screenSize.width/2+242, 340+yOffset);
        if (offerFreeHints == YES) {
            freeHints.position = ccp(screenSize.width/2+170, 275);
        }
	}
}

-(void) refreshHeader {
    
    [self removeGoldGemsHints];
    [self gameHeader];
}

-(void) removeGoldGemsHints {
	
    if (buyGoldDisplayed == YES) {
        buyGoldDisplayed = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGoldDisplayed"];
        [self removeChildByTag:8001 cleanup:YES];
        [self removeChildByTag:8021 cleanup:YES];
        [self removeChildByTag:8022 cleanup:YES];
        [self removeChildByTag:8023 cleanup:YES];
        [self removeChildByTag:8024 cleanup:YES];
        [self removeChildByTag:8025 cleanup:YES];
    }
    else if (buyGemsDisplayed == YES) {
        buyGemsDisplayed = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGemsDisplayed"];
        [self removeChildByTag:8002 cleanup:YES];
        [self removeChildByTag:8021 cleanup:YES];
        [self removeChildByTag:8022 cleanup:YES];
        [self removeChildByTag:8023 cleanup:YES];
        [self removeChildByTag:8024 cleanup:YES];
    }
    else if (needAHintDisplayed == YES) {
        needAHintDisplayed = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needAHintDisplayed"];
        [self removeChildByTag:8003 cleanup:YES];
        [self removeChildByTag:8004 cleanup:YES];
        [self removeChildByTag:8005 cleanup:YES];
        [self removeChildByTag:8006 cleanup:YES];
        [self removeChildByTag:8007 cleanup:YES];
    }
    
	// Remove the backgrounds
 	[self removeChildByTag:101 cleanup:YES];
	[self removeChildByTag:8100 cleanup:YES];
}

-(void) removeSprite:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
    
    if ((sprite.tag == 801) || (sprite.tag == 802) || (sprite.tag == 803) || (sprite.tag == 804)) {
        [_allSpinners removeObject:sprite];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) { //iterate through all the touches currently on the device
		CGPoint location = [touch locationInView: [touch view]]; //location of this touch
		location = [self convertTouchToNodeSpace: touch];

        // Make the pause button rect
        CCSprite *pause = (CCSprite *)[self getChildByTag:13];
        CGRect pauseButton = [pause boundingBox];
        
        // Make the hint button rect
        CCSprite *hint = (CCSprite *)[self getChildByTag:19];
        CGRect hintButton = [hint boundingBox];
        
		// Make the store button rect
 		CCSprite *storeSelector = (CCSprite *)[self getChildByTag:18];
		CGRect storeButton = [storeSelector boundingBox];
		
		// Make the repeat level button rect
 		CCSprite *repeatLevel = (CCSprite *)[self getChildByTag:15];
		CGRect repeatLevelButton = [repeatLevel boundingBox];
		
		// Make the menu button rect
		CCSprite *menu = (CCSprite *)[self getChildByTag:16];
		CGRect menuButton = [menu boundingBox];
		
		// Make the sound button rect
		CCSprite *sound = (CCSprite *)[self getChildByTag:2010];
		CGRect soundButton = [sound boundingBox];
		
		// Make the music button rect
		CCSprite *music = (CCSprite *)[self getChildByTag:2011];
		CGRect musicButton = [music boundingBox];
 		
		// Make the gold header rect
		CCSprite *goldHeader = (CCSprite *)[self getChildByTag:91];
		CGRect goldHeaderRect = [goldHeader boundingBox];
 		
		// Make the gem header rect
		CCSprite *gemHeader = (CCSprite *)[self getChildByTag:92];
		CGRect gemHeaderRect = [gemHeader boundingBox];
        
		// Make the hint header rect
		CCSprite *hintHeader = (CCSprite *)[self getChildByTag:93];
		CGRect hintHeaderRect = [hintHeader boundingBox];
		
        if (notEnoughGemsDisplayed == YES) {
            
            // Make Purchase Button rect
            CCSprite *gems22 = (CCSprite *)[self getChildByTag:8222];
            CGRect gems22Button = [gems22 boundingBox];
            CCSprite *gems48 = (CCSprite *)[self getChildByTag:8248];
            CGRect gems48Button = [gems48 boundingBox];
            CCSprite *gems125 = (CCSprite *)[self getChildByTag:82125];
            CGRect gems125Button = [gems125 boundingBox];

            // Make Rex X button rect
            CCSprite *redX = (CCSprite *)[self getChildByTag:8201];
            CGRect redXButton = [redX boundingBox];
            
            if (CGRectContainsPoint(redXButton, location)) [self expandSpriteEffect:kRedXNotEnoughGems];
            else if (CGRectContainsPoint(gems22Button, location)) [self expandSpriteEffect:kNotEnoughGems22];
            else if (CGRectContainsPoint(gems48Button, location)) [self expandSpriteEffect:kNotEnoughGems48];
            else if (CGRectContainsPoint(gems125Button, location)) [self expandSpriteEffect:kNotEnoughGems125];
           
        }
        else if (notEnoughGoldDisplayed == YES) {
            
            // Make Purchase Button rect
            CCSprite *gold2000 = (CCSprite *)[self getChildByTag:832000];
            CGRect gold2000Button = [gold2000 boundingBox];
            CCSprite *gold4500 = (CCSprite *)[self getChildByTag:834500];
            CGRect gold4500Button = [gold4500 boundingBox];
            CCSprite *gold12000 = (CCSprite *)[self getChildByTag:8312000];
            CGRect gold12000Button = [gold12000 boundingBox];
            

            // Make Rex X button rect
            CCSprite *redX = (CCSprite *)[self getChildByTag:8201];
            CGRect redXButton = [redX boundingBox];
            
            if (CGRectContainsPoint(redXButton, location)) [self expandSpriteEffect:kRedXNotEnoughGold];
            else if (CGRectContainsPoint(gold2000Button, location)) [self expandSpriteEffect:kNotEnoughGold2000];
            else if (CGRectContainsPoint(gold4500Button, location)) [self expandSpriteEffect:kNotEnoughGold4500];
            else if (CGRectContainsPoint(gold12000Button, location)) [self expandSpriteEffect:kNotEnoughGold12000];
        }
        else if (buyGoldDisplayed == YES) {
            
            // Make Gold button rects
            CCSprite *gold1 = (CCSprite *)[self getChildByTag:8021];
            CGRect gold1Button = [gold1 boundingBox];
            CCSprite *gold2 = (CCSprite *)[self getChildByTag:8022];
            CGRect gold2Button = [gold2 boundingBox];
            CCSprite *gold3 = (CCSprite *)[self getChildByTag:8023];
            CGRect gold3Button = [gold3 boundingBox];
            CCSprite *gold4 = (CCSprite *)[self getChildByTag:8024];
            CGRect gold4Button = [gold4 boundingBox];
            CCSprite *freeGold = (CCSprite *)[self getChildByTag:8025];
            CGRect freeGoldButton = [freeGold boundingBox];
            
            // Make Rex X button rect
            CCSprite *redX = (CCSprite *)[self getChildByTag:8100];
            CGRect redXButton = [redX boundingBox];
            
            if (CGRectContainsPoint(redXButton, location)) [self expandSpriteEffect:kRedX];
            if (CGRectContainsPoint(gold1Button, location)) [self expandSpriteEffect:kGold1];
            if (CGRectContainsPoint(gold2Button, location)) [self expandSpriteEffect:kGold2];
            if (CGRectContainsPoint(gold3Button, location)) [self expandSpriteEffect:kGold3];
            if (CGRectContainsPoint(gold4Button, location)) [self expandSpriteEffect:kGold4];
            if (CGRectContainsPoint(freeGoldButton, location)) [self expandSpriteEffect:kFreeGold];
        }
        else if (buyGemsDisplayed == YES) {
            
            // Make Gem button rects
            CCSprite *gem22 = (CCSprite *)[self getChildByTag:8021];
            CGRect gem22Button = [gem22 boundingBox];
            CCSprite *gem48 = (CCSprite *)[self getChildByTag:8022];
            CGRect gem48Button = [gem48 boundingBox];
            CCSprite *gem125 = (CCSprite *)[self getChildByTag:8023];
            CGRect gem125Button = [gem125 boundingBox];
            CCSprite *gem270 = (CCSprite *)[self getChildByTag:8024];
            CGRect gem270Button = [gem270 boundingBox];
            
            // Make Rex X button rect
            CCSprite *redX = (CCSprite *)[self getChildByTag:8100];
            CGRect redXButton = [redX boundingBox];
            
            if (CGRectContainsPoint(redXButton, location)) [self expandSpriteEffect:kRedX];
            if (CGRectContainsPoint(gem22Button, location)) [self expandSpriteEffect:kGem22];
            if (CGRectContainsPoint(gem48Button, location)) [self expandSpriteEffect:kGem48];
            if (CGRectContainsPoint(gem125Button, location)) [self expandSpriteEffect:kGem125];
            if (CGRectContainsPoint(gem270Button, location)) [self expandSpriteEffect:kGem270];
        }
        else if (needAHintDisplayed == YES) {
            
            // Make Rex X button rect
            CCSprite *redX = (CCSprite *)[self getChildByTag:8100];
            CGRect redXButton = [redX boundingBox];
            
            // Make the 20 gems rect
            CCSprite *gems20 = (CCSprite *)[self getChildByTag:8005];
            CGRect gems20Rect = [gems20 boundingBox];
            
            // Make the 110 gems rect
            CCSprite *gems110 = (CCSprite *)[self getChildByTag:8006];
            CGRect gems110Rect = [gems110 boundingBox];
                        
            // Make the free hints rect
            CCSprite *freeHints = (CCSprite *)[self getChildByTag:8007];
            CGRect freeHintsRect = [freeHints boundingBox];

            if (CGRectContainsPoint(redXButton, location)) [self expandSpriteEffect:kRedX];
            if (CGRectContainsPoint(gems20Rect, location)) [self expandSpriteEffect:k2Hints];
            if (CGRectContainsPoint(gems110Rect, location)) [self expandSpriteEffect:k12Hints];
            if (CGRectContainsPoint(freeHintsRect, location)) [self expandSpriteEffect:kFreeHints];
            
        }
        else {
            if (((levelComplete == NO) && (levelFail == NO)) || (pauseButtonStatus == 1)) {
                if (pauseButtonStatus == 0) {
                    if (CGRectContainsPoint(pauseButton, location)) [self expandSpriteEffect:kPauseGame];
                    if (CGRectContainsPoint(hintButton, location)) [self expandSpriteEffect:kHint];
                    if (CGRectContainsPoint(goldHeaderRect, location)) [self expandSpriteEffect:kGoldHeader];
                    if (CGRectContainsPoint(gemHeaderRect, location)) [self expandSpriteEffect:kGemHeader];
                    if (CGRectContainsPoint(hintHeaderRect, location)) [self expandSpriteEffect:kHintHeader];
                    
                    // See if any popper was touched
                    if ((maxTaps - currentTaps) > 0) {
                        [self popperTouch:location];
                    }
                }
                else {
                    if (CGRectContainsPoint(pauseButton, location)) [self expandSpriteEffect:kResumeGame];
                    if (CGRectContainsPoint(hintButton, location)) [self expandSpriteEffect:kHint];
                    if (CGRectContainsPoint(repeatLevelButton, location)) [self expandSpriteEffect:kNewGame];
                    if (CGRectContainsPoint(menuButton, location)) [self expandSpriteEffect:kMenu];
                    if (CGRectContainsPoint(soundButton, location)) [self expandSpriteEffect:kSoundToggle];
                    if (CGRectContainsPoint(musicButton, location)) [self expandSpriteEffect:kMusicToggle];
                    if (CGRectContainsPoint(storeButton, location)) [self expandSpriteEffect:kStoreSelector];
                }
            }
            else if ((levelComplete == YES) || (levelFail == YES)) {
                CCSprite *menuButton = (CCSprite *)[self getChildByTag:16];
                CGRect menuButtonSummary = [menuButton boundingBox];
                menuButtonSummary.origin.y = menuButtonSummary.origin.y - 20;
                CCSprite *repeatLevelButton = (CCSprite *)[self getChildByTag:15];
                CGRect repeatLevelButtonSummary = [repeatLevelButton boundingBox];
                repeatLevelButtonSummary.origin.y = repeatLevelButtonSummary.origin.y - 20;
                CCSprite *nextLevelButton = (CCSprite *)[self getChildByTag:17];
                CGRect nextLevelButtonSummary = [nextLevelButton boundingBox];
                nextLevelButtonSummary.origin.y = nextLevelButtonSummary.origin.y - 20;
                CCSprite *storeButton = (CCSprite *)[self getChildByTag:2012];
                CGRect storeButtonSummary = [storeButton boundingBox];
                storeButtonSummary.origin.y = storeButtonSummary.origin.y - 20;
                CCSprite *storeButton2 = (CCSprite *)[self getChildByTag:2013];
                CGRect storeButtonSummary2 = [storeButton2 boundingBox];
                storeButtonSummary2.origin.y = storeButtonSummary2.origin.y - 20;
                
                if (CGRectContainsPoint(menuButtonSummary, location)) [self expandSpriteEffect:kMenuSummary];
                if (CGRectContainsPoint(repeatLevelButtonSummary, location)) [self expandSpriteEffect:kNewGameSummary];
                if (CGRectContainsPoint(nextLevelButtonSummary, location)) [self expandSpriteEffect:kNextLevel];
                if (CGRectContainsPoint(storeButtonSummary, location)) [self expandSpriteEffect:kStoreSummary];
                if (CGRectContainsPoint(storeButtonSummary2, location)) [self expandSpriteEffect:kStoreSummary2];
                
                // Check PowerUps
                [self powerUpTouch:location];
            }
        }
    }
}

-(void) removeNotEnoughGemsGold {
	
    if (notEnoughGemsDisplayed == YES) {
        notEnoughGemsDisplayed = NO;
        [self removeChildByTag:8200 cleanup:YES];
        [self removeChildByTag:8202 cleanup:YES];
        [self removeChildByTag:8203 cleanup:YES];
        [self removeChildByTag:8222 cleanup:YES];
        [self removeChildByTag:8248 cleanup:YES];
        [self removeChildByTag:82125 cleanup:YES];
    }
    else if (notEnoughGoldDisplayed == YES) {
        notEnoughGoldDisplayed = NO;
        [self removeChildByTag:8300 cleanup:YES];
        [self removeChildByTag:8302 cleanup:YES];
        [self removeChildByTag:8303 cleanup:YES];
        [self removeChildByTag:832000 cleanup:YES];
        [self removeChildByTag:834500 cleanup:YES];
        [self removeChildByTag:8312000 cleanup:YES];
    }
    
	// Remove the RedX
	[self removeChildByTag:8201 cleanup:YES];
}

-(void) reviewApp {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"offer_4free_hints"];
    int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
    hintCnt = hintCnt + 4;
    [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
    [self refreshHeader];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSURL *url = [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=500775208"];
        
        if (![[UIApplication sharedApplication] openURL:url])
            
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
	}
	else {
        NSURL *url = [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=506721616"];
        
        if (![[UIApplication sharedApplication] openURL:url])
            
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
	}
}

-(void) freeGoldAdColony {
        
    [AdColony playVideoAdForSlot:1 withDelegate:self withV4VCPrePopup:YES andV4VCPostPopup:YES];
}

-(void) freeGoldTapjoySite {
    
    [Flurry logEvent:@"Tapjoy.com Clicked"];
    
    NSURL *url;
    url = [NSURL URLWithString:@"http://www.tapjoy.com"];
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

-(BOOL) notEnoughGemsGoldDisplayed {
    CCSprite *gemsDisplayed = (CCSprite *)[self getChildByTag:8200];
    CCSprite *goldDisplayed = (CCSprite *)[self getChildByTag:8300];
    
    if ((gemsDisplayed != nil) || (goldDisplayed != nil)) return YES;
    else return NO;
}

-(void) notEnoughGems:(int)diff {
    
    if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}

    notEnoughGemsDisplayed = YES;
    int fontSize1, fontSize2;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 30;
        fontSize2 = 14;
	}
	else {
		fontSize1 = 50;
        fontSize2 = 30;
	}
    
    // Indicate how many gems are needed
    gemsNeeded = 0;
    if (diff <= 22) {
        gemsNeeded = 22;
    }
    else if (diff <= 48) {
        gemsNeeded = 48;
   }
    else {
        gemsNeeded = 125;
    }
    
    CCSprite *notEnoughGems;
    NSString *productPrice = @" ";
    
    // Add the button
    CCSprite *buyGemsButton = [CCSprite spriteWithSpriteFrameName:@"buyGemsButton.png"];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        notEnoughGems = [CCSprite spriteWithFile:@"notEnoughGems.png"];

        if (gemsNeeded == 22) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];
            [self addChild:buyGemsButton z:12 tag:8222];
        }
        else if (gemsNeeded == 48) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];
            [self addChild:buyGemsButton z:12 tag:8248];
        }
        else {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];
            [self addChild:buyGemsButton z:12 tag:82125];
        }
    }
    else {
        notEnoughGems = [CCSprite spriteWithFile:@"notEnoughGems-hd.png"];

        if (gemsNeeded == 22) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];
            [self addChild:buyGemsButton z:12 tag:8222];
        }
        else if (gemsNeeded == 48) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];
            [self addChild:buyGemsButton z:12 tag:8248];
        }
        else {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];
            [self addChild:buyGemsButton z:12 tag:82125];
        }
    }
    [self addChild:notEnoughGems z:11 tag:8200];
    
    
    NSString *gemStr = [NSString stringWithFormat:@"%d",gemsNeeded];
    CCLabelTTF *gemsLabel = [CCLabelTTF labelWithString:gemStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
    gemsLabel.color = ccc3(0,0,0);
    [self addChild:gemsLabel z:11 tag:8202];
    
    NSString *priceStr;
    if ([productPrice isEqualToString:@" "]) {
        priceStr = [NSString stringWithFormat:@"%@",productPrice];}
    else {
        priceStr = [NSString stringWithFormat:@"for %@",productPrice];}
    CCLabelTTF *priceLabel = [CCLabelTTF labelWithString:priceStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
    priceLabel.color = ccc3(0,0,0);
    [self addChild:priceLabel z:11 tag:8203];
        
    // Add red X
    CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
    [self addChild:redX z:11 tag:8201];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [notEnoughGems setPosition:ccp(screenSize.width/2, 180)];
        [redX setPosition:ccp(screenSize.width/2+180, 295)];
        [gemsLabel setPosition:ccp(screenSize.width/2-105, 135)];
        [priceLabel setPosition:ccp(screenSize.width/2-105, 105)];
        [buyGemsButton setPosition:ccp(screenSize.width/2+47, 140)];
    }
    else {
        [notEnoughGems setPosition:ccp(screenSize.width/2, 430)];
        [redX setPosition:ccp(screenSize.width/2+368, 675)];
        [gemsLabel setPosition:ccp(screenSize.width/2-210, 334)];
        [priceLabel setPosition:ccp(screenSize.width/2-210, 262)];
        [buyGemsButton setPosition:ccp(screenSize.width/2+99, 350)];
    }
}

-(void) notEnoughGold:(int)diff {
    
    if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
    notEnoughGoldDisplayed = YES;
    int fontSize1, fontSize2;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 26;
        fontSize2 = 14;
	}
	else {
		fontSize1 = 44;
        fontSize2 = 30;
	}

    // Indicate how much gold is needed
    goldNeeded = 0;
    if (diff <= 2000) {
        goldNeeded = 2000;
    }
    else if (diff <= 4500) {
        goldNeeded = 4500;
    }
    else {
        goldNeeded = 12000;
    }
    
    CCSprite *notEnoughGold;
    NSString *productPrice = @" ";
        
    // Add the button
    CCSprite *buyGoldButton = [CCSprite spriteWithSpriteFrameName:@"buyGoldButton.png"];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        notEnoughGold = [CCSprite spriteWithFile:@"notEnoughGold.png"];

        if (goldNeeded == 2000) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];
            [self addChild:buyGoldButton z:12 tag:832000];
        }
        else if (goldNeeded == 4500) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];
            [self addChild:buyGoldButton z:12 tag:834500];
        }
        else {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];
            [self addChild:buyGoldButton z:12 tag:8312000];
        }
    }
    else {
        notEnoughGold = [CCSprite spriteWithFile:@"notEnoughGold-hd.png"];

        if (goldNeeded == 2000) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];
            [self addChild:buyGoldButton z:12 tag:832000];
        }
        else if (goldNeeded == 4500) {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];
            [self addChild:buyGoldButton z:12 tag:834500];
        }
        else {
            productPrice = [[NSUserDefaults standardUserDefaults] objectForKey:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];
            [self addChild:buyGoldButton z:12 tag:8312000];
        }
    }
    [self addChild:notEnoughGold z:11 tag:8300];
    
    
    NSString *str = [NSString stringWithFormat:@"%d",goldNeeded];
    CCLabelTTF *label = [CCLabelTTF labelWithString:str dimensions:CGSizeMake([self cpX:200],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
    label.color = ccc3(0,0,0);
    [self addChild:label z:11 tag:8302];
    
    NSString *priceStr;
    if ([productPrice isEqualToString:@" "]) {
        priceStr = [NSString stringWithFormat:@"%@",productPrice];}
    else {
        priceStr = [NSString stringWithFormat:@"for %@",productPrice];}
    CCLabelTTF *priceLabel = [CCLabelTTF labelWithString:priceStr dimensions:CGSizeMake([self cpX:200],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
    priceLabel.color = ccc3(0,0,0);
    [self addChild:priceLabel z:11 tag:8303];
    
    // Add red X
    CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
    [self addChild:redX z:11 tag:8201];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [notEnoughGold setPosition:ccp(screenSize.width/2, 180)];
        [redX setPosition:ccp(screenSize.width/2+180, 295)];
        [label setPosition:ccp(screenSize.width/2-105, 115)];
        [priceLabel setPosition:ccp(screenSize.width/2-105, 85)];
        [buyGoldButton setPosition:ccp(screenSize.width/2+50, 135)];
    }
    else {
        [notEnoughGold setPosition:ccp(screenSize.width/2, 432)];
        [redX setPosition:ccp(screenSize.width/2+368, 675)];
        [label setPosition:ccp(screenSize.width/2-210, 290)];
        [priceLabel setPosition:ccp(screenSize.width/2-210, 235)];
        [buyGoldButton setPosition:ccp(screenSize.width/2+105, 324)];
    }
}

-(void) buyHandfulOfGold {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:1];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) buyStackOfGold {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:2];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) buyBagOfGold {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:3];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) buyBucketOfGold {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:4];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) getFreeGold {
    
    [self freeGoldAdColony];
}

-(void) buy22Gems {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:5];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) buy48Gems {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:6];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) buy125Gems {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:7];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) buy270Gems {
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProductData:8];
    }
    else {
        miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
}

-(void) purchase2Hints {
    
    CCSprite *notEnoughGems;
    int fontSize1, fontSize2;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 30;
        fontSize2 = 14;
	}
	else {
		fontSize1 = 50;
        fontSize2 = 30;
	}
    
	int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
    
    // If not enough gems, notify the user
	if (gems < 20) {
        
        // Temporary  ////
//        gems = gems + 2;
//        [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
        //////////////////
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            notEnoughGems = [CCSprite spriteWithFile:@"notEnoughGems.png"];
        }
        else {
            notEnoughGems = [CCSprite spriteWithFile:@"notEnoughGems-hd.png"];
        }
        [self addChild:notEnoughGems z:11 tag:8200];
        notEnoughGemsDisplayed = YES;
        
        // Indicate that 22 gems are needed
        int gemsNeeded = 22;
        NSString *gemStr = [NSString stringWithFormat:@"%d",gemsNeeded];
        CCLabelTTF *gemsLabel = [CCLabelTTF labelWithString:gemStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
        gemsLabel.color = ccc3(0,0,0);
        [self addChild:gemsLabel z:11 tag:8202];

        int price = 99;
        NSString *priceStr = [NSString stringWithFormat:@"for $0.%d",price];
        CCLabelTTF *priceLabel = [CCLabelTTF labelWithString:priceStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
        priceLabel.color = ccc3(0,0,0);
        [self addChild:priceLabel z:11 tag:8203];

        // Add the button
        CCSprite *buyGemsButton = [CCSprite spriteWithSpriteFrameName:@"buyGemsButton.png"];
        [self addChild:buyGemsButton z:11 tag:8222];

        // Add red X
        CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
        [self addChild:redX z:11 tag:8201];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [notEnoughGems setPosition:ccp(screenSize.width/2, 180)];
            [redX setPosition:ccp(screenSize.width/2+180, 295)];
            [gemsLabel setPosition:ccp(screenSize.width/2-105, 135)];
            [priceLabel setPosition:ccp(screenSize.width/2-105, 105)];
            [buyGemsButton setPosition:ccp(screenSize.width/2+47, 140)];
        }
        else {
            [notEnoughGems setPosition:ccp(screenSize.width/2, 460)];
            [redX setPosition:ccp(screenSize.width/2+368, 708)];
            [gemsLabel setPosition:ccp(screenSize.width/2-210, 334)];
            [priceLabel setPosition:ccp(screenSize.width/2-210, 262)];
            [buyGemsButton setPosition:ccp(screenSize.width/2+99, 390)];

        }
	}
    
    // Otherwise, decrement the gems and add the hints
    else {
        gems = gems - 20;
        [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
        
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
        hintCnt = hintCnt + 2;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self removeGoldGemsHints];
        [self gameHeader];
    }
}

-(void) purchase12Hints {
    
    CCSprite *notEnoughGems;
    int fontSize1, fontSize2;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 30;
        fontSize2 = 14;
	}
	else {
		fontSize1 = 50;
        fontSize2 = 30;
	}
    
	int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
    
    // If not enough gems, notify the user
	if (gems < 110) {
        
        // Add the button
        CCSprite *buyGemsButton = [CCSprite spriteWithSpriteFrameName:@"buyGemsButton.png"];

        NSString *gemStr, *priceStr;
        CCLabelTTF *gemsLabel, *priceLabel;
        
        // If only 22 are needed
        if (gems >= 89) {
            [self addChild:buyGemsButton z:12 tag:8222];

            int gemsNeeded = 22;
            gemStr = [NSString stringWithFormat:@"%d",gemsNeeded];
            gemsLabel = [CCLabelTTF labelWithString:gemStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            gemsLabel.color = ccc3(0,0,0);
            
            int price = 99;
            priceStr = [NSString stringWithFormat:@"for $0.%d",price];
            priceLabel = [CCLabelTTF labelWithString:priceStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            priceLabel.color = ccc3(0,0,0);
        }
        // If 48 are needed
        else if (gems >= 63) {
            [self addChild:buyGemsButton z:12 tag:8248];
            
            int gemsNeeded = 48;
            gemStr = [NSString stringWithFormat:@"%d",gemsNeeded];
            gemsLabel = [CCLabelTTF labelWithString:gemStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            gemsLabel.color = ccc3(0,0,0);
            
            int price = 99;
            priceStr = [NSString stringWithFormat:@"for $1.%d",price];
            priceLabel = [CCLabelTTF labelWithString:priceStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            priceLabel.color = ccc3(0,0,0);
        }
        // If 125 are needed
        else {
            [self addChild:buyGemsButton z:12 tag:82125];
            
            int gemsNeeded = 125;
            gemStr = [NSString stringWithFormat:@"%d",gemsNeeded];
            gemsLabel = [CCLabelTTF labelWithString:gemStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            gemsLabel.color = ccc3(0,0,0);
            
            int price = 99;
            priceStr = [NSString stringWithFormat:@"for $4.%d",price];
            priceLabel = [CCLabelTTF labelWithString:priceStr dimensions:CGSizeMake([self cpX:150],[self cpY:100]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            priceLabel.color = ccc3(0,0,0);
        }

        [self addChild:gemsLabel z:12 tag:8202];
        [self addChild:priceLabel z:12 tag:8203];

        // Temporary  ////
//        gems = gems + 2;
//        [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
        //////////////////
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            notEnoughGems = [CCSprite spriteWithFile:@"notEnoughGems.png"];
        }
        else {
            notEnoughGems = [CCSprite spriteWithFile:@"notEnoughGems-hd.png"];
        }
        [self addChild:notEnoughGems z:11 tag:8200];
        notEnoughGemsDisplayed = YES;
        

        // Add red X
        CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
        [self addChild:redX z:11 tag:8201];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [notEnoughGems setPosition:ccp(screenSize.width/2, 180)];
            [redX setPosition:ccp(screenSize.width/2+180, 295)];
            [gemsLabel setPosition:ccp(screenSize.width/2-105, 135)];
            [priceLabel setPosition:ccp(screenSize.width/2-105, 105)];
            [buyGemsButton setPosition:ccp(screenSize.width/2+47, 140)];
        }
        else {
            [notEnoughGems setPosition:ccp(screenSize.width/2, 460)];
            [redX setPosition:ccp(screenSize.width/2+368, 708)];
            [gemsLabel setPosition:ccp(screenSize.width/2-210, 334)];
            [priceLabel setPosition:ccp(screenSize.width/2-210, 262)];
            [buyGemsButton setPosition:ccp(screenSize.width/2+99, 390)];
        }
	}
    
    // Otherwise, decrement the gems and add the hints
    else {
        gems = gems - 110;
        [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
        
        int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
        hintCnt = hintCnt + 12;
        [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self removeGoldGemsHints];
        [self gameHeader];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    // Handful of Gold
	if (alertView == handfulGoldUnlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];}
		}
		else {
			handfulGoldUnlock = nil;
		}
	}
    
    // Stack of Gold
	if (alertView == stackGoldUnlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];}
		}
		else {
			stackGoldUnlock = nil;
		}
	}
    
    // Bag of Gold
	if (alertView == bagGoldUnlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];}
		}
		else {
			bagGoldUnlock = nil;
		}
	}
    
    // Bucket of Gold
	if (alertView == bucketGoldUnlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"];}
		}
		else {
			bucketGoldUnlock = nil;
		}
	}
    
    // 22 Gems
	if (alertView == gem22Unlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];}
		}
		else {
			gem22Unlock = nil;
		}
	}
    
    // 48 Gems
	if (alertView == gem48Unlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];}
		}
		else {
			gem48Unlock = nil;
		}
	}
    
    // 125 Gems
	if (alertView == gem125Unlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];}
		}
		else {
			gem125Unlock = nil;
		}
	}
    
    // 270 Gems
	if (alertView == gem270Unlock) {
		if (buttonIndex == 1) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.270gems"];}
			else {
				[self purchaseProduct:@"au.com.incredibleadventure.PoppingBlowfish.270gems"];}
		}
		else {
			gem270Unlock = nil;
		}
	}
}

-(void) requestProductData: (int)identifier {
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		switch (identifier)
		{
 			case 1: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];break;}
			case 2: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];break;}
			case 3: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];break;}
			case 4: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"];break;}
			case 5: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];break;}
			case 6: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];break;}
			case 7: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];break;}
			case 8: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.270gems"];break;}
		}
	}
	else {
		switch (identifier)
		{
			case 1: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"];break;}
			case 2: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"];break;}
			case 3: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"];break;}
			case 4: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"];break;}
			case 5: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.22gems"];break;}
			case 6: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.48gems"];break;}
			case 7: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"];break;}
			case 8: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.270gems"];break;}
		}
	}
	
	Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSLog(@"No internet connection!");
		miscError = [[UIAlertView alloc] initWithTitle: @"No Internet Connection!" message: @"Cannot proceed with transaction.  Unable to establish an internet connection" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[miscError show];
		[miscError release];
    } else {
		SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
		request.delegate = self;
		[request start];
	}
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse: (SKProductsResponse *)response {
	
	SKProduct *product;
    //	product = [_storeProducts objectAtIndex:0];
    invalidProductIdentifiers = response.invalidProductIdentifiers;
    //  NSLog(@"Purchase request for: %@", response.invalidProductIdentifiers);
    if (invalidProductIdentifiers.count != 0) return;
    
	product = [response.products objectAtIndex:0];
	currentIdentifier = [NSString stringWithFormat:@"%@", product.productIdentifier];
    NSLog(@"Purchase request for: %@", product.productIdentifier);
	
	// format the price for the location
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:product.priceLocale];
	NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
    
	NSString *ggString = [NSString stringWithFormat:@"Do you want to buy one %@ for %@?",product.localizedTitle, formattedPrice];
	
	// populate UI
	if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"])
		|| ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"])) {
		handfulGoldUnlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[handfulGoldUnlock show];
		[handfulGoldUnlock release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"])) {
		stackGoldUnlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[stackGoldUnlock show];
		[stackGoldUnlock release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"])) {
		bagGoldUnlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[bagGoldUnlock show];
		[bagGoldUnlock release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"])) {
		bucketGoldUnlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[bucketGoldUnlock show];
		[bucketGoldUnlock release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.22gems"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.22gems"])) {
		gem22Unlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[gem22Unlock show];
		[gem22Unlock release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.48gems"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.48gems"])) {
		gem48Unlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[gem48Unlock show];
		[gem48Unlock release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"])) {
		gem125Unlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[gem125Unlock show];
		[gem125Unlock release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.270gems"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.270gems"])) {
		gem270Unlock = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[gem270Unlock show];
		[gem270Unlock release];
	}
	
	[request autorelease];
}

- (void) purchaseProduct:(NSString *)productIdentifier {
	
	NSLog(@"Purchasing product: %@", productIdentifier);
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
	// Record transaction on server side - not necessary at this point
}

- (void)provideContent:(NSString *)productIdentifier {
	
	int goldAmt = 0;
	int gemAmt = 0;
	
    NSLog(@"Adding hints for: %@", productIdentifier);
    
    if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"]) {
        goldAmt = 2000;
        [Flurry logEvent:@"Handful of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"]) {
        goldAmt = 4500;
        [Flurry logEvent:@"Stack of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"]) {
        goldAmt = 12000;
        [Flurry logEvent:@"Bag of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"]) {
        goldAmt = 25000;
        [Flurry logEvent:@"Bucket of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.22gems"]) {
        gemAmt = 22;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"22 Gems Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.48gems"]) {
        gemAmt = 48;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"48 Gems Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"]) {
        gemAmt = 125;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"125 Gems Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.270gems"]) {
        gemAmt = 270;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"270 Gems Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.handfulofgold"]) {
        goldAmt = 2000;
        [Flurry logEvent:@"Handful of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.stackofgold"]) {
        goldAmt = 4500;
        [Flurry logEvent:@"Stack of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bagofgold"]) {
        goldAmt = 12000;
        [Flurry logEvent:@"Bag of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.bucketofgold"]) {
        goldAmt = 25000;
        [Flurry logEvent:@"Bucket of Gold Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.22gems"]) {
        gemAmt = 22;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"22 Gems Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.48gems"]) {
        gemAmt = 48;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"48 Gems Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.125gems1"]) {
        gemAmt = 125;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"125 Gems Added"];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.270gems"]) {
        gemAmt = 270;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"remove_ads"];
        [Flurry logEvent:@"270 Gems Added"];
    }
    
    
    if (goldAmt > 0) {
        int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
        gold = gold + goldAmt;
        [[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"gold"];
        int localGoldPlusTapjoyGold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
        localGoldPlusTapjoyGold = localGoldPlusTapjoyGold + goldAmt;
        [[NSUserDefaults standardUserDefaults] setInteger:localGoldPlusTapjoyGold forKey:@"localGoldPlusTapjoyGold"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        [TapjoyConnect awardTapPoints:goldAmt];

        [[NSNotificationCenter defaultCenter] postNotificationName:productIdentifier object:productIdentifier];
        
        NSString *goldStr = [NSString stringWithFormat:@"You have successfully purchased %d gold",goldAmt];
        miscError = [[UIAlertView alloc] initWithTitle: @"Gold Purchased!" message:goldStr delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
        
        [self removeGoldGemsHints];
        [self removeNotEnoughGemsGold];
        [self gameHeader];
    }
    else if (gemAmt > 0) {
        int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
        gems = gems + gemAmt;
        [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:productIdentifier object:productIdentifier];
        
        NSString *gemStr = [NSString stringWithFormat:@"You have successfully purchased %d gems",gemAmt];
        miscError = [[UIAlertView alloc] initWithTitle: @"Gems Purchased!" message:gemStr delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
        
        [self removeGoldGemsHints];
        [self removeNotEnoughGemsGold];
        [self gameHeader];
    }
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
	
    NSLog(@"completeTransaction...");
	
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
	
    NSLog(@"restoreTransaction...");
	
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
	
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
	
    [[NSNotificationCenter defaultCenter] postNotificationName:transaction.transactionIdentifier object:transaction];
	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSDictionary *userDict = notification.userInfo;
    if ([[userDict objectForKey:@"free_hint"] isEqualToString:@"YES"]) {
        [self refreshHeader];
    }
    NSLog(@"Notification:%@",notification.userInfo);
}

-(void) countTimer {
    
    counter = counter + 1;
    
}

-(void) update: (ccTime) dt {
    
    // Update header if requested
    BOOL freshHeader = [[NSUserDefaults standardUserDefaults] boolForKey:@"update_goldGemsHints"];
    if (freshHeader == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"update_goldGemsHints"];
        [self refreshHeader];
    }
    
    // Display NeedAHint if requested from Poppers Level screen
    BOOL displayNeedAHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"displayNeedAHint"];
    if (displayNeedAHint == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"displayNeedAHint"];
        [self displayNeedAHint];
    }
    
    // Monitor for app promo gold aware
    NSString *promoName = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"promo_name"];
    BOOL promoRun = (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_promo_complete",promoName]];
    
    NSString *urlStr = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"promo_url"];
    NSURL *localUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",urlStr]];
    BOOL alreadyInstalled = [[UIApplication sharedApplication] canOpenURL:localUrl];
    
    if ((alreadyInstalled == YES) && (promoRun == NO)) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_promo_complete",promoName]];
        
        // If the gold is not blank, then award the gold
        NSString *goldStr = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"promo_gold"];
        NSString *gemsStr = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"promo_gems"];
        NSString *hintsStr = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"promo_hints"];
        
        // Award gold
        if (![goldStr isEqualToString:@" "]) {
            int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
            gold = gold + [goldStr integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"gold"];
            
            promoMsg = nil;
            promoMsg = [[UIAlertView alloc] initWithTitle:@"Gold Awarded!" message:[NSString stringWithFormat:@"Congratulations! You have just been awarded %d gold",[goldStr integerValue]] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [promoMsg show];
            [promoMsg release];
            
            [self removeGoldGemsHints];
            [self removeNotEnoughGemsGold];
            [self gameHeader];
        }
        
        // Award gems
        if (![gemsStr isEqualToString:@" "]) {
            int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
            gems = gems + [gemsStr integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
            
            promoMsg = nil;
            promoMsg = [[UIAlertView alloc] initWithTitle:@"Gems Awarded!" message:[NSString stringWithFormat:@"Congratulations! You have just been awarded %d gems",[gemsStr integerValue]] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [promoMsg show];
            [promoMsg release];
            
            [self removeGoldGemsHints];
            [self removeNotEnoughGemsGold];
            [self gameHeader];
        }
        
        // Award hints
        if (![hintsStr isEqualToString:@" "]) {
            int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
            hintCnt = hintCnt + [hintsStr integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
            
            promoMsg = nil;
            promoMsg = [[UIAlertView alloc] initWithTitle:@"Hints Awarded!" message:[NSString stringWithFormat:@"Congratulations! You have just been awarded %d hints",[hintsStr integerValue]] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [promoMsg show];
            [promoMsg release];
            
            [self removeGoldGemsHints];
            [self removeNotEnoughGemsGold];
            [self gameHeader];
       }
        
    }
}

- (void) dealloc
{
    [_allPoppers release];
	_allPoppers = nil;
    [_allSpinners release];
	_allSpinners = nil;
    [_removePoppers release];
	_removePoppers = nil;
    [_allHints release];
	_allHints = nil;
    [_allRicochetWalls release];
	_allRicochetWalls = nil;
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];  // for IAP
    
	[super dealloc];
}
@end
