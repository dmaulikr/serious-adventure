//
//  CrazyPoppers.m
//  CrazyPlay
//
//  Created by Alan Trippe on 2/6/12.
//  Copyright (c) 2012 Trippin' Software. All rights reserved.
//

#import "CrazyPoppers.h"
#import "CCScrollLayer.h"
#import "SimpleAudioEngine.h"
#import "CrazyPoppersLevels.h"
#import "Reachability.h"
#import "BuyGoldGemsHints.h"
#import "Chartboost.h"
#import "Flurry.h"

#define kSettings 14

@implementation CrazyPoppersMenuScene

-(id) init
{
	if( (self=[super init])) {
 		[self addChild:[CrazyPoppersMenuLayer node] z:1];
    }
    return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end

@implementation CrazyPoppersMenuLayer

// Convert iPad to iPhone
-(CGPoint) convertPoint: (CGPoint)pos {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return ccp(pos.x/2.12, pos.y/2.4);
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
        return y/2.4;
	}
	else {
		return y;
	}	
}

-(id) init
{
	if( (self=[super init])) {
        
        self.isTouchEnabled = YES;
        
        // Start the IAP Store
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];  // This is necessary if using pvr.ccz
        
        // iPhone or iPad?
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"popper-menu-spritesheet.pvr.ccz"];
        [self addChild:spriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"popper-menu-spritesheet.plist"];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"popper-menu-spritesheet-hd.pvr.ccz"];
            [self addChild:spriteSheet];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"popper-menu-spritesheet-hd.plist"];
        }

        // Retrieve the current sound default
		playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_sounds"];
		// Retrieve the current music default
		playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_music"];		
        
        
        // Set up the background music
		SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
		if (sae != nil) {
			[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"poppersBackgroundMusic.wav"];
		}
		
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.15f];
		if (playMusic == NO) {
			[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
		}
		else {
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"poppersBackgroundMusic.wav" loop:YES];
		}

        // Initialize the variables
        touchMoved = NO;
        needAHintDisplayed = NO;
        buyGoldDisplayed = NO;
        buyGemsDisplayed = NO;
        notEnoughGemsDisplayed = NO;
        notEnoughGoldDisplayed = NO;
        settingsDisplayed = NO;

        menuSelectionNo = 0;
        
 		selectionArray = [[NSMutableArray alloc] init];		
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGoldDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"buyGemsDisplayed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needAHintDisplayed"];

		// Retrieve the unlocks
		popperPack2Unlock = [[NSUserDefaults standardUserDefaults] boolForKey:@"popper_pack_2_unlocked"];
		popperPack3Unlock = [[NSUserDefaults standardUserDefaults] boolForKey:@"popper_pack_3_unlocked"];
		popperPack4Unlock = [[NSUserDefaults standardUserDefaults] boolForKey:@"popper_pack_4_unlocked"];
		popometerPackUnlock = [[NSUserDefaults standardUserDefaults] boolForKey:@"popometer_pack_unlocked"];
		megaPack1Unlock = [[NSUserDefaults standardUserDefaults] boolForKey:@"mega_pack_1_unlocked"];
        
        // get screen size
        screenSize = [CCDirector sharedDirector].winSize;
        
        int x1, y1, x, y, fontSize1, fontSize2, xOffset;
        
        // Display the background
        CCSprite *background;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            if (screenBounds.size.height == 568) { // iPhone 5
                background = [CCSprite spriteWithFile:@"popperBackground2Small-5hd.jpg"];
            } else {
                background = [CCSprite spriteWithFile:@"popperBackground2Small.jpg"];
            }
            
            fontSize1 = 12;
            fontSize2 = 12;
            xOffset = 0;
            x = 120;
            y = -50;
            x1 = 400;
            y1 = 100;
            [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        }
        else {
            background = [CCSprite spriteWithFile:@"popperBackground2.jpg"];
            fontSize1 = 28;
            fontSize2 = 26;
            xOffset = 15;
            x = 115;
            y = 10;
            x1 = 800;
            y1 = 200;
            [background setPosition:ccp(512, 384)];
        }
        
        [self addChild:background z:0];
        
        
        // *** POPPER PACK 1
        
        // Create the first selection
        CCSprite *popperPack1 = [CCSprite spriteWithSpriteFrameName:@"basicTraining.png"];
        popperPack1.position =  ccp(screenSize.width/2, screenSize.height/2 );
        
        // Add breathing movement
        NSInteger num = (arc4random() % 5) + 1;
        id scaleUp = [CCScaleTo actionWithDuration:1.5+(num*.1) scaleX:1.07+(num*.01) scaleY:.94+(num*.01)];
        id scaleDown = [CCScaleTo actionWithDuration:1 scale:1];
        id action = [CCSequence actions: scaleUp, scaleDown, nil];
        [popperPack1 runAction:[CCRepeatForever actionWithAction:action]];

        // Calculate & Add Basic Training High Score
        [self calculateHighScore:1];
        
        NSString *scoreStr = [NSString stringWithFormat:@"%d",totalHighScore1];
        CCLabelTTF *scoreValue = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
        scoreValue.position = [self convertPoint:ccp(x,y)];
        scoreValue.color = ccc3(255,255,255);
        [popperPack1 addChild:scoreValue z:2];
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score:" dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
        scoreLabel.position = [self convertPoint:ccp(x,y+35)];
        scoreLabel.color = ccc3(0,0,0);
        [popperPack1 addChild:scoreLabel z:2];
                
        [self addChild:popperPack1 z:3 tag:201];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            int xOffset;
            if (screenBounds.size.height == 568) { // iPhone 5
                xOffset = 200;
            } else {
                xOffset = 170;
            }
            popperPack1.position = ccp(screenSize.width/2-xOffset,146);
        }
        else {
            popperPack1.position = [self convertPoint:ccp(137,350)];
        }
        
        // *** POPPER PACK 2
        
        // Create the second selection
        CCSprite *popperPack2 = [CCSprite spriteWithSpriteFrameName:@"twoPoppers.png"];
        popperPack2.position =  ccp(popperPack1.position.x, screenSize.height/2 );
        
        // Add breathing movement
        num = (arc4random() % 5) + 1;
        scaleUp = [CCScaleTo actionWithDuration:2+(num*.1) scaleX:1.04+(num*.01) scaleY:.94+(num*.01)];
        scaleDown = [CCScaleTo actionWithDuration:1 scale:1];
        action = [CCSequence actions: scaleUp, scaleDown, nil];
        [popperPack2 runAction:[CCRepeatForever actionWithAction:action]];

        CCSprite *lock;
        if (popperPack2Unlock == NO) {
            lock = [CCSprite spriteWithSpriteFrameName:@"greySubmenuLock.png"];
            [popperPack2 addChild:lock z:5];
            lock.position = [self convertPoint:ccp(125-xOffset,100)];
        }
        else {
            // Calculate High Score
            [self calculateHighScore:2];
            
            scoreStr = [NSString stringWithFormat:@"%d",totalHighScore2];
            scoreValue = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            scoreValue.position = [self convertPoint:ccp(x,y)];
            scoreValue.color = ccc3(255,255,255);
            [popperPack2 addChild:scoreValue z:2];
            scoreLabel = [CCLabelTTF labelWithString:@"Score:" dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            scoreLabel.position = [self convertPoint:ccp(x,y+35)];
            scoreLabel.color = ccc3(0,0,0);
            [popperPack2 addChild:scoreLabel z:2];
        }
        
        [self addChild:popperPack2 z:3 tag:202];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            int xOffset;
            if (screenBounds.size.height == 568) { // iPhone 5
                xOffset = 75;
            } else {
                xOffset = 60;
            }
            popperPack2.position = ccp(screenSize.width/2-xOffset,219);
        }
        else {
            popperPack2.position = [self convertPoint:ccp(387,525)];
        }
        
        
        // *** POPPER PACK 3
        
        // Create the next selection
        CCSprite *popperPack3 = [CCSprite spriteWithSpriteFrameName:@"threePoppers.png"];
        popperPack3.position =  ccp(popperPack1.position.x, screenSize.height/2 );

        // Add breathing movement
        num = (arc4random() % 5) + 1;
        scaleUp = [CCScaleTo actionWithDuration:2+(num*.1) scaleX:1.04+(num*.01) scaleY:.94+(num*.01)];
        scaleDown = [CCScaleTo actionWithDuration:1 scale:1];
        action = [CCSequence actions: scaleUp, scaleDown, nil];
        [popperPack3 runAction:[CCRepeatForever actionWithAction:action]];
        
        if (popperPack3Unlock == NO) {
            lock = [CCSprite spriteWithSpriteFrameName:@"greySubmenuLock.png"];
            [popperPack3 addChild:lock z:5];
            lock.position = [self convertPoint:ccp(125-xOffset,100)];
        }
        else {
            // Calculate High Score
            [self calculateHighScore:3];
            
            scoreStr = [NSString stringWithFormat:@"%d",totalHighScore3];
            scoreValue = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            scoreValue.position = [self convertPoint:ccp(x,y)];
            scoreValue.color = ccc3(255,255,255);
            [popperPack3 addChild:scoreValue z:2];
            scoreLabel = [CCLabelTTF labelWithString:@"Score:" dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            scoreLabel.position = [self convertPoint:ccp(x,y+35)];
            scoreLabel.color = ccc3(0,0,0);
            [popperPack3 addChild:scoreLabel z:2];
        }
        
        [self addChild:popperPack3 z:3 tag:203];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            int xOffset;
            if (screenBounds.size.height == 568) { // iPhone 5
                xOffset = 75;
            } else {
                xOffset = 60;
            }
            popperPack3.position = ccp(screenSize.width/2+xOffset,219);
        }
        else {
            popperPack3.position = [self convertPoint:ccp(637,525)];
        }
        
        
        // *** POPPER PACK 4
        
        // Create the next selection
        CCSprite *popperPack4 = [CCSprite spriteWithSpriteFrameName:@"fourPoppers.png"];
        popperPack4.position =  ccp(popperPack1.position.x, screenSize.height/2 );
        
        // Add breathing movement
        num = (arc4random() % 5) + 1;
        scaleUp = [CCScaleTo actionWithDuration:2+(num*.1) scaleX:1.04+(num*.01) scaleY:.94+(num*.01)];
        scaleDown = [CCScaleTo actionWithDuration:1 scale:1];
        action = [CCSequence actions: scaleUp, scaleDown, nil];
        [popperPack4 runAction:[CCRepeatForever actionWithAction:action]];

        if (popperPack4Unlock == NO) {
            lock = [CCSprite spriteWithSpriteFrameName:@"greySubmenuLock.png"];
            [popperPack4 addChild:lock z:5];
            lock.position = [self convertPoint:ccp(125-xOffset,100)];
        }
        else {
            // Calculate High Score
            [self calculateHighScore:4];
            
            scoreStr = [NSString stringWithFormat:@"%d",totalHighScore4];
            scoreValue = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            scoreValue.position = [self convertPoint:ccp(x,y)];
            scoreValue.color = ccc3(255,255,255);
            [popperPack4 addChild:scoreValue z:2];
            scoreLabel = [CCLabelTTF labelWithString:@"Score:" dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            scoreLabel.position = [self convertPoint:ccp(x,y+35)];
            scoreLabel.color = ccc3(0,0,0);
            [popperPack4 addChild:scoreLabel z:2];
        }
        
        [self addChild:popperPack4 z:3 tag:204];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            int xOffset;
            if (screenBounds.size.height == 568) { // iPhone 5
                xOffset = 200;
            } else {
                xOffset = 170;
            }
            popperPack4.position = ccp(screenSize.width/2+xOffset,146);
        }
        else {
            popperPack4.position = [self convertPoint:ccp(887,350)];
        }
        
        // *** POPOMETER PACK
        
        // Create the next selection
        CCSprite *popometerPack = [CCSprite spriteWithSpriteFrameName:@"popometerPack.png"];
        popometerPack.position =  ccp(popperPack1.position.x, screenSize.height/2 );
        
        // Add breathing movement
        num = (arc4random() % 5) + 1;
        scaleUp = [CCScaleTo actionWithDuration:2+(num*.1) scaleX:1.04+(num*.01) scaleY:.94+(num*.01)];
        scaleDown = [CCScaleTo actionWithDuration:1 scale:1];
        action = [CCSequence actions: scaleUp, scaleDown, nil];
        [popometerPack runAction:[CCRepeatForever actionWithAction:action]];

        if (popometerPackUnlock == NO) {
            lock = [CCSprite spriteWithSpriteFrameName:@"greySubmenuLock.png"];
            [popometerPack addChild:lock z:5];
            lock.position = [self convertPoint:ccp(125-xOffset,100)];
        }
        else {
            // Calculate High Score
            [self calculateHighScore:11];
            
            scoreStr = [NSString stringWithFormat:@"%d",totalHighScore11];
            scoreValue = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            scoreValue.position = [self convertPoint:ccp(x,y)];
            scoreValue.color = ccc3(255,255,255);
            [popometerPack addChild:scoreValue z:2];
            scoreLabel = [CCLabelTTF labelWithString:@"Score:" dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            scoreLabel.position = [self convertPoint:ccp(x,y+35)];
            scoreLabel.color = ccc3(0,0,0);
            [popometerPack addChild:scoreLabel z:2];
        }
        
        [self addChild:popometerPack z:3 tag:211];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            int xOffset;
            if (screenBounds.size.height == 568) { // iPhone 5
                xOffset = 75;
            } else {
                xOffset = 60;
            }
            popometerPack.position = ccp(screenSize.width/2-xOffset,73);
        }
        else {
            popometerPack.position = [self convertPoint:ccp(387,175)];
        }
        
        // *** MEGA PACK #1
        
        // Create the next selection
        CCSprite *megaPack1 = [CCSprite spriteWithSpriteFrameName:@"megaPack1.png"];
        megaPack1.position =  ccp(popperPack1.position.x, screenSize.height/2 );
        
        // Add breathing movement
        num = (arc4random() % 5) + 1;
        scaleUp = [CCScaleTo actionWithDuration:2+(num*.1) scaleX:1.04+(num*.01) scaleY:.94+(num*.01)];
        scaleDown = [CCScaleTo actionWithDuration:1 scale:1];
        action = [CCSequence actions: scaleUp, scaleDown, nil];
        [megaPack1 runAction:[CCRepeatForever actionWithAction:action]];

        if (megaPack1Unlock == NO) {
            lock = [CCSprite spriteWithSpriteFrameName:@"greySubmenuLock.png"];
            [megaPack1 addChild:lock z:5];
            lock.position = [self convertPoint:ccp(125-xOffset,100)];
        }
        else {
            // Calculate High Score
            [self calculateHighScore:12];
            
            scoreStr = [NSString stringWithFormat:@"%d",totalHighScore12];
            scoreValue = [CCLabelTTF labelWithString:scoreStr dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
            scoreValue.position = [self convertPoint:ccp(x,y)];
            scoreValue.color = ccc3(255,255,255);
            [megaPack1 addChild:scoreValue z:2];
            scoreLabel = [CCLabelTTF labelWithString:@"Score:" dimensions:CGSizeMake(200,100) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize2];
            scoreLabel.position = [self convertPoint:ccp(x,y+35)];
            scoreLabel.color = ccc3(0,0,0);
            [megaPack1 addChild:scoreLabel z:2];
        }
        
        [self addChild:megaPack1 z:3 tag:212];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            int xOffset;
            if (screenBounds.size.height == 568) { // iPhone 5
                xOffset = 75;
            } else {
                xOffset = 60;
            }
            megaPack1.position = ccp(screenSize.width/2+xOffset,73);
        }
        else {
            megaPack1.position = [self convertPoint:ccp(637,175)];
        }
        
        // Display the Gold, Gems & Hints
        [self displayGoldGemHints];
        
		// Display the settings button
 		CCSprite *settings = [CCSprite spriteWithSpriteFrameName:@"menu-settings.png"];
 		[self addChild:settings z:4 tag:2014];

        // Display the Gaming Center Button
        /*
        CCSprite *gamingNetworkButton;
        int gamingNetwork = [[NSUserDefaults standardUserDefaults] integerForKey:@"gaming_network"];
        gamingNetworkButton = [CCSprite spriteWithSpriteFrameName:@"gameCenter.png"];
        [self addChild:gamingNetworkButton z:4 tag:2013];
         */
         
        // Add more games button
        CCSprite *moreGames = [CCSprite spriteWithSpriteFrameName:@"moreGames.png"];
        [self addChild:moreGames z:4 tag:5001];
                
        // Add free gold button
        CCSprite *freeGold = [CCSprite spriteWithSpriteFrameName:@"freeGold.png"];
        [self addChild:freeGold z:4 tag:5004];
        
        // Add more gamnes button
        CCSprite *moreGamesArrow = [CCSprite spriteWithSpriteFrameName:@"moreGamesArrow.png"];
        [self addChild:moreGamesArrow z:4 tag:5005];

        // Make arrow slowly fade in/out
        id appear = [CCFadeTo actionWithDuration:1 opacity:255];
        id disappear = [CCFadeTo actionWithDuration:1 opacity:50];
        action = [CCSequence actions:appear, disappear, nil];
        [moreGamesArrow runAction:[CCRepeatForever actionWithAction:action]];
 
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            settings.position = [self convertPoint:ccp(100,75)];
             moreGames.position = ccp(screenSize.width-48,31);
            freeGold.position = ccp(screenSize.width-43,290);
            moreGamesArrow.position = ccp(screenSize.width-100,50);
        }
        else {
            settings.position = [self convertPoint:ccp(100,75)];
             moreGames.position = [self convertPoint:ccp(screenSize.width-100,75)];
            freeGold.position = [self convertPoint:ccp(screenSize.width-80,660)];
            moreGamesArrow.position = [self convertPoint:ccp(screenSize.width-185,120)];
        }
        
        ////////// For Testing
