//
//  LetsSlotMainGameNode.m
//  LetsSlot
//
//  Created by Tanut Apiwong on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LetsSlotMainGameNode.h"
#import "CCTouchDispatcher.h"
#import "GameVariables.h"
#import "GameStoreViewController.h"
#import "SimpleAudioEngine.h"
#import "SurfSlotMachineAppDelegate.h"
#import "RootViewController.h"

#define MAX_BET				5

//      Row 1				Row 2				Row 3
//
// 0	Bar					Orange				Cherry
// 1	Bell				Water Melon			Bell
// 2	Cherry				Cherry				Bar
// 3	Orange				Bar					Orange
// 4	Seven				Seven				Water Melon
// 5	Water Melon			Bell				Seven
// 6    Orange				Cherry				Cherry
// 7	Bell				Bell				Water Melon
// 8	Water Melon			Water Melon			Bell
// 9	Bell				Seven				Cherry
// 10	Orange				Cherry				Orange
// 11	Bar					Orange				Bar
// 12	Cherry				Water Melon			Bell
// 13	Seven				Orange				Orange
// 14	Cherry				Cherry				Cherry
// 15	Bar					Bar					Water Melon
// 16	Bell				Orange				Bar
// 17	Orange				Cherry				Orange
// 18	Cherry				Bar					Cherry
// 19	Water Melon			Bell				Bell
// 20	Orange				Cherry				Cherry
// 21	Cherry				Bell				Seven
// 22	Water Melon			Orange				Water Melon
// 23	Cherry				Water Melon			Orange

static int sevenIndex[3][2] = {{4, 13}, {4, 9}, {5, 21}};
static int barIndex[3][3] = {{0, 11, 15}, {3, 15, 18}, {2, 11, 16}};
static int waterMelonIndex[3][4] = {{5, 8, 19, 22}, {1, 8, 12, 23}, {4, 7, 15, 22}};
static int bellIndex[3][4] = {{1, 7, 9, 16}, {5, 7, 19, 21}, {1, 8, 12, 19}};
static int orangeIndex[3][5] = {{3, 6, 10, 17, 20}, {0, 11, 13, 16, 22}, {3, 10, 13, 17, 23}};
static int cherryIndex[3][6] = {{2, 12, 14, 18, 21, 23}, {2, 6, 10, 14, 17, 20}, {0, 6, 9, 14, 18, 20}};
static int jackpotLevel[8] = {40, 30, 25, 20, 15, 10, 2, 5};

#define SEVEN_RATE 120
#define BAR_RATE 100
#define WATERMELON_RATE 70
#define BELL_RATE 35
#define ORANGE_RATE 30
#define CHERRY_RATE 25

@implementation LetsSlotMainGameNode

+(id) scene {
	CCScene *scene = [CCScene node];
	LetsSlotMainGameNode *mainGameNode = [LetsSlotMainGameNode node];
	
	[scene addChild:mainGameNode];
	
	return scene;
}

