//
//  LogoLayer.m
//  Mighty Possum World
//
//  Created by Lion User on 3/20/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "StageLayer.h"
#import "SoundManager.h"
#import "MainMenu.h"
#import "AppSettings.h"
#import "StoreLayer.h"
#import "MKStoreManager.h"
#import "GameScene.h"
#import "CoinShopLayer.h"
#import "AppDelegate.h"

@implementation StageLayer

@synthesize lblCoinCount = _lblCoinCount;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StageLayer *layer = [StageLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
- ( void )refreshStageBtn: (NSNotification *) notification{
    NSString *strStage;
    
    if( [ AppSettings getLockLevelState:m_nSelected + 1 ] )
        strStage = [ NSString stringWithFormat:@"stages_%02d_dis.png", m_nSelected + 1 ];
    else
        strStage = [ NSString stringWithFormat:@"stages_%02d_nor.png", m_nSelected + 1 ];
    
    m_btnStage = [GrowButton buttonWithSpriteFrame:strStage
                                   selectframeName:strStage
                                            target:self
                  
                                          selector:@selector(onStage:)];
    
    m_btnStage.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
    [ self addChild:m_btnStage ];
}

-(id) init
{
	if( (self=[super init])) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(refreshStageBtn:) name: @"Notification_RefreshStageLayer" object:nil ];

        [ AppController get ].m_nPrevPageofCoin = 2;
        m_nSelected =   0;
        
        CCSprite    *sprBackground;
        if ( SCREEN_WIDTH == 568 || SCREEN_HEIGHT == 568 )
            sprBackground   = [ CCSprite spriteWithFile:@"bg_back5x.png" ];
        else
            sprBackground   = [ CCSprite spriteWithFile:@"bg_back.png" ];
            
        sprBackground.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:sprBackground ];
        
        CCSprite    *sprBack =  [ CCSprite spriteWithSpriteFrameName:@"btn_back.png" ];
        GrowButton *btnBack = [GrowButton buttonWithSpriteFrame:@"btn_back.png"
                                                selectframeName: @"btn_back.png"
                                                         target:self
                                                       selector:@selector(onBack)];
		[self addChild:btnBack];
        btnBack.position    =   ccp( 10 * SCALE_SCREEN_WIDTH + sprBack.textureRect.size.width / 2.f,
                                    SCREEN_HEIGHT - 10 * SCALE_SCREEN_WIDTH - sprBack.textureRect.size.height / 2.f );
        
        
        CCSprite    *sprStore   =   [ CCSprite spriteWithSpriteFrameName:@"bg_stages.png" ];
        sprStore.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:sprStore ];
        
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

        
        m_btnStage  =   [GrowButton buttonWithSpriteFrame:@"stages_01_nor.png"
                                          selectframeName: @"stages_01_nor.png"
                                                   target:self
                                                 selector:@selector(onStage:)];
        m_btnStage.position =   ccp(SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:m_btnStage ];
        
        int nLevelLock = 0;
        for( int i = 0; i < LEVEL_COUNT; i++ ){
            if( [ AppSettings getLockLevelState: i + 1 ] )
                nLevelLock++;
        }
        if( nLevelLock != 0 ){
            CCSprite    *sprUnlockAllLvl    =   [ CCSprite spriteWithSpriteFrameName:@"select_unlock.png" ];
            GrowButton *btnUnlockAllLvl = [GrowButton buttonWithSpriteFrame:@"select_unlock.png"
                                                            selectframeName: @"select_unlock.png"
                                                                     target:self
                                                                   selector:@selector(onUnlockAllLvl:)];
            [self addChild:btnUnlockAllLvl];
            btnUnlockAllLvl.position    =   ccp( sprUnlockAllLvl.textureRect.size.width / 2.f + 10 * SCALE_SCREEN_WIDTH,
                                                sprUnlockAllLvl.textureRect.size.height / 2.f + 10 * SCALE_SCREEN_WIDTH );
        }

        
        [ self refreshCoinCount ];

	}
    
	return self;
}

- (void)dealloc{
    
    self.lblCoinCount   =   NULL;
    [ super dealloc ];
}

- ( void )refreshCoinCount{
    [ self.lblCoinCount setString:[ NSString stringWithFormat:@"%d",[ AppSettings CoinCount ] ] ];
}

- (void)onBack{
    
    CCScene* layer = [ StoreLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];
    
}

- (void)onPrev:( id )sender{
    
    m_nSelected--;
    if( m_nSelected < 0 )
        m_nSelected = LEVEL_COUNT -1;
    
    [ m_btnStage removeFromParentAndCleanup:YES ];
    
    NSString *strStage;
    
    if( [ AppSettings getLockLevelState:m_nSelected + 1 ] )
        strStage = [ NSString stringWithFormat:@"stages_%02d_dis.png", m_nSelected + 1 ];
    else
        strStage = [ NSString stringWithFormat:@"stages_%02d_nor.png", m_nSelected + 1 ];
    
    m_btnStage = [GrowButton buttonWithSpriteFrame:strStage
                                  selectframeName:strStage
                                           target:self
                 
                                         selector:@selector(onStage:)];
    
    m_btnStage.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
    [ self addChild:m_btnStage ];
    
}

