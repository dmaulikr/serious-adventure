//
//  CrazyPoppersLevels.m
//  CrazyPlay
//
//  Created by Alan Trippe on 2/6/12.
//  Copyright (c) 2012 Trippin' Software. All rights reserved.
//

#import "CrazyPoppersLevels.h"
#import "CrazyPoppers.h"
#import "SimpleAudioEngine.h"
#import "CCParticleSystem.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "PopperPacks.h"
#import "BuyGoldGemsHints.h"
#import "Twitter/Twitter.h"
#import "Social/Social.h"
#import "RootViewController.h"
#import <RevMobAds/RevMobAds.h>
#import "Flurry.h"
#import "Chartboost.h"
#import "ALSdk.h"
#import "ALInterstitialAd.h"

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
#define kUndo 34
#define kInfoIcon 35
#define kRedXPowerUpInfo 36
#define kUndoSummary 37


@implementation CrazyPoppersLevelScene

-(id) init
{
	if( (self=[super init])) {
 		[self addChild:[CrazyPoppersLevelLayer node] z:1];
    }
    return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end

@implementation CrazyPoppersLevelLayer

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
        
		// Retrieve AppLovin flag
		appLovinActive = [[NSUserDefaults standardUserDefaults] boolForKey:@"applovin_active"];
        
		// Retrieve the current sound default
		playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_sounds"];
		
		// Retrieve the current music default
		playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_music"];
        
        // Set up the background music
		SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
		if (sae != nil) {
            BOOL musicPlaying = sae.isBackgroundMusicPlaying;
            if (musicPlaying == NO) {
                [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"poppersBackgroundMusic.wav"];
                
                [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.15f];
                if (playMusic == NO) {
                    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
                }
                else {
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"poppersBackgroundMusic.wav" loop:YES];
                }
            }
		}
		
		// Retrieve the current level
		currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_current_level"];
        
        // Retrieve which Popper page was selected 
		menuSelectionNo = [[NSUserDefaults standardUserDefaults] integerForKey:@"crazy_poppers_menu_selection"];
        
        // Retrieve which page was selected 
        levelSelectionPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"crazy_poppers_level_selection"];
        
        highestLevel = 1;
        
        // Initialize Chartboost
        cb = [Chartboost sharedChartboost];
        
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
        _undoArray = [[NSMutableArray alloc] init];
        
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
        doubleScore = 0;
        levelsPlayed = 0;
        
        // Default the Power Ups to a value of 2000/each
        powerUp1Value = 2000;
        powerUp2Value = 2000;
        powerUp3Value = 2000;
        powerUp4Value = 2000;
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint1"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint2"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint3"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint4"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint5"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint6"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint7"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint8"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint9"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint10"];
        
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
        rewardGem = NO;
        newHighScore = NO;
        powerUpInfoDisplayed = NO;
        
        // This is for testing purposes
        BOOL addGold = NO;

        // Add the user's earned gold to Tapjoy's servers (DO THIS ONLY 1 TIME!)
        BOOL updateGold = [[NSUserDefaults standardUserDefaults] boolForKey:@"update_tapjoy_gold"];
        if (updateGold == YES) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"update_tapjoy_gold"];
            int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"goober_gold"];
            [TapjoyConnect awardTapPoints:gold];
        }
        
        // Retrieve Tap Points
        [TapjoyConnect getTapPoints];

		BOOL startWithHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"start_with_hint"];
        if (startWithHint == YES) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"start_with_hint"];
            displayHint = YES;
            hintsActive = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"delay_hint"];
        }
        else {
            displayHint = NO;
            hintsActive = NO;
        }

        [self gameSetup];

    }
    return self;
}

-(void) gameSetup {
    
    // Remove the ad banner (if there is one)
	[self removeBanner];

    // Display the background
    CCSprite *background;
    NSInteger num = (arc4random() % 4) + 1;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) { // iPhone 5
            if (menuSelectionNo == 1) {
                background = [CCSprite spriteWithFile:@"popperBackground2Small-5hd.jpg"];}
            else if (menuSelectionNo == 2) {
                background = [CCSprite spriteWithFile:@"popperBackground1Small-5hd.jpg"];}
            else if (menuSelectionNo == 3) {
                background = [CCSprite spriteWithFile:@"popperBackground3Small-5hd.jpg"];}
            else if (menuSelectionNo == 4) {
                background = [CCSprite spriteWithFile:@"popperBackground4Small-5hd.jpg"];}
        }
        else {
        if (menuSelectionNo == 1) {
            background = [CCSprite spriteWithFile:@"popperBackground2Small.jpg"];}
        else if (menuSelectionNo == 2) {
            background = [CCSprite spriteWithFile:@"popperBackground1Small.jpg"];}
        else if (menuSelectionNo == 3) {
            background = [CCSprite spriteWithFile:@"popperBackground3Small.jpg"];}
        else if (menuSelectionNo == 4) {
            background = [CCSprite spriteWithFile:@"popperBackground4Small.jpg"];}
        }
    }
    else {
        if (menuSelectionNo == 1) {
            background = [CCSprite spriteWithFile:@"popperBackground2.jpg"];}
        else if (menuSelectionNo == 2) {
            background = [CCSprite spriteWithFile:@"popperBackground1.jpg"];}
        else if (menuSelectionNo == 3) {
            background = [CCSprite spriteWithFile:@"popperBackground3.jpg"];}
        else if (menuSelectionNo == 4) {
            background = [CCSprite spriteWithFile:@"popperBackground4.jpg"];}
    }
    
    if ((menuSelectionNo == 11) || (menuSelectionNo == 12)) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            if (screenBounds.size.height == 568) { // iPhone 5
                switch (num)
                {
                    case 1: {background = [CCSprite spriteWithFile:@"popperBackground1Small-5hd.jpg"]; break;}
                    case 2: {background = [CCSprite spriteWithFile:@"popperBackground2Small-5hd.jpg"]; break;}
                    case 3: {background = [CCSprite spriteWithFile:@"popperBackground3Small-5hd.jpg"]; break;}
                    case 4: {background = [CCSprite spriteWithFile:@"popperBackground4Small-5hd.jpg"]; break;}
                }
            }
            else {                
                switch (num)
                {
                    case 1: {background = [CCSprite spriteWithFile:@"popperBackground1Small.jpg"]; break;}
                    case 2: {background = [CCSprite spriteWithFile:@"popperBackground2Small.jpg"]; break;}
                    case 3: {background = [CCSprite spriteWithFile:@"popperBackground3Small.jpg"]; break;}
                    case 4: {background = [CCSprite spriteWithFile:@"popperBackground4Small.jpg"]; break;}
                }
            }
        }
        else {
            switch (num)
            {
                case 1: {background = [CCSprite spriteWithFile:@"popperBackground1.jpg"]; break;}
                case 2: {background = [CCSprite spriteWithFile:@"popperBackground2.jpg"]; break;}
                case 3: {background = [CCSprite spriteWithFile:@"popperBackground3.jpg"]; break;}
                case 4: {background = [CCSprite spriteWithFile:@"popperBackground4.jpg"]; break;}
            }
        }
    }
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
    }
    else {
        [background setPosition:ccp(512, 384)];
    }
    [self addChild:background z:-1];
    
    // Add Pause button
	CCSprite *pause = [CCSprite spriteWithSpriteFrameName:@"pauseButton.png"];
	[self addChild:pause z:2 tag:13];
    
	// Show the hint button
	CCSprite *hint = [CCSprite spriteWithSpriteFrameName:@"hintButton.png"];
	[self addChild:hint z:3 tag:19];
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        hint.position = ccp(35, 27);
		pause.position = ccp(screenSize.width-25, 25);
	}
	else {
        hint.position = ccp(75, 50);
		pause.position = ccp(screenSize.width-50, 50);
	}
    
    // Bounce the hint bulb
    [self bounceSprite:hint];
    
    // Add the level number
    [self addLevel];

     // Add the popometer
     if (menuSelectionNo != 11) {
     [self popometerSetup:5 random:NO];
     }
     else {
     [self popometerSetup:5 random:YES];
     }
    
    // Display the play window with PowerUps if this is started from the menu
    BOOL startedFromMenu = [[NSUserDefaults standardUserDefaults] boolForKey:@"level_started_from_menu"];
    if (startedFromMenu == YES) {
        [self displayPlayScreen];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"level_started_from_menu"];
    }
    else {
        [self gameSetup2];
    }
}

-(void) gameSetup2 {
    
    // Remove the ad banner (if there is one)
	[self removeBanner];
    
    // For Testing Only //////////
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"remove_ads"];
    /////////////////
    
    [self schedule: @selector(update:)];
    [self schedule: @selector(countTimer) interval:.5];
    
    // Build the levels to Popper Pack 1
    if (menuSelectionNo == 1) {
        
        if (currentLevel == 1) {[self buildPack1Level1];}
        if (currentLevel == 2) {[self buildPack1Level2];}
        if (currentLevel == 3) {[self buildPack1Level3];}
        if (currentLevel == 4) {[self buildPack1Level4];}
        if (currentLevel == 5) {[self buildPack1Level5];}
        if (currentLevel == 6) {[self buildPack1Level6];}
        if (currentLevel == 7) {[self buildPack1Level7];}
        if (currentLevel == 8) {[self buildPack1Level8];}
        if (currentLevel == 9) {[self buildPack1Level9];}
        if (currentLevel == 10) {[self buildPack1Level10];}
        if (currentLevel == 11) {[self buildPack1Level11];}
        if (currentLevel == 12) {[self buildPack1Level12];}
        if (currentLevel == 13) {[self buildPack1Level13];}
        if (currentLevel == 14) {[self buildPack1Level14];}
        if (currentLevel == 15) {[self buildPack1Level15];}
        if (currentLevel == 16) {[self buildPack1Level16];}
        if (currentLevel == 17) {[self buildPack1Level17];}
        if (currentLevel == 18) {[self buildPack1Level18];}
        if (currentLevel == 19) {[self buildPack1Level19];}
        if (currentLevel == 20) {[self buildPack1Level20];}
        if (currentLevel == 21) {[self buildPack1Level21];}
        if (currentLevel == 22) {[self buildPack1Level22];}
        if (currentLevel == 23) {[self buildPack1Level23];}
        if (currentLevel == 24) {[self buildPack1Level24];}
        if (currentLevel == 25) {[self buildPack1Level25];}
        if (currentLevel == 26) {[self buildPack1Level26];}
        if (currentLevel == 27) {[self buildPack1Level27];}
        if (currentLevel == 28) {[self buildPack1Level28];}
        if (currentLevel == 29) {[self buildPack1Level29];}
        if (currentLevel == 30) {[self buildPack1Level30];}
        if (currentLevel == 31) {[self buildPack1Level31];}
        if (currentLevel == 32) {[self buildPack1Level32];}
        if (currentLevel == 33) {[self buildPack1Level33];}
        if (currentLevel == 34) {[self buildPack1Level34];}
        if (currentLevel == 35) {[self buildPack1Level35];}
        if (currentLevel == 36) {[self buildPack1Level36];}
        if (currentLevel == 37) {[self buildPack1Level37];}
        if (currentLevel == 38) {[self buildPack1Level38];}
        if (currentLevel == 39) {[self buildPack1Level39];}
        if (currentLevel == 40) {[self buildPack1Level40];}
        if (currentLevel == 41) {[self buildPack1Level41];}
        if (currentLevel == 42) {[self buildPack1Level42];}
        if (currentLevel == 43) {[self buildPack1Level43];}
        if (currentLevel == 44) {[self buildPack1Level44];}
        if (currentLevel == 45) {[self buildPack1Level45];}
        if (currentLevel == 46) {[self buildPack1Level46];}
        if (currentLevel == 47) {[self buildPack1Level47];}
        if (currentLevel == 48) {[self buildPack1Level48];}
        if (currentLevel == 49) {[self buildPack1Level49];}
        if (currentLevel == 50) {[self buildPack1Level50];}
        if (currentLevel == 51) {[self buildPack1Level51];}
        if (currentLevel == 52) {[self buildPack1Level52];}
        if (currentLevel == 53) {[self buildPack1Level53];}
        if (currentLevel == 54) {[self buildPack1Level54];}
        if (currentLevel == 55) {[self buildPack1Level55];}
        if (currentLevel == 56) {[self buildPack1Level56];}
        if (currentLevel == 57) {[self buildPack1Level57];}
        if (currentLevel == 58) {[self buildPack1Level58];}
        if (currentLevel == 59) {[self buildPack1Level59];}
        if (currentLevel == 60) {[self buildPack1Level60];}
        if (currentLevel == 61) {[self buildPack1Level61];}
        if (currentLevel == 62) {[self buildPack1Level62];}
        if (currentLevel == 63) {[self buildPack1Level63];}
        if (currentLevel == 64) {[self buildPack1Level64];}
        if (currentLevel == 65) {[self buildPack1Level65];}
        if (currentLevel == 66) {[self buildPack1Level66];}
        if (currentLevel == 67) {[self buildPack1Level67];}
        if (currentLevel == 68) {[self buildPack1Level68];}
        if (currentLevel == 69) {[self buildPack1Level69];}
        if (currentLevel == 70) {[self buildPack1Level70];}
        if (currentLevel == 71) {[self buildPack1Level71];}
        if (currentLevel == 72) {[self buildPack1Level72];}
        if (currentLevel == 73) {[self buildPack1Level73];}
        if (currentLevel == 74) {[self buildPack1Level74];}
        if (currentLevel == 75) {[self buildPack1Level75];}
        if (currentLevel == 76) {[self buildPack1Level76];}
        if (currentLevel == 77) {[self buildPack1Level77];}
        if (currentLevel == 78) {[self buildPack1Level78];}
        if (currentLevel == 79) {[self buildPack1Level79];}
        if (currentLevel == 80) {[self buildPack1Level80];}
        if (currentLevel == 81) {[self buildPack1Level81];}
        if (currentLevel == 82) {[self buildPack1Level82];}
        if (currentLevel == 83) {[self buildPack1Level83];}
        if (currentLevel == 84) {[self buildPack1Level84];}
        if (currentLevel == 85) {[self buildPack1Level85];}
        if (currentLevel == 86) {[self buildPack1Level86];}
        if (currentLevel == 87) {[self buildPack1Level87];}
        if (currentLevel == 88) {[self buildPack1Level88];}
        if (currentLevel == 89) {[self buildPack1Level89];}
        if (currentLevel == 90) {[self buildPack1Level90];}
        if (currentLevel == 91) {[self buildPack1Level91];}
        if (currentLevel == 92) {[self buildPack1Level92];}
        if (currentLevel == 93) {[self buildPack1Level93];}
        if (currentLevel == 94) {[self buildPack1Level94];}
        if (currentLevel == 95) {[self buildPack1Level95];}
        if (currentLevel == 96) {[self buildPack1Level96];}
        if (currentLevel == 97) {[self buildPack1Level97];}
        if (currentLevel == 98) {[self buildPack1Level98];}
        if (currentLevel == 99) {[self buildPack1Level99];}
        if (currentLevel == 100) {[self buildPack1Level100];}
        if (currentLevel == 101) {[self buildPack1Level101];}
        if (currentLevel == 102) {[self buildPack1Level102];}
        if (currentLevel == 103) {[self buildPack1Level103];}
        if (currentLevel == 104) {[self buildPack1Level104];}
        if (currentLevel == 105) {[self buildPack1Level105];}
    }
    
    // Build the levels for all other packs
    else if (menuSelectionNo != 1) {
        PopperPacks *getLevel = [PopperPacks requestLevelID:menuSelectionNo level:currentLevel];
        NSString *levelID = [[NSUserDefaults standardUserDefaults] objectForKey:@"levelID_request"];
		int taps = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxTaps_request"];
		int h1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint1_request"];
		int h2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint2_request"];
		int h3 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint3_request"];
		int h4 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint4_request"];
		int h5 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint5_request"];
		int h6 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint6_request"];
		int h7 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint7_request"];
		int h8 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint8_request"];
		int h9 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint9_request"];
		int h10 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint10_request"];
        maxTaps = taps;
        
        // Flip the level? (Flip for Popometer Pack (11) and Mega Pack #1 (12))
        if ((menuSelectionNo == 11) || (menuSelectionNo == 12))  {
            levelID = [self flipLevel:levelID];
            h1 = [self flipHint:h1];
            h2 = [self flipHint:h2];
            h3 = [self flipHint:h3];
            h4 = [self flipHint:h4];
            h5 = [self flipHint:h5];
            h6 = [self flipHint:h6];
            h7 = [self flipHint:h7];
            h8 = [self flipHint:h8];
            h9 = [self flipHint:h9];
            h10 = [self flipHint:h10];
        }
        [self loadPoppers:levelID];
        [self loadHints:h1 h2:h2 h3:h3 h4:h4 h5:h5 h6:h6 h7:h7 h8:h8 h9:h9 h10:h10];
    }
    
    // Build the game header
    [self gameHeader];
}

- (void)gameHeader {
    
    // Add Taps Left
    [self displayTapsLeft];

    // Display the Gold, Gems & Hints
    [self removeChildByTag:8000 cleanup:YES];
    [self displayGoldGemHints];
    
    [self removeChildByTag:91 cleanup:YES];
    [self removeChildByTag:92 cleanup:YES];
    [self removeChildByTag:93 cleanup:YES];
    [self removeChildByTag:94 cleanup:YES];
    
    // Add Taps Header
    CCSprite *tapsHeader = [CCSprite spriteWithSpriteFrameName:@"tapsHeader.png"];
    [self addChild:tapsHeader z:3 tag:94];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [tapsHeader setPosition:ccp(screenSize.width-55, 305)];
	}
	else {
        [tapsHeader setPosition:ccp(screenSize.width-116, 730)];
	}
    
    [self removeChildByTag:1201 cleanup:YES];
    [self removeChildByTag:1202 cleanup:YES];
    [self removeChildByTag:1203 cleanup:YES];
    
    // Display the active PowerUps
    BOOL tap1PowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"tap+1PowerUp"];
    BOOL x2PowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"x2PowerUp"];
    BOOL undoPowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"undoPowerUp"];

    CCSprite *powerUp1, *powerUp2, *powerUp3;
    
    if (tap1PowerUp == YES) {
        powerUp1 = [CCSprite spriteWithSpriteFrameName:@"tap+1.png"];
        [self addChild:powerUp1 z:5 tag:1201];
        powerUp1.scale = .9;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            powerUp1.position = ccp(screenSize.width-170, 305);
        }
        else {
            powerUp1.position = ccp(screenSize.width-357, 732);
        }
        
        // If Tap+1 PowerUp was selected, then add 1 to the Max Taps
        [self addTap];
    }
    if (x2PowerUp == YES) {
        powerUp2 = [CCSprite spriteWithSpriteFrameName:@"megaScorer.png"];
        [self addChild:powerUp2 z:5 tag:1202];
        powerUp2.scale = .9;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            powerUp2.position = ccp(screenSize.width-145, 305);
        }
        else {
            powerUp2.position = ccp(screenSize.width-305, 732);
        }
    }
    if (undoPowerUp == YES) {
        powerUp3 = [CCSprite spriteWithSpriteFrameName:@"undo.png"];
        [self addChild:powerUp3 z:5 tag:1203];
        powerUp3.scale = .65;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
             powerUp3.position = ccp(screenSize.width-120, 305);
        }
        else {
            powerUp3.position = ccp(screenSize.width-252, 732);
        }
    }
}

-(void) displayTapsLeft {
    int fontSize1, fontSize2;

    [self removeChildByTag:1001 cleanup:YES];
	[self removeChildByTag:1002 cleanup:YES];
    
    //	NSString *scoreStr = [NSString stringWithFormat:@"Taps Remaining: %d",maxTaps - currentTaps];
	NSString *scoreStr = [NSString stringWithFormat:@"%d",maxTaps - currentTaps];
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 16;
		fontSize2 = 12;
	}
	else {
		fontSize1 = 32;
		fontSize2 = 30;
	}
    
    // Display the taps
    CCLabelTTF *tapsRemainingShadow = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake([self cpX:50],[self cpY:100]) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	tapsRemainingShadow.color = ccc3(255,255,255);
	[self addChild:tapsRemainingShadow z:4 tag:1002];
    
	CCLabelTTF *tapsRemainingLabel = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake([self cpX:50],[self cpY:100]) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	tapsRemainingLabel.color = ccc3(0,0,0);
	[self addChild:tapsRemainingLabel z:4 tag:1001];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		tapsRemainingLabel.position = ccp(screenSize.width-14, 293);
	}
	else {
		tapsRemainingLabel.position = ccp(screenSize.width-29, 700);
	}
}

-(void) addTap {
        
    // Add the additional tap
    maxTaps = maxTaps + 1;

    // Scale the Tap+1 PowerUp icon up/down
    CCSprite *tap1PowerUp = (CCSprite *)[self getChildByTag:1201];
    
	id scaleUp = [CCScaleTo actionWithDuration:.5 scale:2];
	id scaleDown = [CCScaleTo actionWithDuration:.5 scale:1];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(ping)];
    id addTap = [CCCallFuncN actionWithTarget:self selector:@selector(displayTapsLeft)];
    id action = [CCSequence actions:scaleUp, scaleDown, scaleUp, scaleDown, scaleUp, scaleDown, actionMoveDone, addTap, nil];
    
	[tap1PowerUp runAction:action];
    
    // Fade the "Taps Left" image in/out
    CCSprite *tapsLeft = (CCSprite *)[self getChildByTag:94];
    
    id appear = [CCFadeTo actionWithDuration:.5 opacity:255];
    id disappear = [CCFadeTo actionWithDuration:.5 opacity:0];
    action = [CCSequence actions:appear, disappear, appear, disappear, appear, appear, nil];
    
	[tapsLeft runAction:action];
    
    // Reset the PowerUp
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tap+1PowerUp"];
}

-(void) displayBanner {
    
    if (currentLevel <= 4) return;  // Only start displaying banners after the 4th level

    CGSize adSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        adSize.width = GAD_SIZE_320x50.width;
        adSize.height = GAD_SIZE_320x50.height;
    }
    else {
        adSize.width = GAD_SIZE_728x90.width;
        adSize.height = GAD_SIZE_728x90.height;
    }
    
    // Change the adSize to width & height of 1, if displaying at bottom of screen (this will convey to the receiving
    // routine to move it to the bottom
    //    if (((maxTaps - currentTaps) < 0) && (levelFail == NO)) {
    if ((levelFail != YES) && (levelComplete != YES)) {
        adSize.width = 1;
        adSize.height = 1;
    }
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] displayGoogleAd:adSize];
    bannerDisplayed = YES;
}

-(void) removeBanner {
    
    // Remove RevMob banner
//    [[RevMobAds session] hideBanner];
    
    if (bannerDisplayed != YES) return;
    
    bannerDisplayed = NO;
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeGoogleAd];
}

-(void) displayPlayScreen {
    
    playScreenDisplayed = YES;
    
    // Add semi-transparent black Background over the entire screen
    CCSprite *blackBackground = [CCSprite spriteWithSpriteFrameName:@"roundBackgroundBlack.png"];
    blackBackground.opacity = 200;
    blackBackground.scaleX = 1.7;
    blackBackground.scaleY = 2.4;
    [self addChild:blackBackground z:3 tag:101];

    CCSprite *playBackground = [CCSprite spriteWithSpriteFrameName:@"playBackground.png"];
	[self addChild:playBackground z:8 tag:8300];

    // Display the Gold, Gems & Hints
    [self displayGoldGemHints];

    // Add Play Button
	CCSprite *play = [CCSprite spriteWithSpriteFrameName:@"play.png"];
	[self addChild:play z:10 tag:8302];

    // Add PowerUps
    [self powerUpSetup:currentLevel];
    
    // Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:9 tag:8301];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(screenSize.width/2+180, 277)];
        [playBackground setPosition:ccp(screenSize.width/2, 167)];
        [play setPosition:ccp(screenSize.width/2, 110)];
	}
    else {
        blackBackground.position = ccp(512,384);
		[redX setPosition:ccp(screenSize.width/2+370, 620)];
        [playBackground setPosition:ccp(512, 400)];
        [play setPosition:ccp(512, 300)];
    }
}