//        [self saveGems:500];
//        [self saveGold:30000];
        //////////
        
        // Randomize the unlock currency (i.e. Sometimes let the user unlock a pack with gems, sometimes with gold)
        randomUnlockCurrency = (arc4random() % 2) + 1;
    }
    return self;
}

-(void) removeSprite:(id) sender {
	CCSprite *sprite = (CCSprite *) sender;
	[self removeChild:sprite cleanup:YES];
}

-(void) displayAdColony {
    
    BOOL videoAvailable = [[NSUserDefaults standardUserDefaults] boolForKey:@"video_available"];
    if (videoAvailable == NO) {
        miscError = [[UIAlertView alloc] initWithTitle: @"No Videos Available" message: @"No videos are ready to be viewed at this time. Check back soon!" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [miscError show];
        [miscError release];
    }
    else {
        [AdColony playVideoAdForSlot:1 withDelegate:self withV4VCPrePopup:YES andV4VCPostPopup:YES];
    }
}

-(void) adColonyVirtualCurrencyAwardedByZone:(NSString *)zone currencyName:(NSString *)name
                             currencyAmount:(int)amount {
    //Increase the user’s virtual currency balance here by the amount passed in
    //NOTE: This callback can be executed by AdColony at any time
    //NOTE: This is the ideal place for an alert about the successful reward
    [Flurry logEvent:@"AdColony gold added"];
    [self saveGold:amount];
}

-(void) displayMoreGames {
    
    Chartboost *cb = [Chartboost sharedChartboost];
    [cb showMoreApps];
}


- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    touchMoved = NO;
    
	for (UITouch *touch in touches) { //iterate through all the touches currently on the device
		CGPoint location = [touch locationInView: [touch view]]; //location of this touch
		location = [self convertTouchToNodeSpace: touch];
		
        if (touchCheck == nil) {
            touchMoved = YES;
            touchCheck = touch;
            break;
        }
	}
}	

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGRect selectionBox;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        selectionBox = CGRectMake((screenSize.width/2)/2,(screenSize.height/2)/2,200,200);
    }
    else {
        selectionBox = CGRectMake((screenSize.width/2)/2,(screenSize.height/2)/2,400,400);
    }
    
	// Make more levels soon rect
	CCSprite *moreLevels = (CCSprite *)[self getChildByTag:2022];
	CGRect moreLevelsRect = CGRectMake(
									   moreLevels.position.x - (moreLevels.contentSize.width/2), 
									   moreLevels.position.y - (moreLevels.contentSize.height/2), 
									   moreLevels.contentSize.width, 
									   moreLevels.contentSize.height);
	
	// Left Arrow
	CCSprite *leftArrow = (CCSprite *)[self getChildByTag:2031];
	CGRect leftArrowRect = CGRectMake(
									  leftArrow.position.x - (leftArrow.contentSize.width/2), 
									  leftArrow.position.y - (leftArrow.contentSize.height/2), 
									  leftArrow.contentSize.width, 
									  leftArrow.contentSize.height);
    
    
	// Make sound button rect
	CCSprite *sound = (CCSprite *)[self getChildByTag:2010];
	CGRect soundButton = CGRectMake(
									sound.position.x - (sound.contentSize.width/2),
									sound.position.y - (sound.contentSize.height/2),
									sound.contentSize.width,
									sound.contentSize.height);
	// Make music button rect
	CCSprite *music = (CCSprite *)[self getChildByTag:2011];
	CGRect musicButton = CGRectMake(
									music.position.x - (music.contentSize.width/2),
									music.position.y - (music.contentSize.height/2),
									music.contentSize.width,
									music.contentSize.height);
    
	// Make the Gaming Network button rect
	CCSprite *gamingNetwork = (CCSprite *)[self getChildByTag:2013];
	CGRect gamingNetworkButton = [gamingNetwork boundingBox];
    
	// Make the Settings button rect
	CCSprite *settings = (CCSprite *)[self getChildByTag:2014];
	CGRect settingsButton = [settings boundingBox];

 	// Make the Pack 1 Rect
	CCSprite *pack1 = (CCSprite *)[self getChildByTag:201];
	CGRect pack1Rect = [pack1 boundingBox];
        
 	// Make the Pack 2 Rect
	CCSprite *pack2 = (CCSprite *)[self getChildByTag:202];
	CGRect pack2Rect = [pack2 boundingBox];
    
 	// Make the Pack 3 Rect
	CCSprite *pack3 = (CCSprite *)[self getChildByTag:203];
	CGRect pack3Rect = [pack3 boundingBox];
    
 	// Make the Pack 4 Rect
	CCSprite *pack4 = (CCSprite *)[self getChildByTag:204];
	CGRect pack4Rect = [pack4 boundingBox];
    
 	// Make the Popometer Pack Rect
	CCSprite *popometerPack = (CCSprite *)[self getChildByTag:211];
	CGRect popometerPackRect = [popometerPack boundingBox];
    
 	// Make the Mega Pack Rect
	CCSprite *megaPack = (CCSprite *)[self getChildByTag:212];
	CGRect megaPackRect = [megaPack boundingBox];
    
 	// Game 1 Icon
	CCSprite *game1 = (CCSprite *)[self getChildByTag:5001];
	CGRect game1Rect = [game1 boundingBox];
 	// Game 2 Icon
	CCSprite *game2 = (CCSprite *)[self getChildByTag:5002];
	CGRect game2Rect = [game2 boundingBox];
 	// Game 3 Icon
	CCSprite *game3 = (CCSprite *)[self getChildByTag:5003];
	CGRect game3Rect = [game3 boundingBox];
    
    // Free Gold
	CCSprite *freeGold = (CCSprite *)[self getChildByTag:5004];
	CGRect freeGoldRect = [freeGold boundingBox];

    // Check if not enough gems or gold is displayed
    BuyGoldGemsHintsLayer *goldGemsHints = (BuyGoldGemsHintsLayer *)[self getChildByTag:8000];
    BOOL notEnoughGemsGoldDisplayed = [goldGemsHints notEnoughGemsGoldDisplayed];

    // See if the gold, gems or hints are displayed.  Only proceed if they aren't
    buyGoldDisplayed = [[NSUserDefaults standardUserDefaults] boolForKey:@"buyGoldDisplayed"];
    buyGemsDisplayed = [[NSUserDefaults standardUserDefaults] boolForKey:@"buyGemsDisplayed"];
    needAHintDisplayed = [[NSUserDefaults standardUserDefaults] boolForKey:@"needAHintDisplayed"];
    
    if ((buyGoldDisplayed == NO) && (buyGemsDisplayed == NO) && (needAHintDisplayed == NO)
        && (notEnoughGemsGoldDisplayed == NO)) {

        if (CGRectContainsPoint(settingsButton, location)) [self expandSpriteEffect:13 tag:2014];
        if (CGRectContainsPoint(game1Rect, location)) [self expandSpriteEffect:17 tag:5001];
        if (CGRectContainsPoint(game2Rect, location)) [self expandSpriteEffect:18 tag:5002];
        if (CGRectContainsPoint(game3Rect, location)) [self expandSpriteEffect:19 tag:5003];
        if (CGRectContainsPoint(freeGoldRect, location)) [self expandSpriteEffect:20 tag:5004];
		
		// Only check for sound & music if settings are displayed
		if (settingsDisplayed == YES) {
			if (CGRectContainsPoint(soundButton, location)) [self expandSpriteEffect:14 tag:2010];
			if (CGRectContainsPoint(musicButton, location)) [self expandSpriteEffect:15 tag:2011];
		}

        else {
 			if (CGRectContainsPoint(pack1Rect, location)) [self expandSpriteEffect:1 tag:201];
 			if (CGRectContainsPoint(pack2Rect, location)) {
                if (popperPack2Unlock == YES) {
                    [self expandSpriteEffect:2 tag:202];
                }
                else {
                    pack2Error = nil;
                    if (randomUnlockCurrency == 1) { // Gems
                        pack2Error = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Solve all puzzles in Pack 1 to automatically unlock this pack. Or you can unlock Pack 2 now for 90 gems!" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    else {  // Gold
                        pack2Error = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Solve all puzzles in Pack 1 to automatically unlock this pack. Or you can unlock Pack 2 now for 9000 gold!" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    [pack2Error show];
                    [pack2Error release];
                }
            }
 			if (CGRectContainsPoint(pack3Rect, location)) {
                if (popperPack3Unlock == YES) {
                    [self expandSpriteEffect:3 tag:203];
                }
                else {
                    pack3Error = nil;
                    if (randomUnlockCurrency == 1) { // Gems
                        pack3Error = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Solve all puzzles in Pack 2 to automatically unlock this pack. Or you can unlock Pack 3 now for 90 gems!" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    else {  // Gold
                        pack3Error = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Solve all puzzles in Pack 2 to automatically unlock this pack. Or you can unlock Pack 3 now for 9000 gold!" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    [pack3Error show];
                    [pack3Error release];
                }
            }
 			if (CGRectContainsPoint(pack4Rect, location)) {
                if (popperPack4Unlock == YES) {
                    [self expandSpriteEffect:4 tag:204];
                }
                else {
                    pack4Error = nil;
                    if (randomUnlockCurrency == 1) { // Gems
                        pack4Error = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Solve all puzzles in Pack 3 to automatically unlock this pack. Or you can unlock Pack 4 now for 90 gems!" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    else {  // Gold
                        pack4Error = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Solve all puzzles in Pack 3 to automatically unlock this pack. Or you can unlock Pack 4 now for 9000 gold!" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    [pack4Error show];
                    [pack4Error release];
                }
            }
 			if (CGRectContainsPoint(popometerPackRect, location)) {
                if (popometerPackUnlock == YES) {
                    [self expandSpriteEffect:11 tag:211];
                }
                else {
                    popometerPackError = nil;
                    if (randomUnlockCurrency == 1) { // Gems
                        popometerPackError = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Popometer Pack has over 100 crazy randomized color levels!  Would you like to unlock it now for 90 gems?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    else {  // Gold
                        popometerPackError = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Popometer Pack has over 100 crazy randomized color levels!  Would you like to unlock it now for 9000 gold?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    [popometerPackError show];
                    [popometerPackError release];
                }
            }
 			if (CGRectContainsPoint(megaPackRect, location)) {
                if (megaPack1Unlock == YES) {
                    [self expandSpriteEffect:12 tag:212];
                }
                else {
                    megaPackError = nil;
                    if (randomUnlockCurrency == 1) { // Gems
                        megaPackError = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Mega Pack has over 300 new levels!  Would you like to unlock it now for 190 gems?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    else {  // Gold
                        megaPackError = [[UIAlertView alloc] initWithTitle: @"Pack Locked!" message: @"Mega Pack has over 300 new levels!  Would you like to unlock it now for 18000 gold?" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Yes, Unlock" ,nil];
                    }
                    [megaPackError show];
                    [megaPackError release];
                }
            }
            if (CGRectContainsPoint(gamingNetworkButton, location)) {
                [self expandSpriteEffect:16 tag:2013];
            }
       }
        
    }
    else {
    }		
    
    touchCheck = nil;
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category 
{
	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];	
	scoreReporter.value = score;
	[scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
        if (error != nil) {
            NSLog(@"Score Reporting Failed");
        }
	 }];
}

-(void) calculateHighScore:(int)type {
    
    totalHighScore = 0;
    
    // Basic Training
    if (type == 1) {
        int highScore = 0;
        totalHighScore1 = 0;
        
        for(int i = 1; i <= 105; i++) {
            
            NSString *iStr = [NSString stringWithFormat:@"%d",i];
            highScore = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"popper1_level%@_highScore",iStr]];
            totalHighScore1 = totalHighScore1 + highScore;
        }
        
        if (totalHighScore1 == 0) return;
        
        /*
        if([GameCenterManager isGameCenterAvailable]) {
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [gameCenterManager setDelegate: self];
            [gameCenterManager authenticateLocalUser];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [gameCenterManager reportScore:totalHighScore1 forCategory:@"blowfishpoppers.basictraining.totalscore.iphone"];}
            else {
                [gameCenterManager reportScore:totalHighScore1 forCategory:@"blowfishpoppers.basictraining.totalscore.ipad"];}
        }
         */

        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error){
            if (localPlayer.isAuthenticated) {
                GKScore *scoreReporter;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.basictraining.totalscore.iphone"] autorelease];
                }
                else {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.basictraining.totalscore.ipad"] autorelease];	
                }
                scoreReporter.value = totalHighScore1;
                NSLog(@"High Score: %d", totalHighScore1);
                [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
                    if (error != nil) {
                    }
                }];
           }
        }];
        
    }
    
    // Two's Better than One!
    if (type == 2) {
        int highScore = 0;
        totalHighScore2 = 0;
        
        for(int i = 1; i <= 105; i++) {
            
            NSString *iStr = [NSString stringWithFormat:@"%d",i];
            highScore = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"popper2_level%@_highScore",iStr]];
            totalHighScore2 = totalHighScore2 + highScore;
        }
        
        if (totalHighScore2 == 0) return;
        
        /*
        if([GameCenterManager isGameCenterAvailable]) {
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [gameCenterManager setDelegate: self];
            [gameCenterManager authenticateLocalUser];
            
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [gameCenterManager reportScore:totalHighScore2 forCategory:@"blowfishpoppers.pack2.totalscore.iphone"];}
            else {
                [gameCenterManager reportScore:totalHighScore2 forCategory:@"blowfishpoppers.pack2.totalscore.ipad"];}
        }
         */

        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error){
            if (localPlayer.isAuthenticated) {
                GKScore *scoreReporter;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.pack2.totalscore.iphone"] autorelease];
                }
                else {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.pack2.totalscore.ipad"] autorelease];
                }
                scoreReporter.value = totalHighScore2;
                NSLog(@"High Score: %d", totalHighScore2);
                [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
                    if (error != nil) {
                    }
                }];
            }
        }];
        
    }
    
    // Three's Company
    if (type == 3) {
        int highScore = 0;
        totalHighScore3 = 0;
        
        for(int i = 1; i <= 105; i++) {
            
            NSString *iStr = [NSString stringWithFormat:@"%d",i];
            highScore = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"popper3_level%@_highScore",iStr]];
            totalHighScore3 = totalHighScore3 + highScore;
        }
        
        if (totalHighScore3 == 0) return;
        
        /*
        if([GameCenterManager isGameCenterAvailable]) {
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [gameCenterManager setDelegate: self];
            [gameCenterManager authenticateLocalUser];
            
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [gameCenterManager reportScore:totalHighScore3 forCategory:@"blowfishpoppers.pack3.totalscore.iphone"];}
            else {
                [gameCenterManager reportScore:totalHighScore3 forCategory:@"blowfishpoppers.pack3.totalscore.ipad"];}
        }
         */

        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error){
            if (localPlayer.isAuthenticated) {
                GKScore *scoreReporter;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.pack3.totalscore.iphone"] autorelease];
                }
                else {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.pack3.totalscore.ipad"] autorelease];	
                }
                scoreReporter.value = totalHighScore3;
                NSLog(@"High Score: %d", totalHighScore3);
                [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
                    if (error != nil) {
                    }
                }];
            }
        }];
        
    }
    
    // Four is Fun!
    if (type == 4) {
        int highScore = 0;
        totalHighScore4 = 0;
        
        for(int i = 1; i <= 105; i++) {
            
            NSString *iStr = [NSString stringWithFormat:@"%d",i];
            highScore = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"popper4_level%@_highScore",iStr]];
            totalHighScore4 = totalHighScore4 + highScore;
        }
        
        if (totalHighScore4 == 0) return;
        
        /*
        if([GameCenterManager isGameCenterAvailable]) {
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [gameCenterManager setDelegate: self];
            [gameCenterManager authenticateLocalUser];
            
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [gameCenterManager reportScore:totalHighScore4 forCategory:@"blowfishpoppers.pack4.totalscore.iphone"];}
            else {
                [gameCenterManager reportScore:totalHighScore4 forCategory:@"blowfishpoppers.pack4.totalscore.ipad"];}
        }
         */

        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error){
            if (localPlayer.isAuthenticated) {
                GKScore *scoreReporter;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.pack4.totalscore.iphone"] autorelease];
                }
                else {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.pack4.totalscore.ipad"] autorelease];	
                }
                scoreReporter.value = totalHighScore4;
                NSLog(@"High Score: %d", totalHighScore4);
                [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
                    if (error != nil) {
                    }
                }];
            }
        }];
        
    }
    
    // Five is Fantastic
    if (type == 5) {
        int highScore = 0;
        
        for(int i = 1; i <= 105; i++) {
            
            NSString *iStr = [NSString stringWithFormat:@"%d",i];
            highScore = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"popper5_level%@_highScore",iStr]];
            totalHighScore = totalHighScore + highScore;
        }
        
        if (totalHighScore == 0) return;
    }
    
    // Popometer Pack
    if (type == 11) {
        int highScore = 0;
        totalHighScore11 = 0;
        
        for(int i = 1; i <= 105; i++) {
            
            NSString *iStr = [NSString stringWithFormat:@"%d",i];
            highScore = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"popometerPack_level%@_highScore",iStr]];
            totalHighScore11 = totalHighScore11 + highScore;
        }
        
        if (totalHighScore11 == 0) return;
        
        /*
        if([GameCenterManager isGameCenterAvailable]) {
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [gameCenterManager setDelegate: self];
            [gameCenterManager authenticateLocalUser];
            
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [gameCenterManager reportScore:totalHighScore11 forCategory:@"blowfishpoppers.popometerpack.totalscore.iphone"];}
            else {
                [gameCenterManager reportScore:totalHighScore11 forCategory:@"blowfishpoppers.popometerpack.totalscore.ipad"];}
        }
         */

        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error){
            if (localPlayer.isAuthenticated) {
                GKScore *scoreReporter;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.popometerpack.totalscore.iphone"] autorelease];
                }
                else {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.popometerpack.totalscore.ipad"] autorelease];	
                }
                scoreReporter.value = totalHighScore11;
                NSLog(@"High Score: %d", totalHighScore11);
                [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
                    if (error != nil) {
                    }
                }];
            }
        }];

    }
    
    // Mega Pack #1
    if (type == 12) {
        int highScore = 0;
        totalHighScore12 = 0;
        
        for(int i = 1; i <= 315; i++) {
            
            NSString *iStr = [NSString stringWithFormat:@"%d",i];
            highScore = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"megaPack1_level%@_highScore",iStr]];
            totalHighScore12 = totalHighScore12 + highScore;
        }
        
        if (totalHighScore12 == 0) return;
        
        /*
        if([GameCenterManager isGameCenterAvailable]) {
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [gameCenterManager setDelegate: self];
            [gameCenterManager authenticateLocalUser];
            
            gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [gameCenterManager reportScore:totalHighScore12 forCategory:@"blowfishpoppers.megapack1.totalscore.iphone"];}
            else {
                [gameCenterManager reportScore:totalHighScore12 forCategory:@"blowfishpoppers.megapack1.totalscore.ipad"];}
        }
         */

        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error){
            if (localPlayer.isAuthenticated) {
                GKScore *scoreReporter;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.megapack1.totalscore.iphone"] autorelease];
                }
                else {
                    scoreReporter = [[[GKScore alloc] initWithCategory:@"blowfishpoppers.megapack1.totalscore.ipad"] autorelease];	
                }
                scoreReporter.value = totalHighScore12;
                NSLog(@"High Score: %d", totalHighScore12);
                [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) {
                    if (error != nil) {
                    }
                }];
            }
        }];
        
    }
}

