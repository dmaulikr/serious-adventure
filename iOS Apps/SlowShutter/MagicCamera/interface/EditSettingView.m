//
//  EditSettingView.m
//  MagicCamera
//
//  Created by star com on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditSettingView.h"
#import "MagicCameraAppUtils.h"
#import "MagicCameraViewController.h"

@implementation EditSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frameRect;
        int margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 15 : 15 * 2;
        int labelHieght = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 12 : 12 * 2;
        
        //Insert Freeze Slider & Label
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 15, 320 - margin * 2, labelHieght);
        } else {
            frameRect = CGRectMake(margin, 18 * 2, 768 - margin * 2, labelHieght);
        }
        freeze_label = [self labelOfSlider:frameRect title:@"Freeze: Off"];
        [self addSubview:freeze_label];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(117, 9, 186, 9);
        } else {
            frameRect = CGRectMake(117 * 2, 12 * 2, 186 * SCALE_X, 9 * 2);
        }
        freeze_slider = [self skinSlider:frameRect minValue:-100 maxValue:100 action:@selector(onFreeze:)];
        [self addSubview:freeze_slider];

        //Insert Exposure Slider & Label
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 50, 320 - margin * 2, labelHieght);
        } else {
            frameRect = CGRectMake(margin, 50 * 2, 768 - margin * 2, labelHieght);
        }
        exposure_label = [self labelOfSlider:frameRect title:@"Contrast: 0.00"];
        [self addSubview:exposure_label];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(117, 44, 186, 9);
        } else {
            frameRect = CGRectMake(117 * 2, 44* 2, 186 * SCALE_X, 9 * 2);
        }
        exposure_slider = [self skinSlider:frameRect minValue:-2.0 maxValue:2.0 action:@selector(onExposure:)];
        [self addSubview:exposure_slider];
        
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
//        self.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:10.0f/255.0f blue:2.0f/255.0f alpha:0.6f];
        
        bLayutFEOrder = YES;
    }
    return self;
}

- (void)dealloc {
    [freeze_slider release];
    [exposure_slider release];
    
    [freeze_label release];
    [exposure_label release];    
    
    [super dealloc];
}

#pragma mark - Delegete Controller
- (void)setDelegateController:(MagicCameraViewController *)aController {
    delegeteController = aController;
}

#pragma mark - Stardard User Interface Item Template
- (UILabel *)labelOfSlider:(CGRect)frameRect title:(NSString *)title {
    UILabel *label = [[[UILabel alloc] initWithFrame:frameRect] autorelease];
    CGFloat fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 13 : 13 * 2;
    
	label.textAlignment = UITextAlignmentLeft;
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
	
    return label;
}

- (UISlider *)skinSlider:(CGRect)frameRect minValue:(float)minValue maxValue:(float)maxValue action:(SEL)action {
    UISlider *slider;
    UIEdgeInsets edgeInsets;

    slider = [[[UISlider alloc] initWithFrame:frameRect] autorelease];
    
    CGFloat w, h;
    //if use stretchableImageWithLeftCapWidth, image may be round
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {
        edgeInsets = UIEdgeInsetsMake(0, 5, 9, 6);
        w = 9;
        h = 6;
    } else {
        edgeInsets = UIEdgeInsetsMake(0, 5 * 2, 9 * 2, 6 * 2);
        w = 9*2;
        h = 6*2;
    }
//    UIImage *stretchLeftTrack = [[UIImage imageNamed:[g_AppUtils resourceNameForDevice:@"SliderLeft" ofType:@"png"]] resizableImageWithCapInsets:edgeInsets];
//    UIImage *stretchRightTrack = [[UIImage imageNamed:[g_AppUtils resourceNameForDevice:@"SliderRight" ofType:@"png"]] resizableImageWithCapInsets:edgeInsets];
//    UIImage *stretchLeftTrack = [UIImage imageNamed:[g_AppUtils resourceNameForDevice:@"SliderLeft" ofType:@"png"]];
//    UIImage *stretchRightTrack = [UIImage imageNamed:[g_AppUtils resourceNameForDevice:@"SliderRight" ofType:@"png"]];
    
//    [slider setThumbImage:[UIImage imageNamed:[g_AppUtils resourceNameForDevice:@"SliderThumb" ofType:@"png"]] forState:UIControlStateNormal];
//    [slider setMinimumTrackImage:stretchLeftTrack forState:UIControlStateNormal];
//    [slider setMaximumTrackImage:stretchRightTrack forState:UIControlStateNormal];

    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    slider.backgroundColor = [UIColor clearColor];	
    slider.minimumValue = minValue;
    slider.maximumValue = maxValue;
    slider.continuous = YES;
    slider.value = 0.0f;
		
    return slider;
}

