//
//  SendMessage.mm
//  FatBooth
//
//  Created by user on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendMessage.h"
#import <UIKit/UITextField.h>
//#import "FatBoothAppDelegate.h"
//#import "MainEditController.h"

@implementation SendMessage
@synthesize m_pUserName;
@synthesize m_pPassWord;
@synthesize m_Mode;
@synthesize controller;
@synthesize m_postMode;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

 	NSString* strNibName;
	if(UI_USER_INTERFACE_IDIOM()!= UIUserInterfaceIdiomPad)
		strNibName = [NSString stringWithFormat:@"%@_iPhone", nibNameOrNil];
	else
		strNibName = [NSString stringWithFormat:@"%@_iPad", nibNameOrNil];
	
	self = [super initWithNibName:strNibName bundle:nibBundleOrNil];
	
	
    if (self) {
        // Custom initialization.
    }
    return self;
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [m_pMessageText setEditable:YES];
//	[m_pMessageText setPlaceholder:@"I just took a pic with my new BFF Justin Bieber!!!"];
	
	BraceFaceAppDelegate *appDelegate = (BraceFaceAppDelegate*)[UIApplication sharedApplication].delegate;
    UIImage*	image = appDelegate.m_pResultImage ;

	m_pPhoto.image = image;
	
//	if (m_Mode == MessageFaceBook)
//	{
//		self.navigationItem.title = @"FaceBook";
//        m_pMessageText.text = @"Hi, picture by Slimboth";
//        m_pAccount.hidden = YES;
//        m_LeftCharacterNum.hidden = YES;
//		
//	}
	if (m_Mode == MessageTwitter)
	{
        if(m_postMode == UploadMode)
        {
            self.navigationItem.title = @"Twitter(TwitPic)";
            m_pMessageText.text = @"I just took a pic with my new Big Head Maker!!!";
        }
        else
        {
            self.navigationItem.title = @"Twitter";
            m_pMessageText.text = @"Check out this awesome FREE app that puts Justin Bieber in your pictures!! Download it here";
        }

        m_pAccount.hidden = YES;
        m_LeftCharacterNum.hidden = YES;
      
        m_pAccount.text = [NSString stringWithFormat:@"Account %@", m_pUserName];
        m_nLeftCharacterNum = 130;
        m_LeftCharacterNum.text = [NSString stringWithFormat:@"%d characters left", m_nLeftCharacterNum]; 
	}
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)] autorelease];
	
	UIBarButtonItem* pDisconnect = [[[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStylePlain target:self action:@selector(onDisconnect:)] autorelease];
//    if(m_postMode == PostWallMode)
//    {
//        m_pPhoto.hidden = YES;
//    }
    [self.navigationItem setRightBarButtonItem:pDisconnect];
    m_pMessageText.delegate = self;
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [m_pUserName release];
    [m_pPassWord release];
    [super dealloc];
}

-(IBAction)onCancel:(id)sender
{
	[controller Return];
	
}
-(IBAction)onDisconnect:(id)sender
{	    
	[self onCancel:nil];
}

-(IBAction)onSend:(id)sender
{
    BraceFaceAppDelegate* appDelegate = (BraceFaceAppDelegate*)[UIApplication sharedApplication].delegate;
	
//    if (m_Mode == MessageTwitter)
	{
        if(m_pUserName == nil || m_pPassWord == nil)
            return;
        
        [self AddAlertWindow];
        
		TwitpicEngine *twitpicEngine = [[TwitpicEngine alloc] initWithDelegate:self];

        if(m_postMode == UploadMode)
        {
            NSString* szMessage = [NSString stringWithFormat:@"%@\nDownload the app here for free!!http://oxegenentertainment.com/mybff/",m_pMessageText.text];
            UIImage*	image = appDelegate.m_pResultImage;
            
            NSLog(@"User Name   === %@", m_pUserName);
            NSLog(@"User PW   === %@", m_pPassWord);
            
            [twitpicEngine uploadImageToTwitpic:image withMessage:szMessage
                                       username:m_pUserName password:m_pPassWord];
        }
        
		[twitpicEngine release];
	}
//	else
//	{
//		[controller UpLoadPhoto];
//	}

}

-(void)AddAlertWindow
{
    if(m_postMode == UploadMode)
        alertMain = [[[UIAlertView alloc] initWithTitle:@"Uploading Photo\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    else
    {
         alertMain = [[[UIAlertView alloc] initWithTitle:@"Sending Message\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    }
    [alertMain show];
    
    ActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    ActivityIndicator.center = CGPointMake(150, 85);
    [alertMain addSubview:ActivityIndicator];
    [ActivityIndicator startAnimating];
}

- (void)twitpicEngine:(TwitpicEngine *)engine didUploadImageWithResponse:(NSString *)response{
    [ActivityIndicator stopAnimating];
    [alertMain dismissWithClickedButtonIndex:0 animated:YES];
    
    if([response hasPrefix:@"http://"])
    {
        UIAlertView *baseAlert;
        if(m_postMode == UploadMode)
        {
            baseAlert = [[[UIAlertView alloc] initWithTitle:nil message:@"Photo Uploaded Successfully." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        }        
        else
           baseAlert = [[[UIAlertView alloc] initWithTitle:nil message:@"Message sended Successfully." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        [baseAlert show];
    }
    else if([[response uppercaseString] isEqualToString:@"ERROR"])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error") message:NSLocalizedString(@"Unable to upload Photo",@"Unable to upload Flyers") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss",@"Dismiss") otherButtonTitles: nil] autorelease];
        [alert show];        
    }
    else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error") message:response delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss",@"Dismiss") otherButtonTitles: nil] autorelease];
        [alert show];        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView != m_pMessageText)
        return NO;
    int nCurLength = [textView.text length];
    if(nCurLength > 130)
        return NO;
    m_nLeftCharacterNum = 130 - nCurLength;
    m_LeftCharacterNum.text = [NSString stringWithFormat:@"%d characters left", m_nLeftCharacterNum]; 
    return YES;
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if(textField != m_pMessageText)
//        return NO;
//    int nCurLength = [textField.text length];
//    m_nLeftCharacterNum = 130 - nCurLength;
//    m_LeftCharacterNum.text = [NSString stringWithFormat:@"%d characters left", m_nLeftCharacterNum]; 
//    return YES;
//}

- (void)updateEmptyTextField:(UITextField *)aTextField {
    if (aTextField.text == nil || [aTextField.text length] == 0) {
    // Replace empty text in aTextField
    }
}
                                    
@end
