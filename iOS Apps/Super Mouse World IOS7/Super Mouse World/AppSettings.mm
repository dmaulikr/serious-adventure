//
//  AppSettings.m
//  Mighty Possum World
//
//  Created by Lion User on 3/25/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

+ (void) defineUserDefaults
{
	NSString* userDefaultsValuesPath;
	NSDictionary* userDefaultsValuesDict;
	
	// load the default values for the user defaults
	userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"option" ofType:@"plist"];
	userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile: userDefaultsValuesPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults: userDefaultsValuesDict];
}

+ ( void )setLockLevelStae:(int)nLevel bFlag:( BOOL )bState{
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aFlag  =	[NSNumber numberWithFloat: bState];
	[defaults setObject:aFlag forKey:[NSString stringWithFormat: @"stage%d", nLevel]];
	[NSUserDefaults resetStandardUserDefaults];

}

+ ( BOOL )getLockLevelState:( int )nLevel{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey: [NSString stringWithFormat: @"stage%d", nLevel]];

}

+(void)lockAllStage:(BOOL)bState{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for( int i = 1; i < LEVEL_COUNT; i++ ){
        [defaults boolForKey: [NSString stringWithFormat: @"stage%d", i]];
    }

}

+ ( void )setLockCharState:( int )nIndex bFlag:( BOOL )bState{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aFlag  =	[NSNumber numberWithFloat: bState];
	[defaults setObject:aFlag forKey:[NSString stringWithFormat: @"lockmouse%d", nIndex]];
	[NSUserDefaults resetStandardUserDefaults];

}

+ ( BOOL )getCharLockState:( int )nIndex{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey: [NSString stringWithFormat: @"lockmouse%d", nIndex]];

}



+ (void) setBackgroundMute: (BOOL) bMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[NSNumber numberWithBool: bMute];
	[defaults setObject:aVolume forKey:@"music"];
	[NSUserDefaults resetStandardUserDefaults];
}

+ (BOOL) backgroundMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults boolForKey:@"music"];
	
}

+ (void) setEffectMute: (BOOL) bMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[NSNumber numberWithBool: bMute];
	[defaults setObject:aVolume forKey:@"effect"];
	[NSUserDefaults resetStandardUserDefaults];
}

+ (BOOL) effectMute
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults boolForKey:@"effect"];
	
}

+ (void) addCoin: (int) nCount {
	int nCoinCount = [self CoinCount];
	nCoinCount += nCount;
	[self setCoin: nCoinCount];
}

+ (void) subCoin: (int) nCount {
	int nCoinCount = [self CoinCount];
	nCoinCount -= nCount;
	if (nCoinCount < 0)
		nCoinCount = 0;
	[self setCoin: nCoinCount ];
}

+ (int) CoinCount {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey: @"coin"];
}

+ (void) setCoin: (int) nCount {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: nCount];
	[defaults setObject:aIndex forKey:@"coin"];
	[NSUserDefaults resetStandardUserDefaults];
}


+ (int) getCurrentPlayer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey: @"currentplayer"];
}

+ (void) setCurrentPlayer: (int) playerIndex
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: playerIndex];
	[defaults setObject:aIndex forKey:@"currentplayer"];
	[NSUserDefaults resetStandardUserDefaults];
}

+(int)getSelectedCharcCoin:( int )nPlayerIndex{
    switch ( nPlayerIndex ) {
        case 1:
            return 300;
        case 2:
            return 800;
        case 3:
            return 1500;
        case 4:
            return 2500;
        default:
            return 300;
            break;
    }
    
}

+(int)getSelectedLvlCoin:(int)nLevel{
    
    switch ( nLevel ) {
        case 1:
            return 1000;
        case 2:
            return 3000;
        case 3:
            return 5000;
        default:
            return 1000;
            
    }
}

+(int)getCurrenStage{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey: @"currentstage"];

}

+(void)setCurrentStage:( int )nStage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aIndex  =	[NSNumber numberWithInt: nStage];
	[defaults setObject:aIndex forKey:@"currentstage"];
	[NSUserDefaults resetStandardUserDefaults];

}

@end
