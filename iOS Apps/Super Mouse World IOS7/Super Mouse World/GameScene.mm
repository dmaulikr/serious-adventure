//
//  GameScene.m
//  Super Mouse World
//
//  Created by Luiz Menezes on 21/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "GameScene.h"
#import "SimpleJoystick.h"
#import "MainMenu.h"
#import "AppSettings.h"
#import "SoundManager.h"
#import "GrowButton.h"

@implementation GameScene

@synthesize m_bIsPlay;
//----------------------------------------------------------------------------------------------------------------------

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];

	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
//----------------------------------------------------------------------------------------------------------------------
-(void) showHud {
    world = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"STAGE %d",[ AppSettings getCurrenStage ] ] fontName:@"DBLCDTempBlack" fontSize:igfloat(24)];
    [world setPosition:ccp(70,WINSIZE.height)];
    [world setAnchorPoint:ccp(0,1.25)];
    [self addChild:world z:MAXFLOAT];
    
    vidas = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"LIFES x %d",lifes] fontName:@"DBLCDTempBlack" fontSize:igfloat(24)];
    [vidas setPosition:ccp(230,WINSIZE.height)];
    [vidas setAnchorPoint:ccp(0,1.25)];
    [self addChild:vidas z:MAXFLOAT];
    
    time = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"TIME %d",LEVEL_TIMEOUT] fontName:@"DBLCDTempBlack" fontSize:igfloat(24)];
    [time setPosition:ccp(410,WINSIZE.height)];
    [time setAnchorPoint:ccp(0,1.25)];
    [self addChild:time z:MAXFLOAT];
    
    coins = [CCLabelTTF labelWithString:@"COINS x 0" fontName:@"DBLCDTempBlack" fontSize:igfloat(24)];
    [coins setPosition:ccp(610,WINSIZE.height)];
    [coins setAnchorPoint:ccp(0,1.25)];
    [self addChild:coins z:MAXFLOAT];
    
    score = [CCLabelTTF labelWithString:@"SCORE 0" fontName:@"DBLCDTempBlack" fontSize:igfloat(24)];
    [score setPosition:ccp(820,WINSIZE.height)];
    [score setAnchorPoint:ccp(0,1.25)];
    [self addChild:score z:MAXFLOAT];
    
    CCSprite *pressed = [CCSprite spriteWithFile:@"pausebtn.png"];
    [pressed setColor:ccc3(127, 127, 127)];

    [pressed setScale:0.5];
    CCSprite *normal = [CCSprite spriteWithFile:@"pausebtn.png"];

    [normal setScale:0.5];
    CCMenuItemImage *btnPuase = [CCMenuItemImage itemWithNormalSprite:normal
                                                      selectedSprite:pressed
                                                              target:self selector:@selector(pause)];
    CCMenu *mainMenu = [CCMenu menuWithItems: btnPuase, nil];
    [mainMenu setPosition: ccp(60-5,WINSIZE.height-5)];
    [self addChild:mainMenu z:MAXFLOAT];
    
    OBSERVE_NOTIFICATION(@"UPDATE_COINS", @selector(updateCoins));
    OBSERVE_NOTIFICATION(@"UPDATE_SCORE", @selector(updateScore));
    OBSERVE_NOTIFICATION(@"CHANGE_TO_NEXT_STAGE", @selector(stageComplete));

#ifdef VERSION_IPHONE
    double diff = 0;
    [world setPosition:ccp(world.position.x/2,world.position.y)];
    [vidas setPosition:ccp(vidas.position.x/2,vidas.position.y)];
    [time setPosition:ccp(time.position.x/2,time.position.y)];
    [coins setPosition:ccp((coins.position.x/2)-5,coins.position.y)];
    [score setPosition:ccp((score.position.x/2)-10,score.position.y)];
    [mainMenu setPosition:ccp(mainMenu.position.x/2,mainMenu.position.y)];
#endif
    
    [self schedule:@selector(updateTime) interval:1];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) pause {
    
    if( !m_bIsPlay )
        return;
    
    [[CCDirector sharedDirector] pause];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"PAUSE" message:nil delegate:self cancelButtonTitle:@"QUIT" otherButtonTitles:@"CONTINUE", nil] autorelease ];
    [alert show];
}
//----------------------------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[CCDirector sharedDirector] resume];
    if (buttonIndex == 0) {
        [self gotoMainMenu];
    }

}
//----------------------------------------------------------------------------------------------------------------------