-(void) removePlayScreen {

    [self purchasePowerUps];
	[self removeChildByTag:8000 cleanup:YES];

    playScreenDisplayed = NO;
  	[self removeChildByTag:101 cleanup:YES];
  	[self removeChildByTag:250 cleanup:YES];
  	[self removeChildByTag:601 cleanup:YES];
  	[self removeChildByTag:602 cleanup:YES];
  	[self removeChildByTag:603 cleanup:YES];
  	[self removeChildByTag:604 cleanup:YES];
    [self removeChildByTag:605 cleanup:YES];
    [self removeChildByTag:606 cleanup:YES];
	[self removeChildByTag:8300 cleanup:YES];
	[self removeChildByTag:8301 cleanup:YES];
	[self removeChildByTag:8302 cleanup:YES];
	[self resumeGame];
    
    [self gameSetup2];
}

-(void) powerUpSetup:(int)level {
    
    int tapPlus = 1000;
    if (currentLevel >= 20) tapPlus = 1500;
    if (currentLevel >= 35) tapPlus = 2000;
    if (currentLevel >= 50) tapPlus = 2500;
    
    if ((currentLevel < 5) && (menuSelectionNo == 1)) {
        [self addPowerUps:0 p2:0 p3:0 p4:0];
    }
    else if ((currentLevel < 5) && (menuSelectionNo != 1)) {
        [self addPowerUps:500 p2:500 p3:500 p4:500];
    }
    else if (currentLevel == 5) {
        [self addPowerUps:200 p2:0 p3:0 p4:0];
    }
    else if (currentLevel == 6) {
        [self addPowerUps:500 p2:200 p3:0 p4:0];
    }
    else if (currentLevel == 7) {
        [self addPowerUps:500 p2:500 p3:200 p4:0];
    }
    else if (currentLevel == 8) {
        [self addPowerUps:500 p2:500 p3:500 p4:500];
    }
    else if (currentLevel == 9) {
        [self addPowerUps:500 p2:500 p3:500 p4:500];
    }
    else if ((currentLevel == 20) || (currentLevel == 40) || (currentLevel == 60) || (currentLevel == 80) || (currentLevel == 100)) {
        [self addPowerUps:8 p2:tapPlus p3:12 p4:500];
    }
    else if ((currentLevel == 10) || (currentLevel == 30) || (currentLevel == 50) || (currentLevel == 70) || (currentLevel == 90)) {
        [self addPowerUps:700 p2:16 p3:700 p4:8];
    }
    else {
        [self addPowerUps:700 p2:tapPlus p3:700 p4:500];
    }
}

-(void) addPowerUps:(int)p1 p2:(int)p2 p3:(int)p3 p4:(int)p4 {
    
    powerUp1Value = p1;
    powerUp2Value = p2;
    powerUp3Value = p3;
    powerUp4Value = p4;

    int yOffset = 5;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"undoPowerUp"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tap+1PowerUp"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"x2PowerUp"];
    
    if (playScreenDisplayed == YES) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            yOffset = 20;
        }
        else {
            yOffset = 45;
        }
    }
    
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    BOOL noAdsPowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"noAdsPowerUp"];
    //// Note: for 2.0.1 remove No Ads powerup (i.e. make it always YES)
    noAdsPowerUp = YES;
    ////
    
    CCSprite *powerUp1, *powerUp2, *powerUp3, *powerUp4, *infoIcon;
    // Add Undo PowerUp
    if (p1 == 0) {
        powerUp1 = [CCSprite spriteWithSpriteFrameName:@"powerUpLocked.png"];
        [self addChild:powerUp1 z:10 tag:601];
        powerUp1.userData = @"LOCKED";
    }
    if (p2 == 0) {
        powerUp2 = [CCSprite spriteWithSpriteFrameName:@"powerUpLocked.png"];
        [self addChild:powerUp2 z:10 tag:602];
        powerUp2.userData = @"LOCKED";
    }
    if (p3 == 0) {
        powerUp3 = [CCSprite spriteWithSpriteFrameName:@"powerUpLocked.png"];
        [self addChild:powerUp3 z:10 tag:603];
        powerUp3.userData = @"LOCKED";
    }
    
    // Only add the Remove Ads Power Up if ads haven't already been removed
    if (p4 == 0) {
        powerUp4 = [CCSprite spriteWithSpriteFrameName:@"powerUpLocked.png"];
        powerUp4.userData = @"LOCKED";
        if ((removeAds != YES) && (noAdsPowerUp != YES)) {
            [self addChild:powerUp4 z:10 tag:604];
        }
     }
    
    if (p1 > 0) {
        // Add Undo PowerUp
        [self removeChildByTag:601 cleanup:YES];
        powerUp1 = [CCSprite spriteWithSpriteFrameName:@"powerUp1Off.png"];
        [self addChild:powerUp1 z:10 tag:601];
        powerUp1.userData = @"OFF";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"undoPowerUp"];
    }
    
    if (p2 > 0) {
        // Add Extra Tap PowerUp
        [self removeChildByTag:602 cleanup:YES];
        powerUp2 = [CCSprite spriteWithSpriteFrameName:@"powerUp2Off.png"];
        [self addChild:powerUp2 z:10 tag:602];
        powerUp2.userData = @"OFF";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tap+1PowerUp"];
        
        // Set the PowerUp Value
        powerUp2Value = p2;
    }
    
    if (p3 > 0) {
        // Add Mega Scorer PowerUp
        [self removeChildByTag:603 cleanup:YES];
        powerUp3 = [CCSprite spriteWithSpriteFrameName:@"powerUp3Off.png"];
        [self addChild:powerUp3 z:10 tag:603];
        powerUp3.userData = @"OFF";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"x2PowerUp"];
        
        // Set the PowerUp Value
        powerUp3Value = p3;
    }
    
    // Only add the Remove Ads Power Up if ads haven't already been removed
    
    if (p4 > 0) {
        // Add Remove Ads PowerUp
        [self removeChildByTag:604 cleanup:YES];
        powerUp4 = [CCSprite spriteWithSpriteFrameName:@"powerUp4Off.png"];
        powerUp4.userData = @"OFF";
        
        // Set the PowerUp Value
        powerUp4Value = p4;
        
        if ((removeAds != YES) && (noAdsPowerUp != YES)) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"noAdsPowerUp"];
            [self addChild:powerUp4 z:10 tag:604];
        }
    }

    
    // Display the info icon
    if (((currentLevel > 5) && (menuSelectionNo == 1)) || (menuSelectionNo != 1)) {
        infoIcon = [CCSprite spriteWithSpriteFrameName:@"infoIcon.png"];
        [self addChild:infoIcon z:8 tag:250];
    }
    
    // Position the PowerUps
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ((removeAds != YES) && (noAdsPowerUp != YES)) {
            [powerUp1 setPosition:ccp(screenSize.width/2-97, 155+yOffset)];
            [powerUp2 setPosition:ccp(screenSize.width/2-32, 155+yOffset)];
            [powerUp3 setPosition:ccp(screenSize.width/2+33, 155+yOffset)];
            [powerUp4 setPosition:ccp(screenSize.width/2+98, 155+yOffset)];
        }
        else {
            [powerUp1 setPosition:ccp(screenSize.width/2-65, 155+yOffset)];
            [powerUp2 setPosition:ccp(screenSize.width/2, 155+yOffset)];
            [powerUp3 setPosition:ccp(screenSize.width/2+65, 155+yOffset)];
        }

        int yOffset = 0;
        if ((levelComplete == YES) || (levelFail == YES)) {
            yOffset = -25;
        }
        
        if (((currentLevel > 5) && (menuSelectionNo == 1)) || (menuSelectionNo != 1)) {
            [infoIcon setPosition:ccp(screenSize.width/2+110, 225+yOffset)];
        }
	}
	else {
        if ((removeAds != YES) && (noAdsPowerUp != YES)) {
            [powerUp1 setPosition:ccp(screenSize.width/2-204, 372+yOffset)];
            [powerUp2 setPosition:ccp(screenSize.width/2-67, 372+yOffset)];
            [powerUp3 setPosition:ccp(screenSize.width/2+69, 372+yOffset)];
            [powerUp4 setPosition:ccp(screenSize.width/2+206, 372+yOffset)];
        }
        else {
            [powerUp1 setPosition:ccp(screenSize.width/2-137, 372+yOffset)];
            [powerUp2 setPosition:ccp(screenSize.width/2, 372+yOffset)];
            [powerUp3 setPosition:ccp(screenSize.width/2+137, 372+yOffset)];
        }
        int yOffset = 0;
        if ((levelComplete == YES) || (levelFail == YES)) {
            yOffset = -60;
        }
        if (((currentLevel > 5) && (menuSelectionNo == 1)) || (menuSelectionNo != 1)) {
            [infoIcon setPosition:ccp(screenSize.width/2+231, 540+yOffset)];
        }
    }
    
    int fontSize1;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        fontSize1 = 11;}
    else {
        fontSize1 = 22;}
    
    // Display the Power Up Values (Note: If value is less than 100, then assume gem instead of gold)
    if (![powerUp1.userData isEqualToString:@"LOCKED"]) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",powerUp1Value] dimensions:CGSizeMake(200,100) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];

        CCSprite *goldGem;
        int xOffset = 0;
        if (powerUp1Value >= 100) { // Display the gold
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        }
        else {  // Display the gem            
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gem.png"];
            xOffset = 10;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            label.position = ccp(120+xOffset,-34);
            goldGem.position = ccp(11+xOffset,10);
        }
        else {
            label.position = ccp(145+xOffset,-20);
            goldGem.position = ccp(25+xOffset,20);
        }
        [powerUp1 addChild:goldGem z:10 tag:2];
        [powerUp1 addChild:label z:10 tag:1];
        label.color = ccc3(50,50,50);
        goldGem.scale = .6;
    }

    if (![powerUp2.userData isEqualToString:@"LOCKED"]) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",powerUp2Value] dimensions:CGSizeMake(200,100) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
        
        CCSprite *goldGem;
        int xOffset = 0;
        if (powerUp2Value >= 100) { // Display the gold
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        }
        else {  // Display the gem
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gem.png"];
            xOffset = 10;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            label.position = ccp(120+xOffset,-34);
            goldGem.position = ccp(11+xOffset,10);
        }
        else {
            label.position = ccp(145+xOffset,-20);
            goldGem.position = ccp(23+xOffset,20);
        }
        [powerUp2 addChild:goldGem z:10 tag:2];
        [powerUp2 addChild:label z:10 tag:1];
        label.color = ccc3(50,50,50);
        goldGem.scale = .6;
    }

    if (![powerUp3.userData isEqualToString:@"LOCKED"]) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",powerUp3Value] dimensions:CGSizeMake(200,100) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
        
        CCSprite *goldGem;
        int xOffset = 0;
        if (powerUp3Value >= 100) { // Display the gold
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        }
        else {  // Display the gem
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gem.png"];
            xOffset = 10;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            label.position = ccp(120+xOffset,-34);
            goldGem.position = ccp(11+xOffset,10);
        }
        else {
            label.position = ccp(145+xOffset,-20);
            goldGem.position = ccp(23+xOffset,20);
        }
        [powerUp3 addChild:goldGem z:10 tag:2];
        [powerUp3 addChild:label z:10 tag:1];
        label.color = ccc3(50,50,50);
        goldGem.scale = .6;
    }

    if (![powerUp4.userData isEqualToString:@"LOCKED"]) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",powerUp4Value] dimensions:CGSizeMake(200,100) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
        
        CCSprite *goldGem;
        int xOffset = 0;
        if (powerUp4Value >= 100) { // Display the gold
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        }
        else {  // Display the gem
            goldGem = [CCSprite spriteWithSpriteFrameName:@"gem.png"];
            xOffset = 10;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            label.position = ccp(120+xOffset,-34);
            goldGem.position = ccp(11+xOffset,10);
        }
        else {
            label.position = ccp(145+xOffset,-20);
            goldGem.position = ccp(23+xOffset,20);
        }
        [powerUp4 addChild:goldGem z:10 tag:2];
        [powerUp4 addChild:label z:10 tag:1];
        label.color = ccc3(50,50,50);
        goldGem.scale = .6;
    }
    
    // If this is level 5, show the flashing yellow arrow
    if ((currentLevel == 5) && (levelFail != YES))  {
        CCSprite *yellowArrow = [CCSprite spriteWithSpriteFrameName:@"yellowArrow.png"];
        [self addChild:yellowArrow z:11 tag:605];
        CCSprite *description1 = [CCSprite spriteWithSpriteFrameName:@"powerUpDescription1.png"];
        [self addChild:description1 z:10 tag:606];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [yellowArrow setPosition:ccp(screenSize.width/2-87, 185+yOffset)];
            [description1 setPosition:ccp(screenSize.width/2-20, 225+yOffset)];
        }
        else {
            [yellowArrow setPosition:ccp(screenSize.width/2-183, 444+yOffset)];
            [description1 setPosition:ccp(screenSize.width/2-42, 540+yOffset)];
        }
        yellowArrow.flipX = YES;
        id appear = [CCFadeTo actionWithDuration:1 opacity:255];
        id disappear = [CCFadeTo actionWithDuration:1 opacity:0];
        id action = [CCSequence actions:appear, disappear, nil];
        [yellowArrow runAction:[CCRepeatForever actionWithAction:action]];
    }
}

-(void) powerUpTouch:(CGPoint)location {
    
    // PowerUp 1 Rect
    CCSprite *powerUp1 = (CCSprite *)[self getChildByTag:601];
    CGRect powerUp1Rect = [powerUp1 boundingBox];

    // PowerUp 2 Rect
    CCSprite *powerUp2 = (CCSprite *)[self getChildByTag:602];
    CGRect powerUp2Rect = [powerUp2 boundingBox];

    // PowerUp 3 Rect
    CCSprite *powerUp3 = (CCSprite *)[self getChildByTag:603];
    CGRect powerUp3Rect = [powerUp3 boundingBox];

    // PowerUp 4 Rect
    CCSprite *powerUp4 = (CCSprite *)[self getChildByTag:604];
    CGRect powerUp4Rect = [powerUp4 boundingBox];
    NSLog(@"P1:%@ P2:%@ P3:%@ P4:%@",powerUp1.userData,powerUp2.userData,powerUp3.userData,powerUp4.userData);
    
    if (CGRectContainsPoint(powerUp1Rect, location)) {
        if ([powerUp1.userData isEqualToString:@"OFF"]) {
            BOOL enoughCurrency = [self powerUpPurchaseCheck:1];
            if (enoughCurrency == YES) {
                if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
                CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
                CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp1On.png"];
                [powerUp1 setDisplayFrame:frame];
                powerUp1.userData = @"ON";
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"undoPowerUp"];
            }
        }
        else if ([powerUp1.userData isEqualToString:@"ON"]) {
            if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp1Off.png"];
            [powerUp1 setDisplayFrame:frame];
            powerUp1.userData = @"OFF";
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"undoPowerUp"];
        }
        
    }
    if (CGRectContainsPoint(powerUp2Rect, location)) {
        if ([powerUp2.userData isEqualToString:@"OFF" ]) {
            BOOL enoughCurrency = [self powerUpPurchaseCheck:2];
            if (enoughCurrency == YES) {
                if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
                CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
                CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp2On.png"];
                [powerUp2 setDisplayFrame:frame];
                powerUp2.userData = @"ON";
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tap+1PowerUp"];
            }
        }
        else if ([powerUp2.userData isEqualToString:@"ON"]) {
            if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp2Off.png"];
            [powerUp2 setDisplayFrame:frame];
            powerUp2.userData = @"OFF";
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tap+1PowerUp"];
        }
    }
    if (CGRectContainsPoint(powerUp3Rect, location)) {
        if ([powerUp3.userData isEqualToString:@"OFF"]) {
            BOOL enoughCurrency = [self powerUpPurchaseCheck:3];
            if (enoughCurrency == YES) {
                if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
                CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
                CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp3On.png"];
                [powerUp3 setDisplayFrame:frame];
                powerUp3.userData = @"ON";
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"x2PowerUp"];
            }
        }
        else if ([powerUp3.userData isEqualToString:@"ON"]) {
            if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp3Off.png"];
            [powerUp3 setDisplayFrame:frame];
            powerUp3.userData = @"OFF";
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"x2PowerUp"];
        }
    }
    if (CGRectContainsPoint(powerUp4Rect, location)) {
        if ([powerUp4.userData isEqualToString:@"OFF"]) {
            BOOL enoughCurrency = [self powerUpPurchaseCheck:4];
            if (enoughCurrency == YES) {
                if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
                CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
                CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp4On.png"];
                [powerUp4 setDisplayFrame:frame];
                powerUp4.userData = @"ON";
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noAdsPowerUp"];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"noAdsPowerUp_Count"];
            }
        }
        else if ([powerUp4.userData isEqualToString:@"ON"]) {
            if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            CCSpriteFrame *frame = [frameCache spriteFrameByName:@"powerUp4Off.png"];
            [powerUp4 setDisplayFrame:frame];
            powerUp4.userData = @"OFF";
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"noAdsPowerUp"];
        }
    }

}

-(void) addLevel {
	
	int fontSize1, y1, x, y;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        y1 = 50;
		fontSize1 = 14;
        x = 66;
        y = 285;
	}
	else {
        y1 = 100;
		fontSize1 = 34;
        x = 140;
        y = 660;
    }
    
    [self removeChildByTag:1013 cleanup:YES];
    [self removeChildByTag:1014 cleanup:YES];
	
	NSString *levelStr = @"";
	if (menuSelectionNo == 1) {
        levelStr = [NSString stringWithFormat:@"Level: 1-%d",currentLevel];
    }
	else if (menuSelectionNo == 2) {
        levelStr = [NSString stringWithFormat:@"Level: 2-%d",currentLevel];
    }
	else if (menuSelectionNo == 3) {
        levelStr = [NSString stringWithFormat:@"Level: 3-%d",currentLevel];
    }
	else if (menuSelectionNo == 4) {
        levelStr = [NSString stringWithFormat:@"Level: 4-%d",currentLevel];
    }
	else if (menuSelectionNo == 5) {
        levelStr = [NSString stringWithFormat:@"Level: 5-%d",currentLevel];
    }
    else if (menuSelectionNo == 11) {
        levelStr = [NSString stringWithFormat:@"Level: P-%d",currentLevel];
    }
    else if (menuSelectionNo == 12) {
        levelStr = [NSString stringWithFormat:@"Level: M-%d",currentLevel];
    }
    
	
	// Add shadow
	CCLabelTTF *labelShadow = [CCLabelTTF labelWithString:levelStr dimensions:CGSizeMake([self cpX:200],[self cpY:y1]) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	labelShadow.position = ccp(x+1,y-1);
	[self addChild:labelShadow z:1 tag:1014];
	
	CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:levelStr dimensions:CGSizeMake([self cpX:200],[self cpY:y1]) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	scoreLabel.position = ccp(x, y);
	[self addChild:scoreLabel z:1 tag:1013];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        labelShadow.color = ccc3(0,0,0);
        scoreLabel.color = ccc3(255,255,255);
    }
    else {
        labelShadow.color = ccc3(0,0,0);
        scoreLabel.color = ccc3(255,255,255);
    }
    
    id appear = [CCFadeTo actionWithDuration:2 opacity:255];
	id delay = [CCFadeTo actionWithDuration:5 opacity:255];
	id disappear = [CCFadeTo actionWithDuration:1 opacity:0];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)];
	id action = [CCSequence actions:appear, delay, disappear, actionMoveDone, nil];
	[scoreLabel runAction:action];
	appear = [CCFadeTo actionWithDuration:2 opacity:255];
	delay = [CCFadeTo actionWithDuration:5 opacity:255];
	disappear = [CCFadeTo actionWithDuration:1 opacity:0];
	actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)];
	action = [CCSequence actions:appear, delay, disappear, actionMoveDone, nil];
	[labelShadow runAction:action];
}

-(void) saveHighScore: (int)level score:(int)score {
	
    if (menuSelectionNo == 1) {
        NSString *str = [NSString stringWithFormat:@"popper1_level%d_highScore",level];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:str];
    }
    if (menuSelectionNo == 2) {
        NSString *str = [NSString stringWithFormat:@"popper2_level%d_highScore",level];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:str];
    }
    if (menuSelectionNo == 3) {
        NSString *str = [NSString stringWithFormat:@"popper3_level%d_highScore",level];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:str];
    }
    if (menuSelectionNo == 4) {
        NSString *str = [NSString stringWithFormat:@"popper4_level%d_highScore",level];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:str];
    }
    if (menuSelectionNo == 5) {
        NSString *str = [NSString stringWithFormat:@"popper5_level%d_highScore",level];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:str];
    }
    if (menuSelectionNo == 11) {
        NSString *str = [NSString stringWithFormat:@"popometerPack_level%d_highScore",level];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:str];
    }
    if (menuSelectionNo == 12) {
        NSString *str = [NSString stringWithFormat:@"megaPack1_level%d_highScore",level];
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:str];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int) getHighScore: (int)level {
	
    int highScore;
    
    if (menuSelectionNo == 1) {
        NSString *str = [NSString stringWithFormat:@"popper1_level%d_highScore",level];
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:str];
    }
    if (menuSelectionNo == 2) {
        NSString *str = [NSString stringWithFormat:@"popper2_level%d_highScore",level];
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:str];
    }
    if (menuSelectionNo == 3) {
        NSString *str = [NSString stringWithFormat:@"popper3_level%d_highScore",level];
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:str];
    }
    if (menuSelectionNo == 4) {
        NSString *str = [NSString stringWithFormat:@"popper4_level%d_highScore",level];
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:str];
    }
    if (menuSelectionNo == 5) {
        NSString *str = [NSString stringWithFormat:@"popper5_level%d_highScore",level];
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:str];
    }
    if (menuSelectionNo == 11) {
        NSString *str = [NSString stringWithFormat:@"popometerPack_level%d_highScore",level];
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:str];
    }
    if (menuSelectionNo == 12) {
        NSString *str = [NSString stringWithFormat:@"megaPack1_level%d_highScore",level];
        highScore = [[NSUserDefaults standardUserDefaults] integerForKey:str];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return highScore;
}

-(void) scoreDoubler: (int)score {
    
    // First, make the x2 image grow in size and move
    CCSprite *x2 = [CCSprite spriteWithSpriteFrameName:@"megaScorer.png"];
    [self addChild:x2 z:12];
    x2.opacity = 0;
    x2.scale = 10;
    x2.rotation = -20;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        x2.position = ccp(screenSize.width/2-165,235);
    }
    else {
        x2.position = ccp(screenSize.width/2-307,225);
    }

    doubleScore = score;
    
	id appear = [CCFadeTo actionWithDuration:.75 opacity:255];
	id scaleDown = [CCScaleTo actionWithDuration:.75 scale:2];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(ping)];
    id doubleScore = [CCCallFuncN actionWithTarget:self selector:@selector(scoreDoubler2)];
    id action = [CCSpawn actions:
				 [CCSequence actions:scaleDown, actionMoveDone, doubleScore, nil],
                 [CCSequence actions:appear, nil, nil],nil];

	[x2 runAction:action];
}

-(void) scoreDoubler2 {
    
    // Double the score
    int score = doubleScore * 2;
    
    // Retrieve the high score
    int highScore = [self getHighScore:currentLevel];
	
	// If a new high score, then save it
	if (score > highScore) {
        newHighScore = YES;
        [self saveHighScore:currentLevel score:score];
    }
	
	// Display the score
	[self displayScore:score];
    
    // Display the reward
    [self calculateReward:score];
}

-(void) ping {
    if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"ping.caf"];}
}