-(id) init {
	
	// Create game store view controller
    SurfSlotMachineAppDelegate* del = (SurfSlotMachineAppDelegate*)[UIApplication sharedApplication].delegate;
    [del hideADS:NO];
    
	gameStore = [[GameStoreViewController alloc] initWithNibName:@"GameStoreViewController" bundle:nil];
	[gameStore setMainGameParent:self];
	
	
	srand(time(nil));
	
	randomTable = [[NSMutableArray arrayWithCapacity:2000] retain];
	for (int i = 0; i < 2000; i++) {
		[randomTable addObject:[NSNumber numberWithInt:rand()]];
	}
	
	// Check for win in random list
	int cnt120 = 0;
	int cnt100 = 0;
	int cnt80 = 0;
	int cnt40 = 0;
	int cnt20 = 0;
	int cnt10 = 0;
	for (int i = 0; i < [randomTable count]; i++) {
		int r = [[randomTable objectAtIndex:i] intValue];
		if (r % SEVEN_RATE == 37) cnt120++;
		else if (r % BAR_RATE == 1) cnt100++;
		else if (r % WATERMELON_RATE == 3) cnt80++;
		else if (r % BELL_RATE == 5) cnt40++;
		else if (r % ORANGE_RATE == 7) cnt20++;
		else if (r % CHERRY_RATE == 9) cnt10++;
	}
	NSLog(@"Seven Jackpot = %d : %f%%", cnt120, (float)cnt120 / [randomTable count] * 100.0f);
	NSLog(@"Bar   Jackpot = %d : %f%%", cnt100, (float)cnt100 / [randomTable count] * 100.0f);
	NSLog(@"Water Jackpot = %d : %f%%", cnt80, (float)cnt80 / [randomTable count] * 100.0f);
	NSLog(@"Bell  Jackpot = %d : %f%%", cnt40, (float)cnt40 / [randomTable count] * 100.0f);
	NSLog(@"Orang Jackpot = %d : %f%%", cnt20, (float)cnt20 / [randomTable count] * 100.0f);
	NSLog(@"Cherr Jackpot = %d : %f%%", cnt10, (float)cnt10 / [randomTable count] * 100.0f);
	
	if ((self = [super init])) {
		
		CCScene *scene = [CCScene node];
		
		srcWidth = 480.0;
		srcHeight = 800.0f;
		sceneWidth = scene.contentSize.width;
		sceneHeight = scene.contentSize.height;
		mulX = sceneWidth / srcWidth;
		mulY = sceneHeight / srcHeight;
		
		for (int i = 0; i < 3; i++) {
			stopedElems[i] = 0;
			wheelPos[i] = stopedElems[i] * 91.2f;
			wheelVel[i] = 0.0f;
			bStopRequest[i] = true;
			bFirstStop[i] = false;
		}
		
		bSpining = false;
		bBetMaxButtonState = false;
		bBetOneButtonState = false;
		bSpinButtonState = false;
		bPayoutButtonState = false;
		bShowPayoutInfo = false;
		bShowingGameStore = false;
		
		NSLog(@"Start with %d|%d|%d", stopedElems[0], stopedElems[1], stopedElems[2]);
		
		mDisplayBet = mBet;
		mDisplayCredit = mCredit;
		mDisplayPaid = mPaid;
		
		rectBetMaxButton = CGRectMake(5, 58.5, 80, 33);
		rectBetOneButton = CGRectMake(85, 58.5, 74, 33);
		rectSpinButton = CGRectMake(218.5, 58.5, 97, 33);
		rectPayoutButton = CGRectMake(88, 102, 30, 30);
		rectSoundButton = CGRectMake(3, 3, 30, 30);
		
		splashAlpha = 255;
		slashBitmap = [[CCSprite spriteWithFile:@"Splash.png"] retain];
		//slashBitmap.scaleX = mulX; slashBitmap.scaleY = mulY;
		
		machineBackgroundBitmap = [[CCSprite spriteWithFile:@"machine-bg.png"] retain];
		machineBackgroundBitmap.scaleX = mulX; machineBackgroundBitmap.scaleY = mulY;
		
		elemBarBitmap[0] = [[CCSprite spriteWithFile:@"bar.png"] retain];		
		elemBarBitmap[1] = [[CCSprite spriteWithFile:@"bar-blur.png"] retain];
		elemBarBitmap[2] = [[CCSprite spriteWithFile:@"bar-blur2.png"] retain];
		
		elemBellBitmap[0] = [[CCSprite spriteWithFile:@"bell.png"] retain];
		elemBellBitmap[1] = [[CCSprite spriteWithFile:@"bell-blur.png"] retain];
		elemBellBitmap[2] = [[CCSprite spriteWithFile:@"bell-blur2.png"] retain];
		
		elemCherryBitmap[0] = [[CCSprite spriteWithFile:@"cherry.png"] retain];
		elemCherryBitmap[1] = [[CCSprite spriteWithFile:@"cherry-blur.png"] retain];
		elemCherryBitmap[2] = [[CCSprite spriteWithFile:@"cherry-blur2.png"] retain];
		
		elemOrangeBitmap[0] = [[CCSprite spriteWithFile:@"orange.png"] retain];
		elemOrangeBitmap[1] = [[CCSprite spriteWithFile:@"orange-blur.png"] retain];
		elemOrangeBitmap[2] = [[CCSprite spriteWithFile:@"orange-blur2.png"] retain];
		
		elemSevenBitmap[0] = [[CCSprite spriteWithFile:@"seven.png"] retain];
		elemSevenBitmap[1] = [[CCSprite spriteWithFile:@"seven-blur.png"] retain];
		elemSevenBitmap[2] = [[CCSprite spriteWithFile:@"seven-blur2.png"] retain];
		
		elemWaterMelonBitmap[0] = [[CCSprite spriteWithFile:@"watermalon.png"] retain];
		elemWaterMelonBitmap[1] = [[CCSprite spriteWithFile:@"watermalon-blur.png"] retain];
		elemWaterMelonBitmap[2] = [[CCSprite spriteWithFile:@"watermalon-blur2.png"] retain];
		
		
		numberLEDsBitmap[0] = [[CCSprite spriteWithFile:@"numzero.png"] retain];
		numberLEDsBitmap[1] = [[CCSprite spriteWithFile:@"numone.png"] retain];
		numberLEDsBitmap[2] = [[CCSprite spriteWithFile:@"numtwo.png"] retain];
		numberLEDsBitmap[3] = [[CCSprite spriteWithFile:@"numthree.png"] retain];
		numberLEDsBitmap[4] = [[CCSprite spriteWithFile:@"numfour.png"] retain];
		numberLEDsBitmap[5] = [[CCSprite spriteWithFile:@"numfive.png"] retain];
		numberLEDsBitmap[6] = [[CCSprite spriteWithFile:@"numsix.png"] retain];
		numberLEDsBitmap[7] = [[CCSprite spriteWithFile:@"numseven.png"] retain];
		numberLEDsBitmap[8] = [[CCSprite spriteWithFile:@"numeight.png"] retain];
		numberLEDsBitmap[9] = [[CCSprite spriteWithFile:@"numnine.png"] retain];
		
		
		betMaxButtonBitmap = [[CCSprite spriteWithFile:@"betmaxbutton.png"] retain];
		betMaxButtonPressedBitmap = [[CCSprite spriteWithFile:@"betmaxbutton2.png"] retain];
		betOneButtonBitmap = [[CCSprite spriteWithFile:@"betonebutton.png"] retain];
		betOneButtonPressedBitmap = [[CCSprite spriteWithFile:@"betonebutton2.png"] retain];
		spinButtonBitmap = [[CCSprite spriteWithFile:@"spinbutton.png"] retain];
		spinButtonPressedBitmap = [[CCSprite spriteWithFile:@"spinbutton2.png"] retain];
		payoutButtonBitmap = [[CCSprite spriteWithFile:@"payoutbutton.png"] retain];
		payoutButtonPressedBitmap = [[CCSprite spriteWithFile:@"payoutbutton2.png"] retain];
		soundOnBitmap = [[CCSprite spriteWithFile:@"soundon.png"] retain];
		soundOffBitmap = [[CCSprite spriteWithFile:@"soundoff.png"] retain];
		
		wheelBgBitmap = [[CCSprite spriteWithFile:@"wheel-bg.png"] retain];
		wheelBgBitmap.scaleX = mulX; wheelBgBitmap.scaleY = mulY;
		
		jackpotLightBitmap = [[CCSprite spriteWithFile:@"jackpotlight.png"] retain];
		jackpotLightBitmap.scaleX = mulX; jackpotLightBitmap.scaleY = mulY;
		
		betMaxButton = [[CCSprite spriteWithTexture:[betMaxButtonBitmap texture]] retain];
		betMaxButton.scaleX = mulX; betMaxButton.scaleY = mulY;
		
		betOneButton = [[CCSprite spriteWithTexture:[betOneButtonBitmap texture]] retain];
		betOneButton.scaleX = mulX; betOneButton.scaleY = mulY;
		
		spinButton = [[CCSprite spriteWithTexture:[spinButtonBitmap texture]] retain];
		spinButton.scaleX = mulX; spinButton.scaleY = mulY;
		
		payoutButton = [[CCSprite spriteWithTexture:[payoutButtonBitmap texture]] retain];
		payoutButton.scaleX = mulX; payoutButton.scaleY = mulY;
		
		payoutInfo = [[CCSprite spriteWithFile:@"payout-info.png"] retain];
		
		if (bSoundOn)
			soundButton = [[CCSprite spriteWithTexture:[soundOnBitmap texture]] retain];
		else 
			soundButton = [[CCSprite spriteWithTexture:[soundOffBitmap texture]] retain];
		
		for (int i = 0; i < 12; i++) {
			ledDisplays[i] = [[CCSprite spriteWithTexture:[numberLEDsBitmap[0] texture]] retain];
			ledDisplays[i].scaleX = mulX; ledDisplays[i].scaleY = mulY;
			[self addChild:ledDisplays[i] z:11];
		}
		

		
		
		[self scheduleUpdate];
	
		
		slashBitmap.position = ccp(sceneWidth / 2, sceneHeight / 2);
		[self addChild:slashBitmap z:100];
		
		machineBackgroundBitmap.position = ccp(sceneWidth / 2, sceneHeight / 2);
		[self addChild:machineBackgroundBitmap z:10];
		
		wheelBgBitmap.position = ccp(sceneWidth / 2, 385 * mulY);
		[self addChild:wheelBgBitmap z:1];
		
		jackpotLightBitmap.position = ccp(sceneWidth / 2, 248);
		[self addChild:jackpotLightBitmap z:2];
		jackpotLightBitmap.visible = FALSE;
		
		for (int c = 0; c < 3; c++)
			for (int r = 0; r < 24; r++)
			{
				elemsBitmap[c][r] = [[CCSprite spriteWithTexture:[self GetTextureForWheel:c Index:r BlurLevel:0]] retain];
				elemsBitmap[c][r].scaleX = mulX; 
				elemsBitmap[c][r].scaleY = mulY;
				[self addChild:elemsBitmap[c][r] z:3];
			}
		
		betMaxButton.position = ccp(rectBetMaxButton.origin.x + (rectBetMaxButton.size.width / 2), 
									rectBetMaxButton.origin.y + (rectBetMaxButton.size.height / 2));
		[self addChild:betMaxButton z:11];
		
		betOneButton.position = ccp(rectBetOneButton.origin.x + (rectBetOneButton.size.width / 2),
									rectBetOneButton.origin.y + (rectBetOneButton.size.height / 2));
		[self addChild:betOneButton z:11];
		
		spinButton.position = ccp(rectSpinButton.origin.x + (rectSpinButton.size.width / 2), 
								  rectSpinButton.origin.y + (rectSpinButton.size.height / 2));
		[self addChild:spinButton z:11];
		
		payoutButton.position = ccp(rectPayoutButton.origin.x + (rectPayoutButton.size.width / 2),
									rectPayoutButton.origin.y + (rectPayoutButton.size.height / 2));
		[self addChild:payoutButton z:11];
		
		payoutInfo.position = ccp(163, 250);
		[self addChild:payoutInfo z:11];
		//[payoutInfo setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE}];
		
		soundButton.position = ccp(rectSoundButton.origin.x + (rectSoundButton.size.width / 2), 
								   rectSoundButton.origin.y + (rectSpinButton.size.height / 2));
		[self addChild:soundButton z:11];
		
		ledDisplays[0].position = ccp(15, 110);
		ledDisplays[1].position = ccp(27.5, 110);
		ledDisplays[2].position = ccp(41, 110);
		ledDisplays[3].position = ccp(53.5, 110);
		ledDisplays[4].position = ccp(66, 110);
		
		ledDisplays[5].position = ccp(211.5, 110);
		ledDisplays[6].position = ccp(224.5, 110);
		
		ledDisplays[7].position = ccp(253, 110);
		ledDisplays[8].position = ccp(266, 110);
		ledDisplays[9].position = ccp(279, 110);
		ledDisplays[10].position = ccp(292.5, 110);
		ledDisplays[11].position = ccp(305, 110);
		
		
		//Handle touch event
		self.isTouchEnabled = YES;
		
		//Handle accelerometer event
		self.isAccelerometerEnabled = YES;
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/10];
	}
	return self;
}

