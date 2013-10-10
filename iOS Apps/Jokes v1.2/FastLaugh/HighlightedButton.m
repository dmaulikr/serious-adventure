//
//  HighlightedButton.m
//  StacheMash
//
//  Created by Konstantin Sokolinskyi on 2/13/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import "HighlightedButton.h"

static const NSTimeInterval kTimeLimit = 0.1;

@interface HighlightedButton ()

@property (strong, nonatomic) UIImageView *highlightImageView;
@property (strong, nonatomic) NSDate *touchDownTimeStamp;

- (void)touchDown: (id)sender;
- (void)touchUp: (id)sender;
- (void)fadeOutHighlight: (id)sender;

@end


@implementation HighlightedButton

@synthesize highlightImageView = _highlightImageView;
@synthesize touchDownTimeStamp = _touchDownTimeStamp;
@synthesize button = __button;

+ (id)bottomBarButtonWithButton: (UIButton*)btn
{
    return [[HighlightedButton alloc] initWithButton: btn highlightImageName: @"bar-button-highlight.png"];
}


+ (id)stacheSelectionButtonWithButton: (UIButton*)btn 
{
    return [[HighlightedButton alloc] initWithButton: btn highlightImageName: @"press.png"];
}


- (id)initWithButton: (UIButton*)btn highlightImageName: (NSString*)highlightImageName
{
    self = [self initWithFrame: btn.bounds];
    if ( self ) {
        // HIGHLIGHTING
        self.highlightImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: highlightImageName]];
        self.highlightImageView.center = CGPointMake(round( 0.5 * self.bounds.size.width),
                                                     round( 0.5 * self.bounds.size.height));
        self.highlightImageView.userInteractionEnabled = YES;
        self.highlightImageView.alpha = 0.0;
        
        [self addSubview: self.highlightImageView];
        
        // BUTTON
        btn.frame = btn.bounds;
        [btn addTarget: self action: @selector(touchDown:) forControlEvents: UIControlEventTouchDown];
        [btn addTarget: self action: @selector(touchDown:) forControlEvents: UIControlEventTouchDragEnter];
        
        [btn addTarget: self action: @selector(touchUp:) forControlEvents: UIControlEventTouchUpInside];
        [btn addTarget: self action: @selector(touchUp:) forControlEvents: UIControlEventTouchUpOutside];
        [btn addTarget: self action: @selector(touchUp:) forControlEvents: UIControlEventTouchCancel];
        [btn addTarget: self action: @selector(touchUp:) forControlEvents: UIControlEventTouchDragExit];
        
        __button = btn;
        [self addSubview: __button];
    }
    
    return self;
}


- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)touchDown: (id)sender
{
    self.highlightImageView.alpha = 1.0;
    self.touchDownTimeStamp = [NSDate dateWithTimeIntervalSinceNow: 0];
}


- (void)touchUp: (id)sender
{
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow: 0];
    NSTimeInterval delta = [now timeIntervalSinceDate: self.touchDownTimeStamp];
    
    
    NSTimeInterval timeLeft = kTimeLimit - delta;
    
    if ( 0 < timeLeft ) {
        [self performSelector: @selector(fadeOutHighlight:) withObject: self afterDelay: kTimeLimit];
    }
    else {
        [self fadeOutHighlight: self];
    }
}


- (void)fadeOutHighlight: (id)sender
{
    self.highlightImageView.alpha = 1.0;
}


#pragma mark - @property (readonly, nonatomic) UIButton *button;

- (UIButton*)button
{
    return __button;
}



@end
