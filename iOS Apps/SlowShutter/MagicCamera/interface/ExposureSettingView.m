//
//  ExposureSettingView.m
//  MagicCamera
//
//  Created by star com on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExposureSettingView.h"
#import "MagicCameraAppUtils.h"
#import "MagicCameraViewController.h"

@implementation ExposureSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frameRect;
        int margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 15 : 15 * 2;
        int labelHieght = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 12 : 12 * 2;
        //Insert Capture Mode Label & Segment Button
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 13, 320 - margin * 2, labelHieght);
        } else {
            frameRect = CGRectMake(margin, 13 * 2, 768 - margin * 2, labelHieght);
        }
        captureMode_label = [self labelOfSegButton:frameRect title:@"Capture mode:"];
        [self addSubview:captureMode_label];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 30, 320 - margin * 2, 30);
        } else {
            frameRect = CGRectMake(margin, 30 * 2, 768 - margin * 2, 30 * 2);
        }
        NSArray *captureModeContent = [NSArray arrayWithObjects: @"Automatic", @"Manual", @"Light trail", nil];
        captureMode_segbutton = [self segmentedControl:captureModeContent frame:frameRect action:@selector(onCaptureMode:)];
        [self addSubview:captureMode_segbutton];

        //Insert Shutter Speed Label & Segment Button
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 68, 320 - margin * 2, labelHieght);
        } else {
            frameRect = CGRectMake(margin, 68 * 2, 768 - margin * 2, labelHieght);
        }
        shutterSpeed_label = [self labelOfSegButton:frameRect title:@"Shutter Speed:"];
        [self addSubview:shutterSpeed_label];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 85, 320 - margin * 2, 30);
        } else {
            frameRect = CGRectMake(margin, 85 * 2, 768 - margin * 2, 30 * 2);
        }
        NSArray *shutterSpeedContent = [NSArray arrayWithObjects: @"0.5", @"1", @"2", @"4", @"8", @"15", @"B", nil];
        shutterSpeed_segbutton = [self segmentedControl:shutterSpeedContent frame:frameRect action:@selector(onShutterSpeed:)];
        [self addSubview:shutterSpeed_segbutton];

        //Insert Sensitivity Label & Segment Button
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 123, 320 - margin * 2, labelHieght);
        } else {
            frameRect = CGRectMake(margin, 123 * 2, 768 - margin * 2, labelHieght);
        }
        sensitivity_label = [self labelOfSegButton:frameRect title:@"Sensitivity:"];
        [self addSubview:sensitivity_label];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            frameRect = CGRectMake(margin, 140, 320 - margin * 2, 30);
        } else {
            frameRect = CGRectMake(margin, 140 * 2, 768 - margin * 2, 30 * 2);
        }
        NSArray *sensitivityContent = [NSArray arrayWithObjects: @"1", @"1/2", @"1/4", @"1/8", @"1/16", @"1/32", @"1/64", nil];
        sensitivity_segbutton = [self segmentedControl:sensitivityContent frame:frameRect action:@selector(onSensitivity:)];
        [self addSubview:sensitivity_segbutton]; 
        
//        self.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:10.0f/255.0f blue:2.0f/255.0f alpha:0.6f];
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    return self;
}

- (void)dealloc {
//    [captureMode_segbutton removeAllSegments];
//    [shutterSpeed_segbutton removeAllSegments];
//    [sensitivity_segbutton removeAllSegments];
    
    [captureMode_segbutton removeFromSuperview];
    [shutterSpeed_segbutton removeFromSuperview];
    [sensitivity_segbutton removeFromSuperview];
    
    [captureMode_label removeFromSuperview];    
    [shutterSpeed_label removeFromSuperview];
    [sensitivity_label removeFromSuperview];
    
    [super dealloc];
}

#pragma mark - Delegete Controller
- (void)setDelegateController:(MagicCameraViewController *)aController {
    delegeteController = aController;
}

#pragma mark - Stardard User Interface Item Template
- (UILabel *)labelOfSegButton:(CGRect)frameRect title:(NSString *)title {
    UILabel *label = [[[UILabel alloc] initWithFrame:frameRect] autorelease];
    float fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 13 : 13 * 2;
    
	label.textAlignment = UITextAlignmentLeft;
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
	
    return label;
}

- (UISegmentedControl *)segmentedControl:(NSArray *)segmentTextContent frame:(CGRect)frameRect action:(SEL)action {
    UISegmentedControl *segmentedControl;
    segmentedControl = [[[UISegmentedControl alloc] initWithItems:segmentTextContent] autorelease];
    
    segmentedControl.frame = frameRect;
    [segmentedControl addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

    // is ios7?
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        segmentedControl.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    else {
        segmentedControl.tintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    segmentedControl.selectedSegmentIndex = 0;

//    segmentedControl.alpha = 0.9;

    return segmentedControl;
}

#pragma mark - User Interface Action
- (void)onCaptureMode:(id)sender {
    [g_AppUtils setCaptureModeType:(enum CaptureMode_Type)captureMode_segbutton.selectedSegmentIndex];
    [delegeteController changeExposureSettings];
}

- (void)onShutterSpeed:(id)sender {
    [g_AppUtils setShutterSpeedType:(enum ShutterSpeed_Type)shutterSpeed_segbutton.selectedSegmentIndex];
}

- (void)onSensitivity:(id)sender {
    [g_AppUtils setSensitivityType:(enum Sensitivity_Type)sensitivity_segbutton.selectedSegmentIndex];
}

- (void)updateViewFromAppSettings {
    captureMode_segbutton.selectedSegmentIndex = (int)[g_AppUtils captureModeType];
    shutterSpeed_segbutton.selectedSegmentIndex = (int)[g_AppUtils ShutterSpeedType];
    sensitivity_segbutton.selectedSegmentIndex = (int)[g_AppUtils sensitivityType];
}
@end