-(CCTexture2D*) GetTextureForWheel:(int) wheel Index:(int) index BlurLevel:(int) blurLevel {
	

	if (blurLevel > 2) {
		blurLevel = 2;
	}
	
	if (wheel == 0) {
		switch (index) {
			case 0:
				return [elemBarBitmap[blurLevel] texture];
			case 1:
				return [elemBellBitmap[blurLevel] texture];
			case 2:
				return [elemCherryBitmap[blurLevel] texture];
			case 3:
				return [elemOrangeBitmap[blurLevel] texture];
			case 4:
				return [elemSevenBitmap[blurLevel] texture];
			case 5:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 6:
				return [elemOrangeBitmap[blurLevel] texture];
			case 7:
				return [elemBellBitmap[blurLevel] texture];
			case 8:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 9:
				return [elemBellBitmap[blurLevel] texture];
			case 10:
				return [elemOrangeBitmap[blurLevel] texture];
			case 11:
				return [elemBarBitmap[blurLevel] texture];
			case 12:
				return [elemCherryBitmap[blurLevel] texture];
			case 13:
				return [elemSevenBitmap[blurLevel] texture];
			case 14:
				return [elemCherryBitmap[blurLevel] texture];
			case 15:
				return [elemBarBitmap[blurLevel] texture];
			case 16:
				return [elemBellBitmap[blurLevel] texture];
			case 17:
				return [elemOrangeBitmap[blurLevel] texture];
			case 18:
				return [elemCherryBitmap[blurLevel] texture];
			case 19:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 20:
				return [elemOrangeBitmap[blurLevel] texture];
			case 21:
				return [elemCherryBitmap[blurLevel] texture];
			case 22:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 23:
				return [elemCherryBitmap[blurLevel] texture];
			default:
				break;
		}
	} else if (wheel == 1) {
		switch (index) {
			case 0:
				return [elemOrangeBitmap[blurLevel] texture];
			case 1:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 2:
				return [elemCherryBitmap[blurLevel] texture];
			case 3:
				return [elemBarBitmap[blurLevel] texture];
			case 4:
				return [elemSevenBitmap[blurLevel] texture];
			case 5:
				return [elemBellBitmap[blurLevel] texture];
			case 6:
				return [elemCherryBitmap[blurLevel] texture];
			case 7:
				return [elemBellBitmap[blurLevel] texture];
			case 8:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 9:
				return [elemSevenBitmap[blurLevel] texture];
			case 10:
				return [elemCherryBitmap[blurLevel] texture];
			case 11:
				return [elemOrangeBitmap[blurLevel] texture];
			case 12:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 13:
				return [elemOrangeBitmap[blurLevel] texture];
			case 14:
				return [elemCherryBitmap[blurLevel] texture];
			case 15:
				return [elemBarBitmap[blurLevel] texture];
			case 16:
				return [elemOrangeBitmap[blurLevel] texture];
			case 17:
				return [elemCherryBitmap[blurLevel] texture];
			case 18:
				return [elemBarBitmap[blurLevel] texture];
			case 19:
				return [elemBellBitmap[blurLevel] texture];
			case 20:
				return [elemCherryBitmap[blurLevel] texture];
			case 21:
				return [elemBellBitmap[blurLevel] texture];
			case 22:
				return [elemOrangeBitmap[blurLevel] texture];
			case 23:
				return [elemWaterMelonBitmap[blurLevel] texture];
			default:
				break;
		}
	} else /*if (wheel == 2)*/ {
		switch (index) {
			case 0:
				return [elemCherryBitmap[blurLevel] texture];
			case 1:
				return [elemBellBitmap[blurLevel] texture];
			case 2:
				return [elemBarBitmap[blurLevel] texture];
			case 3:
				return [elemOrangeBitmap[blurLevel] texture];
			case 4:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 5:
				return [elemSevenBitmap[blurLevel] texture];
			case 6:
				return [elemCherryBitmap[blurLevel] texture];
			case 7:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 8:
				return [elemBellBitmap[blurLevel] texture];
			case 9:
				return [elemCherryBitmap[blurLevel] texture];
			case 10:
				return [elemOrangeBitmap[blurLevel] texture];
			case 11:
				return [elemBarBitmap[blurLevel] texture];
			case 12:
				return [elemBellBitmap[blurLevel] texture];
			case 13:
				return [elemOrangeBitmap[blurLevel] texture];
			case 14:
				return [elemCherryBitmap[blurLevel] texture];
			case 15:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 16:
				return [elemBarBitmap[blurLevel] texture];
			case 17:
				return [elemOrangeBitmap[blurLevel] texture];
			case 18:
				return [elemCherryBitmap[blurLevel] texture];
			case 19:
				return [elemBellBitmap[blurLevel] texture];
			case 20:
				return [elemCherryBitmap[blurLevel] texture];
			case 21:
				return [elemSevenBitmap[blurLevel] texture];
			case 22:
				return [elemWaterMelonBitmap[blurLevel] texture];
			case 23:
				return [elemOrangeBitmap[blurLevel] texture];
			default:
				break;
		}
	}	
	return nil;
}

