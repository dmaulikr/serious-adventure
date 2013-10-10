//
//  ComboButton.h
//  streetFighter
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GrowTextButton : CCMenu {	
	CCLabelBMFont* _titleLabel;
}

@property (nonatomic, retain) CCLabelBMFont* titleLabel;

+ (id)buttonWithSprite: (NSString*) title
		   normalImage: (NSString*)normalImage
		   selectImage: (NSString*) selectImage
				target:(id)target
			  selector:(SEL)sel;

+ (id)buttonWithSpriteFrame: (NSString*) title
			normalframeName:(NSString*)normalframeName 
			selectframeName: (NSString*) selectframeName
					 target:(id)target
				   selector:(SEL)sel
				 centerText: (BOOL) centerText;

- (void) setString: (NSString*) title;

@end