-(void)expandSpriteEffect: (int)type tag:(int)tag {
	
	if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3"];}
	
	CCSprite *sprite;
	id actionMoveDone;
	id scaleUp = [CCScaleTo actionWithDuration:.1 scale:1.3];
	id scaleDown = [CCScaleTo actionWithDuration:.05 scale:1];
	id scaleDown2 = [CCScaleTo actionWithDuration:.05 scale:1];
	//	id delay = [CCFadeTo actionWithDuration:.5 opacity:255]; // Use delay to allow the pop sound to play fully
	
	id action;
	
	// Popper Pack 1
	if (type == 1) {
        menuSelectionNo = 1;
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
    
	// Popper Pack 2
	else if (type == 2) {
        menuSelectionNo = 2;
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
    
	// Popper Pack 3
	else if (type == 3) {
        menuSelectionNo = 3;
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
	
    // Popper Pack 4
	else if (type == 4) {
        menuSelectionNo = 4;
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
    
    // Popper Pack 5
	else if (type == 5) {
        menuSelectionNo = 5;
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
        
    // Popometer Pack
	else if (type == 11) {
        menuSelectionNo = 11;
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
    
    // Mega Pack #1
	else if (type == 12) {
        menuSelectionNo = 12;
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}

    // Settings
	else if (type == 13) {
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displaySettings)];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
    
	// Sound Button Toggle
	else if (type == 14) {
		sprite = (CCSprite *)[self getChildByTag:tag];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(soundToggle)];
		[[CCDirector sharedDirector] resume];
	}
	
	// Music Button Toggle
	else if (type == 15) {
		sprite = (CCSprite *)[self getChildByTag:tag];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(musicToggle)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Gaming Network Button
	if (type == 16) {
		sprite = (CCSprite *)[self getChildByTag:2013];
  		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displayGamingNetwork)];
		[[CCDirector sharedDirector] resume];
	}
    
	// More Games
	if (type == 17) {
		sprite = (CCSprite *)[self getChildByTag:5001];
  		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displayMoreGames)];
		[[CCDirector sharedDirector] resume];
	}
    
	// Free Gold
	if (type == 20) {
		sprite = (CCSprite *)[self getChildByTag:tag];
  		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(displayAdColony)];
		[[CCDirector sharedDirector] resume];
	}

	else {
		action = [CCSequence actions:scaleUp, scaleDown, scaleDown2, nil];
		sprite = (CCSprite *)[self getChildByTag:tag];
	}
	
	action = [CCSequence actions:scaleUp, scaleDown, scaleDown2, actionMoveDone, nil];
	[sprite runAction:action];
}