int GetWinMultiplyValue(int *a) {
	/*
	if (a == 4 && b == 4 && c == 5)
		return 500;
	else if (a == 0 && b == 3 && c == 2)
		return 100;
	else if (a == 5 && b == 1 && c == 4)
		return 50;
	else if (a == 1 && b == 5 && c == 1)
		return 20;
	else if (a == 3 && b == 0 && c == 3)
		return 15;
	else if (a == 2 && b == 2 && c == 0)
		return 10;
	
	int cherryCnt = 0;
	if (a == 2)
		cherryCnt++;
	if (b == 2)
		cherryCnt++;
	if (c == 0)
		cherryCnt++;
	
	if (cherryCnt == 2)
		return 5;
	else if (cherryCnt == 1)
		return 2;
	*/
	
	bool bFoundJackpot[6][3];
	for (int i = 0; i < 6; i++)
		for (int c = 0; c < 3; c++)
			bFoundJackpot[i][c] = FALSE;
	
	for (int i = 0; i < 6; i++) {
		
		for (int c = 0; c < 3; c++) {
			if (i < 2 && a[c] == sevenIndex[c][i])
				bFoundJackpot[0][c] |= TRUE;
			else if (i < 3 && a[c] == barIndex[c][i])
				bFoundJackpot[1][c] |= TRUE;
			else if (i < 4 && a[c] == waterMelonIndex[c][i])
				bFoundJackpot[2][c] |= TRUE;
			else if (i < 4 && a[c] == bellIndex[c][i])
				bFoundJackpot[3][c] |= TRUE;
			else if (i < 5 && a[c] == orangeIndex[c][i])
				bFoundJackpot[4][c] |= TRUE;
			else if (i < 6 && a[c] == cherryIndex[c][i])
				bFoundJackpot[5][c] |= TRUE;
		}
	}
	
	for (int i = 0; i < 6; i++) {
		bool isJackpot = true;
		for (int c = 0; c < 3; c++) {
			isJackpot &= bFoundJackpot[i][c];
		}
		if (isJackpot) {
			return jackpotLevel[i];
		} else if (i == 5) { // Some cherry
			int cherryCnt = 0;
			if (bFoundJackpot[i][0])
				cherryCnt++;
			
			if (bFoundJackpot[i][1])
				cherryCnt++;
			
			if (bFoundJackpot[i][2])
				cherryCnt++;
			
			if (cherryCnt > 0)
				return jackpotLevel[5 + cherryCnt];
		}
	}
	
	return 0;
}


