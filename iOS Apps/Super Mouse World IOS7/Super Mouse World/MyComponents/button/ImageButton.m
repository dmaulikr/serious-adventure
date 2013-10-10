//
//  GrowButton.m
//  Game
//
//

#import "ImageButton.h"


@implementation ImageButton

+ (ImageButton*)buttonWithSprite:(NSString*)normalImage 
					 selectImage:(NSString *)selectImage
						  target:(id)target
						selector:(SEL)sel
							 tag: (int) tag
{
	CCSprite *normalSprite = [CCSprite spriteWithFile:normalImage];
	CCSprite *selectSprite = [CCSprite spriteWithFile:selectImage];

	assert(normalSprite);
	assert(selectSprite);
	
	CCMenuItem *menuItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite
												   selectedSprite:selectSprite
														   target:target
														 selector:sel];
	menuItem.tag = tag;
	ImageButton *menu = [ImageButton menuWithItems:menuItem, nil];
	return menu;	
}

+ (ImageButton*)buttonWithSpriteFrame:(NSString*) frameName 
					  selectframeName:(NSString *)selectframeName
							   target:(id)target
							 selector:(SEL)sel
								  tag: (int) tag
{
	CCSprite *normalSprite = [CCSprite spriteWithSpriteFrameName:frameName];
	CCSprite *selectSprite = [CCSprite spriteWithSpriteFrameName:selectframeName];
	[selectSprite setColor: ccc3(230, 230, 230)];
	
	assert(normalSprite);
	assert(selectSprite);
	
	CCMenuItem *menuItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite
												   selectedSprite:selectSprite
														   target:target
														 selector:sel];
	menuItem.tag = tag;
	ImageButton *menu = [ImageButton menuWithItems:menuItem, nil];
	return menu;	
}

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
			
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item rect];
			r.origin = CGPointZero;
			
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

@end
