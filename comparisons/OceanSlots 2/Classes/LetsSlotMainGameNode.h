//
//  LetsSlotMainGameNode.h
//  LetsSlot
//
//  Created by Tanut Apiwong on 8/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class GameStoreViewController;

@interface LetsSlotMainGameNode : CCLayer {
	
	float sceneWidth;
	float sceneHeight;
	float srcWidth;
	float srcHeight;
	float mulX;
	float mulY;
	
	NSMutableArray *randomTable;
	
	CCSprite *slashBitmap;
	CCSprite *machineBackgroundBitmap;
	
	CCSprite *elemBarBitmap[3];
	CCSprite *elemBellBitmap[3];
	CCSprite *elemCherryBitmap[3];
	CCSprite *elemOrangeBitmap[3];
	CCSprite *elemSevenBitmap[3];
	CCSprite *elemWaterMelonBitmap[3];
		
	CCSprite *elemsBitmap[3][24];
	CCSprite *numberLEDsBitmap[10];
	CCSprite *betMaxButtonBitmap;
	CCSprite *betMaxButtonPressedBitmap;
	CCSprite *betOneButtonBitmap;
	CCSprite *betOneButtonPressedBitmap;
	CCSprite *spinButtonBitmap;
	CCSprite *spinButtonPressedBitmap;
	CCSprite *payoutButtonBitmap;
	CCSprite *payoutButtonPressedBitmap;
	CCSprite *soundOnBitmap;
	CCSprite *soundOffBitmap;
	CCSprite *wheelBgBitmap;
	CCSprite *jackpotLightBitmap;
	
	CCSprite *betMaxButton;
	CCSprite *betOneButton;
	CCSprite *spinButton;
	CCSprite *payoutButton;
	CCSprite *soundButton;
	CCSprite *ledDisplays[12];
	
	CCSprite *payoutInfo;
	
	int splashAlpha;
	float wheelPos[3];
	float wheelVel[3];
	int stopedElems[3];
	bool bStopRequest[3];
	bool bFirstStop[3];
	int mDisplayPaid;
	int mDisplayBet;
	int mDisplayCredit;
	bool bSpining;
	bool bJackpotLightOn;
	
	CGRect rectBetMaxButton;
	CGRect rectBetOneButton;
	CGRect rectSpinButton;
	CGRect rectPayoutButton;
	CGRect rectSoundButton;
	
	bool bBetMaxButtonState;
	bool bBetOneButtonState;
	bool bSpinButtonState;
	bool bPayoutButtonState;
	bool bPayoutBlinkState;
	bool bShowPayoutInfo;
	
	GameStoreViewController *gameStore;
	bool bShowingGameStore;
	
	float accelerationY[3];
	float accelerationYBuffer[3];
}

+(id) scene;

int GetWinMultiplyValue(int *a);
bool ChangeValueToDemand(int *current, int demand);

-(CCTexture2D*) GetTextureForWheel:(int) wheel Index:(int) index BlurLevel:(int) blurLevel;
-(void) SpinToA:(int) a B:(int) b C:(int) c;
-(void) update:(ccTime) dt;
-(void) SpinButtonPressed;
-(void) BetMaxButtonPressed;
-(void) BetOneButtonPressed;
-(void) TransferPaidPressed;

@end