- (void)addStageCompleteBtns{
    
    float fOffsetY  =   48;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        fOffsetY  =   96;
    
    CCLabelTTF *completed = [CCLabelTTF labelWithString:@"STAGE COMPLETED!" fontName:@"DBLCDTempBlack" fontSize:igfloat(48)];
    [completed setPosition:ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f + fOffsetY ) ];
    [completed setAnchorPoint:ccp(0.5,0)];
    [self addChild:completed z:MAXFLOAT];
    
    CCLabelTTF *completedCoins = [CCLabelTTF labelWithString:[ NSString stringWithFormat:@"You Collected %d coins", game.coins ] fontName:@"DBLCDTempBlack" fontSize:igfloat(36)];
    [completedCoins setPosition:ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f ) ];
    [completedCoins setAnchorPoint:ccp(0.5,0)];
    [self addChild:completedCoins z:MAXFLOAT];

    float fScale = 1.f;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        fScale  =   2.f;
    GrowButton  *btnMainMenu =   [ GrowButton buttonWithSpriteFrame:@"btn_mainmenu.png"
                                                   selectframeName:@"btn_mainmenu.png"
                                                            target:self
                                                          selector:@selector( gotoMainMenu ) ];
    [ self addChild:btnMainMenu ];
    
    GrowButton  *btnReply =   [ GrowButton buttonWithSpriteFrame:@"btn_replay.png"
                                                    selectframeName:@"btn_replay.png"
                                                             target:self
                                                           selector:@selector( replyThisLevel ) ];
    [ self addChild:btnReply ];
    if( [ AppSettings getCurrenStage ] == LEVEL_COUNT ){
        btnMainMenu.position    =   ccp( SCREEN_WIDTH / 2.f - 40 * fScale, SCREEN_HEIGHT / 2.f - 60 * fScale );
        btnReply.position    =   ccp( SCREEN_WIDTH / 2.f + 40 * fScale, SCREEN_HEIGHT / 2.f - 60 * fScale );
        
    }else{
        btnMainMenu.position    =   ccp( SCREEN_WIDTH / 2.f - 80 * fScale, SCREEN_HEIGHT / 2.f - 60 * fScale );
        btnReply.position    =   ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f - 60 * fScale );
        
        GrowButton  *btnNextLevel =   [ GrowButton buttonWithSpriteFrame:@"btn_nextlevel.png"
                                                         selectframeName:@"btn_nextlevel.png"
                                                                  target:self
                                                                selector:@selector( gotoNextStage ) ];
        btnNextLevel.position    =   ccp( SCREEN_WIDTH / 2.f + 80 * fScale, SCREEN_HEIGHT / 2.f - 60 * fScale );
        [ self addChild:btnNextLevel ];

    }

}

-(void) startPointCount {
    timeOut-=2;
    if (timeOut<0) {
        [time setString:@"TIME 0"];
//        [self performSelector:@selector(gotoNextStage) withObject:nil afterDelay:3];              //jin Code Start
        [ self addStageCompleteBtns ];
    }
    if (timeOut>=0) {
        game.points += 10;
        [time setString:[NSString stringWithFormat:@"TIME %d",timeOut]];
        [self updateScore];
        [self performSelector:@selector(startPointCount) withObject:nil afterDelay:1.0/30.0];
    }

}
//----------------------------------------------------------------------------------------------------------------------
-(void) stageComplete {
    m_bIsPlay   =   FALSE;                  //jin
    [ AppSettings setLockLevelStae:[ AppSettings getCurrenStage ] + 1 bFlag:NO ];
    [self unscheduleAllSelectors];
    [self performSelector:@selector(startPointCount) withObject:nil afterDelay:0.5];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) updateCoins {
    [coins setString:[NSString stringWithFormat:@"COINS x %d",game.coins]];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) updateScore {
    [score setString:[NSString stringWithFormat:@"SCORE %d",game.points]];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) updateTime {
    timeOut--;
    if (timeOut<=10) {
        
        //tocar warning
//            [[SimpleAudioEngine sharedEngine] playEffect:@"warning.mp3"];
            [[ SoundManager sharedSoundManager ] playEffect:kWarning bForce:FALSE ];
        
        if (timeOut<=0) {
            [self unschedule:@selector(updateTime)];
            timeOut = 0;
            [game dieHero];
        }
    }
    
    [time setString:[NSString stringWithFormat:@"TIME %d",timeOut]];
}
//----------------------------------------------------------------------------------------------------------------------

