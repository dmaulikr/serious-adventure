//
//  ExposureSettingView.h
//  MagicCamera
//
//  Created by star com on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MagicCameraViewController;

@interface ExposureSettingView : UIView {
    //User Interface Item
    UISegmentedControl *    captureMode_segbutton;
    UISegmentedControl *    shutterSpeed_segbutton;
    UISegmentedControl *    sensitivity_segbutton;
    UILabel *               captureMode_label;
    UILabel *               shutterSpeed_label;
    UILabel *               sensitivity_label;   
    
    MagicCameraViewController *     delegeteController;    
}

#pragma mark - Delegete Controller
- (void)setDelegateController:(MagicCameraViewController *)aController;

#pragma mark - Stardard User Interface Item Template
- (UILabel *)labelOfSegButton:(CGRect)frameRect  title:(NSString *)title;
- (UISegmentedControl *)segmentedControl:(NSArray *)segmentTextContent frame:(CGRect)frameRect action:(SEL)action;

#pragma mark - User Interface Action
- (void)onCaptureMode:(id)sender;
- (void)onShutterSpeed:(id)sender;
- (void)onSensitivity:(id)sender;

- (void)updateViewFromAppSettings;
@end
