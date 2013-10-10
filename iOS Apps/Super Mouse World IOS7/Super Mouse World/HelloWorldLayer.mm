//
//  HelloWorldLayer.mm
//  Super Mouse World
//
//  Created by Luiz Menezes on 18/10/12.
//  Copyright Thetis Games 2012. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "CCTMXMapInfo+TMXParserExt.h"
#import "Collectable.h"
#import "Enemy.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "AppSettings.h"
#import "SoundManager.h"
#import "AppDelegate.h"

enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@implementation HelloWorldLayer

@synthesize coins,points;
//----------------------------------------------------------------------------------------------------------------------

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
//----------------------------------------------------------------------------------------------------------------------

-(void) readGroundLayer {
    // create Box2d polygons for map collision boundaries
    CCTMXObjectGroup *collisionObjects = [mapa objectGroupNamed:@"ground"];
    NSMutableArray *polygonObjectArray = [collisionObjects objects];
    // TMX polygon points delimiters (Box2d points must have counter-clockwise winding)
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString: @",. "];
    int x, y, n;
//    float area;
    NSString *pointsString;
    NSArray *pointsArray;
//    NSLog(@"array: %@",polygonObjectArray);
    for (id object in polygonObjectArray)
    {
        pointsString = [object valueForKey:@"polylinePoints"];
        if (pointsString != NULL)
        {
            x = [[object valueForKey:@"x"] doubleValue] / CC_CONTENT_SCALE_FACTOR();
            y = [[object valueForKey:@"y"] doubleValue] / CC_CONTENT_SCALE_FACTOR();
            x = igfloat(x);
            y = igfloat(y);
            if (IS_IPHONE) {
                //                x/=2.0;
                y+=256.0+128.0+16.0;
            }
            pointsArray = [pointsString componentsSeparatedByCharactersInSet:characterSet];
            n = pointsArray.count;
            int k =0;
            double posY = [[pointsArray objectAtIndex:3+k] doubleValue];
            posY = igfloat(posY);
            if (y>posY) {
                posY*=-1;
            }
            CGPoint p1 = ccp(igfloat([[pointsArray objectAtIndex:0+k] doubleValue])+x,igfloat([[pointsArray objectAtIndex:1+k] doubleValue])+y);
            CGPoint p2 = ccp(igfloat([[pointsArray objectAtIndex:2+k] doubleValue])+x,posY+y);
            

            //NSLog(@"p1(%f,%f) -> p2(%f,%f) -> %@",p1.x,p1.y,p2.x,p2.y,pointsArray);
            if (p1.x > p2.x) {
                CGPoint temp = p1;
                p1 = p2;
                p2 = temp;
            }
 
            if (p1.y==p2.y) {
                p1.x += igfloat(6);
                p2.x -= igfloat(6);
            }
            
            b2EdgeShape lineGround;

            lineGround.Set(b2Vec2(p1.x/PTM_RATIO,p1.y/PTM_RATIO),b2Vec2(p2.x/PTM_RATIO,p2.y/PTM_RATIO));

            @try {
                b2BodyDef bodyDef;
                bodyDef.type = b2_staticBody;
                
                b2Body *body = world->CreateBody(&bodyDef);
                // Define the dynamic body fixture.
                b2FixtureDef fixtureDef;
                fixtureDef.shape = &lineGround;
                fixtureDef.density = 1.0f;
                fixtureDef.friction = 1.0f;         //1.0f;
                body->CreateFixture(&fixtureDef);
                body->SetUserData((void*)OBJECT_TYPE_GROUND);

            }
            @catch (NSException *exception) {
                NSLog(@"exception: %@",exception);
            }
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------

-(void) readCollisionLayer
{

    // create Box2d polygons for map collision boundaries
    CCTMXObjectGroup *collisionObjects = [mapa objectGroupNamed:@"colisao"];
    NSMutableArray *polygonObjectArray = [collisionObjects objects];
    // TMX polygon points delimiters (Box2d points must have counter-clockwise winding)
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString: @", "];
    int x, y, n, i, k, fX, fY;
    float area;
    NSString *pointsString;
    NSArray *pointsArray;
    for (id object in polygonObjectArray)
    {
        pointsString = [object valueForKey:@"polygonPoints"];
        if (pointsString != NULL)
        {
            x = [[object valueForKey:@"x"] intValue] / CC_CONTENT_SCALE_FACTOR();
            y = [[object valueForKey:@"y"] intValue] / CC_CONTENT_SCALE_FACTOR();
            
            x = igfloat(x);
            y = igfloat(y);
//
            if (IS_IPHONE) {
//                x/=2.0;
                y+=256.0+128.0+16.0;
            }
//            NSLog(@"x: %d, y: %d -> object:%@",x,y,object);

            pointsArray = [pointsString componentsSeparatedByCharactersInSet:characterSet];
            n = pointsArray.count;
            b2PolygonShape shape;
            shape.m_vertexCount = n/2;
            if (shape.m_vertexCount > b2_maxPolygonVertices)
            {
                // polygon has too many vertices, so skip over object
                NSLog(@"%s skipped TMX polygon at x=%d,y=%d for exceeding %d vertices", __PRETTY_FUNCTION__, x, y, b2_maxPolygonVertices);
                continue;
            }
            // build polygon verticies;
            for (i = 0, k = 0; i < n; ++k)
            {
                fX = [[pointsArray objectAtIndex:i] doubleValue] / CC_CONTENT_SCALE_FACTOR();
                ++i;
                // flip y-position (TMX y-origin is upper-left)
                fY = - [[pointsArray objectAtIndex:i] doubleValue] / CC_CONTENT_SCALE_FACTOR();
                ++i;
                fX = igfloat(fX);
                fY = igfloat(fY);
                shape.m_vertices[k].Set((fX/PTM_RATIO)+(x/PTM_RATIO), (fY/PTM_RATIO)+(y/PTM_RATIO));
            }
            // calculate area of a simple (ie. non-self-intersecting) polygon,
            // because it will be negative for counter-clockwise winding
            area = 0.0;
            n = shape.m_vertexCount;
            for (i = 0; i < n; ++i)
            {
                k = (i + 1) % n;
                area += (shape.m_vertices[k].x * shape.m_vertices[i].y) - (shape.m_vertices[i].x * shape.m_vertices[k].y);
            }
            if (area > 0)
            {
                // reverse order of vertices, because winding is clockwise
                b2PolygonShape reverseShape;
                reverseShape.m_vertexCount = shape.m_vertexCount;
                for (i = n - 1, k = 0; i > -1; --i, ++k)
                {
                    reverseShape.m_vertices[i].Set(shape.m_vertices[k].x, shape.m_vertices[k].y);
                }
                shape = reverseShape;
            }
            @try {
                if (shape.m_vertexCount>8) {
                    NSLog(@"maior que 8");
                    continue;
                }
                
//                printf("\nshape (%d): ",shape.m_vertexCount);
//                for (int i =0;i<shape.m_vertexCount;i++) {
//                    printf("(%f,%f) ",shape.m_vertices[i].x,shape.m_vertices[i].y);
//                }
//                printf("\n");
                // must call 'Set', because it processes points
                shape.Set(shape.m_vertices, shape.m_vertexCount);
                
                b2BodyDef bodyDef;
                bodyDef.type = b2_staticBody;
                b2Body *body = world->CreateBody(&bodyDef);

                b2FixtureDef fixtureDef;
                fixtureDef.shape = &shape;
                fixtureDef.density = 1.0f;
                fixtureDef.friction = 0;         //1.0f;
                body->CreateFixture(&fixtureDef);
                body->SetUserData((void*)OBJECT_TYPE_WALL);

            }
            @catch (NSException *exception) {

            }
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------
-(void) loadSprites {
    for (int i =0;i<=7;i++) {
        NSString *name = [NSString stringWithFormat:@"collectable_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }

    for (int i =0;i<=5;i++) {
        NSString *name = [NSString stringWithFormat:@"mouse0%d_000%d.png",[ AppSettings getCurrentPlayer ] + 1, i + 1 ];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
    
    for (int i =0;i<=7;i++) {
        NSString *name = [NSString stringWithFormat:@"gripe-walk_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
    
    for (int i =0;i<=7;i++) {
        NSString *name = [NSString stringWithFormat:@"snipe-walk_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
    
    for (int i =0;i<=3;i++) {
        NSString *name = [NSString stringWithFormat:@"robot-walk_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
    
    for (int i =0;i<=3;i++) {
        NSString *name = [NSString stringWithFormat:@"gripe-die_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
    
    for (int i =0;i<=3;i++) {
        NSString *name = [NSString stringWithFormat:@"snipe-die_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
    
    for (int i =0;i<=0;i++) {
        NSString *name = [NSString stringWithFormat:@"robot-die_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }

    for (int i =0;i<=3;i++) {
        NSString *name = [NSString stringWithFormat:@"spike-walk_%d.png",i];
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
    
    for (int i =0;i<=0;i++) {
        NSString *name = @"Key.png";
        CCSprite *pm = [CCSprite spriteWithFile:name];
        CCSpriteFrame *f = [[CCSpriteFrame alloc] initWithTexture:pm.texture rect:CGRectMake(0, 0, pm.boundingBox.size.width, pm.boundingBox.size.height)];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:name];
    }
}
//----------------------------------------------------------------------------------------------------------------------
-(void) readHero {
    CCTMXObjectGroup *objects = [mapa objectGroupNamed:@"colisao"];
    NSMutableDictionary *spawnPoint = [objects objectNamed:@"personagem"];
    int x = [[spawnPoint valueForKey:@"x"] intValue];
    int y = [[spawnPoint valueForKey:@"y"] intValue];
    [self createHeroAtPosition:ccp(x,y)];
}
//----------------------------------------------------------------------------------------------------------------------
-(void) readCoins {
    collectables = [[NSMutableArray arrayWithCapacity:10] retain];
    
    CCTMXLayer *targetsLayer = [mapa layerNamed:@"itens"];
    CGSize s = [targetsLayer layerSize];
    
    for( int x=0; x<s.width;x++) {
        for( int y=0; y< s.height; y++ ) {
            unsigned int tileGid = [targetsLayer tileGIDAt:ccp(x,y)];
            NSDictionary* properties = [mapa propertiesForGID:tileGid];
            NSString *type = [properties objectForKey:@"item"];
            if (tileGid) {
                
                Collectable *c = [[[Collectable alloc] initWithWorld:world andPosition:[targetsLayer positionAt:ccp(x,y)] andWidth:s.width andIsCoin:[type isEqualToString:@"collectable"]] autorelease];
                [mapa addChild:c ];
                [collectables addObject:c];
                [targetsLayer removeTileAt:ccp(x,y)];
            }
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------
-(void) readEnemys {
    enemys = [[NSMutableArray arrayWithCapacity:10] retain];
    
    CCTMXLayer *targetsLayer = [mapa layerNamed:@"inimigos"];
    CGSize s = [targetsLayer layerSize];
    
    for( int x=0; x<s.width;x++) {
        for( int y=0; y< s.height; y++ ) {
            unsigned int tileGid = [targetsLayer tileGIDAt:ccp(x,y)];
            if (tileGid) {
                NSDictionary* properties = [mapa propertiesForGID:tileGid];

                Enemy *c = [[[Enemy alloc] initWithWorld:world andPosition:[targetsLayer positionAt:ccp(x,y)] withName:[properties objectForKey:@"enemy"]] autorelease];
                [mapa addChild:c z:c.type];
                [enemys addObject:c];
                [targetsLayer removeTileAt:ccp(x,y)];
            }
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------

-(void) readBorders {
    //	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
    groundBody->SetUserData((void*)OBJECT_TYPE_BORDER);

	// Define the ground box shape.
	b2EdgeShape groundBox;

	CGSize s = mapSize;
    s.width*=(igfloat(32.0)/PTM_RATIO);
    s.height*=(igfloat(32.0)/PTM_RATIO);

    // bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width,0));
	groundBody->CreateFixture(&groundBox,0);
	
//	// top
//	groundBox.Set(b2Vec2(0,s.height), b2Vec2(s.width,s.height));
//	groundBody->CreateFixture(&groundBox,0);
	
//	// left
//	groundBox.Set(b2Vec2(0,s.height), b2Vec2(0,0));
//	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width,s.height), b2Vec2(s.width,0));
	groundBody->CreateFixture(&groundBox,0);
}

//----------------------------------------------------------------------------------------------------------------------
-(void) stageComplete {
    
    [ [ AppController get ] submitScore:points ];
    [ [ AppController get ] dispAdvertise ];
    [ AppSettings addCoin:coins ];
    
    [self stopAllActions];
    [self unscheduleUpdate];
    [self unscheduleAllSelectors];
    CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 1) width:MAXFLOAT height:MAXFLOAT];
    [bg setPosition:ccp(0,0)];
    [self addChild:bg z:MAXFLOAT];
    [bg runAction:[CCEaseSineIn actionWithAction:[CCFadeTo actionWithDuration:0.5 opacity:200]]];
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
            if (i==3) {
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

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	REMOVE_OBSERVER();
	[super dealloc];
}
//----------------------------------------------------------------------------------------------------------------------

-(void) initPhysics
{
	
//	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, igfloat(-50.0f));
	world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(true);
	contactListener = new MyContactListener();
    world->SetContactListener(contactListener);

    
#ifdef DEBUG_BOX2D
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
#endif
	
}
//----------------------------------------------------------------------------------------------------------------------

#ifdef DEBUG_BOX2D
-(void) draw
{
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	world->DrawDebugData();
	kmGLPopMatrix();
    [super draw];
}
#endif
//----------------------------------------------------------------------------------------------------------------------
-(void) pos {
//        [self setPosition:ccp(-10*32, -50)];
}
-(void) createHeroAtPosition:(CGPoint)p {
    p.y += igfloat(4);
    p.x += igfloat(32);
    if (IS_IPHONE) {
        p.y+=512+256;
        p.x += 32;
    }
    hero = [[[Hero alloc] initWithWorld:world andPosition:p andJoystick:joystick] autorelease];
    [mapa addChild:hero];
    [self runAction:[CCFollow actionWithTarget:hero worldBoundary:CGRectMake(0, 0, mapSize.width*igfloat(32), mapSize.height*igfloat(32))]];
//    [hero runAction:[CCMoveBy actionWithDuration:20 position:ccp(mapSize.width*32,700)]];

//    [self performSelector:@selector(pos) withObject:nil afterDelay:1];
//    joystick.buttonPressed = YES;
//    hero.canJump = YES;
}
//----------------------------------------------------------------------------------------------------------------------
-(void) dieHero {

//    [[NSUserDefaults standardUserDefaults] setInteger:points forKey:@"HERO_POINTS_COUNT"];
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"HERO_LIFE_COUNT"]-1 forKey:@"HERO_LIFE_COUNT"];

    [ AppSettings addCoin:coins ];
    
    [hero die];
    [self stopAllActions];
    [self performSelector:@selector(replace) withObject:nil afterDelay:1.5];
}
//----------------------------------------------------------------------------------------------------------------------

-(void) processCollisions {

    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->_contacts.begin();
        pos != contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        
        b2Body *heroBodyContact=nil;
        b2Body *otherBodyContact = nil;
        
        b2Fixture* fixtureHero = nil;
        b2Fixture* fixtureOther = nil;
        
        if ((int)bodyA->GetUserData()==OBJECT_TYPE_HERO) {
            heroBodyContact = bodyA;
            otherBodyContact = bodyB;
            fixtureHero = contact.fixtureA;
            fixtureOther = contact.fixtureB;
        } else {
            if ((int)bodyB->GetUserData()==OBJECT_TYPE_HERO) {
                heroBodyContact = bodyB;
                otherBodyContact = bodyA;
                fixtureHero = contact.fixtureB;
                fixtureOther = contact.fixtureA;
            }
        }
        
        if (hero!=nil && heroBodyContact!=nil) {
            int otherBodyType = (int)otherBodyContact->GetUserData();
//            NSLog(@"otherBody: %d",otherBodyType);

            //encostou no chao ou plataforma
            if ( hero.jumping &&
                (otherBodyType==OBJECT_TYPE_GROUND||otherBodyType==OBJECT_TYPE_CREEP_GOOD)&&
                (fabs(heroBodyContact->GetLinearVelocity().y)<1)) {
                joystick.buttonPressed = NO;
                hero.jumping = NO;
                return;
            }

    
            //coletou coin
            if (otherBodyType==OBJECT_TYPE_COIN) {
                points += 10;
                otherBodyContact->SetActive(NO);
                coins++;
                POST_NOTIFICATION(@"UPDATE_COINS", nil);
                POST_NOTIFICATION(@"UPDATE_SCORE", nil);
                return;
            }
            
            //encostou no fundo do buraco
            if (otherBodyType==OBJECT_TYPE_BORDER) {
                [self dieHero];
                return;
            }
            
            //colidiu com inimigo
            if (otherBodyType==OBJECT_TYPE_CREEP_BAD) {

                if (fixtureHero->IsSensor() && fixtureOther->IsSensor()) {
                    [hero enemyJump];
                    points += 10;
                    POST_NOTIFICATION(@"UPDATE_SCORE", nil);
                    otherBodyContact->SetActive(NO);
                } else {
                    [self dieHero];                    
                }

                return;
            }

            //encostou no espinho
            if (otherBodyType==OBJECT_TYPE_SPIKE) {
                [self dieHero];
                return;
            }
            
            
            //caiu no buraco
//            if (otherBodyType==OBJECT_TYPE_GROUND) {
//
//                if (!fixtureHero->IsSensor()) {
//                    [joystick setIsTouchEnabled:NO];
//                }
//                return;
//            }
        }

    }

}

//----------------------------------------------------------------------------------------------------------------------
-(void) replace {
    [self unscheduleUpdate];
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [hero stopAllActions];
    for (CCNode *n in [self children]) {
        [n stopAllActions];
        [n unscheduleAllSelectors];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipY transitionWithDuration:0.5 scene:[GameScene scene]]];
}
//----------------------------------------------------------------------------------------------------------------------

-(void) processEnemys {
    if (enemys!=nil ) {
        for (Enemy *c in enemys) {
            [c checkIsActive];
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------

-(void) processCollectables {
    if (collectables!=nil ) {
        for (Collectable *c in collectables) {
            [c checkIsActive];
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------

-(void) moveWorld {
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
        if ((int)b->GetUserData() != OBJECT_TYPE_GROUND) continue;
		for (b2Fixture* f = b->GetFixtureList(); f; f = f->GetNext()) {
            b2Vec2 bPos = b->GetPosition();
            bPos.x = (mundo.position.x/PTM_RATIO);
            bPos.y = (mundo.position.y/PTM_RATIO);
            b->SetTransform(bPos, b->GetAngle());
		}
	}
}
//----------------------------------------------------------------------------------------------------------------------

-(void) update: (ccTime) dt
{
        int32 velocityIterations = 8;
        int32 positionIterations = 1;
        world->Step(dt, velocityIterations, positionIterations);
        
        [hero update:dt];
        
        [self processCollisions];
        [self processCollectables];
        [self processEnemys];
        [self moveWorld];
 
}
//----------------------------------------------------------------------------------------------------------------------
-(id) initWithJoystick:(SimpleJoystick*)_joystick
{
    //    WithColor:ccc4(24, 146, 255, 255)  width:4096 height:768]
    glClearColor(24.0/255.0, 146/255.0, 255/255.0, 1);
    
	if( (self=[super init])) {
		joystick = _joystick;
        hero = nil;
        collectables = nil;
        coins = 0;
        [self loadSprites];
		// enable events
        
		// init physics
		[self initPhysics];
        
        int area = [ AppSettings getCurrenStage ];
        if (area==0) {
            area =1;
            [ AppSettings setCurrentStage:1 ];
        }
        NSString *areaName = [NSString stringWithFormat:@"area0%d.tmx",area];
//        NSString *musicName = [NSString stringWithFormat:@"audio0%d.mp3",area];
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:musicName];
        [ [ SoundManager sharedSoundManager ] playBackgroundMusic:area + kBAudio1 - 1 ];
        mapa = [CCTMXTiledMap tiledMapWithTMXFile:areaName];
        mapSize = [mapa mapSize];
        //        [CCTMXMapInfo applyParserExtension];
        //        CCTMXLayer *foreground = [map layerNamed:@"foreground"];
        //        CCTMXLayer *cenario = [map layerNamed:@"cenario"];
        //        CCTMXLayer *colisao = [map layerNamed:@"colisao"];
        
        [mapa setAnchorPoint:ccp(0,0)];
        [mapa setPosition:ccp(0,0)];
        
        ccTexParams texParams = { GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT };
        
        int stg = [ AppSettings getCurrenStage ]-1;
        
        CCSprite *fg1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"fg1-%d.png",stg]];
        [[fg1 texture] setTexParameters:&texParams];
        [fg1 setTextureRect:CGRectMake(0, 0, mapSize.width*igfloat(32), igfloat(1024))];
        [fg1 setAnchorPoint:CGPointZero];
        
        CCSprite *bg1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bg1-%d.png",stg]];
        [[bg1 texture] setTexParameters:&texParams];
        [bg1 setTextureRect:CGRectMake(0, 0, mapSize.width*igfloat(32), igfloat(1024))];
        [bg1 setAnchorPoint:CGPointZero];
        
#ifdef DEBUG_BOX2D
        [fg1 setOpacity:16];
        [bg1 setOpacity:16];
#endif
        double offY = IS_IPHONE?0:0;
        mundo = [[CCParallaxNode alloc] init];
        [mundo addChild:bg1 z:0 parallaxRatio:ccp(0.25,0.15) positionOffset:ccp(0,offY)];
        [mundo addChild:fg1 z:1 parallaxRatio:ccp(0.5,0.25) positionOffset:ccp(0,offY)];
        [mundo addChild:mapa z:3 parallaxRatio:ccp(1,1) positionOffset:ccp(0,offY)];
        [self addChild:mundo z:0];
        
        [self readBorders];
        [self readCollisionLayer];
        [self readGroundLayer];
        [self readEnemys];
        [self readCoins];
        [self readHero];
        
//        [self setScale:0.5];
//        [self setScale:1.5];
        [self scheduleUpdate];
        
        OBSERVE_NOTIFICATION(@"CHANGE_TO_NEXT_STAGE", @selector(stageComplete));
        
        
	}
	return self;
}

//----------------------------------------------------------------------------------------------------------------------



@end
