//
//  AleartWaitWindow.m
//  MagicCamera
//
//  Created by star com on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AleartWaitView.h"

CGFloat kMargin;

@implementation AleartWaitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frameRect;
        CGFloat fontSize;
        CGFloat indicatorRadius;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            kMargin = 90;
            fontSize = 13;
            indicatorRadius = 20;
        } else {
            kMargin = 90 * 2;
            fontSize = 13 * 2;
            indicatorRadius = 20 * 2;
        }

        //Insert Message Box
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(kMargin, 90 + 10, frame.size.width - kMargin * 2, 15);
        } else {
            frameRect = CGRectMake(kMargin, (90 + 10) * 2, frame.size.width - kMargin * 2, 15 * 2);
        }
        msg_label = [[UILabel alloc] initWithFrame:frameRect];
        msg_label.textAlignment = UITextAlignmentCenter;
        msg_label.text = @"Wait...";
        msg_label.font = [UIFont systemFontOfSize:fontSize];
        msg_label.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        msg_label.backgroundColor = [UIColor clearColor];
        [self addSubview:msg_label];
        [msg_label release];
        
        //Insert indicator
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(frame.size.width / 2 - indicatorRadius, 90 + 40 - indicatorRadius, indicatorRadius * 2, indicatorRadius * 2);
        } else {
            frameRect = CGRectMake(frame.size.width / 2 - indicatorRadius, (90 + 40) * 2 - indicatorRadius, indicatorRadius * 2, indicatorRadius * 2);
        }
        processing_indicator = [[UIActivityIndicatorView alloc] initWithFrame:frameRect];
        [self addSubview:processing_indicator];
        [processing_indicator release];
        
        [processing_indicator startAnimating];
        
//        self.backgroundColor = [UIColor blueColor];
        self.alpha = 0.2;
    }
    return self;
};

- (void)dealloc {
    [msg_label removeFromSuperview];
    [processing_indicator stopAnimating];
    [processing_indicator removeFromSuperview];
    [super dealloc];
}

- (void)setMessage:(NSString *)megString {
    msg_label.text = megString;
}


- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f] setFill];
    [[UIBezierPath bezierPathWithRect:self.frame] fill];
    
    // Drawing code
    CGFloat cornerRadius;
    CGRect backRect;
    CGFloat height;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cornerRadius = 10;
        height = 60;
    } else {
        cornerRadius = 10 * 2;
        height = 60 * 2;        
    }
    
    backRect = CGRectMake(kMargin, kMargin, self.frame.size.width - kMargin * 2, height);
    [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.5f] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:backRect cornerRadius:cornerRadius];
    path.lineWidth = 2.0;
    [path stroke];
    
    backRect = CGRectMake(kMargin + 1, kMargin + 1, self.frame.size.width - kMargin * 2 - 2, height - 2);
    [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f] setFill];
    [[UIBezierPath bezierPathWithRoundedRect:backRect cornerRadius:cornerRadius] fill];
}

@end