-(void) displayScore: (int)score {
	
	int fontSize1, y1, yOffset;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 22;
        y1 = 60;
        yOffset = 0;
	}
	else {
		fontSize1 = 40;
        y1 = 145;
        yOffset = 0;
	}
	
	// Display the score
	NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
	[self removeChildByTag:1015 cleanup:YES];
	[self removeChildByTag:1016 cleanup:YES];
	
	// Add shadow
	CCLabelTTF *labelShadow = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake([self cpX:400],[self cpY:200]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	labelShadow.color = ccc3(0,0,0);
	[self addChild:labelShadow z:8 tag:1016];
	
	CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake([self cpX:400],[self cpY:200]) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	scoreLabel.color = ccc3(255,255,255);
	[self addChild:scoreLabel z:8 tag:1015];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        labelShadow.position = ccp(screenSize.width/2-45+2,195-2 + yOffset);
        scoreLabel.position = ccp(screenSize.width/2-45, 195 + yOffset);
    }
    else {
        labelShadow.position = ccp(screenSize.width/2-105+2,80-2 + yOffset);
        scoreLabel.position = ccp(screenSize.width/2-105, 80 + yOffset);
    }
}

-(void) calculateScore {
	int score = 0;
	int temp = 0;
    newHighScore = NO;
	
	// Add the bonus for time interval (Max. 10000)
	temp = 10000 - ((counter * 100)/2);
	if (temp > 0) score = score + temp;
	
    // Add the calculated time score to the popper score
    score = score + popperScore;

    // Retrieve the high score
    int highScore = [self getHighScore:currentLevel];
	
	// If a new high score, then save it
	if (score > highScore) {
        newHighScore = YES;
        [self saveHighScore:currentLevel score:score];
    }
	
	// Display the score
	[self displayScore:score];
    
    // See if the "x2" PowerUp is used
    BOOL x2PowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"x2PowerUp"];
    if (x2PowerUp == YES) {
        [self scoreDoubler:score];
    }
    else {        
        // Display the reward
        [self calculateReward:score];
    }
}

-(void) saveGold: (int)cnt {
    
    int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"gold"];
    gold = gold + cnt;
	[[NSUserDefaults standardUserDefaults] setInteger:gold forKey:@"gold"];
    int localGoldPlusTapjoyGold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
    localGoldPlusTapjoyGold = localGoldPlusTapjoyGold + cnt;
    [[NSUserDefaults standardUserDefaults] setInteger:localGoldPlusTapjoyGold forKey:@"localGoldPlusTapjoyGold"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    [TapjoyConnect getTapPoints];
}

-(void) saveGems: (int)cnt {

    int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
    gems = gems + cnt;
    [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) displayReward: (int)score {
	
	int fontSize1, x1, y1, yOffset, yOffset2;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		x1 = 180;
		y1 = 80;
		fontSize1 = 22;
        yOffset = 10;
        yOffset2 = 10;
	}
	else {
		x1 = 400;
		y1 = 200;
		fontSize1 = 40;
        yOffset = 25;
        yOffset2 = 0;
    }
	
    CCSprite *goldGem;
    if (rewardGem == NO) {
        // Display the  gold
        goldGem = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
        [self addChild:goldGem z:8];
    }
    else {
        // Display the  gem
        goldGem = [CCSprite spriteWithSpriteFrameName:@"gem.png"];
        [self addChild:goldGem z:8];
    }
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		goldGem.position = ccp(screenSize.width/2+102,228);
	}
	else {
		goldGem.position = ccp(screenSize.width/2+224,160);
	}
	
	NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
    [self removeChildByTag:1017 cleanup:YES];
	[self removeChildByTag:1018 cleanup:YES];

	// Add shadow
	CCLabelTTF *labelShadow = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	labelShadow.color = ccc3(0,0,0);
	[self addChild:labelShadow z:8 tag:1018];
	
	CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	scoreLabel.color = ccc3(255,255,255);
	[self addChild:scoreLabel z:8 tag:1017];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        labelShadow.position = ccp(screenSize.width/2+208+2,202-2);
        scoreLabel.position = ccp(screenSize.width/2+208, 202);
    }
    else {
        labelShadow.position = ccp(screenSize.width/2+447+2,85-2);
        scoreLabel.position = ccp(screenSize.width/2+447, 85);
    }
}

-(void) calculateReward:(int) score {
    
    int cnt;
    rewardGem = NO;
	
	// If a new high score, the reward is greater
	if (newHighScore == YES) {
        
        // If a new high score, and every 22 level, then reward a gem
        if ((currentLevel == 20) || (currentLevel == 40) || (currentLevel == 60) || (currentLevel == 80) || (currentLevel == 100)) {
            rewardGem = YES;
            cnt = score*.001;
       }
        else {
            cnt = score*.01;
        }
    }
    else {
        cnt = score*.001;
    }
	
	// Reduce the gold amount down is hint was used
    
    
	// Save the gold
    if (rewardGem == NO) {
        [self saveGold:cnt];
    }
    else {
        [self saveGems:cnt];
    }
    
	// Display the reward
	[self displayReward:cnt];
}

-(void) addReward {
	
}

-(int) flipHint: (int)hint {
    
    int tmpHint = 0;
    if (hint == 0) return tmpHint;
    
    int row, col;
    NSMutableString *tmpStr1 = [NSMutableString stringWithString:@"00"];
    NSMutableString *tmpStr2 = [NSMutableString stringWithString:@"00"];
    
    tmpStr1 = [NSString stringWithFormat:@"%d",hint];
    NSString *str = [tmpStr1 substringWithRange: NSMakeRange (0, 1)];
    row = [str integerValue];;
    str = [tmpStr1 substringWithRange: NSMakeRange (1, 1)];
    col = [str integerValue];;
    
    // Row 1
    if (row == 1) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(0, 1) withString:@"5"];                  
    }
    // Row 2
    else if (row == 2) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(0, 1) withString:@"4"];                  
    }
    // Row 3
    else if (row == 3) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(0, 1) withString:@"3"];                  
    }    
    // Row 4 
    else if (row == 4) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(0, 1) withString:@"2"];                  
    }
    // Row 5
    else if (row == 5) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(0, 1) withString:@"1"];                  
    }
    
    // Col 1
    if (col == 1) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(1, 1) withString:@"6"];           
    }
    // Col 2
    else if (col == 2) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(1, 1) withString:@"5"];           
    }
    // Col 3
    else if (col == 3) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(1, 1) withString:@"4"];           
    }
    // Col 4
    else if (col == 4) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(1, 1) withString:@"3"];           
    }
    // Col 5
    else if (col == 5) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(1, 1) withString:@"2"];           
    }
    // Col 6
    else if (col == 6) {
        [tmpStr2 replaceCharactersInRange: NSMakeRange(1, 1) withString:@"1"];           
    }
    
    tmpHint = [tmpStr2 integerValue];;
    
    return tmpHint;
}

