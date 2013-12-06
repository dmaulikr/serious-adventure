//
//  GameScene.h
//  Mighty Possum World
//
//  Created by Luiz Menezes on 21/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "cocos2d.h"
#import "HelloWorldLayer.h"

@interface GameScene : CCScene
{
    CCLabelTTF *world;
    CCLabelTTF *vidas;
    CCLabelTTF *time;
    CCLabelTTF *coins;
    CCLabelTTF *score;
    HelloWorldLayer *game;
    int timeOut;
    int lifes;
    int points;
    
    BOOL        m_bIsPlay;
    
}

@property (nonatomic, assign ) BOOL m_bIsPlay;

+(CCScene *) scene;
@end
