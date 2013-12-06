//
//  PickerAlertView.m
//  YunPlus
//
//  Created by juxue.chen on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerAlertView.h"

@implementation PickerAlertView

@synthesize pickerView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self createPickerView];
	}
	return self;
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:CGRectMake(0, 0, 300, 300)];//width 默认 284
    UIView *v = self.superview;
    self.center = v.center;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	for (UIView *view in self.subviews) {
		if (view.frame.size.height == 43) {
			view.frame = CGRectMake(view.frame.origin.x, 232, 127, 43);
		}
	}
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
}

#pragma mark -
#pragma mark UIPickerView - Date/Time

- (void)createPickerView
{
	pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pickerView.delegate =self;
//	pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	pickerView.frame = CGRectMake(10, 40, 280, 180);//216
	
	[self addSubview:pickerView];
}

#pragma mark -
#pragma mark UIPickerView delegate
-(NSInteger) pickerView: (UIPickerView*)pickerView numberOfRowsInComponent: (NSInteger) component {
    return 4;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row==0) {
        return @"Easy";
    }
    if (row == 1) {
        return @"Medium";
    }
    if (row == 2) {
        return @"Hard";
    }
    if (row == 3) {
        return @"Elite";
    }

}

@end
