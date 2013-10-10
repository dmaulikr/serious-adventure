//
//  Hero.h
//  Super Mouse World
//
//  Created by Luiz Menezes on 22/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "CCPhysicsSprite.h"
#import "SimpleJoystick.h"

@interface Hero : CCPhysicsSprite
{
    CCAnimate *animationHero;
    b2Body *heroBody;
    SimpleJoystick *joystick;

}
@property (nonatomic,assign) BOOL jumping;

- (id)initWithWorld:(b2World*)world andPosition:(CGPoint)p andJoystick:(SimpleJoystick*)joystick;
-(CCAnimate*) createAnimation:(NSString *)name withSpeed:(double) speed;
-(void) enemyJump;
-(void) die;
@end