#pragma mark - User Interface Action
- (void)onFreeze:(id)sender {
    if (fabsf(freeze_slider.value) <= 5.0f) {
        [g_AppUtils setFreeze:0];
    } else {
        [g_AppUtils setFreeze:freeze_slider.value];    
    }
    
    NSString *caption;
    float freezeValue = [g_AppUtils freeze];
    if (freezeValue >= 0) {
        if (freezeValue > 0) {
            caption = [NSString stringWithFormat:@"Freeze: +%d%%", (int)freezeValue];
        } else {
            caption = [NSString stringWithFormat:@"Freeze: Off"];
        }
    } else {
        caption = [NSString stringWithFormat:@"Freeze: %d%%", (int)freezeValue];
    }
    freeze_label.text = caption;
    
    [delegeteController changeEditSettings];
}

- (void)onExposure:(id)sender {
    if (fabsf(exposure_slider.value) <= 0.05f) {
        [g_AppUtils setExposure:0];
    } else {
        [g_AppUtils setExposure:exposure_slider.value];    
    }    
    
    NSString *caption;
    float exposureValue = [g_AppUtils exposure];
    if ([g_AppUtils captureModeType] != MANUAL_MODE) {
        if (exposureValue > 0) {
            caption = [NSString stringWithFormat:@"Contrast: +%.02f", exposureValue];
        } else {
            caption = [NSString stringWithFormat:@"Contrast: %.02f", exposureValue];
        }
    }
    else {
        caption = [NSString stringWithFormat:@"Contrast: %.02f", exposureValue];
    }
    exposure_label.text = caption;
    
    [delegeteController changeEditSettings];
}

- (void)updateViewFromAppSettings {
    NSString *captionFr = nil;
    NSString *captionEx = nil;
    float exposureValue = [g_AppUtils exposure];
    float freezeValue = [g_AppUtils freeze];
    if (freezeValue >= 0) {
        if (freezeValue > 0) {
            captionFr = [NSString stringWithFormat:@"Freeze: +%d%%", (int)freezeValue];
        } else {
            captionFr = [NSString stringWithFormat:@"Freeze: Off"];
        }
    } else {
        captionFr = [NSString stringWithFormat:@"Freeze: %d%%", (int)freezeValue];
    }
    if (captionFr)
        freeze_label.text = captionFr;
    if ([g_AppUtils captureModeType] == AUTOMATIC_MODE) {
        exposure_slider.minimumValue = -2.0f;
        exposure_slider.maximumValue = 2.0f;
        if (exposureValue > 0) {
            captionEx = [NSString stringWithFormat:@"Contrast: +%.02f", exposureValue];
        } else {
            captionEx = [NSString stringWithFormat:@"Contrast: %.02f", exposureValue];
        }
    }
    else if ([g_AppUtils captureModeType] == MANUAL_MODE){
        exposure_slider.minimumValue = -4.0f;
        exposure_slider.maximumValue = 0.0f;

        captionEx = [NSString stringWithFormat:@"Contrast: %.02f", exposureValue];
    }
    if (captionEx)
        exposure_label.text = captionEx;
    
    
    freeze_slider.value = [g_AppUtils freeze];
    exposure_slider.value = [g_AppUtils exposure];
}

#pragma mark - Modify Layout
- (void)modifyLayoutToFEOrder:(BOOL)toFEOrder {
    if (toFEOrder != bLayutFEOrder) {
        CGRect frameRect;
        
        frameRect = freeze_label.frame;
        freeze_label.frame = exposure_label.frame;
        exposure_label.frame = frameRect;
        
        frameRect = freeze_slider.frame;
        freeze_slider.frame = exposure_slider.frame;
        exposure_slider.frame = frameRect;
        
        bLayutFEOrder = toFEOrder;
    }
}

@end