-(id) flipLevel: (NSString *)levelID {
    
    NSMutableString *tmpString = [NSMutableString stringWithString:@"000000000000000000000000000000"];
    NSString *str;
    
    // Move row 1 to row 5 
    str = [levelID substringWithRange: NSMakeRange (0, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(29, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (1, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(28, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (2, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(27, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (3, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(26, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (4, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(25, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (5, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(24, 1) withString:str];
    
    // Move row 2 to row 4
    str = [levelID substringWithRange: NSMakeRange (6, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(23, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (7, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(22, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (8, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(21, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (9, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(20, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (10, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(19, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (11, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(18, 1) withString:str];
    
    // Reverse row 3
    str = [levelID substringWithRange: NSMakeRange (12, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(17, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (13, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(16, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (14, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(15, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (15, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(14, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (16, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(13, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (17, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(12, 1) withString:str];
    
    // Move row 4 to row 2
    str = [levelID substringWithRange: NSMakeRange (18, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(11, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (19, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(10, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (20, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(9, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (21, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(8, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (22, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(7, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (23, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(6, 1) withString:str];
    
    // Move row 5 to row 1
    str = [levelID substringWithRange: NSMakeRange (24, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(5, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (25, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(4, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (26, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(3, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (27, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(2, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (28, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(1, 1) withString:str];
    str = [levelID substringWithRange: NSMakeRange (29, 1)];
    [tmpString replaceCharactersInRange: NSMakeRange(0, 1) withString:str];
    
    return tmpString;
}

-(void) expandSpriteEffect: (int)type {
	
	if ((type != 0) && (type != 34)) {
 		if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:1.0 pan:1.0 gain:5.0];}
	}
	
	CCSprite *sprite;
	id actionMoveDone;
	id scaleUp = [CCScaleTo actionWithDuration:.1 scale:1.3];
	id scaleDown = [CCScaleTo actionWithDuration:.05 scale:1];
	
	// Pause Game
	if (type == 1) {
		sprite = (CCSprite *)[self getChildByTag:13];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(pauseGame)];
	}
	
	// Resume Game
	if (type == 2) {
		sprite = (CCSprite *)[self getChildByTag:13];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(resumeGame)];
		[[CCDirector sharedDirector] resume];
	}
    
	// New Game
	if (type == 3) {
		sprite = (CCSprite *)[self getChildByTag:15];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newGame)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Menu
	if (type == 4) {
		sprite = (CCSprite *)[self getChildByTag:16];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(menu)];
		[[CCDirector sharedDirector] resume];
	}
	
	// Sound Button Toggle
	if (type == 5) {
 		sprite = (CCSprite *)[self getChildByTag:2010];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(soundToggle)];
		[[CCDirector sharedDirector] resume];
	}
	
	// Music Button Toggle
	if (type == 6) {
		sprite = (CCSprite *)[self getChildByTag:2011];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(musicToggle)];
		[[CCDirector sharedDirector] resume];
	}
    
    // Next Level Summary display
	if (type == 8) {
		CCSprite *blackBackground = (CCSprite *)[self getChildByTag:100];
		sprite = (CCSprite *)[self getChildByTag:17];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(nextLevel)];
		[[CCDirector sharedDirector] resume];
	}
	
	// New Game Summary display
	if (type == 9) {
		CCSprite *blackBackground = (CCSprite *)[self getChildByTag:100];
		sprite = (CCSprite *)[self getChildByTag:15];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newGame)];
		[[CCDirector sharedDirector] resume];
	}
	
	// Menu Summary display
	if (type == 10) {
		CCSprite *blackBackground = (CCSprite *)[self getChildByTag:100];
		sprite = (CCSprite *)[self getChildByTag:16];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(menu)];
		[[CCDirector sharedDirector] resume];
	}
    
    // Show Hint Confirmation
	if (type == 11) {
		sprite = (CCSprite *)[self getChildByTag:19];
//		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(hintSelected)];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(needHelp)];
	}
    
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
    
    // Undo Move
	if (type == 34) {
		sprite = (CCSprite *)[self getChildByTag:22];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(undoMove)];
	}
    
    // Info Icon
	if (type == 35) {
		sprite = (CCSprite *)[self getChildByTag:250];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displayPowerUpInfo)];
	}
    
	// Red X for PowerUp Info
	if (type == 36) {
		sprite = (CCSprite *)[self getChildByTag:8401];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removePowerUpInfo)];
		[[CCDirector sharedDirector] resume];
	}
    
    // Undo Move (Fail Screen)
	if (type == 37) {
		sprite = (CCSprite *)[self getChildByTag:14];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(undoMoveSummary)];
	}


	id action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[sprite runAction:action];
}

-(void) soundDisplay {
	
	CCSprite *sprite, *sprite2;
    
    // Check to see if banner ad is displaying.  If so, then offset the buttons
    int adOffset = 0;
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if (removeAds != YES) {
        adOffset = 0; // was 44
    }

	// Retrieve the current sound setting
	playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_sounds"];
	
	if (playSound == NO) {
		sprite = (CCSprite *)[self getChildByTag:2010];
		[self removeChild:sprite cleanup:YES];	
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"soundOff-crazyPopper.png"];
		[self addChild:sprite2 z:6 tag:2010];
	}
	else {
		sprite = (CCSprite *)[self getChildByTag:2010];
		[self removeChild:sprite cleanup:YES];	
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"soundOn-crazyPopper.png"];
		[self addChild:sprite2 z:6 tag:2010];		
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		sprite2.position = ccp(screenSize.width/2+40, 100-adOffset);
	}
	else {
		sprite2.position = ccp(screenSize.width/2+84, 240-adOffset);
	}
    // Flip buttons if screen is flipped
    BOOL flip = [[NSUserDefaults standardUserDefaults] boolForKey:@"level_flipped"];		
    if (flip == YES) {
        sprite2.flipX = YES;
        sprite2.flipY = YES;
    }
}

-(void) soundToggle {
	
	// Retrieve the current sound setting
	playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_sounds"];
	
	if (playSound == NO) {
		playSound = YES;
	}
	else {
		playSound = NO;
	}
	
	// Save the sound setting
	[[NSUserDefaults standardUserDefaults] setBool:playSound forKey:@"should_play_sounds"];
	
	[self soundDisplay];
}


-(void) musicDisplay {
	
	CCSprite *sprite, *sprite2;
    
    // Check to see if banner ad is displaying.  If so, then offset the buttons
    int adOffset = 0;
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if (removeAds != YES) {
        adOffset = 0; // was 44
    }

	// Retrieve the current music setting
	playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_music"];
	
	if (playMusic == NO) {
		sprite = (CCSprite *)[self getChildByTag:2011];
		[self removeChild:sprite cleanup:YES];	
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"musicOff-crazyPopper.png"];
		[self addChild:sprite2 z:6 tag:2011];
	}
	else {
		sprite = (CCSprite *)[self getChildByTag:2011];
		[self removeChild:sprite cleanup:YES];	
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"musicOn-crazyPopper.png"];
		[self addChild:sprite2 z:6 tag:2011];		
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		sprite2.position = ccp(screenSize.width/2+110, 100-adOffset);
	}
	else {
		sprite2.position = ccp(screenSize.width/2+231, 240-adOffset);
	}
    // Flip buttons if screen is flipped
    BOOL flip = [[NSUserDefaults standardUserDefaults] boolForKey:@"level_flipped"];		
    if (flip == YES) {
        sprite2.flipX = YES;
        sprite2.flipY = YES;
    }
}

-(void) musicToggle {
	
 	// Retrieve the current music setting
	playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_music"];
	
	if (playMusic == NO) {
		playMusic = YES;
		[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	}
	else {
		playMusic = NO;
		[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	}
	
	// Save the music setting
	[[NSUserDefaults standardUserDefaults] setBool:playMusic forKey:@"should_play_music"];
	
	[self musicDisplay];
}

-(void) boingSound {
    if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"boingShort.wav" pitch:1.0 pan:1.0 gain:.05];}
}

-(void) resumeGame {
        
    // Remove the ad banner (if there is one)
	[self removeBanner];

	if (pauseButtonStatus == 1) {
        
		// Remove the menu button
        [self removeChildByTag:16 cleanup:YES];
		if (playMusic==YES) {[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];}
        
		CCSprite *sprite = (CCSprite *)[self getChildByTag:30];
		[self removeChild:sprite cleanup:YES];
		CCSprite *sprite2 = (CCSprite *)[self getChildByTag:31];
		[self removeChild:sprite2 cleanup:YES];
		self.isTouchEnabled = YES;
		[[CCDirector sharedDirector] resume];
		pauseButtonStatus = 0;
        
		// Remove the play button and replace it with the pause button
		[self removeChildByTag:13 cleanup:YES];
        
		// Remove the hint button
		[self removeChildByTag:19 cleanup:YES];
        
		// Remove the store button
		[self removeChildByTag:18 cleanup:YES];		
        
		// Remove the new game button
		[self removeChildByTag:15 cleanup:YES];		
		
		// Add Pause button
		CCSprite *pause = [CCSprite spriteWithSpriteFrameName:@"pauseButton.png"];
		[self addChild:pause z:3 tag:13];
 		
		// Add Hint button
		CCSprite *hint = [CCSprite spriteWithSpriteFrameName:@"hintButton.png"];
		[self addChild:hint z:3 tag:19];
        
        // Add Undo button
        CCSprite *undo;
        if (_undoArray.count > 0) {
            undo = [CCSprite spriteWithSpriteFrameName:@"undo.png"];
            [self addChild:undo z:4 tag:22];
        }

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            hint.position = ccp(35, 27);
			pause.position = ccp(screenSize.width-25, 25);
            if (_undoArray.count > 0) {
                undo.position = ccp(screenSize.width-63, 25);
            }
		}
		else {
            hint.position = ccp(75, 50);
			pause.position = ccp(screenSize.width-50, 50);
            if (_undoArray.count > 0) {
                undo.position = ccp(screenSize.width-132, 50);
            }
		}
        
		// Remove the labels
		[self removeChildByTag:2003 cleanup:YES];
		[self removeChildByTag:2004 cleanup:YES];
        
		// Remove the music & sound buttons
		[self removeChildByTag:2010 cleanup:YES];
		[self removeChildByTag:2011 cleanup:YES];
        
	}
	
	// Remove the backgrounds
 	[self removeChildByTag:101 cleanup:YES];
 	[self removeChildByTag:102 cleanup:YES];
}

-(void) pauseGame {
	
    // Check to see if ad banner should display
    int adOffset = 0;
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if (removeAds != YES) {
        
        // Display Chartboost after every 5 attempts
        if ([cb hasCachedInterstitial:@"Game Paused"]) {
            [cb showInterstitial:@"Game Paused"];
            [Flurry logEvent:@"Game Paused"];
        }
        [cb cacheInterstitial:@"Game Paused"];
        
        //        [self displayBanner];
        adOffset = 0; // was 45
    }
    
    int fontSize1;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 60;}
	else {
		fontSize1 = 120;}
	
	if (pauseButtonStatus == 0) {
		pauseButtonStatus = 1;
		[[CCDirector sharedDirector] pause];
		CGSize s = [[CCDirector sharedDirector] winSize];
        
        // Add semi-transparent black Background over the entire screen
        CCSprite *blackBackground = [CCSprite spriteWithSpriteFrameName:@"roundBackgroundBlack.png"];
        blackBackground.opacity = 200;
        blackBackground.scaleX = 1.7;
        blackBackground.scaleY = 2.4;
        [self addChild:blackBackground z:3 tag:101];				

        // Add pause background
        CCSprite *pauseBackground = [CCSprite spriteWithSpriteFrameName:@"pauseBackground.png"];
        [self addChild:pauseBackground z:3 tag:102];
        
        // Show the sound On button
        [self soundDisplay];
        [self musicDisplay];	
        
        // Show the menu button
        CCSprite *menuLeft = [CCSprite spriteWithSpriteFrameName:@"menuButton.png"];
        [self addChild:menuLeft z:5 tag:16];
        
        // Show the restart level button
        CCSprite *newGame = [CCSprite spriteWithSpriteFrameName:@"repeat.png"];
        [self addChild:newGame z:5 tag:15];				
        
        // Remove pause button and add resume button
        [self removeChildByTag:13 cleanup:YES];
        CCSprite *play = [CCSprite spriteWithSpriteFrameName:@"resumeButton.png"];
        [self addChild:play z:5 tag:13];	
        
        // Remove the hint button
        [self removeChildByTag:19 cleanup:YES];
        
        // Remove the undo button
        [self removeChildByTag:22 cleanup:YES];
        
        // Set the button positions based on the device
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            pauseBackground.position = ccp(screenSize.width/2,145);
            blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
            menuLeft.position = ccp(screenSize.width/2-110, 100-adOffset);
            newGame.position = ccp(screenSize.width/2-40, 100-adOffset);
            play.position = ccp(screenSize.width/2, 160);
        }
        else {
            pauseBackground.position = ccp(screenSize.width/2,374);
            blackBackground.position = ccp(512,384);
            menuLeft.position = ccp(screenSize.width/2-231, 240-adOffset);
            newGame.position = ccp(screenSize.width/2-84, 240-adOffset);
            play.position = ccp(screenSize.width/2, 384);
        }
 	}
	else {
        
		[self resumeGame];
	}	
}

-(void) newGame {
	
    // Purchase powerups
    [self purchasePowerUps];
    
    // Remove the ad banner (if there is one)
	[self removeBanner];
    
	[[SimpleAudioEngine sharedEngine] setMute:NO];
	
	CrazyPoppersLevelScene * cpls = [CrazyPoppersLevelScene node];
	[[CCDirector sharedDirector] replaceScene:cpls];
}

-(void) menu {
    
    // Remove the ad banner (if there is one)
	[self removeBanner];
    
    // Save the current level
	[[NSUserDefaults standardUserDefaults] setInteger:currentLevel forKey:@"popper_current_level"];
    
	if (pauseButtonStatus == 1) {
		[[CCDirector sharedDirector] resume];
	}
	CrazyPoppersScene * cps = [CrazyPoppersScene node];
	[[CCDirector sharedDirector] replaceScene:cps];		
}

-(void) nextLevel {
    
    // Remove the ad banner (if there is one)
	[self removeBanner];
    
    //    if (currentLevel < 105) {
    if (((currentLevel < 105) && (menuSelectionNo != 12)) || ((currentLevel < 315) && (menuSelectionNo == 12))) {      
        
        // Purchase the appropriate power ups
        [self purchasePowerUps];
        [self removeChildByTag:8000 cleanup:YES];

        // Set the level attempts value
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"crazy_poppers_level_attempts"];
        
        // Set this value to automatically start displaying hints 
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"start_with_hint"];
        
        // Set this value to help determine if help visuals should display or not
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"level_started_from_menu"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        currentLevel = currentLevel + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:currentLevel forKey:@"popper_current_level"];
		
        CrazyPoppersLevelScene * cpls = [CrazyPoppersLevelScene node];
        [[CCDirector sharedDirector] replaceScene:cpls];
    }
}

-(void) displayPowerUpInfo {
    
    powerUpInfoDisplayed = YES;
    
    // Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:11 tag:8401];

    // Add semi-transparent black Background over the entire screen
    CCSprite *powerUpDescriptions = [CCSprite spriteWithSpriteFrameName:@"powerUpDescriptions.png"];
	[self addChild:powerUpDescriptions z:10 tag:8400];

    int yOffset = 0;
    if ((levelComplete == YES) || (levelFail == YES)) {
        yOffset = 10;
    }
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        powerUpDescriptions.position = ccp(screenSize.width/2+1,164+yOffset);
		[redX setPosition:ccp(screenSize.width/2+180, 280+yOffset)];
    }
    else {
        powerUpDescriptions.position = ccp(screenSize.width/2+1,394+yOffset);
		[redX setPosition:ccp(screenSize.width/2+370, 625+yOffset)];
    }
}

-(void) removePowerUpInfo {
    
    powerUpInfoDisplayed = NO;
    [self removeChildByTag:8400 cleanup:YES];
    [self removeChildByTag:8401 cleanup:YES];
}

-(void) displayGoldGemHints {
    
    CCSprite *goldGemsHints = (CCSprite *)[self getChildByTag:8000];
    if (goldGemsHints != nil) return;
    
    // Display the Gold, Gems & Hints
    BuyGoldGemsHintsLayer *buyGoldGemsHints = [BuyGoldGemsHintsLayer node];
	[self addChild:buyGoldGemsHints z:12 tag:8000];
}

-(void) displayBuyGold {
    
    // Add semi-transparent black Background over the entire screen
    CCSprite *blackBackground = [CCSprite spriteWithSpriteFrameName:@"roundBackgroundBlack.png"];
    blackBackground.opacity = 200;
    blackBackground.scaleX = 1.7;
    blackBackground.scaleY = 2.4;
    [self addChild:blackBackground z:3 tag:101];

    buyGoldDisplayed = YES;
    
    // Add the background
	CCSprite *buyGold = [CCSprite spriteWithSpriteFrameName:@"buyGold.png"];
    [self addChild:buyGold z:10 tag:8001];

    // Add the buttons
	CCSprite *gold1 = [CCSprite spriteWithSpriteFrameName:@"99Button.png"];
    [self addChild:gold1 z:10 tag:8021];
	CCSprite *gold2 = [CCSprite spriteWithSpriteFrameName:@"199Button.png"];
    [self addChild:gold2 z:10 tag:8022];
	CCSprite *gold3 = [CCSprite spriteWithSpriteFrameName:@"499Button.png"];
    [self addChild:gold3 z:10 tag:8023];
	CCSprite *gold4 = [CCSprite spriteWithSpriteFrameName:@"999Button.png"];
    [self addChild:gold4 z:10 tag:8024];
	CCSprite *freeGold = [CCSprite spriteWithSpriteFrameName:@"freeGoldButton.png"];
    [self addChild:freeGold z:10 tag:8025];

	// Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:11 tag:8100];
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        blackBackground.position = ccp(screenSize.width/2,screenSize.height/2);
		[redX setPosition:ccp(420, 300)];
		[buyGold setPosition:ccp(screenSize.width/2, 184)];
		[gold1 setPosition:ccp(182, 213)];
		[gold2 setPosition:ccp(358, 213)];
		[gold3 setPosition:ccp(182, 135)];
		[gold4 setPosition:ccp(358, 135)];
		[freeGold setPosition:ccp(screenSize.width/2, 80)];
	}
	else {
        blackBackground.position = [self convertPoint:ccp(512,384)];
		[redX setPosition:ccp(882, 720)];
		[buyGold setPosition:ccp(screenSize.width/2, 442)];
		[gold1 setPosition:ccp(382, 511)];
		[gold2 setPosition:ccp(752, 511)];
		[gold3 setPosition:ccp(382, 324)];
		[gold4 setPosition:ccp(752, 324)];
		[freeGold setPosition:ccp(screenSize.width/2, 192)];
	}
}

-(void) displayBuyGems {
    
    // Add semi-transparent black Background over the entire screen
    CCSprite *blackBackground = [CCSprite spriteWithSpriteFrameName:@"roundBackgroundBlack.png"];
    blackBackground.opacity = 200;
    blackBackground.position = [self convertPoint:ccp(512,384)];
    blackBackground.scaleX = 1.7;
    blackBackground.scaleY = 2.4;
    [self addChild:blackBackground z:3 tag:101];

    buyGemsDisplayed = YES;
    
    // Add the background
	CCSprite *buyGems = [CCSprite spriteWithSpriteFrameName:@"buyGems.png"];
    [self addChild:buyGems z:10 tag:8002];

    // Add the buttons
	CCSprite *gem1 = [CCSprite spriteWithSpriteFrameName:@"99Button.png"];
    [self addChild:gem1 z:10 tag:8021];
	CCSprite *gem2 = [CCSprite spriteWithSpriteFrameName:@"199Button.png"];
    [self addChild:gem2 z:10 tag:8022];
	CCSprite *gem3 = [CCSprite spriteWithSpriteFrameName:@"499Button.png"];
    [self addChild:gem3 z:10 tag:8023];
	CCSprite *gem4 = [CCSprite spriteWithSpriteFrameName:@"999Button.png"];
    [self addChild:gem4 z:10 tag:8024];
    

	// Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:11 tag:8100];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[redX setPosition:ccp(420, 300)];
		[buyGems setPosition:ccp(screenSize.width/2, 180)];
		[gem1 setPosition:ccp(182, 210)];
		[gem2 setPosition:ccp(358, 210)];
		[gem3 setPosition:ccp(182, 135)];
		[gem4 setPosition:ccp(358, 135)];
	}
	else {
		[redX setPosition:ccp(987, 680)];
		[buyGems setPosition:ccp(512, 400)];
		[gem1 setPosition:ccp(382, 504)];
		[gem2 setPosition:ccp(752, 504)];
		[gem3 setPosition:ccp(382, 324)];
		[gem4 setPosition:ccp(752, 324)];
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
    blackBackground.position = [self convertPoint:ccp(screenSize.width/2,screenSize.height/2)];
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

    // Display the hints
    int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];
    NSString *hintStr = [NSString stringWithFormat:@"%d",hintCnt];
    
	CCLabelTTF *hintsLabel = [CCLabelTTF labelWithString:hintStr dimensions:CGSizeMake([self cpX:50],[self cpY:100]) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	hintsLabel.color = ccc3(0,0,0);
	[self addChild:hintsLabel z:11 tag:8004];

	// Add red X
	CCSprite *redX = [CCSprite spriteWithSpriteFrameName:@"redX.png"];
	[self addChild:redX z:11 tag:8100];
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[redX setPosition:ccp(420, 295)];
		[needAHint setPosition:ccp(screenSize.width/2, 180)];
		hintsLabel.position = ccp(148, 85);
		gems20.position = ccp(360, 194);
		gems110.position = ccp(360, 110);
	}
	else {
		[redX setPosition:ccp(987, 680)];
		[needAHint setPosition:ccp(512, 400)];
		hintsLabel.position = ccp(311, 204);
		gems20.position = ccp(756, 466);
		gems110.position = ccp(756, 264);
	}
}

-(void) removeGoldGemsHints {
	
    if (buyGoldDisplayed == YES) {
        buyGoldDisplayed = NO;
        [self removeChildByTag:8001 cleanup:YES];
        [self removeChildByTag:8021 cleanup:YES];
        [self removeChildByTag:8022 cleanup:YES];
        [self removeChildByTag:8023 cleanup:YES];
        [self removeChildByTag:8024 cleanup:YES];
        [self removeChildByTag:8025 cleanup:YES];
    }
    else if (buyGemsDisplayed == YES) {
        buyGemsDisplayed = NO;
        [self removeChildByTag:8002 cleanup:YES];
        [self removeChildByTag:8021 cleanup:YES];
        [self removeChildByTag:8022 cleanup:YES];
        [self removeChildByTag:8023 cleanup:YES];
        [self removeChildByTag:8024 cleanup:YES];
    }
    else if (needAHintDisplayed == YES) {
        needAHintDisplayed = NO;
        [self removeChildByTag:8003 cleanup:YES];
        [self removeChildByTag:8004 cleanup:YES];
        [self removeChildByTag:8005 cleanup:YES];
        [self removeChildByTag:8006 cleanup:YES];
    }
    
	// Remove the backgrounds
 	[self removeChildByTag:101 cleanup:YES];
	[self removeChildByTag:8100 cleanup:YES];
	[self resumeGame];
}

-(void) removeSprite:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];	
    
    if ((sprite.tag == 801) || (sprite.tag == 802) || (sprite.tag == 803) || (sprite.tag == 804)) {
        [_allSpinners removeObject:sprite];
    }
}

-(void) removePopper:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];	
}

- (void) popometerSetup: (int)cnt random:(BOOL)random {
	
	// Remove the current popometer
	[spriteSheet removeChildByTag:67 cleanup:YES];
	CCSprite *popBackground;
    	
    CCSprite *popometer;
	popometerCnt = cnt;
    
	// Randomly decide which poppers have priority on the Popometer
 	NSInteger num;
    if (random == YES) {
        num = (arc4random() % 5) + 1;
    }
    else if (random == NO) {
        num = 1;
    }
	switch (num)
	{
		case 1: {
            popometerPurple=5;popometerBlue=4;popometerGreen=3;popometerYellow=2;popometerRed=1; 
            popometer = [CCSprite spriteWithSpriteFrameName:@"popometerRed.png"];
            [self addChild:popometer z:3 tag:50];
            break;
        }
		case 2: {
            popometerPurple=4;popometerBlue=3;popometerGreen=2;popometerYellow=1;popometerRed=5; 
            popometer = [CCSprite spriteWithSpriteFrameName:@"popometerYellow.png"];
            [self addChild:popometer z:3 tag:50];
            break;
        }
		case 3: {
            popometerPurple=3;popometerBlue=2;popometerGreen=1;popometerYellow=5;popometerRed=4; 
            popometer = [CCSprite spriteWithSpriteFrameName:@"popometerGreen.png"];
            [self addChild:popometer z:3 tag:50];
            break;
        }
		case 4: {
            popometerPurple=2;popometerBlue=1;popometerGreen=5;popometerYellow=4;popometerRed=3; 
            popometer = [CCSprite spriteWithSpriteFrameName:@"popometerBlue.png"];
            [self addChild:popometer z:3 tag:50];
            break;
        }
		case 5: {
            popometerPurple=1;popometerBlue=5;popometerGreen=4;popometerYellow=3;popometerRed=2; 
            popometer = [CCSprite spriteWithSpriteFrameName:@"popometerPurple.png"];
            [self addChild:popometer z:3 tag:50];
            break;
        }
	}
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [popometer setPosition:ccp(screenSize.width-53, 288)];
	}
	else {
        [popometer setPosition:ccp(screenSize.width-111, 695)];
	}
}

- (void) addLabel: (int)label x:(int)x y:(int)y {
	
	NSString *commentStr;
	int z = 5;
	int fontSize1, x1, y1, yOffset;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		x1 = 150;
		y1 = 100;
		fontSize1 = 18;
        yOffset = -20;}
	else {
		x1 = 280;
		y1 = 200;
		fontSize1 = 28;
        yOffset = 0;}
	
    // if iPhone 5, add x offset
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) { // iPhone 5
        x = x + 44;
    }

	// Introduction Label
	if (label == 1) {
		commentStr = @"Tap the blowfish to 'pop' it";
	}
	// Introduction Label
	else if (label == 2) {
		commentStr = @"Blowfish can pop other blowfish";
	}
	// Popometer Label
	else if (label == 3) {
		commentStr = @"The popometer shows which colors will 'pop'";
	}
	// Ricocet Label
	else if (label == 4) {
		commentStr = @"Spinners can ricochet off walls";
	}
    
	CCSprite *infoIcon = [CCSprite spriteWithSpriteFrameName:@"infoIcon.png"];
	infoIcon.position = ccp(x,y);
 	[self addChild:infoIcon z:z tag:249];
	
	CCLabelTTF *commentLabel = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentLabel.position = [self convertPoint:ccp(22, -100)];
	commentLabel.color = ccc3(255,255,255);
	[infoIcon addChild:commentLabel z:z tag:351];
	CCLabelTTF *commentShadow = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentShadow.color = ccc3(0,0,0);
	[infoIcon addChild:commentShadow z:z tag:352];
	commentShadow.position = [self convertPoint:ccp(20, -98)];
	infoIcon.opacity = 0;
	commentLabel.opacity = 0;
	commentShadow.opacity = 0;
	
	id appear = [CCFadeTo actionWithDuration:2 opacity:255];
	id delay = [CCFadeTo actionWithDuration:6 opacity:255];
	id disappear = [CCFadeTo actionWithDuration:1 opacity:0];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)];
	id action = [CCSequence actions:appear, delay, disappear, actionMoveDone, nil];
	[commentLabel runAction:action];
	appear = [CCFadeTo actionWithDuration:2 opacity:255];
	delay = [CCFadeTo actionWithDuration:6 opacity:255];
	disappear = [CCFadeTo actionWithDuration:1 opacity:0];
	actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeLabel:)];
	action = [CCSequence actions:appear, delay, disappear, actionMoveDone, nil];
	[commentShadow runAction:action];
}

-(void) removeLabel:(id) sender {
	CCLabelTTF *label = (CCLabelTTF *) sender;
	[self removeChild:label cleanup:YES];
}	

- (void) addArrow: (int)type dir:(int)dir x:(int)x y:(int)y rotate:(int)rotate {
	
    // if iPhone 5, add x offset
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) { // iPhone 5
        x = x + 44;
    }

	CCSprite *arrow;
	
	if (type == 1) {
		arrow = [CCSprite spriteWithSpriteFrameName:@"arrowWhite.png"]; 
	}
	if (type == 2) {
		arrow = [CCSprite spriteWithSpriteFrameName:@"arrowBlack.png"]; 
	}
	// Flip direction if necessary
	if (dir == 2) {
		arrow.flipX = YES;
		arrow.rotation = -30;
	}
	
	if (rotate != 0) {
		arrow.rotation = rotate;
	}
	
	arrow.position = ccp(x,y);
	arrow.opacity = 0;
	[self addChild:arrow z:1 tag:248];
	
	id appear = [CCFadeTo actionWithDuration:2 opacity:255];
	id delay = [CCFadeTo actionWithDuration:6 opacity:255];
	id disappear = [CCFadeTo actionWithDuration:1 opacity:0];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
	id action = [CCSequence actions:appear, delay, disappear, actionMoveDone, nil];
	[arrow runAction:action];
}

-(void) loadHints:(int)h1 h2:(int)h2 h3:(int)h3 h4:(int)h4 h5:(int)h5 h6:(int)h6 h7:(int)h7 h8:(int)h8 h9:(int)h9 h10:(int)h10 {
    
    // Set the current hint to 0 (i.e. don't show anything)
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"current_hint"];
    
    // Load all the hints
    if (h1 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h1 forKey:@"hint1"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h2 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h2 forKey:@"hint2"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h3 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h3 forKey:@"hint3"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h4 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h4 forKey:@"hint4"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h5 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h5 forKey:@"hint5"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h6 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h6 forKey:@"hint6"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h7 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h7 forKey:@"hint7"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h8 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h8 forKey:@"hint8"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h9 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h9 forKey:@"hint9"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
    if (h10 != 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:h10 forKey:@"hint10"];
        totalHintsRemaining = totalHintsRemaining + 1;
    }
}

-(void) addHint:(int)pos {
    
    CCSprite *hint = [CCSprite spriteWithSpriteFrameName:@"tapHere.png"]; 
    hint.opacity = 0;
    [self addChild:hint z:3 tag:pos+7000];
    
    id delay;
    // Delay to give time for poppers to get on screen for the training levels
    BOOL delayHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"delay_hint"];
    if (delayHint == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"delay_hint"];
        delay = [CCFadeTo actionWithDuration:2 opacity:0];
    }
    else {
        delay = [CCFadeTo actionWithDuration:.2 opacity:0];
    }
    
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(showHint:)];
	id action = [CCSequence actions:delay, actionMoveDone, nil];
	[hint runAction:action];
}

-(void) showHint:(id)sender {
    CCSprite *hint = (CCSprite *)sender;
    int pos = hint.tag - 7000;
    
    // Set up yOffset
    int yOffset;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        yOffset = 2;
    }
    else {
        yOffset = 10;
    }
    
    // Change hint tag 
    hint.tag = 9999;
    
    // Position the hint below the appropriate popper
    for (CCSprite *popper in _allPoppers) {
        int t = popper.tag;
        
        if ((t >= 7101) && (t <= 7199)) {
            t = t - 7100;
            if (pos == t) {
                hint.position = ccp(popper.position.x,popper.position.y-yOffset);
                hint.scale = popper.scaleX;
                break;
            }
        }
        else if ((t >= 7201) && (t <= 7299)) {
            t = t - 7200;
            if (pos == t) {
                hint.position = ccp(popper.position.x,popper.position.y-yOffset);
                hint.scale = popper.scaleX;
                break;
            }
        }
        else if ((t >= 7301) && (t <= 7399)) {
            t = t - 7300;
            if (pos == t) {
                hint.position = ccp(popper.position.x,popper.position.y-yOffset);
                hint.scale = popper.scaleX;
                break;
            }
        }
        else if ((t >= 7401) && (t <= 7499)) {
            t = t - 7400;
            if (pos == t) {
                hint.position = ccp(popper.position.x,popper.position.y-yOffset);
                hint.scale = popper.scaleX;
                break;
            }
        }
        else if ((t >= 7501) && (t <= 7599)) {
            t = t - 7500;
            if (pos == t) {
                hint.position = ccp(popper.position.x,popper.position.y-yOffset);
                hint.scale = popper.scaleX;
                break;
            }
        }
    }
    
    id appear = [CCFadeTo actionWithDuration:.2 opacity:255]; 
    id action = [CCSequence actions:appear, nil, nil];
 	[hint runAction:action];
}

-(void) needHelp {
    
    // First, save off a screen shot in case the user uses "Ask a friend"
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    CCNode *n = [scene.children objectAtIndex:0];
    
    miscMsg = nil;
    
    miscMsg = [[UIAlertView alloc] initWithTitle: @"Need Some Help?" message:nil delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Use a Hint", @"Ask a Friend" ,nil];
    [miscMsg show];
    [miscMsg release];
    
}

-(void) askAFriend {
    
    msgiOS5 = nil;
    msgiOS6 = nil;
    
    // First, determine if iOS 5 or 6 is installed.
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    // Version 6.0, include Facebook & Twitter
    if ([version floatValue] >= 6.0) {
		msgiOS6 = [[UIAlertView alloc] initWithTitle: @"Ask a Friend for Help" message:nil delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Ask on Twitter", @"Ask on Facebook" ,nil];
		[msgiOS6 show];
		[msgiOS6 release];
    }
    
    // Version 5.0, include only Twitter
    else if ([version floatValue] >= 5.0) {
        msgiOS5 = [[UIAlertView alloc] initWithTitle: @"Ask a Friend for Help" message:nil delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles:  @"Ask on Twitter" ,nil];
        [msgiOS5 show];
        [msgiOS5 release];
    }
}

-(void) shareTwitter5 {
    if ([TWTweetComposeViewController canSendTweet]) {
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayTwitter5];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) shareTwitter6 {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayTwitter6];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) shareFacebook6 {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayFacebook6];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send to Facebook right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(UIImage*) screenshotWithStartNode:(CCNode*)startNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CCRenderTexture* rtx;
    CGSize newSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) { // iPhone 5
            rtx = [CCRenderTexture renderTextureWithWidth:568 height:320];
            newSize = CGSizeMake(284,160);
        }
        else {
            rtx = [CCRenderTexture renderTextureWithWidth:480 height:320];
            newSize = CGSizeMake(240,160);
        }
    }
    else {
        rtx = [CCRenderTexture renderTextureWithWidth:1024 height:768];
        newSize = CGSizeMake(256,192);
    }
    [rtx begin];
    [startNode visit];
    [rtx end];
    
    UIImage *scaledImage = [self resizeImage:[rtx getUIImageFromBuffer] newSize:newSize];
    
    // Save image
    NSData* imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
    NSString* imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/screenShot.png"];
    [imageData writeToFile:imagePath atomically:YES];
    
    return scaledImage;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void) hintSelected {
	
    hintConfirm = nil;
    hintAlert = nil;
    
	int cnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];		
	if (cnt > 0) {
        NSString *cntStr = [NSString stringWithFormat:@"%d",cnt];
        NSString *hintStr = [NSString stringWithFormat:@"Do you want to use 1 Hint for this level?  You have %@ hints remaining.",cntStr];
        
		hintConfirm = [[UIAlertView alloc] initWithTitle: @"Display Hint?" message:hintStr  delegate: self cancelButtonTitle: @"No!" otherButtonTitles: @"Show Hint!" ,nil];
		[hintConfirm show];
		[hintConfirm release];
	}
	else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"displayNeedAHint"];
	}
}

-(void) displayHint {
    
    if (totalHintsRemaining > 0) {
        
        int hint1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint1"];
        int hint2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint2"];
        int hint3 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint3"];
        int hint4 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint4"];
        int hint5 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint5"];
        int hint6 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint6"];
        int hint7 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint7"];
        int hint8 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint8"];
        int hint9 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint9"];
        int hint10 = [[NSUserDefaults standardUserDefaults] integerForKey:@"hint10"];
        
        if (hint1 != 0) {
            [self addHint:hint1];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint1"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint2 != 0) {
            [self addHint:hint2];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint2"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint3 != 0) {
            [self addHint:hint3];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint3"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint4 != 0) {
            [self addHint:hint4];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint4"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint5 != 0) {
            [self addHint:hint5];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint5"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint6 != 0) {
            [self addHint:hint6];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint6"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint7 != 0) {
            [self addHint:hint7];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint7"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint8 != 0) {
            [self addHint:hint8];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint8"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint9 != 0) {
            [self addHint:hint9];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint9"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else if (hint10 != 0) {
            [self addHint:hint10];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"hint10"];
            totalHintsRemaining = totalHintsRemaining - 1;
        }
        else {
            totalHintsRemaining = 0;
        }
    }
}

-(void) addricochetWall:(int)type pos:(int)pos x:(int)x y:(int)y {
    
    CCSprite *ricochet = [CCSprite spriteWithSpriteFrameName:@"ricochet.png"]; 
    ricochet.position = ccp(x,y);
    if (type == 6) {
        [self addChild:ricochet z:3 tag:7801];
    }
    else if (type == 7) {
        [self addChild:ricochet z:3 tag:7802];
        ricochet.flipX = YES;
    }
    // Add the ricochet wall to the ricochhet Wall array
	[_allRicochetWalls addObject:ricochet];
}

-(void) addPopperExplosion:(id)sender {
	CCSprite *popper = (CCSprite *)sender;
    
    // Create 20 explosions
    CCSprite *p1 = [CCSprite spriteWithSpriteFrameName:@"popperExplosion.png"]; 
    CCSprite *p2 = [CCSprite spriteWithSpriteFrameName:@"popperExplosion.png"]; 
    CCSprite *p3 = [CCSprite spriteWithSpriteFrameName:@"popperExplosion.png"]; 
    CCSprite *p4 = [CCSprite spriteWithSpriteFrameName:@"popperExplosion.png"]; 
    CCSprite *p5 = [CCSprite spriteWithSpriteFrameName:@"popperExplosion.png"]; 
    
    [self addChild:p1 z:3];
    [self addChild:p2 z:3];
    [self addChild:p3 z:3];
    [self addChild:p4 z:3];
    [self addChild:p5 z:3];
    
    // Make one explode from the center
    p1.position = ccp(popper.position.x,popper.position.y);
    p1.scale = .1;
    id scaleUp = [CCScaleTo actionWithDuration:.3 scale:.8];
	id scaleDown = [CCScaleTo actionWithDuration:.1 scale:0];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
	id action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[p1 runAction:action];
    
    int xOff;
    NSInteger num = (arc4random() % 5) + 1;
	switch (num)
	{
		case 1: {xOff = 15; break;}
		case 2: {xOff = 20; break;}
		case 3: {xOff = 25; break;}
		case 4: {xOff = 30; break;}
		case 5: {xOff = 35; break;}
	}
    int xOff2;
    NSInteger num2 = (arc4random() % 5) + 1;
	switch (num2)
	{
		case 1: {xOff2 = 15; break;}
		case 2: {xOff2 = 20; break;}
		case 3: {xOff2 = 25; break;}
		case 4: {xOff2 = 30; break;}
		case 5: {xOff2 = 35; break;}
	}
    int yOff;
    NSInteger num3 = (arc4random() % 5) + 1;
	switch (num3)
	{
		case 1: {yOff = 15; break;}
		case 2: {yOff = 20; break;}
		case 3: {yOff = 25; break;}
		case 4: {yOff = 30; break;}
		case 5: {yOff = 35; break;}
	}
    int yOff2;
    NSInteger num4 = (arc4random() % 5) + 1;
	switch (num4)
	{
		case 1: {yOff2 = 15; break;}
		case 2: {yOff2 = 20; break;}
		case 3: {yOff2 = 25; break;}
		case 4: {yOff2 = 30; break;}
		case 5: {yOff2 = 35; break;}
	}
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        xOff = xOff/2;
        xOff2 = xOff2/2;
        yOff = yOff/2;
        yOff2 = yOff2/2;
    }
    
    // Make 4 explode around the center
    p2.position = ccp(popper.position.x-xOff,popper.position.y+yOff2);
    p3.position = ccp(popper.position.x+xOff2,popper.position.y+yOff);
    p4.position = ccp(popper.position.x-xOff,popper.position.y-yOff2);
    p5.position = ccp(popper.position.x+xOff2,popper.position.y-yOff);
    p2.scale = .2;
    p3.scale = .2;
    p4.scale = .2;
    p5.scale = .2;
    
    scaleUp = [CCScaleTo actionWithDuration:.4 scale:.4];
	scaleDown = [CCScaleTo actionWithDuration:.2 scale:0];
    actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
	action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[p2 runAction:action];
    scaleUp = [CCScaleTo actionWithDuration:.4 scale:.5];
	scaleDown = [CCScaleTo actionWithDuration:.05 scale:0];
    actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
	action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[p3 runAction:action];
    scaleUp = [CCScaleTo actionWithDuration:.5 scale:.3];
	scaleDown = [CCScaleTo actionWithDuration:.1 scale:0];
    actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
	action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[p4 runAction:action];
    scaleUp = [CCScaleTo actionWithDuration:.4 scale:.2];
	scaleDown = [CCScaleTo actionWithDuration:.05 scale:0];
    actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
	action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[p5 runAction:action];
}

