//
//  LogoLayer.m
//  Mighty Possum World
//
//  Created by Lion User on 3/20/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "StoreLayer.h"
#import "SoundManager.h"
#import "MainMenu.h"
#import "CoinShopLayer.h"
#import "StageLayer.h"
#import "AppSettings.h"
#import "AppDelegate.h"

@implementation StoreLayer

@synthesize lblCoinCount = _lblCoinCount;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StoreLayer *layer = [StoreLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        
        m_nSelected = [ AppSettings getCurrentPlayer ];
        [ AppController get ].m_nPrevPageofCoin = 3;
        
        CCSprite    *sprBackground;
        if ( SCREEN_WIDTH == 568 || SCREEN_HEIGHT == 568 )
            sprBackground   = [ CCSprite spriteWithFile:@"bg_back5x.png" ];
        else
            sprBackground   = [ CCSprite spriteWithFile:@"bg_back.png" ];
        sprBackground.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:sprBackground ];
        
        CCSprite    *sprBack =  [ CCSprite spriteWithSpriteFrameName:@"btn_back.png" ];
        
        //Add CoinCOuntLabel
        
        int nWidth   =      22;
        int nHeight  =      28;
        float fScale    =   1.f;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            nWidth      =   44;
            nHeight     =   55;
            fScale      =   2.f;
        }

        
        CCSprite    *sprCoin = [ CCSprite spriteWithSpriteFrameName:@"coin_side.png" ];
        sprCoin.position = 	ccp( SCREEN_WIDTH - 110 * fScale, SCREEN_HEIGHT - 15 * fScale );
        sprCoin.scale   =   0.8;
        [ self addChild:sprCoin z:1 ];
        
        
        CCLabelAtlas *lblCoinCount = [ CCLabelAtlas labelWithString:@"number_coin.png" charMapFile:@"number_coin.png" itemWidth:nWidth itemHeight:nHeight startCharMap:'0'];
		lblCoinCount.position =  ccp( SCREEN_WIDTH - 90 * fScale,SCREEN_HEIGHT - 15 * fScale );
        lblCoinCount.anchorPoint = ccp(0.f, 0.5f );
        lblCoinCount.scale  =   0.7;
		[ self addChild:lblCoinCount z:1 ];
		self.lblCoinCount = lblCoinCount;

        GrowButton *btnBack = [GrowButton buttonWithSpriteFrame:@"btn_back.png"
                                                      selectframeName: @"btn_back.png"
                                                               target:self
                                                             selector:@selector(onBack)];
		[self addChild:btnBack];        
         btnBack.position    =   ccp( 10 * SCALE_SCREEN_WIDTH + sprBack.textureRect.size.width / 2.f,
                                     SCREEN_HEIGHT - 10 * SCALE_SCREEN_WIDTH - sprBack.textureRect.size.height / 2.f );

        
        CCSprite    *sprStore   =   [ CCSprite spriteWithSpriteFrameName:@"bg_store.png" ];
        sprStore.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:sprStore ];
        
        GrowButton  *btnPrev    =   [GrowButton buttonWithSpriteFrame:@"btn_left.png"
                                                      selectframeName: @"btn_left.png"
                                                               target:self
        
                                                             selector:@selector(onPrev:)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnPrev.position    =   ccp( 113 / 2.f, 135 );
        else
            btnPrev.position    =   ccp( 113, 270 );
        
        [ sprStore addChild:btnPrev ];
        
        GrowButton  *btnNext    =   [GrowButton buttonWithSpriteFrame:@"btn_right.png"
                                                      selectframeName: @"btn_right.png"
                                                               target:self
                                     
                                                             selector:@selector(onNext:)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnNext.position    =   ccp( 628 / 2.f, 135 );
        else
            btnNext.position    =   ccp( 628, 270 );
        
        [ sprStore addChild:btnNext ];

        NSString *strMouse = [NSString stringWithFormat:@"select_mouse%02d.png",m_nSelected + 1 ];
        m_btnSelected = [ [ GrowButton buttonWithSpriteFrame:strMouse
                                             selectframeName:strMouse
                                                      target:self
                           
                                                    selector:@selector(onMouse:) ] retain ];
        
        m_btnSelected.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:m_btnSelected ];
        
        CCSprite    *sprCoinShop    =   [ CCSprite spriteWithSpriteFrameName:@"btn_coinshop.png" ];
        GrowButton *btnCoinShop = [GrowButton buttonWithSpriteFrame:@"btn_coinshop.png"
                                                selectframeName: @"btn_coinshop.png"
                                                         target:self
                                                           selector:@selector(onCoinShop:)];
		[self addChild:btnCoinShop];        
         btnCoinShop.position    =   ccp( SCREEN_WIDTH - sprCoinShop.textureRect.size.width / 2.f - 10 * SCALE_SCREEN_WIDTH,
                                         sprCoinShop.textureRect.size.height / 2.f + 10 * SCALE_SCREEN_WIDTH );
        
        
        int nLockChar = 0;
        for( int i = 1; i < 5; i++ ){
            if ( [ AppSettings getCharLockState:i ] ) {
                nLockChar++;
            }
        }
        if( nLockChar != 0 ){
            CCSprite    *sprUnlockAllChar    =   [ CCSprite spriteWithSpriteFrameName:@"select_unlockcha.png" ];
            GrowButton *btnUnlockAllChar = [GrowButton buttonWithSpriteFrame:@"select_unlockcha.png"
                                                             selectframeName: @"select_unlockcha.png"
                                                                      target:self
                                                                    selector:@selector(onUnlockAllChar:)];
            [self addChild:btnUnlockAllChar];
            btnUnlockAllChar.position    =   ccp( sprUnlockAllChar.textureRect.size.width / 2.f + 10 * SCALE_SCREEN_WIDTH,
                                                 sprUnlockAllChar.textureRect.size.height / 2.f + 10 * SCALE_SCREEN_WIDTH );

        }
        [ self refreshCoinCount ];

	}
    
	return self;
}

