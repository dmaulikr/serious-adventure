//
//  LogoLayer.m
//  Mighty Possum World
//
//  Created by Lion User on 3/20/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "LogoLayer.h"
#import "SoundManager.h"
#import "MainMenu.h"
#import "AppSettings.h"

@implementation LogoLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LogoLayer *layer = [LogoLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        
        CCSprite    *sprBack;
        if ( SCREEN_WIDTH == 568 || SCREEN_HEIGHT == 568 ) {
            sprBack =   [ CCSprite spriteWithFile:@"bg_logo5x.png" ];
        }
        else
            sprBack =   [ CCSprite spriteWithFile:@"bg_logo.png" ];

        sprBack.position = ccp( SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f );
        [ self addChild:sprBack ];
        
        [ self performSelector:@selector(gotoTitle:) withObject:nil afterDelay:3 ];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_menu.plist"];
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_mouse.plist"];

        [[SoundManager sharedSoundManager] playBackgroundMusic: kbMenu ];

        [ AppSettings defineUserDefaults ];
        
	}
    
	return self;
}

- ( void )gotoTitle:( id )sender{
    [ [ CCDirector sharedDirector ] replaceScene:[ MainMenu node ] ];
}
@end