-(void) addPopperExplosionOld:(id)sender {
	CCSprite *popper = (CCSprite *)sender;
	
	// Make a small explosion	
	CCParticleSun* explosion = [[CCParticleSun alloc]initWithTotalParticles:30];
	explosion.texture = [[CCTextureCache sharedTextureCache] addImage:@"popperExplosion.png"];
	explosion.autoRemoveOnFinish = YES;
	explosion.startSize = 5.0f;
	explosion.startSizeVar = 50.0f;
	explosion.speed = 10.0f;
	// additive
	explosion.blendAdditive = NO;
	// color of particles
	explosion.startColor = (ccColor4F) {1.0f, 1.0f, 1.0f, 1.0f};
	explosion.endColor = (ccColor4F) {1.0f, 1.0f, 1.0f, 1.0f};
	explosion.endColorVar = (ccColor4F) {0.0f, 0.0f, 0.0f, 0.0f};
	
	explosion.anchorPoint = ccp(0.0f,0.0f);
	explosion.duration = .5f;
	explosion.position = ccp(popper.position.x,popper.position.y);
	[self addChild:explosion z:3 tag:251];
	[explosion release];
}

-(void) createPopper:(int)type pos:(int)pos x:(int)x y:(int)y {
    
    float scaleFactor;
    
    // Convert for iPhone
    x = [self cpX:x];
    y = [self cpY:y];
    
    // if iPhone 5, add x offset
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) { // iPhone 5
        x = x + 44;
    }
    
    CCSprite *popper;
    if (type == 1) {
        if (popometerRed == 1) popper = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"];
        else if (popometerYellow == 1) popper = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"];
        else if (popometerGreen == 1) popper = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"];
        else if (popometerBlue == 1) popper = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"];
        else if (popometerPurple == 1) popper = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"];
        popper.tag = 7100+pos;
        scaleFactor = 1.0;
    }
    else if (type == 2) {
        if (popometerRed == 2) popper = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"];
        else if (popometerYellow == 2) popper = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"];
        else if (popometerGreen == 2) popper = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"];
        else if (popometerBlue == 2) popper = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"];
        else if (popometerPurple == 2) popper = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"];
        popper.tag = 7200+pos;
        scaleFactor = .9;
    }
    else if (type == 3) {
        if (popometerRed == 3) popper = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"];
        else if (popometerYellow == 3) popper = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"];
        else if (popometerGreen == 3) popper = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"];
        else if (popometerBlue == 3) popper = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"];
        else if (popometerPurple == 3) popper = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"];
        popper.tag = 7300+pos;
        scaleFactor = .8;
    }
    else if (type == 4) {
        if (popometerRed == 4) popper = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"];
        else if (popometerYellow == 4) popper = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"];
        else if (popometerGreen == 4) popper = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"];
        else if (popometerBlue == 4) popper = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"];
        else if (popometerPurple == 4) popper = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"];
        popper.tag = 7400+pos;
        scaleFactor = .7;
    }
    else if (type == 5) {
        if (popometerRed == 5) popper = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"];
        else if (popometerYellow == 5) popper = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"];
        else if (popometerGreen == 5) popper = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"];
        else if (popometerBlue == 5) popper = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"];
        else if (popometerPurple == 5) popper = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"];
        popper.tag = 7500+pos;
        scaleFactor = .6;
    }
    else if ((type == 6) || (type == 7)) {  // ricochet Wall
        [self addricochetWall:type pos:pos x:x y:y];
        return;
    }
    
    [self addChild:popper z:3];
	
    // Use the popperStartLocation to determine random locations
    if (popperStartLocation < 4) {
        popperStartLocation = popperStartLocation + 1;}
    else {
        popperStartLocation = 1;}
    if (popperStartLocation == 1) popper.position = [self convertPoint:ccp(512,-100)];
    else if (popperStartLocation == 2) popper.position = [self convertPoint:ccp(-100,384)];
    else if (popperStartLocation == 3) popper.position = [self convertPoint:ccp(512,884)];
    else if (popperStartLocation == 4) popper.position = [self convertPoint:ccp(1124,384)];
    
    // Make the popper move in from random locations
 	CCSprite *undo = (CCSprite *)[self getChildByTag:22];
    id move, action;
    if ((undo == nil) && (displayHint == NO)) {
        move = [CCMoveTo actionWithDuration:1 position:ccp(x,y)];
        action = [CCSequence actions:move, nil, nil];
        [popper runAction:action];
    }
    else {
        popper.position = ccp(x,y);
    }
    
    // Add breathing movement
 	id scaleUp = [CCScaleTo actionWithDuration:(1+(popperStartLocation*.1)) scaleX:.94*scaleFactor scaleY:1.07*scaleFactor];
 	id scaleDown = [CCScaleTo actionWithDuration:1 scale:1*scaleFactor];
 	action = [CCSequence actions: scaleUp, scaleDown, nil];	
 	[popper runAction:[CCRepeatForever actionWithAction:action]];
    
    // Add the eyes
    CCSprite *leftEye, *rightEye;
    
    // Randomly flip
    NSInteger num = (arc4random() % 2) + 1;
	switch (num)
	{
		case 1: {
            leftEye = [CCSprite spriteWithSpriteFrameName:@"popperLeftEye.png"];
            rightEye = [CCSprite spriteWithSpriteFrameName:@"popperRightEye.png"];
            [popper addChild:rightEye z:1];
            [popper addChild:leftEye z:1];
            break;}
		case 2: {
            leftEye = [CCSprite spriteWithSpriteFrameName:@"popperLeftEye.png"];
            rightEye = [CCSprite spriteWithSpriteFrameName:@"popperRightEye.png"];
            [popper addChild:leftEye z:1];
            [popper addChild:rightEye z:1];
            break;}
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        leftEye.position = ccp(19,26);
        rightEye.position = ccp(36,26);
    }
    else {
        leftEye.position = ccp(32,50);
        rightEye.position = ccp(67,50);
    }
    
    // Scale the eyes
    scaleUp = [CCScaleTo actionWithDuration:(1+(popperStartLocation*.1)) scale:1.1];
    scaleDown = [CCScaleTo actionWithDuration:1.1 scale:.9];
    action = [CCSequence actions: scaleDown, scaleUp, nil];	
    [leftEye runAction:[CCRepeatForever actionWithAction:action]];
    scaleUp = [CCScaleTo actionWithDuration:(1+(popperStartLocation*.1)) scale:1.1];
    scaleDown = [CCScaleTo actionWithDuration:1.1 scale:.9];
    action = [CCSequence actions: scaleUp, scaleDown, nil];	
    [rightEye runAction:[CCRepeatForever actionWithAction:action]];
    
    // Add the popper to the Popper array
	[_allPoppers addObject:popper];
    
    // Randomly flip
    NSInteger num2 = (arc4random() % 2) + 1;
	switch (num2)
	{
		case 1: {break;}
		case 2: {popper.flipX = YES; break;}
    }
}

-(void) addPopper:(int)p11 p12:(int)p12 p13:(int)p13 p14:(int)p14 p15:(int)p15 p16:(int)p16  
              p21:(int)p21 p22:(int)p22 p23:(int)p23 p24:(int)p24 p25:(int)p25 p26:(int)p26
              p31:(int)p31 p32:(int)p32 p33:(int)p33 p34:(int)p34 p35:(int)p35 p36:(int)p36
              p41:(int)p41 p42:(int)p42 p43:(int)p43 p44:(int)p44 p45:(int)p45 p46:(int)p46
              p51:(int)p51 p52:(int)p52 p53:(int)p53 p54:(int)p54 p55:(int)p55 p56:(int)p56 {
    
    // Note:  Only populate a popper if a value has been entered for the location.  
    //        Additionally, depending on the number entered into the field, that will 
    //        indicate the number of taps required to "pop" the popper
    
    int xOffset,yOffset;
    
    // If nothing is in the 6th column, then make it be a 5x5 grid, otherwise, make it a 5x6 grid
    if ((p16 != 0) || (p26 != 0) || (p36 != 0) || (p46 != 0) || (p56 != 0)) {
        xOffset = 0;
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            xOffset = 70;
        }
        else { 
            xOffset = 75;
        }
    }
    // Set the yOffset
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        yOffset = -25;
    }
    else {
        yOffset = 0;
    }
    
    // Create the poppers
    
    // Row 1
    if (p11 != 0) [self createPopper:p11 pos:11 x:137+xOffset y:585+yOffset];
    if (p12 != 0) [self createPopper:p12 pos:12 x:287+xOffset y:585+yOffset];
    if (p13 != 0) [self createPopper:p13 pos:13 x:437+xOffset y:585+yOffset];
    if (p14 != 0) [self createPopper:p14 pos:14 x:587+xOffset y:585+yOffset];
    if (p15 != 0) [self createPopper:p15 pos:15 x:737+xOffset y:585+yOffset];
    if (p16 != 0) [self createPopper:p16 pos:16 x:887 y:585+yOffset];
    
    // Row 2
    if (p21 != 0) [self createPopper:p21 pos:21 x:137+xOffset y:485+yOffset];
    if (p22 != 0) [self createPopper:p22 pos:22 x:287+xOffset y:485+yOffset];
    if (p23 != 0) [self createPopper:p23 pos:23 x:437+xOffset y:485+yOffset];
    if (p24 != 0) [self createPopper:p24 pos:24 x:587+xOffset y:485+yOffset];
    if (p25 != 0) [self createPopper:p25 pos:25 x:737+xOffset y:485+yOffset];
    if (p26 != 0) [self createPopper:p26 pos:26 x:887 y:485+yOffset];
    
    // Row 3
    if (p31 != 0) [self createPopper:p31 pos:31 x:137+xOffset y:385+yOffset];
    if (p32 != 0) [self createPopper:p32 pos:32 x:287+xOffset y:385+yOffset];
    if (p33 != 0) [self createPopper:p33 pos:33 x:437+xOffset y:385+yOffset];
    if (p34 != 0) [self createPopper:p34 pos:34 x:587+xOffset y:385+yOffset];
    if (p35 != 0) [self createPopper:p35 pos:35 x:737+xOffset y:385+yOffset];
    if (p36 != 0) [self createPopper:p36 pos:36 x:887 y:385+yOffset];
    
    // Row 4
    if (p41 != 0) [self createPopper:p41 pos:41 x:137+xOffset y:285+yOffset];
    if (p42 != 0) [self createPopper:p42 pos:42 x:287+xOffset y:285+yOffset];
    if (p43 != 0) [self createPopper:p43 pos:43 x:437+xOffset y:285+yOffset];
    if (p44 != 0) [self createPopper:p44 pos:44 x:587+xOffset y:285+yOffset];
    if (p45 != 0) [self createPopper:p45 pos:45 x:737+xOffset y:285+yOffset];
    if (p46 != 0) [self createPopper:p46 pos:46 x:887 y:285+yOffset];
    
    // Row 5
    if (p51 != 0) [self createPopper:p51 pos:51 x:137+xOffset y:185+yOffset];
    if (p52 != 0) [self createPopper:p52 pos:52 x:287+xOffset y:185+yOffset];
    if (p53 != 0) [self createPopper:p53 pos:53 x:437+xOffset y:185+yOffset];
    if (p54 != 0) [self createPopper:p54 pos:54 x:587+xOffset y:185+yOffset];
    if (p55 != 0) [self createPopper:p55 pos:55 x:737+xOffset y:185+yOffset];
    if (p56 != 0) [self createPopper:p56 pos:56 x:887 y:185+yOffset];
}

-(void) loadPoppers:(NSString *)str {
    
    NSString *string = [str substringWithRange: NSMakeRange (0, 1)];
    int p11 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (1, 1)];
    int p12 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (2, 1)];
    int p13 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (3, 1)];
    int p14 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (4, 1)];
    int p15 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (5, 1)];
    int p16 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (6, 1)];
    int p21 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (7, 1)];
    int p22 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (8, 1)];
    int p23 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (9, 1)];
    int p24 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (10, 1)];
    int p25 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (11, 1)];
    int p26 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (12, 1)];
    int p31 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (13, 1)];
    int p32 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (14, 1)];
    int p33 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (15, 1)];
    int p34 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (16, 1)];
    int p35 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (17, 1)];
    int p36 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (18, 1)];
    int p41 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (19, 1)];
    int p42 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (20, 1)];
    int p43 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (21, 1)];
    int p44 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (22, 1)];
    int p45 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (23, 1)];
    int p46 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (24, 1)];
    int p51 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (25, 1)];
    int p52 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (26, 1)];
    int p53 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (27, 1)];
    int p54 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (28, 1)];
    int p55 = [string integerValue];;
    string = [str substringWithRange: NSMakeRange (29, 1)];
    int p56 = [string integerValue];;
    
    [self addPopper:p11 p12:p12 p13:p13 p14:p14 p15:p15 p16:p16 p21:p21 p22:p22 p23:p23 p24:p24 p25:p25 p26:p26 p31:p31 p32:p32 p33:p33 p34:p34 p35:p35 p36:p36 p41:p41 p42:p42 p43:p43 p44:p44 p45:p45 p46:p46 p51:p51 p52:p52 p53:p53 p54:p54 p55:p55 p56:p56];
    
    // Load the possible score
    popperScore = p11*100 + p12*100 + p13*100 + p14*100 + p15*100 + p16*100 +
    p21*100 + p22*100 + p23*100 + p24*100 + p25*100 + p26*100 +
    p31*100 + p32*100 + p33*100 + p34*100 + p35*100 + p36*100 +
    p41*100 + p42*100 + p43*100 + p44*100 + p45*100 + p46*100 +
    p51*100 + p52*100 + p53*100 + p54*100 + p55*100 + p56*100;
}

-(void) randomizePopPitch {
    
    NSInteger num = (arc4random() % 5) + 1;
	switch (num)
	{
		case 1: {popPitch = 1.16; break;}
		case 2: {popPitch = 1.0; break;}
		case 3: {popPitch = 1.04; break;}
		case 4: {popPitch = 1.08; break;}
		case 5: {popPitch = 1.12; break;}
	}
}

-(void) popEffect: (id)sender {
    
    // Randomize pop pitch
    [self randomizePopPitch];
    
    if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:popPitch pan:1.0 gain:5.0];}
    if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"bubble_01.wav" pitch:.8 pan:1.0 gain:.7];}
    CCSprite *popper = (CCSprite *) sender;    
    [_removePoppers addObject:popper];
    
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removePopper:)];
	id scaleUp = [CCScaleTo actionWithDuration:.1 scale:1.3];
	id scaleDown = [CCScaleTo actionWithDuration:.05 scale:1];
	id action = [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil];
	[popper runAction:action];
    
    // Make a small explosion
    [self addPopperExplosion:popper];
}

-(void) changePopper: (id)sender {
    
    // Randomize pop pitch
    [self randomizePopPitch];
    
    CCSprite *popper = (CCSprite *) sender;    
	CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	CCSpriteFrame *frame;
    [popper stopAllActions];
    float scaleFactor;
	
	// If Balloon is 2nd Level
	if ((popper.tag >= 7201) && (popper.tag <= 7299)) {
        if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:popPitch pan:1.0 gain:5.0];}
        if (popometerRed == 1) frame = [frameCache spriteFrameByName:@"popperRed.png"];
        else if (popometerYellow == 1) frame = [frameCache spriteFrameByName:@"popperYellow.png"];
        else if (popometerGreen == 1) frame = [frameCache spriteFrameByName:@"popperGreen.png"];
        else if (popometerBlue == 1) frame = [frameCache spriteFrameByName:@"popperBlue.png"];
        else if (popometerPurple == 1) frame = [frameCache spriteFrameByName:@"popperPurple.png"];
        [popper setDisplayFrame:frame];
		popper.tag = popper.tag - 100;
        scaleFactor = 1.0;
	}
	
	// If Balloon is 3rd Level
	else if ((popper.tag >= 7301) && (popper.tag <= 7399)) {
        if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:popPitch pan:1.0 gain:5.0];}
        if (popometerRed == 2) frame = [frameCache spriteFrameByName:@"popperRed.png"];
        else if (popometerYellow == 2) frame = [frameCache spriteFrameByName:@"popperYellow.png"];
        else if (popometerGreen == 2) frame = [frameCache spriteFrameByName:@"popperGreen.png"];
        else if (popometerBlue == 2) frame = [frameCache spriteFrameByName:@"popperBlue.png"];
        else if (popometerPurple == 2) frame = [frameCache spriteFrameByName:@"popperPurple.png"];
        [popper setDisplayFrame:frame];
		popper.tag = popper.tag - 100;
        scaleFactor = .9;
	}
	
	// If Balloon is 4th level
	else if ((popper.tag >= 7401) && (popper.tag <= 7499)) {
        if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:popPitch pan:1.0 gain:5.0];}
        if (popometerRed == 3) frame = [frameCache spriteFrameByName:@"popperRed.png"];
        else if (popometerYellow == 3) frame = [frameCache spriteFrameByName:@"popperYellow.png"];
        else if (popometerGreen == 3) frame = [frameCache spriteFrameByName:@"popperGreen.png"];
        else if (popometerBlue == 3) frame = [frameCache spriteFrameByName:@"popperBlue.png"];
        else if (popometerPurple == 3) frame = [frameCache spriteFrameByName:@"popperPurple.png"];
        [popper setDisplayFrame:frame];
		popper.tag = popper.tag - 100;
        scaleFactor = .8;
	}
	
	// If Balloon is 5th level
	else if ((popper.tag >= 7501) && (popper.tag <= 7599)) {
        if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:popPitch pan:1.0 gain:5.0];}
        if (popometerRed == 4) frame = [frameCache spriteFrameByName:@"popperRed.png"];
        else if (popometerYellow == 4) frame = [frameCache spriteFrameByName:@"popperYellow.png"];
        else if (popometerGreen == 4) frame = [frameCache spriteFrameByName:@"popperGreen.png"];
        else if (popometerBlue == 4) frame = [frameCache spriteFrameByName:@"popperBlue.png"];
        else if (popometerPurple == 4) frame = [frameCache spriteFrameByName:@"popperPurple.png"];
        [popper setDisplayFrame:frame];
		popper.tag = popper.tag - 100;
        scaleFactor = .7;
	}
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(breathing:)];
    id scaleUp = [CCScaleTo actionWithDuration:.1 scale:scaleFactor+.3];
	id scaleDown = [CCScaleTo actionWithDuration:.05 scale:scaleFactor];
     
    id action = [CCSpawn actions:
                 [CCSequence actions:scaleUp, scaleDown, actionMoveDone, nil],
                 nil];
 	[popper runAction:action];
    
    // Remove any hint
    [self removeChildByTag:9999 cleanup:YES];
}

-(void) breathing: (id)sender {
    CCSprite *popper = (CCSprite *) sender; 
    float scaleFactor = popper.scale;
    
    id scaleUp2 = [CCScaleTo actionWithDuration:(1+(popperStartLocation*.1)) scaleX:.94*scaleFactor scaleY:1.07*scaleFactor];
    id scaleDown2 = [CCScaleTo actionWithDuration:1.1 scale:1*scaleFactor];
    id action = [CCSequence actions: scaleUp2, scaleDown2, nil];	
    [popper runAction:[CCRepeatForever actionWithAction:action]];
}

-(void) launchSpinners: (id)sender {
    
    CCSprite *popper = (CCSprite *) sender; 
    int t = popper.tag;
    
    CCSprite *popperUp, *popperDown, *popperLeft, *popperRight;
    
    if (popometerRed == 1) {
        popperUp = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"]; 
        popperDown = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"]; 
        popperLeft = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"]; 
        popperRight = [CCSprite spriteWithSpriteFrameName:@"popperRed.png"];
    }
    else if (popometerYellow == 1) {
        popperUp = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"]; 
        popperDown = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"]; 
        popperLeft = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"]; 
        popperRight = [CCSprite spriteWithSpriteFrameName:@"popperYellow.png"];
    }
    else if (popometerGreen == 1) {
        popperUp = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"]; 
        popperDown = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"]; 
        popperLeft = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"]; 
        popperRight = [CCSprite spriteWithSpriteFrameName:@"popperGreen.png"];
    }
    else if (popometerBlue == 1) {
        popperUp = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"]; 
        popperDown = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"]; 
        popperLeft = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"]; 
        popperRight = [CCSprite spriteWithSpriteFrameName:@"popperBlue.png"];
    }
    else if (popometerPurple == 1) {
        popperUp = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"]; 
        popperDown = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"]; 
        popperLeft = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"]; 
        popperRight = [CCSprite spriteWithSpriteFrameName:@"popperPurple.png"];
    }
    
    [self addChild:popperUp z:3 tag:801]; // Up
    [self addChild:popperRight z:3 tag:802]; // Right
    [self addChild:popperDown z:3 tag:803]; // Down
    [self addChild:popperLeft z:3 tag:804]; // Left
    
    popperUp.position = ccp(popper.position.x,popper.position.y);
    popperDown.position = ccp(popper.position.x,popper.position.y);
    popperLeft.position = ccp(popper.position.x,popper.position.y);
    popperRight.position = ccp(popper.position.x,popper.position.y);
    popperUp.scale = .2;
    popperDown.scale = .2;
    popperLeft.scale = .2;
    popperRight.scale = .2;
    
    // Spin the spinners
    id action = [CCRotateBy actionWithDuration:2.5  angle: 5000];	
	[popperUp runAction:[CCRepeatForever actionWithAction:action]];
    action = [CCRotateBy actionWithDuration:2.5  angle: 5000];	
	[popperDown runAction:[CCRepeatForever actionWithAction:action]];
    action = [CCRotateBy actionWithDuration:2.5  angle: 5000];	
	[popperLeft runAction:[CCRepeatForever actionWithAction:action]];
    action = [CCRotateBy actionWithDuration:2.5  angle: 5000];	
	[popperRight runAction:[CCRepeatForever actionWithAction:action]];
    
    // Move the spinners
    id move = [CCMoveBy actionWithDuration:2 position:ccp(0,[self cpY:900])];		
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
	action = [CCSequence actions:move, actionMoveDone, nil];
	[popperUp runAction:action];
    move = [CCMoveBy actionWithDuration:2 position:ccp(0,-[self cpY:900])];		
	action = [CCSequence actions:move, actionMoveDone, nil];
	[popperDown runAction:action];
    move = [CCMoveBy actionWithDuration:2 position:ccp(-[self cpX:1200],0)];		
	action = [CCSequence actions:move, actionMoveDone, nil];
	[popperLeft runAction:action];
    move = [CCMoveBy actionWithDuration:2 position:ccp([self cpX:1200],0)];		
	action = [CCSequence actions:move, actionMoveDone, nil];
	[popperRight runAction:action];
    
    // Add the spinners to the Spinner array
	[_allSpinners addObject:popperUp];
	[_allSpinners addObject:popperDown];
	[_allSpinners addObject:popperLeft];
	[_allSpinners addObject:popperRight];
}

-(void) popperTouch:(CGPoint)location {
    
	// Cycle through all Poppers
	for (CCSprite *popper in _allPoppers) {
		CGRect popperRect = [popper boundingBox]; 
        
        // If a Popper was touched, first determine if it is a top level popper.  If it is, pop it, otherwise change it
		if (CGRectContainsPoint(popperRect, location)) {	
            
            // Save the popper positions prior to any move
            [self savePopperPos];

            currentTaps = currentTaps + 1;
            [self gameHeader];

            if ((popper.tag >= 7101) && (popper.tag <= 7199)) {
                [self launchSpinners:popper];
                [self popEffect:popper];
            }
            else {
                [self changePopper:popper];                
            }
            
            // Remove any hint
            [self removeChildByTag:9999 cleanup:YES];
            if (hintsActive == YES) displayHint = YES;
		}
	}
    // Remove all poppers that have been popped
    for (CCSprite *popper in _removePoppers) {
        [_allPoppers removeObject:popper];
        [self removeChild:popper cleanup:YES];
    }
    [_removePoppers removeAllObjects];
}

