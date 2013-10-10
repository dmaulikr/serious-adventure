//
//  Enemy.m
//  Super Mouse World
//
//  Created by Luiz Menezes on 25/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "Enemy.h"
#import "AppSettings.h"
#import "SoundManager.h"

@implementation Enemy
@synthesize type;
//----------------------------------------------------------------------------------------------------------------------
-(void)dealloc {
    [enemyname autorelease];
    [super dealloc];
}
//----------------------------------------------------------------------------------------------------------------------
- (id)initWithWorld:(b2World*)world andPosition:(CGPoint)p withName:(NSString*)_name{

    self = [super initWithSpriteFrameName:[NSString stringWithFormat:@"%@-walk_0.png",_name]];
    
    if (self) {
        
        dying = NO;
        enemyname = [[NSString alloc] initWithString:_name];
//        p.x = igfloat(p.x);
//        p.y = igfloat(p.y);
//        p.y -= 64;
        p = ccpAdd(p, ccp(igfloat(16),igfloat(16)));

        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;


        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(igfloat(20.0)/PTM_RATIO, igfloat(8.0)/PTM_RATIO,b2Vec2(0,IS_IPHONE?-0.7:-1.6),0);

        [self setAnchorPoint:ccp(0.5,0.45)];
        
        if ([_name isEqualToString:@"gripe"]) type = ENEMY_TYPE_BLUE;
        if ([_name isEqualToString:@"snipe"]) type = ENEMY_TYPE_RED;
        if ([_name isEqualToString:@"spike"]) {

            b2Vec2 vertices[3] = {b2Vec2(igfloat(-0.6),igfloat(-1)),b2Vec2(igfloat(0.6),igfloat(-1)),b2Vec2(0,IS_IPHONE?0.4:1.8-1)};
            bodyDef.type = b2_staticBody;
            dynamicBox.Set(vertices, 3);
            
            type = ENEMY_TYPE_SPIKE;
            [self setAnchorPoint:ccp(0.5,0.75)];
        }
        if ([_name isEqualToString:@"robot"]) {
            type = ENEMY_TYPE_ROBOT;
            dynamicBox.SetAsBox(igfloat(24.0)/PTM_RATIO, igfloat(24.0)/PTM_RATIO);
            [self setAnchorPoint:ccp(0.5,0.475)];
        }

        body = world->CreateBody(&bodyDef);
        body->SetFixedRotation(YES);

        
        if (type == ENEMY_TYPE_SPIKE) {
            body->SetUserData((void*)OBJECT_TYPE_SPIKE);
            
            b2FixtureDef fixtureDef;
            fixtureDef.shape = &dynamicBox;
            fixtureDef.density = 0;
            fixtureDef.friction = 0;
            fixtureDef.isSensor = YES;
            body->CreateFixture(&fixtureDef);
            
        } else {

            b2FixtureDef fixtureDef;
            fixtureDef.shape = &dynamicBox;
            fixtureDef.density = 1024*100;
            fixtureDef.friction = 0;
            body->CreateFixture(&fixtureDef);
            

            b2PolygonShape head;
            if (type ==ENEMY_TYPE_ROBOT) {
                head.SetAsBox(igfloat(18.0)/PTM_RATIO, 2.0/PTM_RATIO,b2Vec2(0,igfloat(1.5)),0);
                body->SetUserData((void*)OBJECT_TYPE_CREEP_GOOD);
            }
            else {
                head.SetAsBox(igfloat(18.0)/PTM_RATIO, igfloat(22.0)/PTM_RATIO,b2Vec2(0,igfloat(0.5)),0);
                body->SetUserData((void*)OBJECT_TYPE_CREEP_BAD);
            }
            
            b2FixtureDef fixtureHead;
            fixtureHead.shape = &head;
            fixtureHead.density = 1;
            fixtureHead.friction = 1;
            fixtureHead.isSensor = type != (ENEMY_TYPE_ROBOT);
            body->CreateFixture(&fixtureHead);
        }

        [[self texture] setAliasTexParameters];
        [self setPTMRatio:PTM_RATIO];
        [self setBody:body];
        [self setPosition:p];
        originalPosition = p;
        
    #ifdef DEBUG_BOX2D
        [self setOpacity:16];
    #endif
    //    [self setFlipX:YES];
        [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0];
    }
    return self;
}
//----------------------------------------------------------------------------------------------------------------------
-(CCAnimate*) createAnimation:(NSString *)name withSpeed:(double) speed{

    CCAnimation *animation= [[CCAnimationCache sharedAnimationCache] animationByName:name];
    
    if (animation == nil) {
        
        NSMutableArray *anim = [[NSMutableArray alloc] init];
        
        int i = 0;
        id obj = nil;
        do {
            obj = ANIM_FRAME(name, i++);
            if (obj!=nil)[anim addObject: obj];
            
        }while (obj!=nil);
        
        animation = [CCAnimation animationWithFrames:anim delay:speed];
        [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:name];
        [anim removeAllObjects];
        [anim release];
        
    }
    return [CCAnimate actionWithAnimation:animation restoreOriginalFrame: YES];
}


