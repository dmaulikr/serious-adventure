//
//  Collectable.m
//  Mighty Possum World
//
//  Created by Luiz Menezes on 23/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "Collectable.h"
#import "SoundManager.h"

@implementation Collectable
@synthesize isCoin;
//----------------------------------------------------------------------------------------------------------------------

- (id)initWithWorld:(b2World*)world andPosition:(CGPoint)p andWidth:(double)w andIsCoin:(BOOL) _isCoin{
    self = [super initWithSpriteFrameName:_isCoin?@"collectable_0.png":@"Key.png"];
    isCoin = _isCoin;
    [self setAnchorPoint:ccp(0,0)];
    dying = NO;

    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;

    body = world->CreateBody(&bodyDef);
    body->SetFixedRotation(YES);
    body->SetSleepingAllowed(YES);
    
     b2FixtureDef fixtureDef;
    
    
    if (isCoin) {
        b2CircleShape dynamicBox;
        dynamicBox.m_radius = igfloat(20)/PTM_RATIO;
        dynamicBox.m_p = b2Vec2(igfloat(20)/PTM_RATIO,igfloat(20)/PTM_RATIO);
        if (IS_IPHONE) {
            dynamicBox.m_radius = igfloat(16)/PTM_RATIO;

            dynamicBox.m_p = b2Vec2(igfloat(16)/PTM_RATIO,igfloat(16)/PTM_RATIO);
        }
        fixtureDef.shape = &dynamicBox;
    } else {
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(igfloat(24.0)/PTM_RATIO, igfloat(48.0)/PTM_RATIO, b2Vec2(igfloat(50.0)/PTM_RATIO,igfloat(70.0)/PTM_RATIO), 0);
        fixtureDef.shape = &dynamicBox;
    }

    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.5f;
    fixtureDef.isSensor = YES;
    body->CreateFixture(&fixtureDef);
    body->SetUserData((void*)OBJECT_TYPE_COIN);
        [[self texture] setAliasTexParameters];
    [self setPTMRatio:PTM_RATIO];
    [self setBody:body];
    [self setPosition:p];

#ifdef DEBUG_BOX2D
    [self setOpacity:16];
#endif
    if (isCoin) [self performSelector:@selector(startCoinAnimation:) withObject:nil afterDelay:(((p.x+p.y)/w)/4.0)];

    return self;
}
//----------------------------------------------------------------------------------------------------------------------
-(CCAnimate*) createAnimation:(NSString *)name withSpeed:(double) speed{
    CCAnimation *animation= [[CCAnimationCache sharedAnimationCache] animationByName:name];
    
    if (animation == nil) {
        
        NSMutableArray *anim = [[NSMutableArray alloc] init];
        
        int i = 0;
        BOOL exit = NO;
        id obj = nil;
        
        while (exit == NO){
            if (i==8) {
                i=0;
                exit = YES;
            }
            obj = ANIM_FRAME(name, i++);
            [anim addObject: obj];
            
        }
        
        animation = [CCAnimation animationWithFrames:anim delay:speed];
        [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:name];
        [anim removeAllObjects];
        [anim release];
        
    }
    return [CCAnimate actionWithAnimation:animation restoreOriginalFrame: YES];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) startCoinAnimation:(CCSprite*)p {
    [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
                                                    [CCDelayTime actionWithDuration:1],
                                                    [self createAnimation:@"collectable" withSpeed:1.0/10.0],
                                                    nil]]];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) die {
    if (dying) return;
    dying = YES;
    body->SetActive(NO);
    [self stopAllActions];
    

    if (isCoin) {
        
//        [[SimpleAudioEngine sharedEngine] playEffect:@"mono-CoinDrop-0.mp3"];
        [ [ SoundManager sharedSoundManager ] playEffect:kMonoCoinDrop bForce:FALSE ];
        [self runAction:[CCSequence actions:
    //                     [CCFadeTo actionWithDuration:0.25 opacity:0],
                         [CCCallFuncN actionWithTarget:self selector:@selector(removeFromParentAndCleanup:)],
                         nil]];
        
    } else {
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"endstage.mp3" loop:NO];
//        [ [ SoundManager sharedSoundManager ] playBackgroundMusic:kbEndStage ];
        [ [ SoundManager sharedSoundManager ] playBackgroundMusic:kbEndStage bLoopState:NO ];
        POST_NOTIFICATION(@"CHANGE_TO_NEXT_STAGE", nil);
    }
}
//----------------------------------------------------------------------------------------------------------------------
-(void) checkIsActive {
    if (body->IsActive() == NO) {
        [self die];
    }
}
//----------------------------------------------------------------------------------------------------------------------

@end