-(void) replyThisLevel {
//    int area = [ AppSettings getCurrenStage ]+1;
//    [ AppSettings setCurrentStage:area ];
//    
//    if (area == 5) {
//        [[NSUserDefaults standardUserDefaults] setInteger:-111 forKey:@"HERO_LIFE_COUNT"];
//    
//    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:[GameScene scene]]];
    
}
//----------------------------------------------------------------------------------------------------------------------
-(void) gotoNextStage {
    int area = [ AppSettings getCurrenStage ]+1;
    [ AppSettings setCurrentStage:area ];
    
    if (area == 5) {
        [[NSUserDefaults standardUserDefaults] setInteger:-111 forKey:@"HERO_LIFE_COUNT"];

    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:[GameScene scene]]];
    
}
//----------------------------------------------------------------------------------------------------------------------
-(void) gotoMainMenu {

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:[MainMenu scene]]];
    [[SoundManager sharedSoundManager] playBackgroundMusic: kbMenu ];
    
}
//----------------------------------------------------------------------------------------------------------------------
-(id) init
{
	if( (self=[super init])) {
        timeOut = LEVEL_TIMEOUT;
        lifes = [[NSUserDefaults standardUserDefaults] integerForKey:@"HERO_LIFE_COUNT"];
        points = [[NSUserDefaults standardUserDefaults] integerForKey:@"HERO_POINTS_COUNT"];
//        points  =   [ AppSettings CoinCount ];
        
        if (lifes<0)
        {
            m_bIsPlay   =   FALSE;              //jin
//            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mono-gameover.mp3" loop:NO];
            [[ SoundManager sharedSoundManager ] stopBackgroundMusic ];
            [ [ SoundManager sharedSoundManager ] playEffect:kbMono_GameOver bForce:NO ];
            
            CCLabelTTF *gameover = [CCLabelTTF labelWithString:lifes==-111?@"CONGRATULATIONS!!":@"GAME OVER" fontName:@"DBLCDTempBlack" fontSize:34];
            [gameover setPosition:ccp(WINSIZE.width/2,WINSIZE.height/2)];
            [gameover setAnchorPoint:ccp(0.5,-1)];
            [self addChild:gameover z:MAXFLOAT];
            
            CCLabelTTF *scrpt = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"SCORE %d",points] fontName:@"DBLCDTempBlack" fontSize:34];
            [scrpt setPosition:ccp(WINSIZE.width/2,WINSIZE.height/2)];
            [scrpt setAnchorPoint:ccp(0.5,2)];
            [self addChild:scrpt z:MAXFLOAT];
            
//            lifes = LEVEL_LIFE;                                                                           //jin
//            [[NSUserDefaults standardUserDefaults] setInteger:LEVEL_LIFE forKey:@"HERO_LIFE_COUNT"];//jin
//            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"HERO_POINTS_COUNT"];//jin
            
            
            [self performSelector:@selector(gotoMainMenu) withObject:nil afterDelay:3];
        } else {
            
            m_bIsPlay   =   TRUE;
            [self showHud];
            
            SimpleJoystick *j = [[[SimpleJoystick alloc] init] autorelease];
            game = [[[HelloWorldLayer alloc] initWithJoystick: j] autorelease];
            game.points = points;
            [self updateScore];
            [self addChild:game];
            [self addChild:j];
        }
#ifdef VERSION_IPHONE
//        [self setScale:0.5];
//        [self setPosition:ccpSub(self.position, ccp(128,64))];
#endif
	}

	return self;
}

//----------------------------------------------------------------------------------------------------------------------
-(void) dealloc {
    REMOVE_OBSERVER();
    [super dealloc];
}
//----------------------------------------------------------------------------------------------------------------------

@end
