//
//  GrowButton.h
//  Game
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GrowIconButton : CCMenu 
{    
	CCSprite* _iconSprite;
}

@property (nonatomic, retain) CCSprite* iconSprite;

+ (GrowIconButton*)buttonWithSprite:(NSString*)normalImage
						selectImage: (NSString*) selectImage
						  iconImage: (NSString*) iconImage
							posIcon:(CGPoint) posIcon
							 target:(id)target
						   selector:(SEL)sel;

+ (GrowIconButton*)buttonWithSpriteFrame:(NSString*)frameName 
							selectframeName: (NSString*) selectframeName
							   iconframeName: (NSString*) iconframeName
								 posIcon:(CGPoint) posIcon
								  target:(id)target
								selector:(SEL)sel;

- (void) setIconSpriteFrame: (NSString*) frameName;
- (void) setIconVisible: (BOOL) visible;
@end
