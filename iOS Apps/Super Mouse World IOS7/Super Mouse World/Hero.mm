//
//  Hero.m
//  Super Mouse World
//
//  Created by Luiz Menezes on 22/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "Hero.h"
#import "AppSettings.h"
#import "SoundManager.h"

@implementation Hero

@synthesize jumping;
//----------------------------------------------------------------------------------------------------------------------

- (id)initWithWorld:(b2World*)world andPosition:(CGPoint)p andJoystick:(SimpleJoystick*)_joystick
{
    self = [super initWithFile:[ NSString stringWithFormat:@"mouse%02d_0001.png", [ AppSettings getCurrentPlayer ] + 1 ] ];

    if (self) {
                
        joystick = _joystick;
        jumping = NO;
        [self setFlipX:NO];
//        NSString *str = [ NSString stringWithFormat:@"mouse%02d", [ AppSettings getCurrentPlayer ] + 1 ];
//        animationHero = [self createAnimation:str withSpeed:1.0/10.0];

        CCSpriteFrame* frame1, *frame2, *frame3, *frame4;
        
            frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"mouse%02d_0001.png", [ AppSettings getCurrentPlayer ] + 1]];
            frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"mouse%02d_0002.png", [ AppSettings getCurrentPlayer ] + 1]];
            frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"mouse%02d_0003.png", [ AppSettings getCurrentPlayer ] + 1]];
            frame4 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"mouse%02d_0004.png", [ AppSettings getCurrentPlayer ] + 1]];

        CCAnimation *danceAnimation = [CCAnimation animationWithFrames:[NSArray arrayWithObjects:frame1, frame2,frame3, frame4, nil] delay:0.1f];
        
        CCAnimate *danceAction = [CCAnimate actionWithAnimation:danceAnimation];
        animationHero  = [CCRepeatForever actionWithAction:danceAction];

        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(0,0);
        heroBody = world->CreateBody(&bodyDef);
        heroBody->SetFixedRotation(YES);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(igfloat(24.0)/PTM_RATIO, igfloat(24.0)/PTM_RATIO);
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.5f;
        heroBody->CreateFixture(&fixtureDef);
        heroBody->SetUserData((void*)OBJECT_TYPE_HERO);

        b2PolygonShape colisionShape;
        colisionShape.SetAsBox(igfloat(19.0)/PTM_RATIO, igfloat(20.0)/PTM_RATIO,b2Vec2(0,igfloat(-1.375)),0);

        b2FixtureDef colisionGround;
        colisionGround.shape = &colisionShape;
        colisionGround.isSensor = YES;
        colisionGround.density = 0.0f;
        colisionGround.friction = 0.0f;

        heroBody->CreateFixture(&colisionGround);
//        heroBody->SetActive(NO);
        [self runAction:[CCRepeatForever actionWithAction:animationHero]];
        
        [[self texture] setAliasTexParameters];
#ifdef DEBUG_BOX2D
        [self setOpacity:16];
#endif

        [self setPTMRatio:PTM_RATIO];
        [self setBody:heroBody];
        [self setPosition:p];
        [self setAnchorPoint:ccp(0.425,0.525)];
    }
    return self;
}
//----------------------------------------------------------------------------------------------------------------------
-(CCAnimate*) createAnimation:(NSString *)name withSpeed:(double) speed{
    CCAnimation *animation= [[CCAnimationCache sharedAnimationCache] animationByName:name];
    
    if (animation == nil) {
        
        NSMutableArray *anim = [[NSMutableArray alloc] init];
        
        int i = 1;
        BOOL exit = NO;
        id obj = nil;
        
        while (exit == NO){
            if (i==5) {
                i = 1;
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
    return [CCAnimate actionWithAnimation:animation restoreOriginalFrame: NO];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) die {
    heroBody->SetActive(NO);
//    [[SimpleAudioEngine sharedEngine] playEffect:@"mono-wow.mp3"];
    [[ SoundManager sharedSoundManager ] playEffect:kMono_Wow bForce:FALSE ];
    [self stopAllActions];
    CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"mouse%02d_0006.png", [ AppSettings getCurrentPlayer ] + 1]];
    [self setDisplayFrame:frame1 ];
    [self runAction:[CCSequence actions:
                     [CCEaseSineOut actionWithAction:[CCMoveBy actionWithDuration:0.25 position:ccp(0,igfloat(50))]],
                     [CCDelayTime actionWithDuration:0.1],
                     [CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:1 position:ccp(0,igfloat(-1000))]],
                     nil]];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) enemyJump {

    heroBody->SetAngularVelocity(0);
    b2Vec2 impulse = b2Vec2(heroBody->GetLinearVelocity().x,igfloat(230.0)/PTM_RATIO);
    heroBody->SetLinearVelocity(impulse);
}
//----------------------------------------------------------------------------------------------------------------------
-(void) update:(ccTime)delta {
    if (!heroBody->IsActive()) return;
    double x = heroBody->GetLinearVelocity().x*0.95;

    
    if (joystick.direction == JOYSTICK_DIRECTION_LEFT) {
        x = igfloat(-180.0)/PTM_RATIO;
        self.flipX = YES;
        [self setAnchorPoint:ccp(0.575,self.anchorPoint.y)];
    } else {
        if (joystick.direction == JOYSTICK_DIRECTION_RIGHT) {
            x = igfloat(180.0)/PTM_RATIO;
            self.flipX = NO;
            [self setAnchorPoint:ccp(0.425,self.anchorPoint.y)];
        }
    }
    
    double y =heroBody->GetLinearVelocity().y;
    
    if (joystick.buttonPressed == YES)
    {
        if (!jumping) {
//            [[SimpleAudioEngine sharedEngine] playEffect:@"jump.mp3"];
            [[ SoundManager sharedSoundManager ] playEffect:kJump bForce:FALSE ];

            joystick.buttonPressed = NO;
            double maxY = igfloat(31);
            y+= maxY;
            if (y>=maxY) y = maxY;
        }
        jumping = YES;

    }
    heroBody->SetAngularVelocity(0);
    b2Vec2 impulse = b2Vec2(x,y);
    heroBody->SetLinearVelocity(impulse);

    if (animationHero!=nil) {
        if (x==0 || (fabs(heroBody->GetLinearVelocity().y)>0.2 && jumping == YES)) {
//            [animationHero setDuration:0];
//            if( [ self isRunning ] )
//                [ self stopAllActions ];
            
            NSString *strMouse;
            CCSpriteFrame *frame;

            if (heroBody->GetLinearVelocity().y == 0) {
               strMouse  = [ NSString stringWithFormat:@"mouse%02d_0004.png", [ AppSettings getCurrentPlayer ] + 1 ];
            }
            else
            if (heroBody->GetLinearVelocity().y > 0.1) {
                strMouse  = [ NSString stringWithFormat:@"mouse%02d_0005.png", [ AppSettings getCurrentPlayer ] + 1 ];
            }
            else
            if (heroBody->GetLinearVelocity().y < 0.1) {
                strMouse  = [ NSString stringWithFormat:@"mouse%02d_0006.png", [ AppSettings getCurrentPlayer ] + 1 ];
            }
            frame =  [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: strMouse ];
            [ self setDisplayFrame:frame ];
            
        } else {

//            [animationHero setDuration:igfloat(10)/fabs(heroBody->GetLinearVelocity().x)];
            if( ![ self isRunning ] )
                [ self runAction:animationHero ];
        }
        
    }
}
//----------------------------------------------------------------------------------------------------------------------

@end