-(void) exitToFullVersion {
	
	fullVersionConfirm = nil;
	fullVersionConfirm = [[UIAlertView alloc] initWithTitle: @"Thanks for trying Blowfish Poppers Sneak Peek!" message: @"The FULL version of Blowfish Poppers is coming soon to the App Store!  Check it out!" delegate: self cancelButtonTitle: @"No" otherButtonTitles: @"Ok" ,nil];
	[fullVersionConfirm show];
	[fullVersionConfirm release];
}

-(void) soundDisplay {
	
	// Retrieve the current sound setting
	playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_sounds"];
	CCSprite *sprite, *sprite2;
	
	if (playSound == NO) {
		sprite = (CCSprite *)[self getChildByTag:2010];
		[self removeChild:sprite cleanup:YES];
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"soundOff.png"];
		[self addChild:sprite2 z:4 tag:2010];
	}
	else {
		sprite = (CCSprite *)[self getChildByTag:2010];
		[self removeChild:sprite cleanup:YES];
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"soundOn.png"];
		[self addChild:sprite2 z:4 tag:2010];
	}
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		sprite2.position = ccp(44,145);
	}
	else {
		sprite2.position = ccp(100,290);
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
	
	// Retrieve the current music setting
	playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_music"];
	CCSprite *sprite, *sprite2;
	
	if (playMusic == NO) {
		sprite = (CCSprite *)[self getChildByTag:2011];
		[self removeChild:sprite cleanup:YES];
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"musicOff.png"];
		[self addChild:sprite2 z:4 tag:2011];
	}
	else {
		sprite = (CCSprite *)[self getChildByTag:2011];
		[self removeChild:sprite cleanup:YES];
		sprite2 = [CCSprite spriteWithSpriteFrameName:@"musicOn.png"];
		[self addChild:sprite2 z:4 tag:2011];
	}
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		sprite2.position = ccp(44,90);
	}
	else {
		sprite2.position = ccp(100,200);
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

-(void) settingsToggle {
	
	if (playMusic==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3"];}
	
}

-(void) displaySettings {
	
	if (settingsDisplayed == NO) {
		settingsDisplayed = YES;
		
		// Show the volume & music icons
		CCSprite *settingsBackground = [CCSprite spriteWithSpriteFrameName:@"settingsBackground.png"];
		[self addChild:settingsBackground z:3 tag:2018];
		settingsBackground.scale = .1;
		settingsBackground.opacity = 175;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			settingsBackground.position = ccp(44,105);}
		else {
			settingsBackground.position = ccp(100,210);}
		
		// Display the music & sound buttons
  		[self soundDisplay];
 		[self musicDisplay];
		
		// Scale up the music & sound buttons
		CCSprite *sound = (CCSprite *)[self getChildByTag:2010];
		CCSprite *music = (CCSprite *)[self getChildByTag:2011];
		sound.scale = .1;
		music.scale = .1;
        
		id scaleUp = [CCScaleTo actionWithDuration:.25 scale:1];
		[sound runAction:[CCSequence actions:scaleUp, nil, nil]];
		scaleUp = [CCScaleTo actionWithDuration:.25 scale:1];
		[music runAction:[CCSequence actions:scaleUp, nil, nil]];
		scaleUp = [CCScaleTo actionWithDuration:.25 scaleX:1 scaleY:.6];
		id move = [CCMoveBy actionWithDuration:.25 position:[self convertPoint:ccp(0, 15)]];
		id action2 = [CCSpawn actions:
                      [CCSequence actions:scaleUp, nil, nil],
                      [CCSequence actions:move, nil, nil],
                      nil];
		
		[settingsBackground runAction:action2];
	}
	else {
		settingsDisplayed = NO;
		
		CCSprite *settingsBackground = (CCSprite *)[self getChildByTag:2018];
		
		[self removeChildByTag:2010 cleanup:YES];
		[self removeChildByTag:2011 cleanup:YES];
		[self removeChildByTag:2019 cleanup:YES];
		[self removeChildByTag:2020 cleanup:YES];
		
		// Remove the background
		id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeSettingsBackground)];
		id scaleDown = [CCScaleTo actionWithDuration:.25 scale:.1];
		id move = [CCMoveBy actionWithDuration:.25 position:[self convertPoint:ccp(0, -165)]];
		id action2 = [CCSpawn actions:
					  [CCSequence actions:scaleDown, nil, nil],
					  [CCSequence actions:move, actionMoveDone, nil],
					  nil];
		[settingsBackground runAction:action2];
	}
}

