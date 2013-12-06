//
//  HelloWorldLayer.h
//  Mighty Possum World
//
//  Created by Luiz Menezes on 18/10/12.
//  Copyright Thetis Games 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "SimpleJoystick.h"
#import "MyContactListener.h"
#import "Hero.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer<UITextFieldDelegate>{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref

    Hero *hero;
    CCParallaxNode *mundo;
    CCTMXTiledMap *mapa;
    
    CCLayer *game;

    SimpleJoystick *joystick;
    MyContactListener *contactListener;
    NSMutableArray *collectables;
    NSMutableArray *enemys;
    
    CGSize mapSize;
    
}

@property (nonatomic, assign) int coins;
@property (nonatomic, assign) int points;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(id) initWithJoystick:(SimpleJoystick*)joystick;
-(void) createHeroAtPosition:(CGPoint)p;
-(void) dieHero;
@end
