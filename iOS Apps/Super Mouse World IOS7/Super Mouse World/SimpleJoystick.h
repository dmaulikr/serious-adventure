//
//  SimpleJoystick.h
//  Mighty Possum World
//
//  Created by Luiz Menezes on 21/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "cocos2d.h"

enum SIMPLE_JOYSTIC_DIRECTION {
    JOYSTICK_DIRECTION_NONE,
    JOYSTICK_DIRECTION_LEFT,
    JOYSTICK_DIRECTION_RIGHT,
    
    };

@interface SimpleJoystick : CCLayer
{
    CCSprite *joyImage;
    CCSprite *buttonImage;
    CGRect rButton;
}

@property (nonatomic,assign) int direction;
@property (nonatomic,assign) BOOL buttonPressed;
@end