-(void) removeSettingsBackground {
	[self removeChildByTag:2018 cleanup:YES];
}

-(void) displayGamingNetwork {
    
    [self showGameCenterLeaderboard];
}

- (void) showGameCenterLeaderboard
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error){
        if (!localPlayer.isAuthenticated) {
            [self startGameCenter];
        }
    }];
    
    if (!localPlayer.isAuthenticated) {
        return;
    }
    
	CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	tempVC = [[UIViewController alloc] init];
    
	GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
	if (leaderboardController != nil)
	{
        
        /*
         leaderboardController.leaderboardDelegate = self;
         [[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
         [tempVC presentModalViewController:leaderboardController animated: YES];
         */
        /*
         RootViewController *controller = [[RootViewController alloc]init];
         leaderboardController.leaderboardDelegate = self;
         [[[CCDirector sharedDirector] openGLView] addSubview:controller.view];
         
         [controller presentModalViewController:leaderboardController animated:YES];
         */
        
        // *** NOTE: It appears that if animation is set to YES, then the orientation gets messed up ****
        
        leaderboardController.leaderboardDelegate = self;
		[[[CCDirector sharedDirector] openGLView] addSubview:tempVC.view];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [tempVC presentModalViewController: leaderboardController animated: NO];}
        else {
            [tempVC presentModalViewController: leaderboardController animated: YES];}
		leaderboardController.view.transform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(0.0f));
		[leaderboardController.view setCenter:CGPointMake(screenSize.height/2, screenSize.width/2)];
	}
    
    /*
     GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
     if (leaderboardController != nil)
     {
     leaderboardController.leaderboardDelegate = self;
     [self presentModalViewController: leaderboardController animated: YES];
     }
     
     [leaderboardController release];
     */
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[tempVC dismissModalViewControllerAnimated:YES];
	[tempVC.view removeFromSuperview];
}

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            // Perform additional tasks for the authenticated player.
        }
    }];
}

-(void) startGameCenter {
    gameCenterSignIn = [[UIAlertView alloc] initWithTitle: @"Game Center is Disabled!" message: @"Please sign in with the Game Center application to enable." delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Sign In" ,nil];
    [gameCenterSignIn show];
    [gameCenterSignIn release];
}

-(void) endGameCenter {
    
}

-(void) displayGoldGemHints {
    
    CCSprite *goldGemsHints = (CCSprite *)[self getChildByTag:8000];
    if (goldGemsHints != nil) return;
    
    // Display the Gold, Gems & Hints
    BuyGoldGemsHintsLayer *buyGoldGemsHints = [BuyGoldGemsHintsLayer node];
	[self addChild:buyGoldGemsHints z:12 tag:8000];
    
}

-(void) newScene {
    
    [[NSUserDefaults standardUserDefaults] setInteger:menuSelectionNo forKey:@"crazy_poppers_menu_selection"];
	
    // Remove the Gold, Gem & Hints header
    [self removeChildByTag:8000 cleanup:YES];
    
    CrazyPoppersScene * cps = [CrazyPoppersScene node];
    [[CCDirector sharedDirector] replaceScene:cps];
}

-(void) displayFullVersion {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/crazy-poppers/id500775208?mt=8"];
        
        if (![[UIApplication sharedApplication] openURL:url])
            
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
	}
	else {
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/app/crazy-poppers-hd/id506721616?mt=8"];
        
        if (![[UIApplication sharedApplication] openURL:url])
            
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
	}
}

-(void) unlockPack:(int)pack {
    
    // Pack 2
    if (pack == 2) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"popper_pack_2_unlocked"];
    }
    
    // Pack 3
    if (pack == 3) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"popper_pack_3_unlocked"];
    }
    
    // Pack 4
    if (pack == 4) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"popper_pack_4_unlocked"];        
    }
    
    // Popometer Pack
    if (pack == 11) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"popometer_pack_unlocked"];
    }
    
    // Mega Pack
    if (pack == 12) {
        [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"mega_pack_1_unlocked"];
    }
    
    // Refresh to screen
    CrazyPoppersMenuScene * cpms = [CrazyPoppersMenuScene node];
    [[CCDirector sharedDirector] replaceScene:cpms];
}

-(void) requestProductData: (int)identifier {
    
    miscError = nil;
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		switch (identifier)
		{
			case 1: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.pack2"];break;}
			case 2: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.pack3"];break;}
			case 3: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.pack4"];break;}
			case 4: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.popometerpack"];break;}
			case 5: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.megapack1"];break;}
		}
	}
	else {
		switch (identifier)
		{
			case 1: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.pack2"];break;}
			case 2: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.pack3"];break;}
			case 3: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.pack4"];break;}
			case 4: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.popometerpack"];break;}
			case 5: {productIdentifiers =[NSSet setWithObject:@"au.com.incredibleadventure.PoppingBlowfish.megapack1"];break;}
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
	
	// format the price for the location
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:product.priceLocale];
	NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
	NSString *ggString = [NSString stringWithFormat:@"Do you want to buy %@ for %@?",product.localizedTitle, formattedPrice];
	
	// populate UI
	if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack2"]) 
		|| ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack2"])) {
		pack2Error = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[pack2Error show];
		[pack2Error release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack3"]) 
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack3"])) {
		pack3Error = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[pack3Error show];
		[pack3Error release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack4"]) 
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack4"])) {
		pack4Error = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[pack4Error show];
		[pack4Error release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.popometerpack"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.popometerpack"])) {
		popometerPackError = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[popometerPackError show];
		[popometerPackError release];
	}
	else if (([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.megapack1"])
             || ([currentIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.megapack1"])) {
		megaPackError = [[UIAlertView alloc] initWithTitle: @"Confirm Your In-App Purchase" message: ggString delegate: self cancelButtonTitle: @"Cancel" otherButtonTitles: @"Buy" ,nil];
		[megaPackError show];
		[megaPackError release];
	}
	
	[request autorelease];
}

- (void)purchaseProduct:(NSString *)productIdentifier {
	
	NSLog(@"Purchasing product: %@", productIdentifier);
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
	// Record transaction on server side - not necessary at this point
}

- (void)provideContent:(NSString *)productIdentifier {
    
    if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack2"]) {
        [Flurry logEvent:@"Pack 2 Unlocked"];
        [self unlockPack:2];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack3"]) {
        [Flurry logEvent:@"Pack 3 Unlocked"];
        [self unlockPack:3];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack4"]) {
        [Flurry logEvent:@"Pack 4 Unlocked"];
        [self unlockPack:4];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.popometerpack"]) {
        [Flurry logEvent:@"Popometer Pack Unlocked"];
        [self unlockPack:11];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.megapack1"]) {
        [Flurry logEvent:@"Mega Pack #1 Unlocked"];
        [self unlockPack:12];
    }
    
    
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack2"]) {
        [Flurry logEvent:@"Pack 2 Unlocked"];
        [self unlockPack:2];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack3"]) {
        [Flurry logEvent:@"Pack 3 Unlocked"];
        [self unlockPack:3];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.pack4"]) {
        [Flurry logEvent:@"Pack 4 Unlocked"];
        [self unlockPack:4];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.popometerpack"]) {
        [Flurry logEvent:@"Popometer Pack Unlocked"];
        [self unlockPack:11];
    }
	else if ([productIdentifier isEqualToString:@"au.com.incredibleadventure.PoppingBlowfish.megapack1"]) {
        [Flurry logEvent:@"Mega Pack #1 Unlocked"];
        [self unlockPack:12];
    }
     
	[[NSNotificationCenter defaultCenter] postNotificationName:productIdentifier object:productIdentifier];
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    BuyGoldGemsHintsLayer *goldGemsHints = (BuyGoldGemsHintsLayer *)[self getChildByTag:8000];
    
    // Game Center Sign In
    if (alertView == gameCenterSignIn) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        }
        else {gameCenterSignIn = nil;}
    }
    
    // Unlock Pack 2
    if (alertView == pack2Error) {
        if (buttonIndex == 1) {
            
            int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
            int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
            if (randomUnlockCurrency == 1) { // gems
                if (90 <= gems) {
                    [Flurry logEvent:@"Pack 2 Unlocked w/Gems"];
                    [self saveGems:-90];
                    [self unlockPack:2];
                }
                else {
                    [goldGemsHints notEnoughGems:90-gems];
                }
            }
            else { // gold
                if (9000 <= gold) {
                    [Flurry logEvent:@"Pack 2 Unlocked w/Gold"];
                    [self saveGold:-9000];
                    [self unlockPack:2];
               }
                else {
                    [goldGemsHints notEnoughGold:9000-gold];
                }
            }
            pack2Error = nil;
        }
        else {
            pack2Error = nil;
        }
	}
    
    // Unlock Pack 3
    if (alertView == pack3Error) {
        if (buttonIndex == 1) {
            
            int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
            int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
            if (randomUnlockCurrency == 1) { // gems
                if (90 <= gems) {
                    [Flurry logEvent:@"Pack 3 Unlocked w/Gems"];
                    [self saveGems:-90];
                    [self unlockPack:3];
                }
                else {
                    [goldGemsHints notEnoughGems:90-gems];
                }
            }
            else { // gold
                if (9000 <= gold) {
                    [Flurry logEvent:@"Pack 3 Unlocked w/Gold"];
                    [self saveGold:-9000];
                    [self unlockPack:3];
                }
                else {
                    [goldGemsHints notEnoughGold:9000-gold];
                }
            }
            
            pack3Error = nil;
        }
        else {
            pack3Error = nil;
        }
	}
    
    // Unlock Pack 4
    if (alertView == pack4Error) {
        if (buttonIndex == 1) {
            
            int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
            int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
            if (randomUnlockCurrency == 1) { // gems
                if (90 <= gems) {
                    [Flurry logEvent:@"Pack 4 Unlocked w/Gems"];
                    [self saveGems:-90];
                    [self unlockPack:4];
                }
                else {
                    [goldGemsHints notEnoughGems:90-gems];
                }
            }
            else { // gold
                if (9000 <= gold) {
                    [Flurry logEvent:@"Pack 4 Unlocked w/Gold"];
                    [self saveGold:-9000];
                    [self unlockPack:4];
                }
                else {
                    [goldGemsHints notEnoughGold:9000-gold];
                }
            }
            
            pack4Error = nil;
        }
        else {
            pack4Error = nil;
        }
    }
        
    // Popometer Pack unlock
	if (alertView == popometerPackError) {
		if (buttonIndex == 1) {
            int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
            int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
            if (randomUnlockCurrency == 1) { // gems
                if (90 <= gems) {
                    [Flurry logEvent:@"Popometer Pack Unlocked"];
                    [self saveGems:-90];
                    [self unlockPack:11];
                }
                else {
                    [goldGemsHints notEnoughGems:90-gems];
                }
            }
            else { // gold
                if (9000 <= gold) {
                    [Flurry logEvent:@"Popometer Pack Unlocked"];
                    [self saveGold:-9000];
                    [self unlockPack:11];
                }
                else {
                    [goldGemsHints notEnoughGold:9000-gold];
                }
            }
            
            popometerPackError = nil;
		}
		else {
			popometerPackError = nil;
		}
	}
    
    // Mega Pack #1 unlock
	if (alertView == megaPackError) {
		if (buttonIndex == 1) {
            int gems = [[NSUserDefaults standardUserDefaults] integerForKey:@"gems"];
            int gold = [[NSUserDefaults standardUserDefaults] integerForKey:@"localGoldPlusTapjoyGold"];
            if (randomUnlockCurrency == 1) { // gems
                if (190 <= gems) {
                    [Flurry logEvent:@"Mega Pack #1 Unlocked"];
                    [self saveGems:-190];
                    [self unlockPack:12];
                }
                else {
                    [goldGemsHints notEnoughGems:190-gems];
                }
            }
            else { // gold
                if (18000 <= gold) {
                    [Flurry logEvent:@"Mega Pack #1 Unlocked"];
                    [self saveGold:-18000];
                    [self unlockPack:12];
                }
                else {
                    [goldGemsHints notEnoughGold:18000-gold];
                }
            }
            
            megaPackError = nil;
		}
		else {
			megaPackError = nil;
		}
	}    
}