-(void) ricochetCollisionDetection {
	
	for (CCSprite *ricochet in _allRicochetWalls) {
        
		CGRect ricochetRect = [ricochet boundingBox]; 
		
		// Array for spinners to process
		NSMutableArray *spinnersToProcess1 = [[NSMutableArray alloc] init];
		NSMutableArray *spinnersToProcess2 = [[NSMutableArray alloc] init];
		
		// Cycle through all spinners
		for (CCSprite *spinner in _allSpinners) {
            CGRect spinnerRect = [spinner boundingBox]; 
            
			if (CGRectIntersectsRect(spinnerRect, ricochetRect)) {
                
                // Determine which way the ricochet wall is facing
                if (ricochet.tag == 7801) {
                    [spinnersToProcess1 addObject:spinner];                    
                }
                else if (ricochet.tag == 7802) {
                    [spinnersToProcess2 addObject:spinner];                    
                }
			}
		}
		
        // Process the spinners for LEFT/DOWN facing wall
		for (CCSprite *spinner in spinnersToProcess2) {
            [spinner stopAllActions];
            
            // Spinner is going UP, then it will ricochet to LEFT
            if (spinner.tag == 801) {
                spinner.tag = 804; 
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id move = [CCMoveBy actionWithDuration:2 position:ccp(-[self cpX:1200],0)];		
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            // Spinner is going RIGHT, then it will ricochet DOWN
            else if (spinner.tag == 802) {
                spinner.tag = 803;
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id move = [CCMoveBy actionWithDuration:2 position:ccp(0,-[self cpY:900])];		
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            // Spinner is going LEFT, then it will ricochet UP
            else if (spinner.tag == 804) {
                spinner.tag = 801;
                id move = [CCMoveBy actionWithDuration:2 position:ccp(0,[self cpY:900])];		
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            // Spinner is going DOWN, then it will ricochet RIGHT
            else if (spinner.tag == 803) {
                spinner.tag = 802;
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id move = [CCMoveBy actionWithDuration:2 position:ccp([self cpX:1200],0)];		
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            
            // Spin the spinners
            id action = [CCRotateBy actionWithDuration:2.5  angle: 5000];	
            [spinner runAction:[CCRepeatForever actionWithAction:action]];
  		}
        
        // Process the spinners for RIGHT/UP facing wall
		for (CCSprite *spinner in spinnersToProcess1) {
            [spinner stopAllActions];
            
            // Spinner is going UP, then it will ricochet to RIGHT
            if (spinner.tag == 801) {
                spinner.tag = 802; 
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id move = [CCMoveBy actionWithDuration:2 position:ccp([self cpX:1200],0)];		
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            // Spinner is going RIGHT, then it will ricochet UP
            else if (spinner.tag == 802) {
                spinner.tag = 801;
                id move = [CCMoveBy actionWithDuration:2 position:ccp(0,[self cpY:900])];		
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            // Spinner is going LEFT, then it will ricochet DOWN
            else if (spinner.tag == 804) {
                spinner.tag = 803;
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id move = [CCMoveBy actionWithDuration:2 position:ccp(0,-[self cpY:900])];		
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            // Spinner is going DOWN, then it will ricochet LEFT
            else if (spinner.tag == 803) {
                spinner.tag = 804;
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                id move = [CCMoveBy actionWithDuration:2 position:ccp(-[self cpX:1200],0)];		
                id action = [CCSequence actions:move, actionMoveDone, nil];
                [spinner runAction:action];
            }
            
            // Spin the spinners
            id action = [CCRotateBy actionWithDuration:2.5  angle: 5000];	
            [spinner runAction:[CCRepeatForever actionWithAction:action]];
 		}
        
		[spinnersToProcess1 release];
		[spinnersToProcess2 release];
	}
}

-(void) popperCollisionDetection {
	
	for (CCSprite *popper in _allPoppers) {
        
		CGRect popperRect = [popper boundingBox]; 
		
		// Array for spinners to delete
		NSMutableArray *spinnersToDelete = [[NSMutableArray alloc] init];
		
		// Cycle through all spinners
		for (CCSprite *spinner in _allSpinners) {
            CGRect spinnerRect = [spinner boundingBox]; 
            
			if (CGRectIntersectsRect(spinnerRect, popperRect)) {
                
                // Remove any double sets of spinners that are attempting to pop the same popper
                // Load the array to delete the spinner
				[spinnersToDelete addObject:spinner];
			}
		}
		
        // Remove the spinners that collided with poppers
		for (CCSprite *spinner in spinnersToDelete) {
			[_allSpinners removeObject:spinner];
            [self removeChild:spinner cleanup:YES];
            
            // If top level pop the popper, else change it
            if ((popper.tag >= 7101) && (popper.tag <= 7199)) {
                [self launchSpinners:popper];
                [self popEffect:popper];
            }
            else {
                [self changePopper:popper];                
            }
            
            break;
		}
		[spinnersToDelete release];
	}
    // Remove all poppers that have been popped
    for (CCSprite *popper in _removePoppers) {
        [_allPoppers removeObject:popper];
        [self removeChild:popper cleanup:YES];
    }
    [_removePoppers removeAllObjects];
}

-(void) popperCollisionDetectionTest {
    
    // Array for spinners to delete
    NSMutableArray *spinnersToDelete = [[NSMutableArray alloc] init];
    
	for (CCSprite *spinner in _allSpinners) {
        
		CGRect spinnerRect = [spinner boundingBox]; 
		
		// Array for poppers to delete
		NSMutableArray *poppersToDelete = [[NSMutableArray alloc] init];
		
		// Cycle through all poppers
		for (CCSprite *popper in _allPoppers) {
            CGRect popperRect = [popper boundingBox]; 
            
			if (CGRectIntersectsRect(popperRect, spinnerRect)) {
				
                // If top level pop the popper, else change it
                
                if ((popper.tag >= 7101) && (popper.tag <= 7199)) {
                    [self launchSpinners:popper];
                    [self popEffect:popper];
                }
                else {
                    [self changePopper:popper];                
                }
                
                // Load the array to delete the spinner
				[spinnersToDelete addObject:spinner];
			}
		}
        
        // Remove all poppers that have been popped
        for (CCSprite *popper in _removePoppers) {
            [_allPoppers removeObject:popper];
        }
	}
    // Remove all spinners that have already collided
    for (CCSprite *spinner in spinnersToDelete) {
        [_allSpinners removeObject:spinner];
    }
    [spinnersToDelete release];
}

-(void) reviewApp {
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

-(void) displayFacebook {
	NSURL *url = [NSURL URLWithString:@"http://www.facebook.com/icrazyplay"];
	
	if (![[UIApplication sharedApplication] openURL:url])
		
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

-(void) levelFailSummary {
    
    levelFail = YES;
    levelsPlayed = [[NSUserDefaults standardUserDefaults] integerForKey:@"levels_played"];
    levelsPlayed = levelsPlayed + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:levelsPlayed forKey:@"levels_played"];
    
    // If No Ads PowerUp is active, then retrieve the count.  If count is less than 10, increment it.  Otherwise, reset the
    // No Ads PowerUp
    /* 2.0.1
    BOOL noAdsPowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"noAdsPowerUp"];
    if (noAdsPowerUp == YES) {
        int noAdsPowerUpCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"noAdsPowerUp_Count"];
        noAdsPowerUpCount = noAdsPowerUpCount + 1;
        if (noAdsPowerUpCount >= 10) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"noAdsPowerUp"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"noAdsPowerUp_Count"];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setInteger:noAdsPowerUpCount forKey:@"noAdsPowerUp_Count"];
        }
    }
     */

    // Check to see if ad banner should display
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if (removeAds != YES) {
        
        // Display Chartboost after every 5 attempts
        NSLog(@"Levels Played:%d",levelsPlayed);

        if (levelsPlayed >= 5) {
            levelsPlayed = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"levels_played"];
            
            if (appLovinActive == NO) {
                if ([cb hasCachedInterstitial:@"Level Summary Every 5"]) {
                    [cb showInterstitial:@"Level Summary Every 5"];
                    [Flurry logEvent:@"Chartboost Ad Every 5"];
                }
                [cb cacheInterstitial:@"Level Summary Every 5"];
            }
            else {
                [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
            }
        }
        
        // Display RevMob banner
//        [[RevMobAds session] showBanner];
        
        // Display adMob banner
        //        [self displayBanner];
    }
    
	[Flurry logEvent:@"Popper Level Failed"];
    
    // Record the level completed analytics
    int adjustedLevel;
    if (menuSelectionNo == 1) {
        adjustedLevel = currentLevel;
    }
    else {
        adjustedLevel = currentLevel + (100*menuSelectionNo);
    }
  	NSString *levelAnalyticsStr = [NSString stringWithFormat:@"%d",adjustedLevel];
	NSDictionary *levelNumDictionary = [NSDictionary dictionaryWithObjectsAndKeys:levelAnalyticsStr,
                                        @"Level #", nil];
 	[Flurry logEvent:@"Level # Failed" withParameters:levelNumDictionary];
	
	// Add Level Background
	CCSprite *levelBackground = [CCSprite spriteWithSpriteFrameName:@"levelCompleteBackground.png"];
	levelBackground.scaleY = .1;
	levelBackground.scaleX = .1;
	levelBackground.opacity = 0;
	[self addChild:levelBackground z:7 tag:500];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        levelBackground.position = ccp(screenSize.width/2, 155);
    }
    else {
        levelBackground.position = ccp(512,370);
    }
	
	id delay = [CCFadeTo actionWithDuration:.75 opacity:0];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(levelFailSummary2)];
	id appear = [CCFadeTo actionWithDuration:1.25 opacity:255];
	id scaleUp = [CCScaleTo actionWithDuration:.2 scaleX:1.2 scaleY:1.2];
	id scaleDown = [CCScaleTo actionWithDuration:.1 scaleX:1 scaleY:1];
	id action = [CCSpawn actions: appear,
				 [CCSequence actions:delay, scaleUp, scaleDown, actionMoveDone, nil],nil];
	
	[levelBackground runAction:action];
}

-(void) levelFailSummary2 {
       
	if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Cartoon Whistle.mp3" pitch:1.0 pan:1.0 gain:5.0];}
	
 	CCSprite *levelBackground = (CCSprite *)[self getChildByTag:500];
 	id appear = [CCFadeTo actionWithDuration:.25 opacity:255];
 	id action = [CCSequence actions:appear, nil, nil];
 	[levelBackground runAction:action];
	
	// Add semi-transparent black Background over the entire screen
	CCSprite *blackBackground;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		blackBackground = [CCSprite spriteWithFile:@"blackBackground.png"];}
	else {
		blackBackground = [CCSprite spriteWithFile:@"blackBackground-hd.png"];}
	
	blackBackground.opacity = 0;
	[self addChild:blackBackground z:6 tag:100];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        blackBackground.position = ccp(screenSize.width/2, 170);
    }
	else {
        blackBackground.position = ccp(512,384);
    }
	
	NSString *commentStr;
    
    // Check to see if banner ad is displaying.  If so, then offset the buttons
    int adOffset = 0;
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if (removeAds != YES) {
        adOffset = 0;  // was 44
    }

    // If undo powerup is active, show the undo button
    BOOL undoPowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"undoPowerUp"];

    if (undoPowerUp == YES) {
        // Show the undo button
        CCSprite *undoButton = [CCSprite spriteWithSpriteFrameName:@"undoButton.png"];
        [self addChild:undoButton z:8 tag:14];

        // Show the menu button
        CCSprite *menuButton = [CCSprite spriteWithSpriteFrameName:@"menuButton.png"];
        [self addChild:menuButton z:8 tag:16];
        
        // Show the repeat level button
        CCSprite *repeatLevel = [CCSprite spriteWithSpriteFrameName:@"repeat.png"];
        [self addChild:repeatLevel z:8 tag:15];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            undoButton.position = ccp(screenSize.width/2-68, 100-adOffset);
            menuButton.position = ccp(screenSize.width/2+4, 100-adOffset);
            repeatLevel.position = ccp(screenSize.width/2+75, 100-adOffset);
        }
        else {
            undoButton.position = ccp(screenSize.width/2-143, 240-adOffset);
            menuButton.position = ccp(screenSize.width/2+8, 240-adOffset);
            repeatLevel.position = ccp(screenSize.width/2+158, 240-adOffset);
        }
    }
    else {
        // Show the menu button
        CCSprite *menuButton = [CCSprite spriteWithSpriteFrameName:@"menuButton.png"];
        [self addChild:menuButton z:8 tag:16];
        
        // Show the repeat level button
        CCSprite *repeatLevel = [CCSprite spriteWithSpriteFrameName:@"repeat.png"];
        [self addChild:repeatLevel z:8 tag:15];
 
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            menuButton.position = ccp(screenSize.width/2-28, 100-adOffset);
            repeatLevel.position = ccp(screenSize.width/2+43, 100-adOffset);
        }
        else {
            menuButton.position = ccp(screenSize.width/2-59, 240-adOffset);
            repeatLevel.position = ccp(screenSize.width/2+90, 240-adOffset);
        }
    }
	
    // Build the power ups
    [self powerUpSetup:currentLevel];

    
	int fontSize1, fontSize2, x1, y1, yOffset;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 48;
		fontSize2 = 17;
		x1 = 400;
		y1 = 125;
        yOffset = 18;}
	else {
		fontSize1 = 100;
		fontSize2 = 36;
		x1 = 725;
		y1 = 250;
        yOffset = 0;}
	
	// LEVEL FAILED Label
    commentStr = @"Level Failed!";
	CCLabelTTF *commentLabel = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentLabel.color = ccc3(255,233,142);
	[self addChild:commentLabel z:8 tag:51];
	CCLabelTTF *commentShadow = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentShadow.color = ccc3(0,0,0);
	[self addChild:commentShadow z:7 tag:52];


    // Show Max Taps
    NSString *maxTapsStr;
    if (maxTaps == 1) {
        maxTapsStr = [NSString stringWithFormat:@"Level can be completed in %d Tap",maxTaps];}
    else { 
        maxTapsStr = [NSString stringWithFormat:@"Level can be completed in %d Taps",maxTaps];}
	CCLabelTTF *maxTapsLabel = [CCLabelTTF labelWithString:maxTapsStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
	maxTapsLabel.color = ccc3(0,0,0);
	[self addChild:maxTapsLabel z:7 tag:53];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        commentLabel.position = ccp(screenSize.width/2, 229);
        commentShadow.position = ccp(screenSize.width/2+3, 229-3);
        maxTapsLabel.position = ccp(screenSize.width/2, 196 - yOffset);
    }
    else {
        commentLabel.position = ccp(screenSize.width/2, 500);
        commentShadow.position = ccp(screenSize.width/2+3, 500-3);
        maxTapsLabel.position = ccp(screenSize.width/2, 65 - yOffset);
    }
    
	appear = [CCFadeTo actionWithDuration:.25 opacity:70];
	action = [CCSequence actions:appear, nil, nil];
	[blackBackground runAction:action];
	
	// Remove the existing high score
	[self removeChildByTag:1011 cleanup:YES];
	[self removeChildByTag:1012 cleanup:YES];
	
	// Remove the pause button
	[self removeChildByTag:13 cleanup:YES];
	
	// Remove the hint button
	[self removeChildByTag:19 cleanup:YES];
        
	// Remove the undo button
	[self removeChildByTag:22 cleanup:YES];
    
    // If the user is stuck, then display a pop-up 
    int attempts = [[NSUserDefaults standardUserDefaults] integerForKey:@"crazy_poppers_level_attempts"];
    if (attempts >= 3) {
        if (currentLevel == 5) {
            freeHint = nil;
            NSString *hintStr = [NSString stringWithString:@"Having trouble with the level? Use a FREE hint to complete it!"];
            
            freeHint = [[UIAlertView alloc] initWithTitle: @"Having Trouble?" message:hintStr  delegate: self cancelButtonTitle: @"No Thanks" otherButtonTitles: @"Hint!" ,nil];
            [freeHint show];
            [freeHint release];
        }
        else {
            hintPrompt = nil;
            NSString *hintStr = [NSString stringWithString:@"Stuck on a level? Use a hint to complete it!"];
            
            hintPrompt = [[UIAlertView alloc] initWithTitle: @"Having Trouble?" message:hintStr  delegate: self cancelButtonTitle: @"No Thanks" otherButtonTitles: @"Hint!" ,nil];
            [hintPrompt show];
            [hintPrompt release];
        }
    }
    else {
        attempts = attempts + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:attempts forKey:@"crazy_poppers_level_attempts"];
    }
}


-(void) levelSummary {
    
    if (levelFail == YES) return;
    levelsPlayed = [[NSUserDefaults standardUserDefaults] integerForKey:@"levels_played"];
    levelsPlayed = levelsPlayed + 1;
    [[NSUserDefaults standardUserDefaults] setInteger:levelsPlayed forKey:@"levels_played"];
    
    // If No Ads PowerUp is active, then retrieve the count.  If count is less than 10, increment it.  Otherwise, reset the
    // No Ads PowerUp
    /* 2.0.1
    BOOL noAdsPowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"noAdsPowerUp"];
    if (noAdsPowerUp == YES) {
        int noAdsPowerUpCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"noAdsPowerUp_Count"];
        noAdsPowerUpCount = noAdsPowerUpCount + 1;
        if (noAdsPowerUpCount >= 10) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"noAdsPowerUp"];
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"noAdsPowerUp_Count"];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setInteger:noAdsPowerUpCount forKey:@"noAdsPowerUp_Count"];
        }
    }
     */

    // Check to see if feature ad (Chartboost) should display.
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
//    BOOL noAdsPowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"noAdsPowerUp"];
//    if ((removeAds != YES) && (noAdsPowerUp != YES)) {
    if (removeAds != YES) {
//        [self displayBanner];

        // Display Chartboost after every 5 attempts
        if (levelsPlayed >= 5) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"levels_played"];
            levelsPlayed = 0;
            
            if ([cb hasCachedInterstitial:@"Level Summary Every 5"]) {
                if (appLovinActive == NO) {
                    [cb showInterstitial:@"Level Summary Every 5"];
                    [Flurry logEvent:@"Chartboost Ad Every 5"];
                }
                else {
                    [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
                }
            }
            [cb cacheInterstitial:@"Level Summary Every 5"];
        }
        // Every 5th level display a feature ad
        if ((currentLevel % 5) == 0) {
            // Show an interstitial
            
            if ([cb hasCachedInterstitial:@"Level Summary Every 5th"]) {
                if (appLovinActive == NO) {
                    [cb showInterstitial:@"Level Summary Every 5th"];
                    [Flurry logEvent:@"Chartboost Ad Every 5th"];
                }
                else {
                    [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
                }
            }
            [cb cacheInterstitial:@"Level Summary Every 5th"];
        }
        // Every 8th level display a feature ad
        else if ((currentLevel % 8) == 0) {
            // Show an interstitial
            
            if ([cb hasCachedInterstitial:@"Level Summary Every 8th"]) {
                if (appLovinActive == NO) {
                    [cb showInterstitial:@"Level Summary Every 8th"];
                    [Flurry logEvent:@"Chartboost Ad Every 8th"];
                }
                else {
                    [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
                }
            }
            [cb cacheInterstitial:@"Level Summary Every 8th"];
        }
 //       else {
 //           [self displayBanner];
//        }

    }
    
	[Flurry logEvent:@"Popper Level Completed"];
    
    // Tapjoy PPE first 5 levels completed
    if (currentLevel == 5) {
        [TapjoyConnect actionComplete:@"7a430a53-a316-42de-9577-64d155d01cbb"];
    }
    
    // Tapjoy PPE first 10 levels completed
    if (currentLevel == 10) {
        [TapjoyConnect actionComplete:@"1e682357-8b50-400f-a49e-a8e89ebefe68"];
    }

    // Record the level completed analytics
    int adjustedLevel;
    if (menuSelectionNo == 1) {
        adjustedLevel = currentLevel;
    }
    else {
        adjustedLevel = currentLevel + (100*menuSelectionNo);
    }
  	NSString *levelAnalyticsStr = [NSString stringWithFormat:@"%d",adjustedLevel];
	NSDictionary *levelNumDictionary = [NSDictionary dictionaryWithObjectsAndKeys:levelAnalyticsStr,
                                        @"Level #", nil];
 	[Flurry logEvent:@"Level # Completed" withParameters:levelNumDictionary];
	
	// Add Level Background
	CCSprite *levelBackground = [CCSprite spriteWithSpriteFrameName:@"levelCompleteBackground.png"];
	levelBackground.scaleY = .1;
	levelBackground.scaleX = .1;
	levelBackground.opacity = 0;
	[self addChild:levelBackground z:7 tag:500];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        levelBackground.position = ccp(screenSize.width/2, 153);
    }
    else {
        levelBackground.position = ccp(512,370);
    }
	
	id delay = [CCFadeTo actionWithDuration:.75 opacity:0];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(levelSummary2)];
	id appear = [CCFadeTo actionWithDuration:1.25 opacity:255];
	id scaleUp = [CCScaleTo actionWithDuration:.2 scaleX:1.2 scaleY:1.2];
	id scaleDown = [CCScaleTo actionWithDuration:.1 scaleX:1 scaleY:1];
	id action = [CCSpawn actions: appear,
				 [CCSequence actions:delay, scaleUp, scaleDown, actionMoveDone, nil],nil];
	
	[levelBackground runAction:action];
}

