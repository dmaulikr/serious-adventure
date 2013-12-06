//
//  GameVariables.h
//  LetsSlot
//
//  Created by Tanut Apiwong on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

extern int mPaid;
extern int mBet;
extern int mCredit;
extern bool bSoundOn;
extern bool bPayoutLocked;

#define kPayoutUnlockProduct @"com.topgame.surf.payout"
#define STARTUP_CREDIT		200
#define KEY_PAID			@"Paid"
#define KEY_BET				@"Bet"
#define KEY_CREDIT			@"Credit"
#define KEY_SOUND			@"Sound"
#define KEY_PAYOUTLOCKED	@"PayoutLocked"

enum {
	kTagHalfMarathon = 1,
	kTagPopMarathon = 2,
	kTagAvoidHarvest = 3,
    kTagAmaizing = 4,
    kTagKernelYesSir = 5,
    kTagNumber1Crop = 6,
    kTagPostCorn = 7,
    kTagTweetCorn = 8,
    kTagRateCorn = 9,
};

/*
 
 Payout Button Unlock
 
 Payout button will transfer your Paid amount back to your game Credits. 
 After unlock this Payout button, you will never run out of Credits for your bet.
 
 */