- ( void )dealloc{
    
    self.lblCoinCount   =   NULL;
    
    [ m_btnSelected release ];
    m_btnSelected = nil;
    [ super dealloc ];
    
}

- ( void )refreshCoinCount{
    [ self.lblCoinCount setString:[ NSString stringWithFormat:@"%d",[ AppSettings CoinCount ] ] ];
}

- (void)onNext:( id )sender{
    
    m_nSelected++;
    if( m_nSelected >= 5 )
        m_nSelected = 0;
    
    [ m_btnSelected removeFromParentAndCleanup:YES ];
    NSString *strMouse;
    float fInterval =   0;
    if( [ AppSettings getCharLockState:m_nSelected ] && m_nSelected != 0 ){
        fInterval = 30 * SCALE_SCREEN_HEIGHT;
        strMouse = [NSString stringWithFormat:@"select_mouse%02d_.png",m_nSelected + 1 ];
    }else
        strMouse = [NSString stringWithFormat:@"select_mouse%02d.png",m_nSelected + 1 ];
    
    m_btnSelected = [ [ GrowButton buttonWithSpriteFrame:strMouse
                                      selectframeName:strMouse
                                               target:self
                     
                                             selector:@selector(onMouse:) ] retain ];
    m_btnSelected.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f - fInterval );
    [ self addChild:m_btnSelected ];
    
}

- (void)onPrev:( id )sender{
    
    m_nSelected--;
    if( m_nSelected < 0 )
        m_nSelected = 4;
    
    [ m_btnSelected removeFromParentAndCleanup:YES ];
    
    NSString *strMouse;
    float fInterval =   0;

    if( [ AppSettings getCharLockState:m_nSelected ] && m_nSelected != 0 ){
        strMouse = [NSString stringWithFormat:@"select_mouse%02d_.png",m_nSelected + 1 ];
        fInterval = 30 * SCALE_SCREEN_HEIGHT;
    }else
        strMouse = [NSString stringWithFormat:@"select_mouse%02d.png",m_nSelected + 1 ];
    m_btnSelected = [ [ GrowButton buttonWithSpriteFrame:strMouse
                                         selectframeName:strMouse
                                                  target:self
                       
                                                selector:@selector(onMouse:) ] retain ];

    m_btnSelected.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f - fInterval );
    [ self addChild:m_btnSelected ];

}

- (void)onMouse:( id )sender{
    
    if( [ AppSettings getCharLockState:m_nSelected ] ){
        
        if( [ AppSettings getSelectedCharcCoin: m_nSelected ] <= [ AppSettings CoinCount ] ){
            UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Unlock Mouse!"
                                    message:[ NSString stringWithFormat:@"Would you like to unlock this Mouse for %d coins?", [ AppSettings getSelectedCharcCoin:m_nSelected ] ]
                                    delegate:self
                                    cancelButtonTitle:@"No"
                                    otherButtonTitles:@"Yes", nil ];
            myAlert.tag = 11;
            [myAlert show];
            [myAlert release];
        }else{
            UIAlertView *myAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Unlock Mouse!"
                                    message:@"You have not too enough coins to unlock this mouse.\nWould you like to get more coins?"
                                    delegate:self
                                    cancelButtonTitle:@"No"
                                    otherButtonTitles:@"Yes", nil ];
            myAlert.tag = 12;
            [myAlert show];
            [myAlert release];
        }

    }else{
        
        [ AppSettings setCurrentPlayer:m_nSelected ];
        
        CCScene* layer = [ StageLayer node ];
        ccColor3B color;
        color.r = 0x0;
        color.g = 0x0;
        color.b = 0x0;
        CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
        [[CCDirector sharedDirector] replaceScene:ts];

    }
    
}

- (void)onUnlockAllChar:( id )sender{
    
    if( [ AppSettings CoinCount ] < 4000 ){
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Get Coin!"
                                message:@"You have not too enough coins to get it.\nWould you like to get more coins?"
                                delegate:self
                                cancelButtonTitle:@"No"
                                otherButtonTitles:@"Yes", nil ];
        myAlert.tag = 10;
        [myAlert show];
        [myAlert release];
    }else{
        for( int i = 1; i < 5; i++ )
            [ AppSettings setLockCharState:i bFlag:NO ];
    }
    
}

- (void)onCoinShop:( id )sender{
    
    CCScene* layer = [ CoinShopLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];

}

- (void)onBack{
    
    CCScene* layer = [MainMenu node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if( alertView.tag == 10 ){
        if (buttonIndex == 1) {
            [ self onCoinShop:nil ];
        }
    }else if( alertView.tag == 11 ){
        if (buttonIndex == 1) {
            [ AppSettings setLockCharState:m_nSelected bFlag:NO ];
            [ AppSettings subCoin:[ AppSettings getSelectedCharcCoin:m_nSelected ] ];
            [ self refreshCoinCount ];
        }
        
    }else if( alertView.tag == 12 ){
        if (buttonIndex == 1) {
            [ self onCoinShop:nil ];
        }
        
    }

    
}

@end
