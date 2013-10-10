//
//  GrowButton.h
//  Game
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ImageButton : CCMenu 
{    
}

+ (ImageButton*)buttonWithSprite:(NSString*)normalImage
					 selectImage: (NSString*) selectImage
						  target:(id)target
						selector:(SEL)sel
							 tag: (int) tag;

+ (ImageButton*)buttonWithSpriteFrame:(NSString*)frameName 
							selectframeName: (NSString*) selectframeName
							   target:(id)target
							 selector:(SEL)sel
								  tag: (int) tag;

@end
