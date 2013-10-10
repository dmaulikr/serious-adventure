//
//  LogoLayer.m
//  Super Mouse World
//
//  Created by Lion User on 3/20/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "CoinShopLayer.h"
#import "SoundManager.h"
#import "StoreLayer.h"
#import "StageLayer.h"
#import "MKStoreManager.h"
#import "AppSettings.h"
#import "AppDelegate.h"

static NSString* strCoins[] =
{
	@"Coins_50.png",
    @"Coins_400.png",
    @"Coins_1500.png",
    @"Coins_5000.png",
};


@implementation CoinShopLayer

@synthesize lblCoinCount = _lblCoinCount;

@synthesize m_btnCoin;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CoinShopLayer *layer = [CoinShopLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(refreshCoinCount:) name: @"Notification_RefreshCoinCount" object:nil ];

        m_nSelected = 0;
        
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
        
        
        CCSprite    *sprStore   =   [ CCSprite spriteWithSpriteFrameName:@"bg_store.png" ];
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
        
        
        CCLabelAtlas *lblCoinCount = [ CCLabelAtlas labelWithString:[ NSString stringWithFormat:@"%d", [ AppSettings CoinCount ] ] charMapFile:@"number_coin.png" itemWidth:nWidth itemHeight:nHeight startCharMap:'0'];
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
        
        m_btnCoin = [ GrowButton buttonWithSpriteFrame:@"Coins_50.png"
                                          selectframeName:@"Coins_50.png"
                                                   target:self
                         
                                                 selector:@selector(onCoin:)];
        m_btnCoin.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:m_btnCoin ];

	}
    
	return self;
}

- ( void )dealloc {
    
     [ [ NSNotificationCenter defaultCenter ] removeObserver:self ];
    self.lblCoinCount   =   NULL;
    [ super dealloc ];
}

- ( void )refreshCoinCount: (NSNotification *) notification{
    [ self.lblCoinCount setString:[ NSString stringWithFormat:@"%d",[ AppSettings CoinCount ] ] ];
}

- (void)onCoin:( id )sender{
    
    switch ( m_nSelected ) {
        case 0:
            [ [ MKStoreManager sharedManager ] buyFeatureGetCoin50 ];
            break;
        case 1:
            [ [ MKStoreManager sharedManager ] buyFeatureGetCoin400 ];
            break;
        case 2:
            [ [ MKStoreManager sharedManager ] buyFeatureGetCoin1500 ];
            break;
        case 3:
            [ [ MKStoreManager sharedManager ] buyFeatureGetCoin5000 ];
            break;
        default:
            break;
    }

}

- (void)onPrev:( id )sender{
    
    m_nSelected--;
    if( m_nSelected < 0 )
        m_nSelected = 3;
    
    [ m_btnCoin removeFromParentAndCleanup:YES ];
    
    m_btnCoin = [GrowButton buttonWithSpriteFrame:strCoins[ m_nSelected ]
                                      selectframeName:strCoins[ m_nSelected ]
                                               target:self
                     
                                             selector:@selector(onCoin:)];
    
    m_btnCoin.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
    [ self addChild:m_btnCoin ];
    
}

- (void)onNext:( id )sender{
    
    m_nSelected++;
    if( m_nSelected > 3 )
        m_nSelected = 0;
    
    [ m_btnCoin removeFromParentAndCleanup:YES ];
    
    m_btnCoin = [GrowButton buttonWithSpriteFrame:strCoins[ m_nSelected ]
                                  selectframeName:strCoins[ m_nSelected ]
                                           target:self
                 
                                         selector:@selector(onCoin:)];
    
    m_btnCoin.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
    [ self addChild:m_btnCoin ];
    
}

- (void)onBack{
    
    if( [ AppController get ].m_nPrevPageofCoin == 3){
        CCScene* layer = [ StoreLayer node];
        ccColor3B color;
        color.r = 0x0;
        color.g = 0x0;
        color.b = 0x0;
        CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
        [[CCDirector sharedDirector] replaceScene:ts];

    }
    else if( [ AppController get ].m_nPrevPageofCoin == 2 ){
        CCScene* layer = [ StageLayer node];
        ccColor3B color;
        color.r = 0x0;
        color.g = 0x0;
        color.b = 0x0;
        CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
        [[CCDirector sharedDirector] replaceScene:ts];

    }
}
@end
