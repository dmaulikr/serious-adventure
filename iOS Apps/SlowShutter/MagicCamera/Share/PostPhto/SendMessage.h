//
//  SendMessage.h
//  FatBooth
//
//  Created by user on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

//enum MessageWindowMode
//{
//	MessageFaceBook,
//	MessageTwitter,
//};

typedef enum{
    MessageFaceBook,
	MessageTwitter,
}MessageWindowMode;

typedef enum{
    UploadMode,
    PostWallMode
}PostMode;

@class MainEditController;

@interface SendMessage : UIViewController <FBSessionDelegate, FBRequestDelegate, UITextFieldDelegate, UITextViewDelegate>
{
	IBOutlet UIImageView* m_pPhoto;
	IBOutlet UITextView* m_pMessageText;
    IBOutlet UITextField*     m_pAccount;
    IBOutlet UITextField*     m_LeftCharacterNum;
    
	NSString *m_pUserName;
	NSString *m_pPassWord;
    
	MessageWindowMode m_Mode;
	MainEditController* controller;
    PostMode          m_postMode;

    int     m_nLeftCharacterNum;
    UIActivityIndicatorView *ActivityIndicator;
    UIAlertView *alertMain;
	
}

@property(nonatomic, retain) 	NSString *m_pUserName;
@property(nonatomic, retain)	NSString *m_pPassWord;

@property(nonatomic, assign)	MessageWindowMode m_Mode;
@property(nonatomic, assign)	MainEditController* controller;
@property(nonatomic, assign)    PostMode m_postMode;

-(IBAction)onCancel:(id)sender;
-(IBAction)onDisconnect:(id)sender;
-(IBAction)onSend:(id)sender;
- (void)updateEmptyTextField:(UITextField *)aTextField;
-(void)AddAlertWindow;
@end
