//
//  EditSettingView.h
//  MagicCamera
//
//  Created by star com on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MagicCameraViewController;

@interface EditSettingView : UIView {
    UISlider *          freeze_slider;
    UISlider *          exposure_slider;
    
    UILabel *           freeze_label;
    UILabel *           exposure_label; 
    
    BOOL                bLayutFEOrder;
    
    MagicCameraViewController *     delegeteController;
}

#pragma mark - Delegete Controller
- (void)setDelegateController:(MagicCameraViewController *)aController;

#pragma mark - Stardard User Interface Item Template
- (UILabel *)labelOfSlider:(CGRect)frameRect title:(NSString *)title;
- (UISlider *)skinSlider:(CGRect)frameRect minValue:(float)minValue maxValue:(float)maxValue action:(SEL)action;

#pragma mark - User Interface Action
- (void)onFreeze:(id)sender;
- (void)onExposure:(id)sender;

- (void)updateViewFromAppSettings;

#pragma mark - Modify Layout
- (void)modifyLayoutToFEOrder:(BOOL)toFEOrder;

@end
