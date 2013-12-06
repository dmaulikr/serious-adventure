//
//  Collectable.h
//  Mighty Possum World
//
//  Created by Luiz Menezes on 23/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "CCPhysicsSprite.h"
#import "cocos2d.h"
#import "Box2D.h"

@interface Collectable : CCPhysicsSprite
{
    b2Body *body;
    BOOL dying;
}

@property (nonatomic,assign) BOOL isCoin;

- (id)initWithWorld:(b2World*)world andPosition:(CGPoint)p andWidth:(double)w andIsCoin:(BOOL) _isCoin;
-(void) checkIsActive ;
@end
