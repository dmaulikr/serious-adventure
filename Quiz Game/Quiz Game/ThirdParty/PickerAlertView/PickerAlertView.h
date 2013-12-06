//
//  PickerAlertView.h
//  YunPlus
//
//  Created by juxue.chen on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface PickerAlertView : UIAlertView <UIPickerViewDelegate,UIPickerViewDataSource>{
	UIPickerView *pickerView;
}

@property (nonatomic,retain) UIPickerView *pickerView;

- (void)createPickerView;

@end
