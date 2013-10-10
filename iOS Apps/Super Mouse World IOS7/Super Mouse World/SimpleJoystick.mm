//
//  SimpleJoystick.m
//  Super Mouse World
//
//  Created by Luiz Menezes on 21/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "SimpleJoystick.h"

@implementation SimpleJoystick
@synthesize direction,buttonPressed;
//----------------------------------------------------------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        direction = JOYSTICK_DIRECTION_NONE;
        buttonPressed = NO;
        
        joyImage = [CCSprite spriteWithFile:@"Joystick.png"];
        [joyImage setAnchorPoint:CGPointZero];
        [self addChild:joyImage];
        
        buttonImage = [CCSprite spriteWithFile:@"Button.png"];
        [buttonImage setPosition:ccp(WINSIZE.width,0)];
        [buttonImage setAnchorPoint:ccp(1,0)];
        [self addChild:buttonImage];
        
        [self setIsTouchEnabled:YES];
        
        rButton = buttonImage.boundingBox;

        
    }
    return self;
}

//----------------------------------------------------------------------------------------------------------------------

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	for(UITouch *touch in touches) {
		CGPoint location = [touch locationInView: [touch view]];

		location = [[CCDirector sharedDirector] convertToGL: location];
        if (CGRectContainsPoint(joyImage.boundingBox, location)) {

            if (location.x < joyImage.boundingBox.size.width/2) {
                direction = JOYSTICK_DIRECTION_LEFT;
            } else {
                direction = JOYSTICK_DIRECTION_RIGHT;
            }
        } else {

            if (CGRectContainsPoint(rButton, location)) {
                buttonPressed = YES;
            }
        }
	}
}

//----------------------------------------------------------------------------------------------------------------------

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for(UITouch *touch in touches) {
		CGPoint location = [touch locationInView: [touch view]];
        
		location = [[CCDirector sharedDirector] convertToGL: location];
        if (CGRectContainsPoint(joyImage.boundingBox, location)) {
            
            if (location.x < joyImage.boundingBox.size.width/2) {
                direction = JOYSTICK_DIRECTION_LEFT;
            } else {
                direction = JOYSTICK_DIRECTION_RIGHT;
            }
        }
	}
}

//----------------------------------------------------------------------------------------------------------------------

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for(UITouch *touch in touches) {
		CGPoint location = [touch locationInView: [touch view]];
        
		location = [[CCDirector sharedDirector] convertToGL: location];
        if (CGRectContainsPoint(joyImage.boundingBox, location)) {
             direction = JOYSTICK_DIRECTION_NONE;

        } else {
            if (CGRectContainsPoint(buttonImage.boundingBox, location)) {
                buttonPressed = NO;
            }
        }
	}
   
}

//----------------------------------------------------------------------------------------------------------------------


@end