//----------------------------------------------------------------------------------------------------------------------
-(void) pauseAnimation {
    [animloop setDuration:0];
    body->SetLinearVelocity(b2Vec2(0,0));
}
//----------------------------------------------------------------------------------------------------------------------

-(void) resumeAnimation {
    [animloop setDuration:0.45];
    
}
//----------------------------------------------------------------------------------------------------------------------

-(void) walkRight {
    body->SetLinearVelocity(b2Vec2(igfloat(4),0));
}
//----------------------------------------------------------------------------------------------------------------------

-(void) walkLeft {
    body->SetLinearVelocity(b2Vec2(igfloat(-4),0));
}
//----------------------------------------------------------------------------------------------------------------------
-(void) startAnimation {
    if (type == ENEMY_TYPE_SPIKE) {
        [self setDisplayFrame:ANIM_FRAME(@"spike-walk", [ AppSettings getCurrenStage ] ) ];
        return;
    }
    animloop = [self createAnimation:[NSString stringWithFormat:@"%@-walk",enemyname] withSpeed:1.0/10.0];
    [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
                                                       animloop,
                                                       nil]]];
    switch (type) {
        case ENEMY_TYPE_RED:
            [self runAction:[CCRepeatForever actionWithAction:
                             [CCSequence actions:
                                [CCMoveTo actionWithDuration:0 position:originalPosition],
                              [CCMoveBy actionWithDuration:4 position:ccp(igfloat(256),0)],
                              [CCFlipX actionWithFlipX:YES],
                              [CCMoveBy actionWithDuration:4 position:ccp(igfloat(-256),0)],
                              [CCFlipX actionWithFlipX:NO],
                              nil]]];
            break;

        case ENEMY_TYPE_BLUE:
            [self runAction:[CCRepeatForever actionWithAction:
                             [CCSequence actions:
                                  [CCMoveTo actionWithDuration:0 position:originalPosition],
                                  [CCMoveBy actionWithDuration:2 position:ccp(igfloat(128),0)],
                                  [CCFlipX actionWithFlipX:YES],
                                  [CCMoveBy actionWithDuration:2 position:ccp(igfloat(-128),0)],
                                  [CCFlipX actionWithFlipX:NO],
                                   nil]]];

            break;
        
        case ENEMY_TYPE_ROBOT:
            [self runAction:[CCRepeatForever actionWithAction:
                             [CCSequence actions:
                              [CCMoveTo actionWithDuration:0 position:originalPosition],
                              [CCCallFuncN actionWithTarget:self selector:@selector(walkRight)],
                              [CCDelayTime actionWithDuration:2],
                              [CCCallFuncN actionWithTarget:self selector:@selector(pauseAnimation)],
                              [CCDelayTime actionWithDuration:1.5],
                              [CCCallFuncN actionWithTarget:self selector:@selector(resumeAnimation)],
                              [CCFlipX actionWithFlipX:YES],
                              [CCCallFuncN actionWithTarget:self selector:@selector(walkLeft)],
                              [CCDelayTime actionWithDuration:2],
                              [CCCallFuncN actionWithTarget:self selector:@selector(pauseAnimation)],
                              [CCDelayTime actionWithDuration:1.5],
                              [CCCallFuncN actionWithTarget:self selector:@selector(resumeAnimation)],
                              [CCFlipX actionWithFlipX:NO],
                              nil]]];
            break;
            
        default:
            break;
    }
}
//----------------------------------------------------------------------------------------------------------------------
-(void) die {
    if (dying) return;
//    [[SimpleAudioEngine sharedEngine] playEffect:@"Limb-0.mp3"];
    [[ SoundManager sharedSoundManager ] playEffect:kLimb_0 bForce:FALSE ];
    dying = YES;
    body->SetActive(NO);
    [self stopAllActions];
    [self runAction:[CCSequence actions:
                     [CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,igfloat(-1000))]],
                     [CCCallFuncN actionWithTarget:self selector:@selector(removeFromParentAndCleanup:)],
                     nil]];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) checkIsActive {
    if (body->IsActive() == NO) {
        [self die];
    }
}
//----------------------------------------------------------------------------------------------------------------------

@end