- (void)onNext:( id )sender{
    
    m_nSelected++;
    if( m_nSelected >= LEVEL_COUNT )
        m_nSelected = 0;
    
    [ m_btnStage removeFromParentAndCleanup:YES ];
    
    NSString *strStage;
    
    if( [ AppSettings getLockLevelState:m_nSelected + 1 ] )
        strStage = [ NSString stringWithFormat:@"stages_%02d_dis.png", m_nSelected + 1 ];
    else
        strStage = [ NSString stringWithFormat:@"stages_%02d_nor.png", m_nSelected + 1 ];
    
    m_btnStage = [GrowButton buttonWithSpriteFrame:strStage
                                   selectframeName:strStage
                                            target:self
                  
                                          selector:@selector(onStage:)];
    
    m_btnStage.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
    [ self addChild:m_btnStage ];
    
}

- (void)onUnlockAllLvl:( id )sender{

//    for( int i = 0; i < LEVEL_COUNT; i++ ){
//        if( [ AppSettings getLockLevelState:i + 1 ] ){
//            UIAlertView *myAlert = [[UIAlertView alloc]
//                                    initWithTitle:@"Unlock All Levels!"
//                                    message:@"Would you like to unlock all levels?"
//                                    delegate:self
//                                    cancelButtonTitle:@"No"
//                                    otherButtonTitles:@"Yes", nil ];
//            myAlert.tag = 10;
//            [myAlert show];
//            [myAlert release];
//        }
//    }
    [ [ MKStoreManager sharedManager ] buyfeatureAllOpenLevel ];
}

- (void)onStage:( id )sender{
    
    if( ![ AppSettings getLockLevelState:m_nSelected + 1 ] )
    {
   		[[NSUserDefaults standardUserDefaults] setInteger:LEVEL_LIFE forKey:@"HERO_LIFE_COUNT"];
        [ AppSettings setCurrentStage:m_nSelected + 1 ];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:[GameScene scene]]];

    }
    else
    {
//        if( [ AppSettings CoinCount ] > [ AppSettings getSelectedLvlCoin:m_nSelected ] ){
//            UIAlertView *myAlert = [[UIAlertView alloc]
//                                    initWithTitle:@"Level Locked!"
//                                    message:[ NSString stringWithFormat:@"Would you like to unlock this level for %d coins?", [ AppSettings getSelectedLvlCoin:m_nSelected ] ]
//                                    delegate:self
//                                    cancelButtonTitle:@"No"
//                                    otherButtonTitles:@"Yes", nil ];
//            myAlert.tag = 11;
//            [myAlert show];
//            [myAlert release];
//        }else{
//            UIAlertView *myAlert = [[UIAlertView alloc]
//                                    initWithTitle:@"Level Locked!"
//                                    message:@"You have not too enough coins to unlock this Level.\nWould you like to get more coins?"
//                                    delegate:self
//                                    cancelButtonTitle:@"No"
//                                    otherButtonTitles:@"Yes", nil ];
//            myAlert.tag = 12;
//            [myAlert show];
//            [myAlert release];
//
//        }
        switch (m_nSelected ) {
            case 1:
                [ [ MKStoreManager sharedManager ] buyFeatureOpenLevel2 ];
                break;
            case 2:
                [ [ MKStoreManager sharedManager ] buyFeatureOpenLevel3 ];
                break;
            case 3:
                [ [ MKStoreManager sharedManager ] buyFeatureOpenLevel4 ];
                break;
            default:
                break;
        }

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if( alertView.tag == 10 ){
        if (buttonIndex == 1) {
            if( [ AppSettings CoinCount ] >= 4000 )
            {
                [ AppSettings lockAllStage:NO ];
                [ AppSettings subCoin:4000 ];
                [ self refreshCoinCount ];
                
            }else{
                UIAlertView *myAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Unlock All Levels!"
                                        message:@"You have not too enough coins to unlock all Levels.\nWould you like to get more coins?"
                                        delegate:self
                                        cancelButtonTitle:@"No"
                                        otherButtonTitles:@"Yes", nil ];
                myAlert.tag = 13;
                [myAlert show];
                [myAlert release];

            }
        }
    }else if( alertView.tag == 11 ){
        if (buttonIndex == 1) {
            
            [ AppSettings setLockLevelStae:m_nSelected bFlag:NO ];
            [ AppSettings subCoin:[ AppSettings getSelectedLvlCoin:m_nSelected ] ];
            [ self refreshCoinCount ];
            [ m_btnStage removeFromParentAndCleanup:YES ];
            
            NSString *strStage;
            
            strStage = [ NSString stringWithFormat:@"stages_%02d_nor.png", m_nSelected + 1 ];
            m_btnStage = [GrowButton buttonWithSpriteFrame:strStage
                                           selectframeName:strStage
                                                    target:self
                          
                                                  selector:@selector(onStage:)];
            
            m_btnStage.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
            [ self addChild:m_btnStage ];
        }
        
    }else if( alertView.tag == 12 ){
        if (buttonIndex == 1) {
            [ self onCoinShop:nil ];
        }
        
    }else if( alertView.tag == 13) {
        if (buttonIndex == 1) {
            [ self onCoinShop:nil ];
        }
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


@end