-(void) levelSummary2 {

	if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"applause2.mp3" pitch:1.0 pan:1.0 gain:5.0];}
	
 	CCSprite *levelBackground = (CCSprite *)[self getChildByTag:500];
 	id appear = [CCFadeTo actionWithDuration:.25 opacity:255];
 	id action = [CCSequence actions:appear, nil, nil];
 	[levelBackground runAction:action];
	
	// Add semi-transparent black Background over the entire screen
	CCSprite *blackBackground;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		blackBackground = [CCSprite spriteWithFile:@"blackBackground.png"];}
	else {
		blackBackground = [CCSprite spriteWithFile:@"blackBackground-hd.png"];}
	
	blackBackground.opacity = 0;
	[self addChild:blackBackground z:6 tag:100];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        blackBackground.position = ccp(screenSize.width/2, 170);
    }
	else {
        blackBackground.position = ccp(512,384);
    }
	NSString *commentStr;
	    
    // Automatically unlock when last level is reached
    if ((menuSelectionNo == 1) && (currentLevel == 105)) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"popper_pack_2_unlocked"];
    }
    if ((menuSelectionNo == 2) && (currentLevel == 105)) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"popper_pack_3_unlocked"];
    }
    if ((menuSelectionNo == 3) && (currentLevel == 105)) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"popper_pack_4_unlocked"];
    }    

    // Show the menu button
    CCSprite *menuButton = [CCSprite spriteWithSpriteFrameName:@"menuButton.png"];
    [self addChild:menuButton z:8 tag:16];
    
    // Show the repeat level button
    CCSprite *repeatLevel = [CCSprite spriteWithSpriteFrameName:@"repeat.png"];
    [self addChild:repeatLevel z:8 tag:15];
    
    // Check to see if banner ad is displaying.  If so, then offset the buttons
    int adOffset = 0;
    BOOL removeAds = [[NSUserDefaults standardUserDefaults] boolForKey:@"remove_ads"];
    if ((removeAds != YES) && ((currentLevel % 5) != 0) && ((currentLevel % 8) != 0)) {
        adOffset = 0; // was 42
    }

    // Show the next level button
    CCSprite *nextLevel;
    if (((currentLevel < 105) && (menuSelectionNo != 12)) || ((currentLevel < 315) && (menuSelectionNo == 12))) {
        nextLevel = [CCSprite spriteWithSpriteFrameName:@"nextLevel.png"];
        [self addChild:nextLevel z:8 tag:17];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            nextLevel.position = ccp(screenSize.width/2+75, 98-adOffset);
        }
        else {
            nextLevel.position = [self convertPoint:ccp(662, 250-adOffset)];
        }
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        menuButton.position = ccp(screenSize.width/2-68, 98-adOffset);
        repeatLevel.position = ccp(screenSize.width/2+4, 98-adOffset);
    }
    else {
        menuButton.position = [self convertPoint:ccp(362, 250-adOffset)];
        repeatLevel.position = [self convertPoint:ccp(512, 250-adOffset)];
    }
    
	int fontSize1, fontSize2, x1, y1, yOffset;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 50;
        fontSize2 = 20;
		x1 = 400;
		y1 = 125;
        yOffset = 40;}
	else {
		fontSize1 = 130;
        fontSize2 = 44;
		x1 = 725;
		y1 = 250;
        yOffset = 0;}
	
	// EXCELLENT, GREAT, GOOD Label
    NSInteger num = (arc4random() % 6) + 1;
	switch (num)
	{
		case 1: {commentStr = @"Excellent!"; break;}
		case 2: {commentStr = @"Awesome!"; break;}
		case 3: {commentStr = @"Great!"; break;}
		case 4: {commentStr = @"Very Cool!"; break;}
		case 5: {commentStr = @"Terrific!"; break;}
		case 6: {commentStr = @"Super!"; break;}
	}
    
	CCLabelTTF *commentLabel = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentLabel.color = ccc3(255,233,142);
	[self addChild:commentLabel z:8];
	CCLabelTTF *commentShadow = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentShadow.color = ccc3(0,0,0);
	[self addChild:commentShadow z:7];
	
    // Show Score & Rewards Label
    NSString *scoreStr;
    scoreStr = [NSString stringWithFormat:@"Score:                   Reward:"];
	CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
	scoreLabel.color = ccc3(0,0,0);
	[self addChild:scoreLabel z:7];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        commentLabel.position = ccp(screenSize.width/2+4, 230);
        commentShadow.position = ccp(screenSize.width/2+4+3, 230-3);
        scoreLabel.position = ccp(screenSize.width/2-28, 177);
    }
    else {
        commentLabel.position = [self convertPoint:ccp(512, 510)];
        commentShadow.position = [self convertPoint:ccp(512+3, 510-3)];
        scoreLabel.position = ccp(445, 60);
    }
    
	appear = [CCFadeTo actionWithDuration:.25 opacity:70];
	action = [CCSequence actions:appear, nil, nil];
	[blackBackground runAction:action];
	
	// Remove the existing high score
	[self removeChildByTag:1011 cleanup:YES];
	[self removeChildByTag:1012 cleanup:YES];
	
	// Remove the pause button
	[self removeChildByTag:13 cleanup:YES];
    
	// Remove the hint button
	[self removeChildByTag:19 cleanup:YES];
        
	// Remove the undo button
	[self removeChildByTag:22 cleanup:YES];

    // Calculate, save & display the current score
    [self calculateScore];

    // Display Reward
    [self addReward];
        
    // Add the Power Ups
    [self powerUpSetup:currentLevel];

	// Save the current level
	[[NSUserDefaults standardUserDefaults] setInteger:currentLevel forKey:@"popper_current_level"];
    
    // Retrieve which page was selected 
    levelSelectionPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"crazy_poppers_level_selection"];
    
    int actualLevel = currentLevel;
    
	// Save the highest level
	if (actualLevel > highestLevel) {
        if (menuSelectionNo == 1) {
            [[NSUserDefaults standardUserDefaults] setInteger:actualLevel forKey:@"popper1_highest_level"];}
        else if (menuSelectionNo == 2) {
            [[NSUserDefaults standardUserDefaults] setInteger:actualLevel forKey:@"popper2_highest_level"];}
        else if (menuSelectionNo == 3) {
            [[NSUserDefaults standardUserDefaults] setInteger:actualLevel forKey:@"popper3_highest_level"];}
        else if (menuSelectionNo == 4) {
            [[NSUserDefaults standardUserDefaults] setInteger:actualLevel forKey:@"popper4_highest_level"];}
        else if (menuSelectionNo == 5) {
            [[NSUserDefaults standardUserDefaults] setInteger:actualLevel forKey:@"popper5_highest_level"];}
        else if (menuSelectionNo == 11) {
            [[NSUserDefaults standardUserDefaults] setInteger:actualLevel forKey:@"popometerPack_highest_level"];}
        else if (menuSelectionNo == 12) {
            [[NSUserDefaults standardUserDefaults] setInteger:actualLevel forKey:@"megaPack1_highest_level"];}
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) buildPack1Level1  {  
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Add Label
        [self addLabel:1 x:142 y:147];
        
        // Add Arrow
        [self addArrow:2 dir:2 x:190 y:151 rotate:0];
    }
    else {
        // Add Label
        [self addLabel:1 x:300 y:340];
        
        // Add Arrow
        [self addArrow:2 dir:2 x:400 y:350 rotate:0];
    }
    
    maxTaps = 1;    
    [self addPopper:0 p12:0 p13:0 p14:0 p15:0 p16:0 p21:0 p22:0 p23:0 p24:0 p25:0 p26:0 p31:0 p32:0 p33:1 p34:0 p35:0 p36:0 p41:0 p42:0 p43:0 p44:0 p45:0 p46:0 p51:0 p52:0 p53:0 p54:0 p55:0 p56:0];    
}

-(void) buildPack1Level2 {  
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Add Label
        [self addLabel:2 x:240 y:200];
    }
    else {
        // Add Label
        [self addLabel:2 x:512 y:480];
    }
    
    maxTaps = 1;    
    [self addPopper:1 p12:0 p13:0 p14:0 p15:1 p16:0 p21:0 p22:1 p23:0 p24:0 p25:1 p26:0 p31:0 p32:1 p33:0 p34:0 p35:0 p36:1 p41:0 p42:0 p43:1 p44:0 p45:0 p46:1 p51:0 p52:0 p53:1 p54:0 p55:0 p56:0];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"delay_hint"];
    // Add Hint
    [self addHint:11];
}

-(void) buildPack1Level3 {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Add Label
        [self addLabel:3 x:407 y:275];
        
        // Add Arrow
        [self addArrow:2 dir:2 x:350 y:282 rotate:0];
    }
    else {
        // Add Label
        [self addLabel:3 x:660 y:670];
        
        // Add Arrow
        [self addArrow:2 dir:2 x:760 y:680 rotate:0];
    }
    
    maxTaps = 3;    
    [self addPopper:0 p12:0 p13:0 p14:0 p15:0 p16:0 p21:0 p22:1 p23:0 p24:2 p25:0 p26:0 p31:0 p32:0 p33:0 p34:0 p35:0 p36:0 p41:0 p42:1 p43:0 p44:3 p45:0 p46:0 p51:0 p52:0 p53:0 p54:0 p55:0 p56:0];
    [self loadHints:22 h2:24 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"delay_hint"];
    displayHint = YES; hintsActive = YES;
}

