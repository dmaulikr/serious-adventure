//
//  MainMenu.m
//  Mighty Possum World
//
//  Created by Luiz Menezes on 29/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "GrowButton.h"
#import "AppSettings.h"
#import "SoundManager.h"
#import "StoreLayer.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"


@implementation MainMenu

@synthesize btnSound=_btnSound;
@synthesize btnEffect=_btnEffect;
//----------------------------------------------------------------------------------------------------------------------

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
//----------------------------------------------------------------------------------------------------------------------
-(void) play {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:[GameScene scene]]];

}
//----------------------------------------------------------------------------------------------------------------------
-(id) init
{
	if( (self=[super init])) {
        glClearColor(24.0/255.0, 146/255.0, 255/255.0, 1);
        
        [ [ AppController get ] dispAdvertise ];

		[[NSUserDefaults standardUserDefaults] setInteger:LEVEL_LIFE forKey:@"HERO_LIFE_COUNT"];
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"HERO_POINTS_COUNT"];
//        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ACTUAL_STAGE_COUNT"];
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu.mp3"];
//      jin code start
//        CCTMXTiledMap *mapa = [CCTMXTiledMap tiledMapWithTMXFile:@"menu.tmx"];
//        CGSize mapSize = [mapa mapSize];
//        
//        [mapa setAnchorPoint:ccp(0,0)];
//        [mapa setPosition:ccp(0,0)];
//        
//        ccTexParams texParams = { GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT };
//        
//        CCSprite *fg1 = [CCSprite spriteWithFile:@"fg1-0.png"];
//        [[fg1 texture] setTexParameters:&texParams];
//        [fg1 setTextureRect:CGRectMake(0, 0, mapSize.width*32, 512)];
//        [fg1 setAnchorPoint:CGPointZero];
//        
//        CCSprite *bg1 = [CCSprite spriteWithFile:@"bg1-0.png"];
//        [[bg1 texture] setTexParameters:&texParams];
//        [bg1 setTextureRect:CGRectMake(0, 0, mapSize.width*32, 512)];
//        [bg1 setAnchorPoint:CGPointZero];
//        
//#ifdef DEBUG_BOX2D
//        [fg1 setOpacity:16];
//        [bg1 setOpacity:16];
//#endif
//        
//        CCParallaxNode *mundo = [[CCParallaxNode alloc] init];
//        [mundo addChild:bg1 z:0 parallaxRatio:ccp(0.25,0.15) positionOffset:ccp(0,0)];
//        [mundo addChild:fg1 z:1 parallaxRatio:ccp(0.5,0.25) positionOffset:ccp(0,0)];
//        [mundo addChild:mapa z:3 parallaxRatio:ccp(1,1) positionOffset:ccp(0,0)];
//        [self addChild:mundo z:0];
//        [mundo setAnchorPoint:ccp(0,0)];
//        
//        CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 192) width:MAXFLOAT height:MAXFLOAT];
//        [bg setPosition:ccp(0,0)];
//        [self addChild:bg];
//        jin code end
        
//          jin code start
        
        CCSprite*   sprBack;

        if ( SCREEN_WIDTH == 568 || SCREEN_HEIGHT == 568 ) {
            sprBack =   [ CCSprite spriteWithFile:@"bg_logo5x.png" ];
        }
        else
            sprBack =   [ CCSprite spriteWithFile:@"bg_logo.png" ];
        
        sprBack.position    =   ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:sprBack ];
//
//        CCSprite *pressed = [CCSprite spriteWithFile:@"playbtn.png"];
//        [pressed setColor:ccc3(127, 127, 127)];
//        CCMenuItemImage *btnPlay = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"playbtn.png"]
//                                                          selectedSprite:pressed
//                                                    target:self selector:@selector(play)];
//        CCMenu *mainMenu = [CCMenu menuWithItems: btnPlay, nil];
//        [mainMenu setPosition: ccp(WINSIZE.width/2,200)];
//        [self addChild:mainMenu];
//        jin code end
        
		GrowButton *btnPlay = [GrowButton buttonWithSpriteFrame:@"btn_play.png"
                                                 selectframeName: @"btn_play.png"
                                                          target:self
                                                       selector:@selector(actionPlay:)];
		[self addChild:btnPlay];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnPlay.position    =   ccp( SCREEN_WIDTH / 2.f + 150, 175 );
        else
            btnPlay.position    =   ccp(823, 768 - 376 );
        
        GrowButton *btnStore = [GrowButton buttonWithSpriteFrame:@"btn_store.png"
                                                selectframeName: @"btn_store.png"
                                                         target:self
                                                        selector:@selector(actionPlay:)];
		[self addChild:btnStore];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnStore.position    =   ccp( SCREEN_WIDTH / 2.f + 140, 115 );
        else
            btnStore.position    =   ccp(790, 768 - 506 );
        
        GrowButton *btnFreeGame = [GrowButton buttonWithSpriteFrame:@"btn_freegame.png"
                                                 selectframeName: @"btn_freegame.png"
                                                          target:self
                                                           selector:@selector(actionFreeGame:)];
		[self addChild:btnFreeGame];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnFreeGame.position    =   ccp( SCREEN_WIDTH / 2.f + 120, 70 );
        else
            btnFreeGame.position    =   ccp(760, 768 - 606 );

        GrowButton *btnMoreGame = [GrowButton buttonWithSpriteFrame:@"btn_moregame.png"
                                                    selectframeName: @"btn_moregame.png"
                                                             target:self
                                                           selector:@selector(actionMoreGame:)];
		[self addChild:btnMoreGame];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnMoreGame.position    =   ccp( SCREEN_WIDTH / 2.f + 100, 25 );
        else
            btnMoreGame.position    =   ccp(700, 768 - 700 );
        
