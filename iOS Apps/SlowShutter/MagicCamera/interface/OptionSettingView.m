//
//  VideoThumbView.m
//  MyCamera
//
//  Created by Kwang on 11/10/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionSettingView.h"
#import "MagicCameraAppUtils.h"
#import "MagicCameraViewController.h"

@implementation OptionSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
//    if (self.delegate)
//        [self.delegate release];
    [m_segmentSelfTime release];
    [m_switchScreenShutter release];
    [m_switchAutoSave release];
    [super dealloc];
}

- (void) initialize {
    m_segmentSelfTime.selectedSegmentIndex = [g_AppUtils selfTimerIndex];
    m_switchAutoSave.on = [g_AppUtils useAutoSave];
    m_switchScreenShutter.on = [g_AppUtils useScreenShutter];
    m_segmentSelfTime.segmentedControlStyle = UISegmentedControlStyleBar;
    // is ios7?
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        m_segmentSelfTime.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    else {
        m_segmentSelfTime.tintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];
}

- (IBAction) onSelftime:(id)sender {
    UISegmentedControl* seg = (UISegmentedControl*)sender;
    [g_AppUtils setSelfTimerDelay:seg.selectedSegmentIndex];
    [delegeteController changeShutterBtnImage];
}
- (IBAction) onSreenShutter:(id)sender {
    UISwitch* btn = (UISwitch*)sender;
    [g_AppUtils setUseScreenShutter:btn.on];
}
- (IBAction) onAutoSave:(id)sender {
    UISwitch* btn = (UISwitch*)sender;
    [g_AppUtils setUseAutoSave:btn.on];
}

- (void)setDelegateController:(MagicCameraViewController *)aController {
    delegeteController = aController;
}

@end