- (void) dealloc
{   
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];  // for IAP
    
    [selectionArray release];
	selectionArray = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
}
@end


// Crazy Poppers Scene implementation
@implementation CrazyPoppersScene

-(id) init
{
	if( (self=[super init])) {
		[self addChild:[CrazyPoppersLayer node] z:1];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end


// Crazy Poppers Layer implementation
@implementation CrazyPoppersLayer

// Convert iPad to iPhone
-(CGPoint) convertPoint: (CGPoint)pos {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return ccp(pos.x/1.75, pos.y/2.1);
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
        return y/2.4;
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

		// Retrieve the current level
		currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper_current_level"];
        
		// Retrieve the selection number
		menuSelectionNo = [[NSUserDefaults standardUserDefaults] integerForKey:@"crazy_poppers_menu_selection"];
        
        offset = 0;
        
		// Retrieve the highest level 
        if (menuSelectionNo == 1) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper1_highest_level"];
        }
        else if (menuSelectionNo == 2) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper2_highest_level"];
        }
        else if (menuSelectionNo == 3) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper3_highest_level"];
        }
        else if (menuSelectionNo == 4) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper4_highest_level"];
        }
        else if (menuSelectionNo == 5) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popper5_highest_level"];
        }
        else if (menuSelectionNo == 11) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"popometerPack_highest_level"];
        }
        else if (menuSelectionNo == 12) {
            highestLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"megaPack1_highest_level"];
        }
        
        // Set the popper level page
        if (highestLevel <= 21) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"current_popper_page"];}
        
		// Load the sprite sheet		
		[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];  // This is necessary if using pvr.ccz
		
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"popper-spritesheet.pvr.ccz"];
        [self addChild:spriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"popper-spritesheet.plist"];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"popper-spritesheet-hd.pvr.ccz"];
			[self addChild:spriteSheet];
			[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"popper-spritesheet-hd.plist"];
		}
		
        // Initialize the selection layers
        selection1 = [[CCLayer alloc] init];
        selection2 = [[CCLayer alloc] init];
        selection3 = [[CCLayer alloc] init];
        selection4 = [[CCLayer alloc] init];
        selection5 = [[CCLayer alloc] init];
        selection6 = [[CCLayer alloc] init];
        selection7 = [[CCLayer alloc] init];
        selection8 = [[CCLayer alloc] init];
        selection9 = [[CCLayer alloc] init];
        selection10 = [[CCLayer alloc] init];
        selection11 = [[CCLayer alloc] init];
        selection12 = [[CCLayer alloc] init];
        selection13 = [[CCLayer alloc] init];
        selection14 = [[CCLayer alloc] init];
        selection15 = [[CCLayer alloc] init];
        
		// Initialize values
		selectLevel = YES;
        touchMoved = NO;
		highScore = 0;
		levelSelectionPage = 0;
		levelCounter = 0;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            levelSelect1 = CGRectMake(screenSize.width/2-192, 200, 50, 50);
            levelSelect2 = CGRectMake(screenSize.width/2-132, 200, 50, 50);
            levelSelect3 = CGRectMake(screenSize.width/2-72, 200, 50, 50);
            levelSelect4 = CGRectMake(screenSize.width/2-12, 200, 50, 50);
            levelSelect5 = CGRectMake(screenSize.width/2+48, 200, 50, 50);
            levelSelect6 = CGRectMake(screenSize.width/2+108, 200, 50, 50);
            levelSelect7 = CGRectMake(screenSize.width/2+168, 200, 50, 50);
            levelSelect8 = CGRectMake(screenSize.width/2-192, 142, 50, 50);
            levelSelect9 = CGRectMake(screenSize.width/2-132, 142, 50, 50);
            levelSelect10 = CGRectMake(screenSize.width/2-72, 142, 50, 50);
            levelSelect11 = CGRectMake(screenSize.width/2-12, 142, 50, 50);
            levelSelect12 = CGRectMake(screenSize.width/2+48, 142, 50, 50);
            levelSelect13 = CGRectMake(screenSize.width/2+108, 142, 50, 50);
            levelSelect14 = CGRectMake(screenSize.width/2+168, 142, 50, 50);
            levelSelect15 = CGRectMake(screenSize.width/2-192, 83, 50, 50);
            levelSelect16 = CGRectMake(screenSize.width/2-132, 83, 50, 50);
            levelSelect17 = CGRectMake(screenSize.width/2-72, 83, 50, 50);
            levelSelect18 = CGRectMake(screenSize.width/2-12, 83, 50, 50);
            levelSelect19 = CGRectMake(screenSize.width/2+48, 83, 50, 50);
            levelSelect20 = CGRectMake(screenSize.width/2+108, 83, 50, 50);
            levelSelect21 = CGRectMake(screenSize.width/2+168, 83, 50, 50);
 		}
		else {
            levelSelect1 = CGRectMake(screenSize.width/2-394, 470, 100, 100);
            levelSelect2 = CGRectMake(screenSize.width/2-289, 470, 100, 100);
            levelSelect3 = CGRectMake(screenSize.width/2-184, 470, 100, 100);
            levelSelect4 = CGRectMake(screenSize.width/2-79, 470, 100, 100);
            levelSelect5 = CGRectMake(screenSize.width/2+26, 470, 100, 100);
            levelSelect6 = CGRectMake(screenSize.width/2+131, 470, 100, 100);
            levelSelect7 = CGRectMake(screenSize.width/2+236, 470, 100, 100);
            levelSelect8 = CGRectMake(screenSize.width/2-394, 330, 100, 100);
            levelSelect9 = CGRectMake(screenSize.width/2-274, 330, 100, 100);
            levelSelect10 = CGRectMake(screenSize.width/2-154, 330, 100, 100);
            levelSelect11 = CGRectMake(screenSize.width/2-34, 330, 100, 100);
            levelSelect12 = CGRectMake(screenSize.width/2+86, 330, 100, 100);
            levelSelect13 = CGRectMake(screenSize.width/2+206, 330, 100, 100);
            levelSelect14 = CGRectMake(screenSize.width/2+326, 330, 100, 100);
            levelSelect15 = CGRectMake(screenSize.width/2-394, 190, 100, 100);
            levelSelect16 = CGRectMake(screenSize.width/2-274, 190, 100, 100);
            levelSelect17 = CGRectMake(screenSize.width/2-154, 190, 100, 100);
            levelSelect18 = CGRectMake(screenSize.width/2-34, 190, 100, 100);
            levelSelect19 = CGRectMake(screenSize.width/2+86, 190, 100, 100);
            levelSelect20 = CGRectMake(screenSize.width/2+206, 190, 100, 100);
            levelSelect21 = CGRectMake(screenSize.width/2+326, 190, 100, 100);
        }
		
		// Retrieve the current sound default
		playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_sounds"];
		// Retrieve the current music default
		playMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"should_play_music"];		
		
		if (selectLevel == YES) {
            CCSprite *background;
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                CGRect screenBounds = [[UIScreen mainScreen] bounds];
                if (screenBounds.size.height == 568) { // iPhone 5
                    background = [CCSprite spriteWithFile:@"popperBackground2Small-5hd.jpg"];
                } else {
                    background = [CCSprite spriteWithFile:@"popperBackground2Small.jpg"];
                }
				[background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
			}
			else {
                background = [CCSprite spriteWithFile:@"popperBackground2.jpg"];
				[background setPosition:ccp(512, 384)];
			}
			[self addChild:background z:0];
            
            [self levelSelection];
		}
	}
	
	return self;
}

-(void)expandSpriteEffect: (int)type {
	
	CCSprite *sprite;
	id actionMoveDone;
	id scaleUp = [CCScaleTo actionWithDuration:.1 scale:1.3];
	id scaleDown = [CCScaleTo actionWithDuration:.05 scale:1];
	id scaleDown2 = [CCScaleTo actionWithDuration:.05 scale:1];
	
	int t;
	t = 1000 + levelCounter;
	CCSprite *levelSelectionBackground;
    int currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"current_popper_page"];
	if (currentPage == 0) {
		levelSelectionBackground = (CCSprite *)[selection1 getChildByTag:2501];}
	else if (currentPage == 1) {
		levelSelectionBackground = (CCSprite *)[selection2 getChildByTag:2502];}
	else if (currentPage == 2) {
		levelSelectionBackground = (CCSprite *)[selection3 getChildByTag:2503];}
	else if (currentPage == 3) {
		levelSelectionBackground = (CCSprite *)[selection4 getChildByTag:2504];}
	else if (currentPage == 4) {
		levelSelectionBackground = (CCSprite *)[selection5 getChildByTag:2505];}
	else if (currentPage == 5) {
		levelSelectionBackground = (CCSprite *)[selection6 getChildByTag:2506];}
	else if (currentPage == 6) {
		levelSelectionBackground = (CCSprite *)[selection7 getChildByTag:2507];}
	else if (currentPage == 7) {
		levelSelectionBackground = (CCSprite *)[selection8 getChildByTag:2508];}
	else if (currentPage == 8) {
		levelSelectionBackground = (CCSprite *)[selection9 getChildByTag:2509];}
	else if (currentPage == 9) {
		levelSelectionBackground = (CCSprite *)[selection10 getChildByTag:2510];}
	else if (currentPage == 10) {
		levelSelectionBackground = (CCSprite *)[selection11 getChildByTag:2511];}
	else if (currentPage == 11) {
		levelSelectionBackground = (CCSprite *)[selection12 getChildByTag:2512];}
	else if (currentPage == 12) {
		levelSelectionBackground = (CCSprite *)[selection13 getChildByTag:2513];}
	else if (currentPage == 13) {
		levelSelectionBackground = (CCSprite *)[selection14 getChildByTag:2514];}
	else if (currentPage == 14) {
		levelSelectionBackground = (CCSprite *)[selection15 getChildByTag:2515];}
	
	// New Scene
	if (type == 1) {
		sprite = (CCSprite *)[levelSelectionBackground getChildByTag:t];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(newScene)];
	}
	
	// Left Arrow 
	if (type == 2) {
		sprite = (CCSprite *)[self getChildByTag:2031];
		actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(leftArrow)];
	}
	
	id action = [CCSequence actions:scaleUp, scaleDown, scaleDown2, actionMoveDone, nil];
	[sprite runAction:action];
}

