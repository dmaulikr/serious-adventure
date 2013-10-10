//
//  AppSettings.h
//  Super Mouse World
//
//  Created by Lion User on 3/25/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject{
    
}

+ (void) defineUserDefaults;

+ ( void )setLockLevelStae:(int)nLevel bFlag:( BOOL )bState;
+ ( BOOL )getLockLevelState:( int )nLevel;
+ ( void )setLockCharState:( int )nIndex bFlag:( BOOL )bState;
+ ( BOOL )getCharLockState:( int )nIndex;
+ (void)lockAllStage:(BOOL)bState;
+ (void) setBackgroundMute: (BOOL) bMute;
+ (BOOL) backgroundMute;
+ (void) setEffectMute: (BOOL) bMute;
+ (BOOL) effectMute;
+ (void) addCoin: (int) nCount;
+ (void) subCoin: (int) nCount;
+ (int) CoinCount;
+ (void) setCoin: (int) nCount;
+ (int) getCurrentPlayer;
+ (void) setCurrentPlayer: (int) playerIndex;
+(int)getSelectedCharcCoin:( int )nPlayerIndex;
+(int)getSelectedLvlCoin:(int)nLevel;
+(int)getCurrenStage;
+(void)setCurrentStage:( int )nStage;

@end
