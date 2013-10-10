//
//  GrowButton.m
//  Game
//
//

#import "GrowIconButton.h"


@implementation GrowIconButton
@synthesize iconSprite=_iconSprite;

+ (GrowIconButton*)buttonWithSprite:(NSString*)normalImage 
						selectImage:(NSString *)selectImage
						  iconImage:(NSString *)iconImage 
							posIcon:(CGPoint) posIcon
							 target:(id)target
						   selector:(SEL)sel
{
	CCSprite *normalSprite = [CCSprite spriteWithFile:normalImage];
	CCSprite *selectSprite = [CCSprite spriteWithFile:selectImage];
	CCSprite *iconSprite = [CCSprite spriteWithFile:iconImage];

	assert(normalSprite);
	assert(selectSprite);
	assert(iconSprite);
	
	CCMenuItem *menuItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite
												   selectedSprite:selectSprite
														   target:target
														 selector:sel];
	[iconSprite setPosition: posIcon];
	[menuItem addChild: iconSprite];
	GrowIconButton *menu = [GrowIconButton menuWithItems:menuItem, nil];
	menu.iconSprite = iconSprite;
	return menu;	
}

+ (GrowIconButton*)buttonWithSpriteFrame:(NSString*) frameName 
						 selectframeName:(NSString *)selectframeName
						   iconframeName: (NSString*) iconframeName
								 posIcon:(CGPoint) posIcon
								  target:(id)target
								selector:(SEL)sel
{
	CCSprite *normalSprite = [CCSprite spriteWithSpriteFrameName:frameName];
	CCSprite *selectSprite = [CCSprite spriteWithSpriteFrameName:selectframeName];
	CCSprite *iconSprite = [CCSprite spriteWithSpriteFrameName:iconframeName];
	
	assert(normalSprite);
	assert(selectSprite);
	assert(iconSprite);
	
	CCMenuItem *menuItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite
												   selectedSprite:selectSprite
														   target:target
														 selector:sel];
	[iconSprite setPosition: posIcon];
	[menuItem addChild: iconSprite];
	GrowIconButton *menu = [GrowIconButton menuWithItems:menuItem, nil];
	menu.iconSprite = iconSprite;
	return menu;	
}

- (void) setIconSpriteFrame: (NSString*) frameName {
	CCSpriteFrameCache* cache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[_iconSprite setDisplayFrame: [cache spriteFrameByName: frameName]];
}

- (void) setIconVisible: (BOOL) visible {
	[_iconSprite setVisible: visible];
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

- (void) animateFocusMenuItem: (CCMenuItem*) menuItem
{
	id movetozero = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	id ease = [CCEaseBackOut actionWithAction:movetozero];
	id movetozero1 = [CCScaleTo actionWithDuration:0.1f scale:1.15f];
	id ease1 = [CCEaseBackOut actionWithAction:movetozero1];
	id movetozero2 = [CCScaleTo actionWithDuration:0.1f scale:1.2f];
	id ease2 = [CCEaseBackOut actionWithAction:movetozero2];
	id sequence = [CCSequence actions: ease, ease1, ease2, nil];
	[menuItem runAction:sequence];	
}

- (void) animateFocusLoseMenuItem: (CCMenuItem*) menuItem
{
	id movetozero = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
	id ease = [CCEaseBackOut actionWithAction:movetozero];
	id movetozero1 = [CCScaleTo actionWithDuration:0.1f scale:1.05];
	id ease1 = [CCEaseBackOut actionWithAction:movetozero1];
	id movetozero2 = [CCScaleTo actionWithDuration:0.1f scale:1.0];
	id ease2 = [CCEaseBackOut actionWithAction:movetozero2];
	id movetozero3 = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
	id ease3 = [CCEaseBackOut actionWithAction:movetozero3];
	id sequence = [CCSequence actions: ease,ease1, ease2, ease3, nil];
	[menuItem runAction:sequence];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( state_ != kCCMenuStateWaiting || !visible_ )
		return NO;
	
	selectedItem_ = [self itemForTouch:touch];
	[selectedItem_ selected];
	
	if( selectedItem_ ) {
		[self animateFocusMenuItem: selectedItem_];
		state_ = kCCMenuStateTrackingTouch;
		return YES;
	}
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchEnded] -- invalid state");
	
	[selectedItem_ unselected];
	[selectedItem_ activate];
	state_ = kCCMenuStateWaiting;

	[self animateFocusLoseMenuItem: selectedItem_];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchCancelled] -- invalid state");
	
	[selectedItem_ unselected];
	
	[self animateFocusLoseMenuItem: selectedItem_];
	state_ = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state_ == kCCMenuStateTrackingTouch, @"[Menu ccTouchMoved] -- invalid state");
	
	CCMenuItem *currentItem = [self itemForTouch:touch];
	
	if (currentItem != selectedItem_) {
		[self animateFocusLoseMenuItem: selectedItem_];
		[self animateFocusMenuItem: currentItem];
		[selectedItem_ unselected];
		selectedItem_ = currentItem;
		[selectedItem_ selected];
	}
}

- (void) dealloc {
	self.iconSprite = nil;
	[super dealloc];
}

@end
