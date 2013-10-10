//
//  GrowButton.h
//  Game
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GrowButton : CCMenu 
{    
}

+ (GrowButton*)buttonWithSprite:(NSString*)normalImage
					selectImage: (NSString*) selectImage
					  target:(id)target
					selector:(SEL)sel;

+ (GrowButton*)buttonWithSpriteFrame:(NSString*)frameName 
						 selectframeName: (NSString*) selectframeName
						 target:(id)target
					   selector:(SEL)sel;

@end