bool ChangeValueToDemand(int *current, int demand) {
	
	int diff = demand - *current;
	int diff2 = 0;
	
	if (diff >= 1000)
		diff2 = 100;
	else if (diff <= -1000)
		diff2 = -100;
	else if (diff >= 100)
		diff2 = 10;
	else if (diff <= -100)
		diff2 = -10;
	else if (diff >= 1)
		diff2 = 1;
	else if (diff <= -1)
		diff2 = -1;
	
	*current += diff2;
	
	return (diff2 != 0);
}


-(void) SpinToA:(int) a B:(int) b C:(int) c
{
	/*
	static float tmpVel = 150.5f;
	
	NSLog(@"Val = %f", tmpVel);
	
	for (int i = 0; i < 3; i++) {
		stopedElems[i] = 0;
		wheelPos[i] = stopedElems[i] * 91.2f;
		
		wheelVel[i] = tmpVel;
		bStopRequest[i] = NO;
		bFirstStop[i] = NO;
	}
	tmpVel += 10;
	*/
	
	NSLog(@"Spin to %d|%d|%d", a, b, c);
	
	
	static float valOffset[24] = 
	{
		161, 141, 120, 121, 100, 101, 80, 81, 190, 61, 170, 150, 150.5,
		130, 131, 110, 111, 90, 91, 70, 71, 180, 51, 160.5
	};
	
	//static int tmp = 21;
	
	int offset[3];
	
	offset[0] = a - stopedElems[0];
	offset[1] = b - stopedElems[1];
	offset[2] = c - stopedElems[2];
	
	for (int i = 0; i < 3; i++) {
	
		if (offset[i] < 0)
			offset[i] += 24;
		
		wheelVel[i] = valOffset[offset[i]];
		
		bStopRequest[i] = false;
		bFirstStop[i] = false;
	}
	
	//NSLog(@"Offset %d|%d|%d", offset[0], offset[1], offset[2]);
	
}

-(void)accelerometer:(UIAccelerometer*) accelerometer didAccelerate:(UIAcceleration*)acceleration {
	//static int i = 0;
	
	//accelerationY[i] = acceleration.y * 20.0f;
	//i++;
	//if (i > 2)
	//	i = 0;
	accelerationY[0] = acceleration.y * 20.0f;
	accelerationY[1] = acceleration.y * 20.0f;
	accelerationY[2] = acceleration.y * 20.0f;
	
}


-(void) update:(ccTime) dt 
{
	
	static float allElemHeight = 0;
	static float deltaToEndPos[3];
	static float targetEndPos[3];
	static float endingVel[3];
	static bool bFirstEndRolling = false;
	static int jackpotLightBlinkCount = 0;
	
	if (allElemHeight == 0)
		allElemHeight = 24 * 91.2f;
	
	if (splashAlpha > 0) {
		splashAlpha -= 5;
		slashBitmap.opacity = splashAlpha;
	} else if (slashBitmap.visible) {
		//slashBitmap.visible = FALSE;
	}
	
	bool bHasPlaySpinSound = false;
	static float lastTimePlaySpinSound = 0.0f;
	lastTimePlaySpinSound += dt;
	if (lastTimePlaySpinSound < 0.5f) {
		bHasPlaySpinSound = TRUE;
	} else {
		lastTimePlaySpinSound -= 0.5f;
	}

	
	for (int i = 0; i < 3; i++) {
		
		if (wheelVel[i] > 10.0f) {
			
			wheelPos[i] += wheelVel[i];
			
			// Float modulate
			wheelPos[i] = wheelPos[i] - ((int) (wheelPos[i] / allElemHeight)
										 * allElemHeight);
			
			wheelVel[i] /= 1.01f;
			
			bFirstEndRolling = false;
			bSpining = true;
			
			if (!bHasPlaySpinSound) {
				
				if (bSoundOn) {
					[[SimpleAudioEngine sharedEngine] playEffect:@"spin.wav"];
				}
				bHasPlaySpinSound = TRUE;
			}
			
		} else {
			
			if (!bStopRequest[i]) {
				
				wheelVel[i] = 0.0f;
				
				stopedElems[i] = (int) ((wheelPos[i] + 76) / 91.2f);
				deltaToEndPos[i] = stopedElems[i] * 91.2f - wheelPos[i];
				targetEndPos[i] = stopedElems[i] * 91.2f;
				
				endingVel[i] = 10.0f;
				
				bStopRequest[i] = true;
				
//				if (pWheelStopPlayer->GetState() == PLAYER_STATE_PLAYING)
//					pWheelStopPlayer->Stop();
//				pWheelStopPlayer->Play();
				
				if (bSoundOn) {
					[[SimpleAudioEngine sharedEngine] playEffect:@"stop.wav"];
				}
				
				
			} else {
				
				if (wheelPos[i] < targetEndPos[i])
					wheelPos[i] += endingVel[i];
				else
					wheelPos[i] -= endingVel[i];
				
				if (endingVel[i] < 1.0f) {
					
					endingVel[i] = 0.0f;
					
				} else {
					
					endingVel[i] /= 1.1f;
					
					if (!bHasPlaySpinSound) {
						if (bSoundOn) {
							[[SimpleAudioEngine sharedEngine] playEffect:@"spin.wav"];
						}
						bHasPlaySpinSound = TRUE;
					}
					
					//					if (pWheelSpinPlayer->GetState() == PLAYER_STATE_ENDOFCLIP
					//							|| pWheelSpinPlayer->GetState()
					//									== PLAYER_STATE_STOPPED) {
					//						pWheelSpinPlayer->Play();
					//					}
				}
			}
		}
		
		// Add accelerometer effect on wheels
		accelerationYBuffer[i] = (accelerationY[i] - accelerationYBuffer[i]) / 1.6f;
	}
	
	bool bEndRolling = true;
	for (int i = 0; i < 3; i++) {
		bEndRolling = bEndRolling && bStopRequest[i] && (endingVel[i] == 0.0f);
		
		if (bStopRequest[i] && (endingVel[i] == 0.0f) && (bFirstStop[i]
														  == false)) {
			bFirstStop[i] = true;
			//			if (pWheelStopPlayer->GetState() != PLAYER_STATE_PLAYING)
			//				pWheelStopPlayer->Play();
//			if (pWheelSpinPlayer->IsLooping() && pWheelSpinPlayer->GetState()
//				!= PLAYER_STATE_ENDOFCLIP && pWheelSpinPlayer->GetState()
//				== PLAYER_STATE_PLAYING) {
//				pWheelSpinPlayer->SetLooping(false);
//				pWheelSpinPlayer->Stop();
//			}
		}
		
	}
	if (bEndRolling) {
		
		if (!bFirstEndRolling) {
			
			// Modulate stop element at last stop
			for (int i = 0; i < 3; i++)
				stopedElems[i] %= 24;
			
			NSLog(@"Stop at %d|%d|%d", stopedElems[0], stopedElems[1], stopedElems[2]);
			// Check win multiplier
			int winMul = GetWinMultiplyValue(stopedElems);
			if (winMul > 0) {
				
				// Play Win sound!!
//				pWinPlayer->Play();
				if (bSoundOn) {
					[[SimpleAudioEngine sharedEngine] playEffect:@"win.wav"];
				}
				
				int winValue = mBet * winMul;
				
				jackpotLightBlinkCount = winValue;
				mPaid += winValue;
                
                SurfSlotMachineAppDelegate* del = (SurfSlotMachineAppDelegate*)[UIApplication sharedApplication].delegate;
                RootViewController *rootViewController = del.viewController;
                [rootViewController submitScore:mPaid];

			}
			mBet = 0;
			
			bFirstEndRolling = true;
			bSpining = false;
		}
		//rand();
	}
	
	bJackpotLightOn = (jackpotLightBlinkCount > 0) && (jackpotLightBlinkCount
													   % 2 == 0);
	if (jackpotLightBlinkCount > 0)
		jackpotLightBlinkCount--;
	
	bool valueChange = false;
	/*valueChange |= */ChangeValueToDemand(&mDisplayBet, mBet);
	/*valueChange |= */ChangeValueToDemand(&mDisplayCredit, mCredit);
	valueChange |= ChangeValueToDemand(&mDisplayPaid, mPaid);
	if (valueChange) {
		if (bSoundOn) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"ledchange.wav"];
		}