//        GrowButton *btnRestore = [GrowButton buttonWithSpriteFrame:@"btn_moregame.png"
//                                                    selectframeName: @"btn_moregame.png"
//                                                             target:self
//                                                           selector:@selector(onRestore)];
//		[self addChild:btnRestore];
//        
//        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
//            btnRestore.position    =   ccp( SCREEN_WIDTH / 2.f + 100, 300 );
//        else
//            btnRestore.position    =   ccp(790, 768 - 526 );

        
        GrowButton *btnGameCetner = [GrowButton buttonWithSpriteFrame:@"btn_gamecenter.png"
                                                    selectframeName: @"btn_gamecenter.png"
                                                             target:self
                                                             selector:@selector(onLeaderboard:)];
		[self addChild:btnGameCetner];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnGameCetner.position    =   ccp( 30, 30 );
        else
            btnGameCetner.position    =   ccp(90, 768 - 700 );
        
        CGPoint ptMute;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            ptMute  =   CGPointMake( 23, 23 );
        else
            ptMute  =   CGPointMake( 46, 46 );
        
		GrowIconButton *btnSound = [GrowIconButton buttonWithSpriteFrame:@"btn_sound.png"
                                                         selectframeName: @"btn_sound.png"
                                                           iconframeName: @"btn_nosound.png"
                                                                 posIcon: ptMute
                                                                  target:self
                                                                selector:@selector(actionSound:)];
        [ self addChild:btnSound ];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnSound.position    =   ccp( 30, 290 );
        else
            btnSound.position    =   ccp( 70, 700 );
        self.btnSound   =   btnSound;
        [_btnSound setIconVisible: [ AppSettings backgroundMute ] ];
        [[ SoundManager sharedSoundManager ] setBackgroundMusicMute:[ AppSettings backgroundMute ] ];
        GrowIconButton *btnEffect = [GrowIconButton buttonWithSpriteFrame:@"btn_music.png"
                                                          selectframeName: @"btn_music.png"
                                                            iconframeName: @"btn_nomusic.png"
                                                                  posIcon: ptMute
                                                                   target:self
                                                                 selector:@selector(actionEffect:)];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnEffect.position    =   ccp( 80, 290 );
        else
            btnEffect.position    =   ccp( 170, 700 );
		[self addChild:btnEffect];
		self.btnEffect = btnEffect;
        [_btnEffect setIconVisible: [ AppSettings effectMute ] ];
        [[ SoundManager sharedSoundManager ] setBackgroundMusicMute:[ AppSettings effectMute ] ];
        
        GrowButton *btnRestore = [GrowButton buttonWithSpriteFrame:@"btn_restore.png"
                                                   selectframeName: @"btn_restore.png"
                                                            target:self
                                                          selector:@selector(actionRestore:)];
        [self addChild:btnRestore];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            btnRestore.position    =   ccp( SCREEN_WIDTH - 30, 290 );
        else
            btnRestore.position    =   ccp( SCREEN_WIDTH - 100, 700 );
        
        
        if( ![ MKStoreManager featurePaidVersionPurchase ] ){
            
            GrowButton *btnRemoveADS = [GrowButton buttonWithSpriteFrame:@"btn_removeads.png"
                                                         selectframeName: @"btn_removeads.png"
                                                                  target:self
                                                                selector:@selector(removeADS:)];
            [self addChild:btnRemoveADS];
            
            if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
                btnRemoveADS.position    =   ccp( 200, 30 );
            else
                btnRemoveADS.position    =   ccp( 400, 768 - 700 );
            
        }

#ifdef VERSION_IPHONE
//        [self setScale:0.5];
//        [self setPosition:ccpSub(self.position, ccp(128,128))];
#endif

	}
	
	return self;
}

- (void) actionPlay:( id )sender{
    
    CCScene* layer = [StoreLayer node];
	ccColor3B color;
	color.r = 0x0;
	color.g = 0x0;
	color.b = 0x0;
	CCTransitionScene *ts = [CCTransitionSlideInR transitionWithDuration:0.5f scene:layer];
	[[CCDirector sharedDirector] replaceScene:ts];

}

- ( void )actionStore:( id )sender{
    
}

- (void) actionSound:( id )sender {
	BOOL bMute = ![AppSettings backgroundMute];
	[AppSettings setBackgroundMute: bMute];
	[_btnSound setIconVisible: bMute];
	[[SoundManager sharedSoundManager] setBackgroundMusicMute: bMute];

}

- (void) actionEffect:( id )sender {
    
	BOOL bMute = ![AppSettings effectMute];
	[AppSettings setEffectMute: bMute];
	[_btnEffect setIconVisible: bMute];
	[[SoundManager sharedSoundManager] setEffectMute: bMute];
}

- (void)actionFreeGame:( id )sender{
    [ [ AppController get ] dispFreeGames ];
}

- (void)actionMoreGame:( id )sender{
    [ [ AppController get ] dispMoreGames ];
}

- (void)removeADS:( id )sender{
    [ [ MKStoreManager sharedManager ] buyFeaturePaidRemoveADS ];
}

- (void)actionRestore:( id )sender{
    [ [ MKStoreManager sharedManager ] restorePurchase ];
}
- (void)onLeaderboard:( id )sender{
    [ [ AppController  get ] showLeaderboard ];
}

- ( void )dealloc{
    
    self.btnEffect = nil;
	self.btnSound = nil;

    [ super dealloc ];
}

@end