-(void) buildPack1Level4 {
    maxTaps = 1;    
    [self addPopper:1 p12:0 p13:1 p14:0 p15:1 p16:0 p21:0 p22:0 p23:2 p24:0 p25:0 p26:0 p31:0 p32:0 p33:1 p34:0 p35:1 p36:0 p41:0 p42:0 p43:2 p44:0 p45:0 p46:0 p51:1 p52:0 p53:2 p54:0 p55:1 p56:0];
    [self loadHints:35 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level5 {    
    maxTaps = 2;
    [self addPopper:1 p12:0 p13:0 p14:0 p15:0 p16:1 p21:2 p22:2 p23:2 p24:2 p25:2 p26:2 p31:1 p32:1 p33:3 p34:3 p35:0 p36:1 p41:0 p42:0 p43:1 p44:1 p45:0 p46:0 p51:0 p52:0 p53:0 p54:0 p55:0 p56:0];
    [self loadHints:32 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level6 {
    maxTaps = 2;    
    [self loadPoppers:@"111000000111111000222020003000"];
    [self loadHints:43 h2:43 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level7 {
    maxTaps = 2;    
    [self addPopper:0 p12:3 p13:2 p14:1 p15:0 p16:0 p21:0 p22:2 p23:2 p24:2 p25:0 p26:0 p31:1 p32:1 p33:1 p34:1 p35:1 p36:1 p41:0 p42:2 p43:2 p44:2 p45:2 p46:2 p51:0 p52:0 p53:2 p54:2 p55:2 p56:0];
    [self loadHints:14 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level8 {
    maxTaps = 1;    
    [self loadPoppers:@"020200211030001103022022301202"];    
    [self loadHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level9 {    
    maxTaps = 3;    
    [self loadPoppers:@"120012002100123312002100120012"];
    [self loadHints:34 h2:36 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level10 {
    maxTaps = 1;    
    [self loadPoppers:@"011032202232031121212123222022"];
    [self loadHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level11 {
    maxTaps = 3;    
    [self loadPoppers:@"302322200032010111010010210013"];
    [self loadHints:36 h2:13 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level12 {
    maxTaps = 2;    
    [self loadPoppers:@"333330022200100010111110332330"];
    [self loadHints:35 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level13 {
    maxTaps = 1;    
    [self loadPoppers:@"111111102201210012130031111111"];
    [self loadHints:11 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level14 {
    maxTaps = 2;    
    [self loadPoppers:@"103301112301101311322313203113"];
    [self loadHints:16 h2:11 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level15 { // 1.01    
    maxTaps = 3;    
    [self loadPoppers:@"132211031130200003300011013220"];
    [self loadHints:15 h2:22 h3:36 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level16 {  
    maxTaps = 3;    
    [self loadPoppers:@"222130333012212233202200301033"];
    [self loadHints:53 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level17 { // 1.01
    maxTaps = 2;    
    [self loadPoppers:@"023130412020010301313114021031"];
    [self loadHints:22 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level18 {
    maxTaps = 2;    
    [self loadPoppers:@"102232221022132241422222101012"];
    [self loadHints:23 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level19 {
    maxTaps = 1;    
    [self loadPoppers:@"103221111102201002200312301200"];
    [self loadHints:23 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level20 {
    maxTaps = 4;    
    [self loadPoppers:@"031322320211323203223230132222"];
    [self loadHints:25 h2:13 h3:32 h4:32 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level21 {
    maxTaps = 4;    
    [self loadPoppers:@"233210002321030233122103021311"];
    [self loadHints:56 h2:24 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}


-(void) buildPack1Level22 {
    maxTaps = 3;    
    [self loadPoppers:@"131320022302430321221220323120"];
    [self loadHints:54 h2:22 h3:43 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level23 {
    maxTaps = 2;    
    [self loadPoppers:@"312310030323022233221103102012"];
    [self loadHints:43 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level24 {
    maxTaps = 1;    
    [self loadPoppers:@"303322103301121200313010012312"];
    [self loadHints:42 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level25 {
    maxTaps = 2;    
    [self loadPoppers:@"211202332132311332200231322320"];
    [self loadHints:13 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level26 { // 1.01
    maxTaps = 3;    
    [self loadPoppers:@"103040201222210222124243222312"];
    [self loadHints:32 h2:34 h3:45 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level27 {
    maxTaps = 3;    
    [self loadPoppers:@"002311010123020203000131322333"];
    [self loadHints:24 h2:13 h3:53 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level28 {
    maxTaps = 4;    
    [self loadPoppers:@"201123222222323302033323310202"];
    [self loadHints:24 h2:34 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level29 {
    maxTaps = 5;    
    [self loadPoppers:@"124223340001330120213322331301"];
    [self loadHints:26 h2:34 h3:14 h4:32 h5:32 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level30 { // done
    maxTaps = 2;    
    [self loadPoppers:@"033414021132101001003202022020"];
    [self loadHints:44 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level31 {
    maxTaps = 4;    
    [self loadPoppers:@"423020134302213302322013021410"];
    [self loadHints:45 h2:43 h3:33 h4:12 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level32 {
    maxTaps = 4;    
    [self loadPoppers:@"214412033132100330330120111322"];
    [self loadHints:53 h2:42 h3:24 h4:15 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level33 {
    maxTaps = 2;    
    [self loadPoppers:@"223213220121323033132112100131"];
    [self loadHints:51 h2:36 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level34 {
    maxTaps = 2;    
    [self loadPoppers:@"003310000201331212113300202300"];
    [self loadHints:33 h2:15 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level35 { // 1.01
    maxTaps = 2;    
    [self loadPoppers:@"113112211300402223102030202100"];
    [self loadHints:33 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level36 {
    maxTaps = 3;    
    [self loadPoppers:@"123202003131223220100220303231"];
    [self loadHints:11 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level37 {
    maxTaps = 3;    
    [self loadPoppers:@"302021100111221111240430020233"];
    [self loadHints:35 h2:44 h3:54 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level38 {
    maxTaps = 5;    
    [self loadPoppers:@"002010223302323220213200102301"];
    [self loadHints:56 h2:42 h3:41 h4:43 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level39 {
    maxTaps = 5;    
    [self loadPoppers:@"102123331221334333322323012043"];
    [self loadHints:46 h2:33 h3:33 h4:33 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level40 { // 1.01
    maxTaps = 2;    
    [self loadPoppers:@"111322021330132210033130011311"];
    [self loadHints:23 h2:56 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level41 {
    maxTaps = 1;    
    [self loadPoppers:@"243334200120030100210122323232"];
    [self loadHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level42 {
    maxTaps = 3;    
    [self loadPoppers:@"321104013221143332231122331003"];
    [self loadHints:44 h2:13 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}


-(void) buildPack1Level43 {
    maxTaps = 3;    
    [self loadPoppers:@"002113012303111034011403024113"];
    [self loadHints:14 h2:55 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level44 {
    maxTaps = 3;    
    [self loadPoppers:@"232000133001012313131133200022"];
    [self loadHints:44 h2:33 h3:13 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level45 {
    maxTaps = 4;    
    [self loadPoppers:@"122230103010323330002131200211"];
    [self loadHints:25 h2:44 h3:34 h4:34 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level46 {
    maxTaps = 3;    
    [self loadPoppers:@"113300100021022002034201111111"];
    [self loadHints:44 h2:44 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level47 {
    maxTaps = 4;    
    [self loadPoppers:@"231140223202110321400040233022"];
    [self loadHints:32 h2:22 h3:23 h4:26 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level48 {
    maxTaps = 1;    
    [self loadPoppers:@"211021331232031012032132010212"];
    [self loadHints:23 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level49 {
    maxTaps = 3;    
    [self loadPoppers:@"130412204312222201212321102010"];
    [self loadHints:36 h2:33 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level50 {
    maxTaps = 4;    
    [self loadPoppers:@"011023300303320122320233101002"];
    [self loadHints:13 h2:34 h3:41 h4:24 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level51 { // 1.01
    maxTaps = 2;    
    [self loadPoppers:@"313131223223023132231141012303"];
    [self loadHints:34 h2:36 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level52 {
    maxTaps = 3;    
    [self loadPoppers:@"121320100002002103212001233002"];
    [self loadHints:46 h2:43 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level53 {
    maxTaps = 2;    
    [self loadPoppers:@"040123221311000000113020302323"];
    [self loadHints:42 h2:23 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level54 {
    maxTaps = 4;    
    [self loadPoppers:@"100142200112221341033301300332"];
    [self loadHints:33 h2:32 h3:34 h4:42 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level55 {
    maxTaps = 1;    
    [self loadPoppers:@"010013020300011103210231331001"];
    [self loadHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level56 {
    maxTaps = 5;    
    [self loadPoppers:@"233312021311303004220210134010"];
    [self loadHints:15 h2:23 h3:12 h4:52 h5:33 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level57 {
    maxTaps = 3;    
    [self loadPoppers:@"332023303032012200031230113111"];
    [self loadHints:26 h2:33 h3:33 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level58 {
    maxTaps = 5;    
    [self loadPoppers:@"043310232332132200123021033230"];
    [self loadHints:31 h2:23 h3:33 h4:33 h5:43 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level59 {
    maxTaps = 1;    
    [self loadPoppers:@"323400321130013211041201102000"];
    [self loadHints:35 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level60 {
    maxTaps = 4;    
    [self loadPoppers:@"003343203203131203312012003113"];
    [self loadHints:45 h2:14 h3:24 h4:24 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level61 {
    maxTaps = 3;    
    [self loadPoppers:@"011122200033201203130001130232"];
    [self loadHints:14 h2:36 h3:55 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level62 {
    maxTaps = 2;    
    [self loadPoppers:@"320220012200103020020211110122"];
    [self loadHints:45 h2:14 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level63 {
    maxTaps = 3;    
    [self loadPoppers:@"114202403020204122213001312222"];
    [self loadHints:34 h2:14 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}


-(void) buildPack1Level64 {
    maxTaps = 3;    
    [self loadPoppers:@"220022033320031100313010013113"];
    [self loadHints:45 h2:42 h3:15 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level65 {
    maxTaps = 2;    
    [self loadPoppers:@"210103312003030210320311311203"];
    [self loadHints:35 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level66 {
    maxTaps = 3;    
    [self loadPoppers:@"022220022023022022000000103210"];
    [self loadHints:36 h2:35 h3:35 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level67 {
    maxTaps = 2;    
    [self loadPoppers:@"312000100312110001000203233311"];
    [self loadHints:36 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level68 {
    maxTaps = 3;    
    [self loadPoppers:@"001200242043122213123200131130"];
    [self loadHints:51 h2:44 h3:44 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level69 { // 1.01
    maxTaps = 4;    
    [self loadPoppers:@"021024320202000323020021310100"];
    [self loadHints:36 h2:15 h3:35 h4:35 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level70 {
    maxTaps = 2;    
    [self loadPoppers:@"234232223010131043331111000211"];
    [self loadHints:33 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level71 {
    maxTaps = 1;    
    [self loadPoppers:@"131203202021102113213002100220"];
    [self loadHints:34 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level72 {
    maxTaps = 2;    
    [self loadPoppers:@"212103012000133223230121321011"];
    [self loadHints:44 h2:45 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level73 {
    maxTaps = 2;    
    [self loadPoppers:@"331111023221321232223331020001"];
    [self loadHints:24 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level74 {
    maxTaps = 2;    
    [self loadPoppers:@"022223001331312121332003333113"];
    [self loadHints:55 h2:41 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level75 {
    maxTaps = 2;    
    [self loadPoppers:@"200330202421130212112221110222"];
    [self loadHints:35 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level76 {
    maxTaps = 4;    
    [self loadPoppers:@"023301032010320010330222312110"];
    [self loadHints:23 h2:23 h3:22 h4:54 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level77 {
    maxTaps = 3;    
    [self loadPoppers:@"231222123321023103122300102311"];
    [self loadHints:24 h2:24 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level78 {
    maxTaps = 4;    
    [self loadPoppers:@"303302020131321020014310101313"];
    [self loadHints:45 h2:32 h3:44 h4:43 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level79 {
    maxTaps = 2;    
    [self loadPoppers:@"200232302202113010112201314022"];
    [self loadHints:52 h2:24 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level80 { // good
    maxTaps = 2;    
    [self loadPoppers:@"220322233331321030031010323111"];
    [self loadHints:51 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level81 {  // done
    maxTaps = 2;    
    [self loadPoppers:@"231020223332011210113233331133"];
    [self loadHints:44 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level82 { //  
    maxTaps = 1;    
    [self loadPoppers:@"330303322132303133311031331110"];
    [self loadHints:24 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level83 {  
    maxTaps = 2;    
    [self loadPoppers:@"102221112100400212111021221111"];
    [self loadHints:34 h2:34 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level84 {   
    maxTaps = 4;    
    [self loadPoppers:@"224100201004413103022233020101"];
    [self loadHints:34 h2:43 h3:12 h4:21 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}


-(void) buildPack1Level85 {  // good
    maxTaps = 3;    
    [self loadPoppers:@"211313100412313031020032020013"];
    [self loadHints:45 h2:35 h3:25 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level86 {   
    maxTaps = 3;    
    [self loadPoppers:@"431313102210001302200200002121"];
    [self loadHints:25 h2:24 h3:11 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level87 {  // done
    maxTaps = 3;    
    [self loadPoppers:@"440100310312112132122321202132"];
    [self loadHints:11 h2:22 h3:45 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level88 {   
    maxTaps = 3;    
    [self loadPoppers:@"302101122220233103012203320001"];
    [self loadHints:14 h2:34 h3:36 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level89 {   
    maxTaps = 4;    
    [self loadPoppers:@"013001032121233300223031032213"];
    [self loadHints:24 h2:23 h3:33 h4:54 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level90 {  // good
    maxTaps = 2;    
    [self loadPoppers:@"212134312321114102232221022011"];
    [self loadHints:36 h2:32 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level91 { // ok
    maxTaps = 2;    
    [self loadPoppers:@"213113010331122123332321302003"];
    [self loadHints:22 h2:51 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level92 { // ok
    maxTaps = 2;    
    [self loadPoppers:@"112221232223313113010020123212"];
    [self loadHints:32 h2:35 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level93 { // good
    maxTaps = 3;    
    [self loadPoppers:@"222103123310013131100021231301"];
    [self loadHints:36 h2:45 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level94 {  
    maxTaps = 3;    
    [self loadPoppers:@"010021332201220213322323202320"];
    [self loadHints:16 h2:34 h3:34 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level95 {  
    maxTaps = 2;    
    [self loadPoppers:@"220002123232120110023010302032"];
    [self loadHints:34 h2:25 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level96 {   
    maxTaps = 4;    
    [self loadPoppers:@"212223310123333322221311303220"];
    [self loadHints:24 h2:35 h3:51 h4:51 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level97 {  
    maxTaps = 3;    
    [self loadPoppers:@"122230010223330322231221112021"];
    [self loadHints:52 h2:44 h3:25 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level98 {  
    maxTaps = 2;    
    [self loadPoppers:@"232233433323102311231122132000"];
    [self loadHints:33 h2:33 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level99 {  
    maxTaps = 3;    
    [self loadPoppers:@"213320223103301022222310133123"];
    [self loadHints:45 h2:35 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level100 {
    maxTaps = 1;    
    [self loadPoppers:@"000001312220002102113010321311"];
    [self loadHints:42 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level101 {
    maxTaps = 4;    
    [self loadPoppers:@"220313122303102134002100121033"];
    [self loadHints:51 h2:35 h3:35 h4:35 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level102 {
    maxTaps = 1;    
    [self loadPoppers:@"023334310211021121100332211000"];
    [self loadHints:25 h2:0 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level103 {
    maxTaps = 3;    
    [self loadPoppers:@"012221312113231032011233012333"];
    [self loadHints:45 h2:45 h3:24 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level104 {
    maxTaps = 3;    
    [self loadPoppers:@"432112232120233102332230232000"];
    [self loadHints:23 h2:23 h3:53 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
}
-(void) buildPack1Level105 {
    maxTaps = 2;    
    [self loadPoppers:@"511332030212033402122102021213"];
    [self loadHints:43 h2:43 h3:0 h4:0 h5:0 h6:0 h7:0 h8:0 h9:0 h10:0];
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
       
        // Make the undo button rect
        CCSprite *undo = (CCSprite *)[self getChildByTag:22];
        CGRect undoButton = [undo boundingBox];
        
        // Make the info icon rect
        CCSprite *infoIcon = (CCSprite *)[self getChildByTag:250];
        CGRect infoIconRect = [infoIcon boundingBox];
        
        // Check if not enough gems or gold is displayed
        BuyGoldGemsHintsLayer *goldGemsHints = (BuyGoldGemsHintsLayer *)[self getChildByTag:8000];
        BOOL notEnoughGemsGoldDisplayed = [goldGemsHints notEnoughGemsGoldDisplayed];


        // See if the gold, gems or hints are displayed.  Only proceed if they aren't
        buyGoldDisplayed = [[NSUserDefaults standardUserDefaults] boolForKey:@"buyGoldDisplayed"];
        buyGemsDisplayed = [[NSUserDefaults standardUserDefaults] boolForKey:@"buyGemsDisplayed"];
        needAHintDisplayed = [[NSUserDefaults standardUserDefaults] boolForKey:@"needAHintDisplayed"];

        if ((buyGoldDisplayed == NO) && (buyGemsDisplayed == NO) && (needAHintDisplayed == NO)
            && (notEnoughGemsGoldDisplayed == NO)) {
            
            if (powerUpInfoDisplayed == YES) {
                
                // Make Rex X button rect
                CCSprite *redX = (CCSprite *)[self getChildByTag:8401];
                CGRect redXButton = [redX boundingBox];
                if (CGRectContainsPoint(redXButton, location)) [self expandSpriteEffect:kRedXPowerUpInfo];
            }
            else if (playScreenDisplayed == YES) {
                
                // Make Rex X button rect
                CCSprite *redX = (CCSprite *)[self getChildByTag:8301];
                CGRect redXButton = [redX boundingBox];

                // Make Play button rect
                CCSprite *play = (CCSprite *)[self getChildByTag:8302];
                CGRect playButton = [play boundingBox];
                
                if (CGRectContainsPoint(redXButton, location)) [self expandSpriteEffect:kRedXPlay];
                if (CGRectContainsPoint(playButton, location)) [self expandSpriteEffect:kPlayButton];
                if (CGRectContainsPoint(infoIconRect, location)) [self expandSpriteEffect:kInfoIcon];
               
                // Check PowerUps
                [self powerUpTouch:location];
            }
            else {
                if (((levelComplete == NO) && (levelFail == NO)) || (pauseButtonStatus == 1)) {
                    if (pauseButtonStatus == 0) {
                        if (CGRectContainsPoint(pauseButton, location)) [self expandSpriteEffect:kPauseGame];
                        if (CGRectContainsPoint(undoButton, location)) [self expandSpriteEffect:kUndo];
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
                    CCSprite *blackBackground = (CCSprite *)[self getChildByTag:100];
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

                    // Make the undo button rect (Fail screen)
                    CCSprite *undo = (CCSprite *)[self getChildByTag:14];
                    CGRect undoButtonSummary = [undo boundingBox];

                    if (CGRectContainsPoint(menuButtonSummary, location)) [self expandSpriteEffect:kMenuSummary];
                    if (CGRectContainsPoint(repeatLevelButtonSummary, location)) [self expandSpriteEffect:kNewGameSummary];
                    if (CGRectContainsPoint(nextLevelButtonSummary, location)) [self expandSpriteEffect:kNextLevel];
                    if (CGRectContainsPoint(storeButtonSummary, location)) [self expandSpriteEffect:kStoreSummary];
                    if (CGRectContainsPoint(storeButtonSummary2, location)) [self expandSpriteEffect:kStoreSummary2];
                    if (CGRectContainsPoint(undoButtonSummary, location)) [self expandSpriteEffect:kUndoSummary];
                    if (CGRectContainsPoint(infoIconRect, location)) [self expandSpriteEffect:kInfoIcon];
                    
                    // Check PowerUps
                    [self powerUpTouch:location];
               }
            }
        }
     }
}

-(void) bounceSprite:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
    
    // Rock the sprite
    id delay = [CCFadeTo actionWithDuration:20 opacity:255];
    id moveUp1 = [CCMoveBy actionWithDuration:.2 position:ccp(0,15)];
    id moveDown1 = [CCMoveBy actionWithDuration:.1 position:ccp(0,-15)];
    id moveUp2 = [CCMoveBy actionWithDuration:.2 position:ccp(0,10)];
    id moveDown2 = [CCMoveBy actionWithDuration:.1 position:ccp(0,-10)];
    id moveUp3 = [CCMoveBy actionWithDuration:.2 position:ccp(0,5)];
    id moveDown3 = [CCMoveBy actionWithDuration:.1 position:ccp(0,-5)];
    id sound = [CCCallFuncN actionWithTarget:self selector:@selector(boingSound)];
    id action = [CCSequence actions:delay, sound, moveUp1, moveDown1, moveUp2, moveDown2, moveUp3, moveDown3, nil];
    [sprite runAction:[CCRepeatForever actionWithAction:action]];
}

-(int) getPopperColor:(id)sender {
	CCSprite *popper = (CCSprite *)sender;
    int t = popper.tag;
    int color;
    
    if ((t >= 7101) && (t <= 7199)) {
        color = 7100;
    }
    else if ((t >= 7201) && (t <= 7299)) {
        color = 7200;
    }
    else if ((t >= 7301) && (t <= 7399)) {
        color = 7300;
    }
    else if ((t >= 7401) && (t <= 7499)) {
        color = 7400;
    }
    else if ((t >= 7501) && (t <= 7599)) {
        color = 7500;
    }
    return color;
}

-(int) getPopperCol:(id)sender {
	CCSprite *popper = (CCSprite *)sender;
    int t = popper.tag;
    int col;
    
    if ((t >= 7101) && (t <= 7199)) {
        t = t - 7100;
    }
    else if ((t >= 7201) && (t <= 7299)) {
        t = t - 7200;
    }
    else if ((t >= 7301) && (t <= 7399)) {
        t = t - 7300;
    }
    else if ((t >= 7401) && (t <= 7499)) {
        t = t - 7400;
    }
    else if ((t >= 7501) && (t <= 7599)) {
        t = t - 7500;
    }
    
    if ((t >= 10) && (t <= 19)) {
        col = t - 10;
    }
    else if ((t >= 20) && (t <= 29)) {
        col = t - 20;
    }
    else if ((t >= 30) && (t <= 39)) {
        col = t - 30;
    }
    else if ((t >= 40) && (t <= 49)) {
        col = t - 40;
    }
    else if ((t >= 50) && (t <= 59)) {
        col = t - 50;
    }
    else if ((t >= 60) && (t <= 69)) {
        col = t - 60;
    }
    else if ((t >= 70) && (t <= 79)) {
        col = t - 70;
    }
    return col;
}

-(int) getPopperRow:(id)sender {
	CCSprite *popper = (CCSprite *)sender;
    int t = popper.tag;
    int row;
    
    if ((t >= 7101) && (t <= 7199)) {
        t = t - 7100;
    }
    else if ((t >= 7201) && (t <= 7299)) {
        t = t - 7200;
    }
    else if ((t >= 7301) && (t <= 7399)) {
        t = t - 7300;
    }
    else if ((t >= 7401) && (t <= 7499)) {
        t = t - 7400;
    }
    else if ((t >= 7501) && (t <= 7599)) {
        t = t - 7500;
    }
    
    if ((t >= 10) && (t <= 19)) {
        row = 1;
    }
    else if ((t >= 20) && (t <= 29)) {
        row = 2;
    }
    else if ((t >= 30) && (t <= 39)) {
        row = 3;
    }
    else if ((t >= 40) && (t <= 49)) {
        row = 4;
    }
    else if ((t >= 50) && (t <= 59)) {
        row = 5;
    }
    else if ((t >= 60) && (t <= 69)) {
        row = 6;
    }
    else if ((t >= 70) && (t <= 79)) {
        row = 7;
    }
    return row;
}

-(id) getPopperString {
    int row, col, color, value, pos;
    NSMutableString *valueStr;
    
    NSMutableString *tmpStr = [NSMutableString stringWithString:@"000000000000000000000000000000"];
    
    // Process through all popperScore
    for (CCSprite *popper in _allPoppers) {
        
        // Determine the color
        color = [self getPopperColor:popper];
        if (color == 7100) value = 1;
        else if (color == 7200) value = 2;
        else if (color == 7300) value = 3;
        else if (color == 7400) value = 4;
        else if (color == 7500) value = 5;
        valueStr = [NSString stringWithFormat:@"%d",value];
        
        // Determine the position
        row = [self getPopperRow:popper];
        col = [self getPopperCol:popper];
        pos = row * 6 - 6 + col - 1;
        NSLog(@"Saved Popper Row: %d", row);
        NSLog(@"Saved Popper col: %d", col);
        NSLog(@"Saved Popper Position: %d", pos);
        [tmpStr replaceCharactersInRange: NSMakeRange(pos, 1) withString:valueStr];
    }
    NSLog(@"Saved Popper Position: %@", tmpStr);
    
    return tmpStr;
}

-(void) savePopperPos {
    
    BOOL undoPowerUp = [[NSUserDefaults standardUserDefaults] boolForKey:@"undoPowerUp"];

    // Display the undo button, if it isn't already displayed ONLY IF UNDO POWERUP IS ACTIVE
    CCSprite *undo = (CCSprite *)[self getChildByTag:22];
    if ((undo == nil) && (undoPowerUp == YES)) {
        undo = [CCSprite spriteWithSpriteFrameName:@"undo.png"];
        [self addChild:undo z:4 tag:22];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            undo.position = ccp(screenSize.width-63, 25);
        }
        else {
            undo.position = ccp(screenSize.width-132, 50);
        }
    }
    
    // Also remove the gravity button when the undo button is displayed
    //    [self removeChildByTag:20 cleanup:YES];
    
    NSMutableString *tmpStr;
    
    // Retrieve the current popper string
    tmpStr = [self getPopperString];
    
    // Save the positions into an array
    [_undoArray addObject:tmpStr];
}

-(void) undoMoveSummary {
    
    levelFail = NO;
    levelComplete = NO;
    
    // Remove the level fail screen
    [self removeChildByTag:14 cleanup:YES];
    [self removeChildByTag:15 cleanup:YES];
    [self removeChildByTag:16 cleanup:YES];
    [self removeChildByTag:51 cleanup:YES];
    [self removeChildByTag:52 cleanup:YES];
    [self removeChildByTag:53 cleanup:YES];
    [self removeChildByTag:100 cleanup:YES];
    [self removeChildByTag:250 cleanup:YES];
    [self removeChildByTag:500 cleanup:YES];
    [self removeChildByTag:601 cleanup:YES];
    [self removeChildByTag:602 cleanup:YES];
    [self removeChildByTag:603 cleanup:YES];
    [self removeChildByTag:604 cleanup:YES];
    [self removeChildByTag:605 cleanup:YES];
    [self removeChildByTag:606 cleanup:YES];
    
    // Reactivate Undo Powerup
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"undoPowerUp"];

    // Add back in Pause, Hint & Undo buttons

    // Add Pause button
    CCSprite *pause = [CCSprite spriteWithSpriteFrameName:@"pauseButton.png"];
    [self addChild:pause z:3 tag:13];
    
    // Add Hint button
    CCSprite *hint = [CCSprite spriteWithSpriteFrameName:@"hintButton.png"];
    [self addChild:hint z:3 tag:19];
    
    CCSprite *undo = [CCSprite spriteWithSpriteFrameName:@"undo.png"];
    [self addChild:undo z:4 tag:22];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        hint.position = ccp(35, 27);
        pause.position = ccp(screenSize.width-25, 25);
        undo.position = ccp(screenSize.width-63, 25);
    }
    else {
        hint.position = ccp(75, 50);
        pause.position = ccp(screenSize.width-50, 50);
        undo.position = ccp(screenSize.width-132, 50);
    }

    [self undoMove];
}

-(void) undoMove {
    
    // Remove the ad banner (if there is one)
	[self removeBanner];

    if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"tick.caf" pitch:1.0 pan:1.0 gain:5.0];}
    
    NSString *str, *gravityStr;
    
    // First, clear the current poppers
    for (CCSprite *popper in _allPoppers) {
        [self removeChildByTag:popper.tag cleanup:YES];
    }
    [_allPoppers removeAllObjects];
    
    // Last, load the previous positions
    str = _undoArray.lastObject;
    [self loadPoppers:str];
    NSLog(@"Restored Popper Position: %@", str);
    
    // If necessary, remove the undo button & add back the gravity button
    [_undoArray removeLastObject];
    if (_undoArray.count == 0) {
        CCSprite *undo = (CCSprite *)[self getChildByTag:22];
        if (undo != nil) {
            [self removeChildByTag:22 cleanup:YES];
            currentTaps = currentTaps - 1;
         }
    }
    else {
        currentTaps = currentTaps - 1;
    }
    
    [self gameHeader];
}

-(void) removeNotEnoughGemsGold {
	
    if (notEnoughGemsDisplayed == YES) {
        notEnoughGemsDisplayed = NO;
        [self removeChildByTag:8200 cleanup:YES];
    }
    else if (notEnoughGoldDisplayed == YES) {
        notEnoughGoldDisplayed = NO;
        [self removeChildByTag:8200 cleanup:YES];
    }
    
	// Remove the RedX
	[self removeChildByTag:8201 cleanup:YES];
	[self resumeGame];
}

-(void) freeGoldTapjoySite {
    
    [Flurry logEvent:@"Tapjoy.com Clicked"];
    
    NSURL *url;
    url = [NSURL URLWithString:@"http://www.tapjoy.com"];
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
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
    
    [self freeGoldTapjoySite];
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
    
	int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
    
    // If not enough gems, notify the user
	if (gems < 20) {
        
        // Temporary  ////
        gems = gems + 2;
        [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
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
        }
        else {
            [notEnoughGems setPosition:ccp(512, 400)];
            [redX setPosition:ccp(987, 680)];
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
    
	int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
    
    // If not enough gems, notify the user
	if (gems < 110) {
        
        // Temporary  ////
        gems = gems + 2;
        [[NSUserDefaults standardUserDefaults] setInteger:gems forKey:@"gems"];
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
        }
        else {
            [notEnoughGems setPosition:ccp(512, 400)];
            [redX setPosition:ccp(987, 680)];
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

-(void) purchasePowerUps {
    
    int gemAmt = 0;
    int goldAmt = 0;

    // For every power up button that is ON, subtract the appropriate values from gems or gold
    // Assume gems if value < 100, otherwise assume gold
	CCSprite *powerUp1 = (CCSprite *)[self getChildByTag:601];
	CCSprite *powerUp2 = (CCSprite *)[self getChildByTag:602];
	CCSprite *powerUp3 = (CCSprite *)[self getChildByTag:603];
	CCSprite *powerUp4 = (CCSprite *)[self getChildByTag:604];
    
    NSLog(@"P1:%@ P2:%@ P3:%@ P4:%@",powerUp1.userData,powerUp2.userData,powerUp3.userData,powerUp4.userData);
    if ([powerUp1.userData isEqualToString:@"ON"]) {
        [Flurry logEvent:@"PowerUp Purchased:Undo"];
        if (powerUp1Value < 100) {  // Gems
            gemAmt = gemAmt + powerUp1Value;
        }
        else {  // Gold
            goldAmt = goldAmt + powerUp1Value;
        }
    }
    if ([powerUp2.userData isEqualToString:@"ON"]) {
        [Flurry logEvent:@"PowerUp Purchased:Tap+1"];
        if (powerUp2Value < 100) {  // Gems
            gemAmt = gemAmt + powerUp2Value;
        }
        else {  // Gold
            goldAmt = goldAmt + powerUp2Value;
        }
    }
    if ([powerUp3.userData isEqualToString:@"ON"]) {
        [Flurry logEvent:@"PowerUp Purchased:Mega Scorer"];
        if (powerUp3Value < 100) {  // Gems
            gemAmt = gemAmt + powerUp3Value;
        }
        else {  // Gold
            goldAmt = goldAmt + powerUp3Value;
        }
    }
    if ([powerUp4.userData isEqualToString:@"ON"]) {
        [Flurry logEvent:@"PowerUp Purchased:No Ads"];
        if (powerUp4Value < 100) {  // Gems
            gemAmt = gemAmt + powerUp4Value;
        }
        else {  // Gold
            goldAmt = goldAmt + powerUp4Value;
        }
    }
    
    if (gemAmt > 0) {
        [self saveGems:-gemAmt];
    }
    if (goldAmt > 0) {
        [self saveGold:-goldAmt];
    }
}

-(BOOL) powerUpPurchaseCheck:(int)powerUpClicked {
    
    BuyGoldGemsHintsLayer *goldGemsHints = (BuyGoldGemsHintsLayer *)[self getChildByTag:8000];

    // This method will validate whether the user has enough currency to cover the power up purchases
    int totalGemsUsed = 0;
    int totalGoldUsed = 0;
    
    // First, add up all powerups that are already clicked
	CCSprite *powerUp1 = (CCSprite *)[self getChildByTag:601];
	CCSprite *powerUp2 = (CCSprite *)[self getChildByTag:602];
	CCSprite *powerUp3 = (CCSprite *)[self getChildByTag:603];
	CCSprite *powerUp4 = (CCSprite *)[self getChildByTag:604];
    
    if ([powerUp1.userData isEqualToString:@"ON"]) {
        if (powerUp1Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp1Value;}
        else {
            totalGoldUsed = totalGoldUsed + powerUp1Value;}
    }
    if ([powerUp2.userData isEqualToString:@"ON"]) {
        if (powerUp2Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp2Value;}
        else {
            totalGoldUsed = totalGoldUsed + powerUp2Value;}
    }
    if ([powerUp3.userData isEqualToString:@"ON"]) {
        if (powerUp3Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp3Value;}
        else {
            totalGoldUsed = totalGoldUsed + powerUp3Value;}
    }
    if ([powerUp4.userData isEqualToString:@"ON"]) {
        if (powerUp4Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp4Value;}
        else {
            totalGoldUsed = totalGoldUsed + powerUp4Value;}
    }

    // Next, take the current selection and add it to the already selected total.  If it exceeds the amount of currency available,
    // return a NO, otherwise, return a YES
    int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
	int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];

    NSLog(@"Gems:%d Gold:%d",gems,gold);
    if (powerUpClicked == 1) {
        if (powerUp1Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp1Value;
            NSLog(@"Gems Used:%d",totalGemsUsed);
            if (totalGemsUsed <= gems) return YES;
            else {
                [goldGemsHints notEnoughGems:totalGemsUsed-gems];
                return NO;
            }
        }
        else {
            totalGoldUsed = totalGoldUsed + powerUp1Value;
            NSLog(@"Gold Used:%d",totalGoldUsed);
            if (totalGoldUsed <= gold) return YES;
            else {
                [goldGemsHints notEnoughGold:totalGoldUsed-gold];
                return NO;
            }
        }
    }
    else if (powerUpClicked == 2) {
        if (powerUp2Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp2Value;
            if (totalGemsUsed <= gems) return YES;
            else {
                [goldGemsHints notEnoughGems:totalGemsUsed-gems];
                return NO;
            }
        }
        else {
            totalGoldUsed = totalGoldUsed + powerUp2Value;
            if (totalGoldUsed <= gold) return YES;
            else {
                [goldGemsHints notEnoughGold:totalGoldUsed-gold];
                return NO;
            }
        }
    }
    else if (powerUpClicked == 3) {
        if (powerUp3Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp3Value;
            if (totalGemsUsed <= gems) return YES;
            else {
                [goldGemsHints notEnoughGems:totalGemsUsed-gems];
                return NO;
            }
        }
        else {
            totalGoldUsed = totalGoldUsed + powerUp3Value;
            if (totalGoldUsed <= gold) return YES;
            else {
                [goldGemsHints notEnoughGold:totalGoldUsed-gold];
                return NO;
            }
        }
    }
    else if (powerUpClicked == 4) {
        if (powerUp4Value < 100) {
            totalGemsUsed = totalGemsUsed + powerUp4Value;
            if (totalGemsUsed <= gems) return YES;
            else {
                [goldGemsHints notEnoughGems:totalGemsUsed-gems];
                return NO;
            }
        }
        else {
            totalGoldUsed = totalGoldUsed + powerUp4Value;
            if (totalGoldUsed <= gold) return YES;
            else {
                [goldGemsHints notEnoughGold:totalGoldUsed-gold];
                return NO;
            }
        }
    }
       
    return NO;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Display FREE Hint?
	if (alertView == freeHint) {
		if (buttonIndex == 1) {
            
            // If displaying from Level Fail screen, then clear the screen
            if (levelFail == YES) {
                // Set this value to automatically start displaying hints 
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"start_with_hint"];
                
                [self newGame];
            }
            else {
                displayHint = YES;
                hintsActive = YES;
            }
		}
        else {freeHint = nil;}
        [[CCDirector sharedDirector] resume];
	}

    // Display Hint?
	if (alertView == hintConfirm) {
		if (buttonIndex == 1) {
			int cnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];			
			cnt = cnt - 1;
			[[NSUserDefaults standardUserDefaults] setInteger:cnt forKey:@"popper_hints"];
            
            // If displaying from Level Fail screen, then clear the screen
            if (levelFail == YES) {
                // Set this value to automatically start displaying hints 
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"start_with_hint"];
                
                [self newGame];
            }
            else {
                displayHint = YES;
                hintsActive = YES;
            }
		}
        else {hintConfirm = nil;}
        [[CCDirector sharedDirector] resume];
	}
    if (alertView == hintAlert) {
		if (buttonIndex == 1) {
            BOOL freeHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"offer_free_hints"];
            BOOL freeFBHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"offer_free_fb_like_hints"];
            
            if ((freeHint == YES) && (freeFBHint == YES)) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"offer_free_fb_like_hints"];
                // Give the user 2 free hints
                int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];		
                hintCnt = hintCnt + 2;
                [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
                [self displayFacebook];
            }
			else if ([SKPaymentQueue canMakePayments]) {
                [self requestProductData:1];
            }
            else {
                miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
                [miscError show];
                [miscError release];					
            }
            hintAlert = nil;
        }
        else if (buttonIndex == 2) {
            BOOL freeHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"offer_free_hints"];
            BOOL freeFBHint = [[NSUserDefaults standardUserDefaults] boolForKey:@"offer_free_fb_like_hints"];
            
            if ((freeHint == YES) && (freeFBHint == YES)) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"offer_free_hints"];
                // Give the user 2 free hints
                int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];		
                hintCnt = hintCnt + 2;
                [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
                [self reviewApp];
            }
            else if ((freeHint == YES) && (freeFBHint == NO)) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"offer_free_hints"];
                // Give the user 2 free hints
                int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];		
                hintCnt = hintCnt + 2;
                [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
                [self reviewApp];
            }
            else if ((freeHint == NO) && (freeFBHint == YES)) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"offer_free_fb_like_hints"];
                // Give the user 2 free hints
                int hintCnt = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_hints"];		
                hintCnt = hintCnt + 2;
                [[NSUserDefaults standardUserDefaults] setInteger:hintCnt forKey:@"popper_hints"];
                [self displayFacebook];
            }
            else {
                if ([SKPaymentQueue canMakePayments]) {
                    [self requestProductData:2];
                }
                else {
                    miscError = [[UIAlertView alloc] initWithTitle: @"In-App Purchasing Not Available!" message: @"In-App Purchasing is not available for this device (possibly due to parental controls)" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [miscError show];
                    [miscError release];					
                }
            }
            hintAlert = nil;
        }
        else {hintAlert = nil;}
        
        [[CCDirector sharedDirector] resume];        
    }
    
    // Hint Prompt (when a user gets stuck)
	if (alertView == hintPrompt) {
		if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"crazy_poppers_level_attempts"];
            [self hintSelected];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"crazy_poppers_level_attempts"];
            hintPrompt = nil;
        }
    }

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
    
    // Need some help
    if (alertView == miscMsg) {
        if (buttonIndex == 1) {
            [self hintSelected];
        }
        else if (buttonIndex == 2) {
            [self askAFriend];
        }
        else {
            msgiOS5 = nil;
        }
    }

    // Ask a Friend
    if (alertView == msgiOS5) {
        if (buttonIndex == 1) {
            [self shareTwitter5];
        }
        else {
            msgiOS5 = nil;
        }
    }
    if (alertView == msgiOS6) {
        if (buttonIndex == 1) {
            [self shareTwitter5];
        }
        else if (buttonIndex == 2) {
            [self shareFacebook6];
        }
        else {
            msgiOS6 = nil;
        }
    }
    
}

-(void) countTimer {
    
    counter = counter + 1;
    
}

-(void) update: (ccTime) dt {
	
  	[self popperCollisionDetection];
    //  	[self ricochetCollisionDetection];
    
    // If there are no more poppers on screen, then level is complete
    if (_allPoppers.count == 0) {
        levelComplete = YES;
    }
    
    // If level is complete, then display the level summary
    if ((levelComplete == YES) && (firstPass == YES)) {
		firstPass = NO;
		[self levelSummary];
	}
    
    // If level fail
    if (((maxTaps - currentTaps) <= 0) && (levelFail != YES) && (_allSpinners.count == 0) && (levelComplete == NO)) {
        [self levelFailSummary];
    }
    
    // Display hints
    if ((hintsActive == YES) && (displayHint == YES) && (_allSpinners.count == 0)) {
        displayHint = NO;
        [self displayHint];
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
    invalidProductIdentifiers = response.invalidProductIdentifiers;    
    if (invalidProductIdentifiers.count != 0) return;
    
	product = [response.products objectAtIndex:0];	
	currentIdentifier = [NSString stringWithFormat:@"%@", product.productIdentifier];
    NSLog(@"Purchase request for: %@", product.productIdentifier);
	
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
    [_undoArray release];
	_undoArray = nil;
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];  // for IAP
    
	[super dealloc];
}
@end