//		if (pWheelSpinPlayer->GetState() != PLAYER_STATE_PLAYING) {
//			pWheelSpinPlayer->SetLooping(true);
//			pWheelSpinPlayer->Play();
//		}
	} else {
		//if (!bSpining && pWheelSpinPlayer->GetState() == PLAYER_STATE_PLAYING)
		//	pWheelSpinPlayer->Stop();
	}
	
	// Decrease jackpot light duration when display paid animation stopped.
	if (mDisplayPaid == mPaid && jackpotLightBlinkCount > 50)
		jackpotLightBlinkCount = 50;
	
	
	// Jackpot Light
	jackpotLightBitmap.visible = bJackpotLightOn;
	
	// Payout button blink
	static float halfSecTimer = 0.0f;
	static float infoOpacity = 0.0f;
	halfSecTimer += dt;
	if (halfSecTimer >= 0.2f) {
		halfSecTimer = 0.0f;
		bPayoutBlinkState = !bPayoutBlinkState;
	}
	if (mBet == 0 && mCredit == 0 && !valueChange) {
		infoOpacity += dt * 255.0f;
		if (infoOpacity > 255)
			infoOpacity = 255;

		bShowPayoutInfo = YES;
		
	} else {
		infoOpacity -= dt * 255.0f;
		if (infoOpacity < 0)
			infoOpacity = 0;
		
		bPayoutBlinkState = NO;
	}
	payoutInfo.opacity = infoOpacity;
	
	
	// Slot elements
	float posY = 0;
	int elemId = 0;
	
	for (int i = 0; i < 24; i++) {
		for (int c = 0; c < 3; c++) {
			elemsBitmap[c][i].visible = NO;
		}
	}
	
	for (int i = -1; i < 26; i++) {
		if (i < 0)
			elemId = 24 + i;
		else if (i >= 24)
			elemId = i - 24;
		else
			elemId = i;
		
		for (int c = 0; c < 3; c++) {
			
			posY = 248 + (i * 91.2f) - wheelPos[c];
			
			
			if (posY >= 20 && posY <= 480) {
				elemsBitmap[c][elemId].visible = YES;
				elemsBitmap[c][elemId].position = ccp(58.6f + (101.3f * c), posY + accelerationYBuffer[c]);
				
				if (wheelVel[c] > 60.0) {
					[elemsBitmap[c][elemId] setTexture:[self GetTextureForWheel:c Index:elemId BlurLevel:2]];
				} else if (wheelVel[c] > 15.0) {
					[elemsBitmap[c][elemId] setTexture:[self GetTextureForWheel:c Index:elemId BlurLevel:1]];
				} else {
					[elemsBitmap[c][elemId] setTexture:[self GetTextureForWheel:c Index:elemId BlurLevel:0]];
				}
			}
		}
	}
	
	// Bet max button
	if (bBetMaxButtonState)
		[betMaxButton setTexture:[betMaxButtonPressedBitmap texture]];
	else
		[betMaxButton setTexture:[betMaxButtonBitmap texture]];
	
	// Bet one button
	if (bBetOneButtonState)
		[betOneButton setTexture:[betOneButtonPressedBitmap texture]];
	else
		[betOneButton setTexture:[betOneButtonBitmap texture]];
	
	// Spin button
	if (bSpinButtonState)
		[spinButton setTexture:[spinButtonPressedBitmap texture]];
	else
		[spinButton setTexture:[spinButtonBitmap texture]];
	
	// Payout button
	if (bPayoutButtonState || bPayoutBlinkState)
		[payoutButton setTexture:[payoutButtonPressedBitmap texture]];
	else
		[payoutButton setTexture:[payoutButtonBitmap texture]];
	
	
	// Sound on/off
	if (bSoundOn)
		[soundButton setTexture:[soundOnBitmap texture]];
	else 
		[soundButton setTexture:[soundOffBitmap texture]];
	
	// Paid LEDs display
	int div = 10000;
	for (int i = 0; i < 5; i++) {
		int x = (mDisplayPaid / div) % 10;
		[ledDisplays[i] setTexture:[numberLEDsBitmap[x] texture]];
		div /= 10;
	}
	
	// Bet LEDs display
	div = 10;
	for (int i = 0; i < 2; i++) {
		int x = (mDisplayBet / div) % 10;
		[ledDisplays[i + 5] setTexture:[numberLEDsBitmap[x] texture]];
		div /= 10;
	}
	
	// Credit LEDs display
	div = 10000;
	for (int i = 0; i < 5; i++) {
		int x = (mDisplayCredit / div) % 10;
		[ledDisplays[i + 7] setTexture:[numberLEDsBitmap[x] texture]];
		div /= 10;
	}
}