-(void) leftArrow {
	
	// Set the current level to 1
	[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"popper_current_level"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];}
	CrazyPoppersMenuScene * cpms = [CrazyPoppersMenuScene node];
	[[CCDirector sharedDirector] replaceScene:cpms];			
}

-(void) newScene {
    
    // Set the page the user selected
    [[NSUserDefaults standardUserDefaults] setInteger:levelSelectionPage forKey:@"crazy_poppers_level_selection"];
    
    // Set the level attempts value
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"crazy_poppers_level_attempts"];
    
	// Set this value to automatically start displaying hints 
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"start_with_hint"];
    
	// Set this value to help determine if help screens should display or not
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"level_started_from_menu"];
	
	// Set crazy poppers flag (for character animations, etc.)
	[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"launched_from"];
	[[NSUserDefaults standardUserDefaults] synchronize];
        
    // Reset levels played
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"levels_played"];
	
    BOOL generateSolution = NO;
    
    if (generateSolution == NO) {
        CrazyPoppersLevelScene * cpls = [CrazyPoppersLevelScene node];
        [[CCDirector sharedDirector] replaceScene:cpls];
    }
    else {
//        LevelSolutionScene * cpls = [LevelSolutionScene node];
//        [[CCDirector sharedDirector] replaceScene:cpls];
    }
}

-(void) addLevelNumber: (int)x y:(int)y level:(int)level page:(int)page {
	
	int fontSize, x1, y1, yOffset;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (page <= 5) {
            fontSize = 26;}
        else {
            fontSize = 24;}
        x1 = 50;
        y1 = 90;
 	}
	else {
        if (page <= 5) {
            fontSize = 44;}
        else {
            fontSize = 40;}
		x1 = 100;
		y1 = 100;
	}
	
	CCSprite *levelSelectionBackground;
	if (page == 1) {
		levelSelectionBackground = (CCSprite *)[selection1 getChildByTag:2501];
	}
	if (page == 2) {
		levelSelectionBackground = (CCSprite *)[selection2 getChildByTag:2502];
        level = level + 21;
	}
	if (page == 3) {
		levelSelectionBackground = (CCSprite *)[selection3 getChildByTag:2503];
        level = level + 42;
	}
	if (page == 4) {
		levelSelectionBackground = (CCSprite *)[selection4 getChildByTag:2504];
        level = level + 63;
	}
	if (page == 5) {
		levelSelectionBackground = (CCSprite *)[selection5 getChildByTag:2505];
        level = level + 84;
	}
    
    // Add these for Mega Pack #1
	if (page == 6) {
		levelSelectionBackground = (CCSprite *)[selection6 getChildByTag:2506];
        level = level + 105;
	}
	if (page == 7) {
		levelSelectionBackground = (CCSprite *)[selection7 getChildByTag:2507];
        level = level + 126;
	}
	if (page == 8) {
		levelSelectionBackground = (CCSprite *)[selection8 getChildByTag:2508];
        level = level + 147;
	}
	if (page == 9) {
		levelSelectionBackground = (CCSprite *)[selection9 getChildByTag:2509];
        level = level + 168;
	}
	if (page == 10) {
		levelSelectionBackground = (CCSprite *)[selection10 getChildByTag:2510];
        level = level + 189;
	}
	if (page == 11) {
		levelSelectionBackground = (CCSprite *)[selection11 getChildByTag:2511];
        level = level + 210;
	}
	if (page == 12) {
		levelSelectionBackground = (CCSprite *)[selection12 getChildByTag:2512];
        level = level + 231;
	}
	if (page == 13) {
		levelSelectionBackground = (CCSprite *)[selection13 getChildByTag:2513];
        level = level + 252;
	}
	if (page == 14) {
		levelSelectionBackground = (CCSprite *)[selection14 getChildByTag:2514];
        level = level + 273;
	}
	if (page == 15) {
		levelSelectionBackground = (CCSprite *)[selection15 getChildByTag:2515];
        level = level + 294;
	}
    
	NSString *levelStr = [NSString stringWithFormat:@"%d",level];
	CCLabelTTF *commentShadow = [CCLabelTTF labelWithString:levelStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize];
	commentShadow.position = [self convertPoint:ccp(x+2, y-2)];
	commentShadow.color = ccc3(0,0,0);
	[levelSelectionBackground addChild:commentShadow z:3];
	CCLabelTTF *commentLabel = [CCLabelTTF labelWithString:levelStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize];
	commentLabel.position = [self convertPoint:ccp(x, y)];
	commentLabel.color = ccc3(255,255,255);
	[levelSelectionBackground addChild:commentLabel z:3];
}

