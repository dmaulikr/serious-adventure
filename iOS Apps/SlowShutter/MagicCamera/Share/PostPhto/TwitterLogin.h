//
//  TwitterLogin.h
//  FatBooth
//
//  Created by user on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainEditController;
@interface TwitterLogin : UIViewController <UITableViewDataSource, UITextFieldDelegate>
{
	UITextField* m_pUserName;
	UITextField* m_pPassword;
	
	MainEditController* controller;
	
	IBOutlet UITableView *m_pTabelView;
    BOOL    m_fSelectedRemember;
    BOOL m_fIsRating;
}

@property(nonatomic, assign)MainEditController* controller;
@property(nonatomic) BOOL   m_fIsRating;
-(IBAction)actionSwitch:(id)sender;
-(IBAction)onSignIn:(id)sender;
-(void)actionCancel:(id)sender;

@end
