//
//  VideoThumbView.h
//  MyCamera
//
//  Created by Kwang on 11/10/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MagicCameraViewController;

@interface OptionSettingView : UIView {
    IBOutlet UISegmentedControl*   m_segmentSelfTime;
    IBOutlet UISwitch*             m_switchScreenShutter;
    IBOutlet UISwitch*             m_switchAutoSave;
    MagicCameraViewController *     delegeteController;    
}

- (void) initialize;
- (IBAction) onSelftime:(id)sender;
- (IBAction) onSreenShutter:(id)sender;
- (IBAction) onAutoSave:(id)sender;
- (void)setDelegateController:(MagicCameraViewController *)aController;

@end