-(void) buildSelectionPage: (int)page {
    
    int x1, y1, fontSize1, yRow1, yRow2, yRow3;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		fontSize1 = 17;
		x1 = 400;
		y1 = 100;
		yRow1 = 462;
		yRow2 = 322;
		yRow3 = 182;
	}
	else {
		fontSize1 = 32;
		x1 = 800;
		y1 = 200;
		yRow1 = 432;
		yRow2 = 292;
		yRow3 = 152;
	}
    
	CCSprite *levelBackdrop;
	
	// Add the selection background
	CCSprite *levelSelectionBackground = [CCSprite spriteWithSpriteFrameName:@"levelSelectionBackground.png"];
	levelSelectionBackground.scale = .1;
	levelSelectionBackground.opacity = 235;
	id scaleUp = [CCScaleTo actionWithDuration:.2 scale:1.15];
	id scaleDown = [CCScaleTo actionWithDuration:.1 scale:1];
	[levelSelectionBackground runAction:[CCSequence actions:scaleUp, scaleDown, nil]];
    
    if (page == 1) {
        offset = 0;
        [selection1 addChild:levelSelectionBackground z:3 tag:2501];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 2) {
        offset = 21;
        [selection2 addChild:levelSelectionBackground z:3 tag:2502];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 3) {
        offset = 42;
        [selection3 addChild:levelSelectionBackground z:3 tag:2503];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 4) {
        offset = 63;
        [selection4 addChild:levelSelectionBackground z:3 tag:2504];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 5) {
        offset = 84;
        [selection5 addChild:levelSelectionBackground z:3 tag:2505];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    
    // Add these pages for larger packs
    else if (page == 6) {
        offset = 105;
        [selection6 addChild:levelSelectionBackground z:3 tag:2506];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 7) {
        offset = 126;
        [selection7 addChild:levelSelectionBackground z:3 tag:2507];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 8) {
        offset = 147;
        [selection8 addChild:levelSelectionBackground z:3 tag:2508];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 9) {
        offset = 168;
        [selection9 addChild:levelSelectionBackground z:3 tag:2509];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 10) {
        offset = 189;
        [selection10 addChild:levelSelectionBackground z:3 tag:2510];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 11) {
        offset = 210;
        [selection11 addChild:levelSelectionBackground z:3 tag:2511];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 12) {
        offset = 231;
        [selection12 addChild:levelSelectionBackground z:3 tag:2512];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 13) {
        offset = 252;
        [selection13 addChild:levelSelectionBackground z:3 tag:2513];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 14) {
        offset = 273;
        [selection14 addChild:levelSelectionBackground z:3 tag:2514];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    else if (page == 15) {
        offset = 294;
        [selection15 addChild:levelSelectionBackground z:3 tag:2515];
        levelSelectionBackground.position =  ccp(screenSize.width/2, screenSize.height/2 );
    }
    
	// Add the label at the top
	NSString *commentStr = [NSString stringWithString:@"Select the level where you would like to begin:"];
	CCLabelTTF *commentLabel = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentLabel.color = ccc3(0,0,0);
	[levelSelectionBackground addChild:commentLabel z:1];
	CCLabelTTF *commentShadow = [CCLabelTTF labelWithString:commentStr dimensions:CGSizeMake(x1,y1) alignment:UITextAlignmentCenter fontName:@"ArialRoundedMTBold" fontSize:fontSize1];
	commentShadow.color = ccc3(255,255,255);
	[levelSelectionBackground addChild:commentShadow z:1];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int xOffset, xOffset2;
    if (screenBounds.size.height == 568) { // iPhone 5
        xOffset = 50;
    } else {
        xOffset = 0;
    }
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        xOffset2 = 0;
		commentLabel.position = ccp(screenSize.width/2-xOffset, 240);
		commentShadow.position = ccp(screenSize.width/2-xOffset+1, 240-1);
	}
	else {
        xOffset2 = 40;
		commentLabel.position = ccp(450, 430);
		commentShadow.position = ccp(450+1, 430-1);
	}
    
    // Row 1
	if (highestLevel >= (0 + offset)) {
		[self addLevelNumber:102+xOffset2 y:405 level:1 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(102+xOffset2,yRow1)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1001];
	
	if (highestLevel >= (1 + offset)) {
		[self addLevelNumber:207+xOffset2 y:405 level:2 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(207+xOffset2,yRow1)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1002]; 
	
	if (highestLevel >= (2 + offset)) {
		[self addLevelNumber:312+xOffset2 y:405 level:3 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(312+xOffset2,yRow1)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1003]; 
	
	if (highestLevel >= (3 + offset)) {
		[self addLevelNumber:417+xOffset2 y:405 level:4 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(417+xOffset2,yRow1)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1004]; 
	
	if (highestLevel >= (4 + offset)) {
		[self addLevelNumber:522+xOffset2 y:405 level:5 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(522+xOffset2,yRow1)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1005]; 
	
	if (highestLevel >= (5 + offset)) {
		[self addLevelNumber:627+xOffset2 y:405 level:6 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(627+xOffset2,yRow1)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1006]; 
	
	if (highestLevel >= (6 + offset)) {
		[self addLevelNumber:732+xOffset2 y:405 level:7 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(732+xOffset2,yRow1)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1007]; 
	
	// Row 2
	if (highestLevel >= (7 + offset)) {
		[self addLevelNumber:102+xOffset2 y:265 level:8 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(102+xOffset2,yRow2)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1008]; 
	
	if (highestLevel >= (8 + offset)) {
		[self addLevelNumber:207+xOffset2 y:265 level:9 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(207+xOffset2,yRow2)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1009]; 
	
	if (highestLevel >= (9 + offset)) {
		[self addLevelNumber:312+xOffset2 y:265 level:10 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(312+xOffset2,yRow2)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1010]; 
	
	if (highestLevel >= (10 + offset)) {
		[self addLevelNumber:417+xOffset2 y:265 level:11 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(417+xOffset2,yRow2)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1011]; 
	
	if (highestLevel >= (11 + offset)) {
		[self addLevelNumber:522+xOffset2 y:265 level:12 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(522+xOffset2,yRow2)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1012]; 
	
	if (highestLevel >= (12 + offset)) {
		[self addLevelNumber:627+xOffset2 y:265 level:13 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(627+xOffset2,yRow2)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1013]; 
	
	if (highestLevel >= (13 + offset)) {
		[self addLevelNumber:732+xOffset2 y:265 level:14 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(732+xOffset2,yRow2)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1014]; 
	
	// Row 3
	if (highestLevel >= (14 + offset)) {
		[self addLevelNumber:102+xOffset2 y:125 level:15 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(102+xOffset2,yRow3)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1015]; 
	
	if (highestLevel >= (15 + offset)) {
		[self addLevelNumber:207+xOffset2 y:125 level:16 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(207+xOffset2,yRow3)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1016]; 
	
	if (highestLevel >= (16 + offset)) {
		[self addLevelNumber:312+xOffset2 y:125 level:17 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(312+xOffset2,yRow3)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1017]; 
	
	if (highestLevel >= (17 + offset)) {
		[self addLevelNumber:417+xOffset2 y:125 level:18 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(417+xOffset2,yRow3)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1018]; 
	
	if (highestLevel >= (18 + offset)) {
		[self addLevelNumber:522+xOffset2 y:125 level:19 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(522+xOffset2,yRow3)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1019]; 
	
	if (highestLevel >= (19 + offset)) {
		[self addLevelNumber:627+xOffset2 y:125 level:20 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(627+xOffset2,yRow3)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1020]; 
	
	if (highestLevel >= (20 + offset)) {
		[self addLevelNumber:732+xOffset2 y:125 level:21 page:page];
		levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdrop.png"];}
	else {levelBackdrop = [CCSprite spriteWithSpriteFrameName:@"levelBackdropLock.png"];}
	levelBackdrop.position = [self convertPoint:ccp(732+xOffset2,yRow3)];
	[levelSelectionBackground addChild:levelBackdrop z:1 tag:1021]; 
}

-(void) levelSelection  {
	
    // Build the selection pages
    
    // Build page 1
    [self buildSelectionPage:1];
    
    // Build page 2
    [self buildSelectionPage:2];
    
    // Build page 3
    [self buildSelectionPage:3];
    
    // Build page 4
    [self buildSelectionPage:4];
    
    // Build page 5
    [self buildSelectionPage:5];
    
    // Build extra pages for Mega Pack #1
    if (menuSelectionNo == 12) {
        
        // Build page 6
        [self buildSelectionPage:6];
        
        // Build page 7
        [self buildSelectionPage:7];
        
        // Build page 8
        [self buildSelectionPage:8];
        
        // Build page 9
        [self buildSelectionPage:9];
        
        // Build page 10
        [self buildSelectionPage:10];
        
        // Build page 11
        [self buildSelectionPage:11];
        
        // Build page 12
        [self buildSelectionPage:12];
        
        // Build page 13
        [self buildSelectionPage:13];
        
        // Build page 14
        [self buildSelectionPage:14];
        
        // Build page 15
        [self buildSelectionPage:15];
        
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
        
        CCScrollLayer *scroller;
        if (menuSelectionNo != 12) {
            scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: selection1,selection2,selection3,selection4,selection5,nil] widthOffset: 0];
        }
        else {
            scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: selection1,selection2,selection3,selection4,selection5,selection6,selection7,selection8,selection9,selection10,selection11,selection12,selection13,selection14,selection15,nil] widthOffset: 0];
        }
        
        // finally add the scroller to your scene
        [self addChild:scroller z:2 tag:9999];
        
        // Retrieve and set the current page
        int currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"current_popper_page"];
        [scroller selectPage:currentPage];
    }
    else {
        // now create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages)
        
        CCScrollLayer *scroller;
        if (menuSelectionNo != 12) {
            scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: selection1,selection2,selection3,selection4,selection5,nil] widthOffset: 50];
        }
        else {
            scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: selection1,selection2,selection3,selection4,selection5,selection6,selection7,selection8,selection9,selection10,selection11,selection12,selection13,selection14,selection15,nil] widthOffset: 50];
        }
        
        // finally add the scroller to your scene
        [self addChild:scroller z:2 tag:9999];
        
        // Retrieve and set the current page
        int currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"current_popper_page"];
        [scroller selectPage:currentPage];
    }
    
    // Add the arrow to return to the menu 
    CCSprite *leftArrow = [CCSprite spriteWithSpriteFrameName:@"warehouseArrowLeft.png"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        leftArrow.position = ccp(screenSize.width/2-192,30);
    }
    else {
        leftArrow.position = [self convertPoint:ccp(100,55)];
    }
    [self addChild:leftArrow z:3 tag:2031];
}

-(void) levelSelectionTouch: (CGPoint)location {
	
	CGRect leftArrow, rightArrow;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		CCSprite *levelSelectionBackground = (CCSprite *)[self getChildByTag:2500];
		CCSprite *lArrow = (CCSprite *)[levelSelectionBackground getChildByTag:2001];
		CCSprite *rArrow = (CCSprite *)[levelSelectionBackground getChildByTag:2002];
		
		leftArrow = [lArrow boundingBox]; 	
		rightArrow = [rArrow boundingBox]; 	
	}
	else {
		leftArrow = CGRectMake(150, 110, 90, 90);
		rightArrow = CGRectMake(784, 110, 90, 90);
	}
    
	BOOL levelSelected = NO;
    
    CCScrollLayer *scroller = (CCScrollLayer *)[self getChildByTag:9999];
    if (scroller.currentScreen == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"current_popper_page"];
        offset = 0;
        levelSelectionPage = 1;
    }
    else if (scroller.currentScreen == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"current_popper_page"];
        offset = 21;
        levelSelectionPage = 2;
    }
    else if (scroller.currentScreen == 2) {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"current_popper_page"];
        offset = 42;
        levelSelectionPage = 3;
    }
    else if (scroller.currentScreen == 3) {
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"current_popper_page"];
        offset = 63;
        levelSelectionPage = 4;
    }
    else if (scroller.currentScreen == 4) {
        [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"current_popper_page"];
        offset = 84;
        levelSelectionPage = 5;
    }
    else if (scroller.currentScreen == 5) {
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"current_popper_page"];
        offset = 105;
        levelSelectionPage = 6;
    }
    else if (scroller.currentScreen == 6) {
        [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"current_popper_page"];
        offset = 126;
        levelSelectionPage = 7;
    }
    else if (scroller.currentScreen == 7) {
        [[NSUserDefaults standardUserDefaults] setInteger:7 forKey:@"current_popper_page"];
        offset = 147;
        levelSelectionPage = 8;
    }
    else if (scroller.currentScreen == 8) {
        [[NSUserDefaults standardUserDefaults] setInteger:8 forKey:@"current_popper_page"];
        offset = 168;
        levelSelectionPage = 9;
    }
    else if (scroller.currentScreen == 9) {
        [[NSUserDefaults standardUserDefaults] setInteger:9 forKey:@"current_popper_page"];
        offset = 189;
        levelSelectionPage = 10;
    }
    else if (scroller.currentScreen == 10) {
        [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"current_popper_page"];
        offset = 210;
        levelSelectionPage = 11;
    }
    else if (scroller.currentScreen == 11) {
        [[NSUserDefaults standardUserDefaults] setInteger:11 forKey:@"current_popper_page"];
        offset = 231;
        levelSelectionPage = 12;
    }
    else if (scroller.currentScreen == 12) {
        [[NSUserDefaults standardUserDefaults] setInteger:12 forKey:@"current_popper_page"];
        offset = 252;
        levelSelectionPage = 13;
    }
    else if (scroller.currentScreen == 13) {
        [[NSUserDefaults standardUserDefaults] setInteger:13 forKey:@"current_popper_page"];
        offset = 273;
        levelSelectionPage = 14;
    }
    else if (scroller.currentScreen == 14) {
        [[NSUserDefaults standardUserDefaults] setInteger:14 forKey:@"current_popper_page"];
        offset = 294;
        levelSelectionPage = 15;
    }
    
    
    if (CGRectContainsPoint(levelSelect1, location)) {
        levelCounter = 1;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect2, location)) {
        levelCounter = 2;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect3, location)) {
        levelCounter = 3;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect4, location)) {
        levelCounter = 4;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect5, location)) {
        levelCounter = 5;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect6, location)) {
        levelCounter = 6;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect7, location)) {
        levelCounter = 7;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect8, location)) {
        levelCounter = 8;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect9, location)) {
        levelCounter = 9;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect10, location)) {
        levelCounter = 10;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect11, location)) {
        levelCounter = 11;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect12, location)) {
        levelCounter = 12;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect13, location)) {
        levelCounter = 13;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect14, location)) {
        levelCounter = 14;
        levelSelected = YES;
    }	
    if (CGRectContainsPoint(levelSelect15, location)) {
        levelCounter = 15;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect16, location)) {
        levelCounter = 16;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect17, location)) {
        levelCounter = 17;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect18, location)) {
        levelCounter = 18;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect19, location)) {
        levelCounter = 19;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect20, location)) {
        levelCounter = 20;
        levelSelected = YES;
    }
    if (CGRectContainsPoint(levelSelect21, location)) {
        levelCounter = 21;
        levelSelected = YES;
    }	
	
	if (levelSelected == YES) {
        
		// Only allow the user to click if it is an unlocked level
		if ((levelCounter+offset) <= (highestLevel+1)) {
			
			if (playSound==YES) {[[SimpleAudioEngine sharedEngine] playEffect:@"Pops 01.mp3" pitch:1.0 pan:1.0 gain:5.0];}
			selectLevel = NO;
			
			// Save the current level
			[[NSUserDefaults standardUserDefaults] setInteger:levelCounter+offset forKey:@"popper_current_level"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
            // Display new level 
			[self expandSpriteEffect:1];
		}
	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    touchMoved = NO;
    
	for (UITouch *touch in touches) { //iterate through all the touches currently on the device
		CGPoint location = [touch locationInView: [touch view]]; //location of this touch
        //		location = [[CCDirector sharedDirector] convertToGL:location];
		location = [self convertTouchToNodeSpace: touch];
		
        if (touchCheck == nil) {
            touchMoved = YES;
            touchCheck = touch;
            break;
        }
	}
}	

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	for (UITouch *touch in touches) { //iterate through all the touches currently on the device
		CGPoint location = [touch locationInView: [touch view]]; //location of this touch
        //		location = [[CCDirector sharedDirector] convertToGL:location];
		location = [self convertTouchToNodeSpace: touch];
		
        // Left Arrow Rect
        CCSprite *leftArrow = (CCSprite *)[self getChildByTag:2031];
		CGRect leftArrowRect = [leftArrow boundingBox]; 	
        
		// See if the user selected something (only if the pages weren't scrolled left or right)
		if ((selectLevel == YES) && (touchCheck != touch)) {
            [self levelSelectionTouch:location];
		}
        // If left arrow pressed, return to the menu
		if (CGRectContainsPoint(leftArrowRect, location)) {[self expandSpriteEffect:2];}
        
	}
    touchCheck = nil;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"popper-spritesheet.plist"];
	}
	else {
		[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"popper-spritesheet-hd.plist"];
	}
    
	// don't forget to call "super dealloc"
	[super dealloc];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	
}

@end