-(void) delloc {
	
	[gameStore release];
	
	[randomTable release];
	
	[slashBitmap release];
	[machineBackgroundBitmap release];
	
	for (int i = 0; i < 3; i++) {
		[elemBarBitmap[i] release];
		[elemBellBitmap[i] release];
		[elemCherryBitmap[i] release];
		[elemOrangeBitmap[i] release];
		[elemSevenBitmap[i] release];
		[elemWaterMelonBitmap[i] release];
	}
	
	for (int i = 0; i < 3; i++)
		for (int c = 0; c < 24; c++)
			[elemsBitmap[i][c] release];
	
	for (int i = 0; i < 10; i++)
		[numberLEDsBitmap[i] release];
	
	[betMaxButtonBitmap release];
	[betMaxButtonPressedBitmap release];
	[betOneButtonBitmap release];
	[betOneButtonPressedBitmap release];
	[spinButtonBitmap release];
	[spinButtonPressedBitmap release];
	[payoutButtonBitmap release];
	[payoutButtonPressedBitmap release];
	[soundOnBitmap release];
	[soundOffBitmap release];
	[wheelBgBitmap release];
	[jackpotLightBitmap release];
	
	[betMaxButton release];
	[betOneButton release];
	[spinButton release];
	[payoutButton release];
	[soundButton release];
	[payoutInfo release];
	for (int i = 0; i < 12; i++) {
		[ledDisplays[i] release];
	}
	
	[super dealloc];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];

	//Ignore touch event when display game store...
	if (bShowingGameStore) {
		NSLog(@"Ignore touch while running game store");
		return;
	}
	
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint locationGl = [[CCDirector sharedDirector] convertToGL:location];

	// Sound on/off
	if (CGRectContainsPoint(rectSoundButton, locationGl))
		bSoundOn = !bSoundOn;
	
//	pWheelSpinPlayer->SetMute(!bSoundOn);
//	pWheelStopPlayer->SetMute(!bSoundOn);
//	pWinPlayer->SetMute(!bSoundOn);
//	
	if (bSpining)
		return;

	bBetMaxButtonState = CGRectContainsPoint(rectBetMaxButton, locationGl);
	bBetOneButtonState = CGRectContainsPoint(rectBetOneButton, locationGl);
	bSpinButtonState = CGRectContainsPoint(rectSpinButton, locationGl);
	bPayoutButtonState = CGRectContainsPoint(rectPayoutButton, locationGl);
	
}

-(void) ccTouchesMoved:(NSSet *) touches withEvent:(UIEvent *) event {
	/*
	if (bSpining)
		return;
	
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint locationGl = [[CCDirector sharedDirector] convertToGL:location];
	
	bBetMaxButtonState &= CGRectContainsPoint(rectBetMaxButton, locationGl);
	bBetOneButtonState &= CGRectContainsPoint(rectBetOneButton, locationGl);
	bSpinButtonState &= CGRectContainsPoint(rectSpinButton, locationGl);
	bPayoutButtonState &= CGRectContainsPoint(rectPayoutButton, locationGl);
	 */
}

-(void) ccTouchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	
	if (bSpining)
		return;
	
	if (bSpinButtonState) {
		[self SpinButtonPressed];
	} else if (bBetMaxButtonState) {
		[self BetMaxButtonPressed];
	} else if (bBetOneButtonState) {
		[self BetOneButtonPressed];
	} else if (bPayoutButtonState) {
		[self TransferPaidPressed];
	}
	
	bBetMaxButtonState = false;
	bBetOneButtonState = false;
	bSpinButtonState = false;
	bPayoutButtonState = false;
	
}


