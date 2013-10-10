//
//  Enemy.h
//  Super Mouse World
//
//  Created by Luiz Menezes on 25/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "CCPhysicsSprite.h"
#import "cocos2d.h"
#import "Box2D.h"

@interface Enemy : CCPhysicsSprite
{
    b2Body *body;
    NSString *enemyname;

    CCAnimate *animloop;
    CGPoint originalPosition;
    BOOL dying;
}

@property (nonatomic,assign) int type;

- (id)initWithWorld:(b2World*)world andPosition:(CGPoint)p withName:(NSString*)name;
-(void) checkIsActive ;
-(void) die;
@end
