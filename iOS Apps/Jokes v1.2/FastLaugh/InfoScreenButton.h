//
//  InfoScreenButton.h
//  StacheMash
//
//  Created by Konstantin Sokolinskyi on 2/14/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoScreenButton : UIView

- (id)initWithButton: (UIButton*)btn
                text: (NSString*)text
 labelWidthExtension: (CGFloat)widthExtension;

@property (strong, readonly) UIButton *button;

@end