-(void) SpinButtonPressed {
	
	if (mBet <= 0) {
		return;
	}
	
	/*
	 //  Jackpot test block
	 //	static int tmp = -1;
	 //	tmp++;
	 //	if (tmp == 0)			SpinTo(4, 4, 5); // 777
	 //	else if (tmp == 1)		SpinTo(0, 3, 2); // Bar Bar Bar
	 //	else if (tmp == 2)		SpinTo(5, 1, 4); // Melon Melon Melon
	 //	else if (tmp == 3)		SpinTo(1, 5, 1); // Bell Bell Bell
	 //	else if (tmp == 4)		SpinTo(3, 0, 3); // Orange Orange Orange
	 //	else if (tmp == 5)		SpinTo(2, 2, 0); // Cherry Cherry Cherry
	 //	else 					SpinTo(rand() % 6, rand() % 6, rand() % 6);
	 //	return;
	 */
	
	if ([randomTable count] <= 0) {
		for (int i = 0; i < 2000; i++) {
			[randomTable addObject:[NSNumber numberWithInt:rand()]];
		}
	}
	
	int r = [[randomTable objectAtIndex:0] intValue];
	[randomTable removeObjectAtIndex:0];
	
	if (r % SEVEN_RATE == 37) {
		[self SpinToA:sevenIndex[0][rand() % 2] B:sevenIndex[1][rand() % 2] C:sevenIndex[2][rand() % 2]]; // 777
		NSLog(@"Spin to Seven jackpot");
	}
	else if (r % BAR_RATE == 1) {
		[self SpinToA:barIndex[0][rand() % 3] B:barIndex[1][rand() % 3] C:barIndex[2][rand() % 3]]; // Bar Bar Bar
		NSLog(@"Spin to Bar jackpot");
	}
	else if (r % WATERMELON_RATE == 3) {
		[self SpinToA:waterMelonIndex[0][rand() % 4] B:waterMelonIndex[1][rand() % 4] C:waterMelonIndex[2][rand() % 4]]; // Melon Melon Melon
		NSLog(@"Spin to Water Melon jackpot");
	}
	else if (r % BELL_RATE == 5) {
		[self SpinToA:bellIndex[0][rand() % 4] B:bellIndex[1][rand() % 4] C:bellIndex[2][rand() % 4]]; // Bell Bell Bell
		NSLog(@"Spin to Bell jackpot");
	}
	else if (r % ORANGE_RATE == 7) {
		[self SpinToA:orangeIndex[0][rand() % 5] B:orangeIndex[1][rand() % 5] C:orangeIndex[2][rand() % 5]]; // Orange Orange Orange
		NSLog(@"Spin to Orange jackpot");
	}
	else if (r % CHERRY_RATE == 9) {
		[self SpinToA:cherryIndex[0][rand() % 6] B:cherryIndex[1][rand() % 6] C:cherryIndex[2][rand() % 6]]; // Cherry Cherry Cherry
		NSLog(@"Spin to Cherry jackpot");
	}
	else if ((mPaid + mCredit < 10) && ((r % 3) < 2)) {
		if (r % 3 == 0)
			[self SpinToA:orangeIndex[0][rand() % 5] B:orangeIndex[1][rand() % 5] C:orangeIndex[2][rand() % 5]]; // Orange Orange Orange
		else if (r % 3 == 1)
			[self SpinToA:cherryIndex[0][rand() % 6] B:cherryIndex[1][rand() % 6] C:cherryIndex[2][rand() % 6]]; // Cherry Cherry Cherry
		NSLog(@"Spin to Cherry or Orange jackpot");
	}
	else if ((mPaid + mCredit) <= 0) {
		[self SpinToA:cherryIndex[0][rand() % 6] B:(rand() % 24) C:(rand() % 24)]; // Cherry Any Any
	}
	else {
		int a[3];
		bool bReRandom;
		do {
			bReRandom = false;
			a[0] = rand() % 24;
			a[1] = rand() % 24;
			a[2] = rand() % 24;
			
			int winValue = GetWinMultiplyValue(a);
			//NSLog(@"Check %d, %d, %d = %d", a[0], a[1], a[2], winValue);
			if (winValue >= jackpotLevel[5]) {
				bReRandom = true;
				//NSLog(@"Re-random!!!");
			} else if (winValue > 0) {
				NSLog(@"Here!!!!!");
				if (rand() % 10 != 7) {
					bReRandom = true;
					NSLog(@"Reject some cherry");
				}
			}
		} while (bReRandom);
		[self SpinToA:a[0] B:a[1] C:a[2]];
	}
	
	
	if (bSoundOn) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"button.wav"];
	}
//	if (pWheelSpinPlayer->GetState() == PLAYER_STATE_PLAYING)
//		pWheelSpinPlayer->Stop();
//	pWheelSpinPlayer->SetLooping(true);
//	pWheelSpinPlayer->Play();
}

-(void) BetMaxButtonPressed {
	int addBet = MAX_BET - mBet;
	
	if (addBet > mCredit)
		addBet = mCredit;
	
	mBet += addBet;
	mCredit -= addBet;
	
	if (bSoundOn) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"button.wav"];
	}
	//	if (pWheelStopPlayer->GetState() == PLAYER_STATE_PLAYING)
	//		pWheelStopPlayer->Stop();
	//	pWheelStopPlayer->Play();
}

-(void) BetOneButtonPressed {
	int addBet = 1;
	
	if (addBet > mCredit)
		addBet = mCredit;
	
	if (mBet < MAX_BET) {
		mBet += addBet;
		mCredit -= addBet;
	}
	
	if (bSoundOn) {
		[[SimpleAudioEngine sharedEngine] playEffect:@"button.wav"];
	}
	//	if (pWheelStopPlayer->GetState() == PLAYER_STATE_PLAYING)
	//		pWheelStopPlayer->Stop();
	//	pWheelStopPlayer->Play();
}

-(void) TransferPaidPressed {
	
	if (bPayoutLocked) {
		
		//Display store
		
		bShowingGameStore = true;
		
		gameStore.view.frame = CGRectMake(0.0f, srcHeight, srcWidth, srcHeight);
		[[[CCDirector sharedDirector] openGLView] addSubview:gameStore.view];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		gameStore.view.frame = CGRectMake(0.0f, 0.0f, srcWidth, srcHeight);
		[UIView commitAnimations];
		
		NSLog(@"Payout Locked!");
		
	} else {
		mCredit += mPaid;
		mPaid = 0;
	}
}

-(void) GameStoreClosed {
	bShowingGameStore = false;
	NSLog(@"Game store closed...");
}


@end