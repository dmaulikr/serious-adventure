//
//  HighlightedButton.h
//  StacheMash
//
//  Created by Konstantin Sokolinskyi on 2/13/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighlightedButton : UIView

- (id)initWithButton: (UIButton*)btn highlightImageName: (NSString*)highlightImageName;
+ (id)bottomBarButtonWithButton: (UIButton*)btn;
+ (id)stacheSelectionButtonWithButton: (UIButton*)btn;

@property (strong, readonly, nonatomic) UIButton *button;


@end
