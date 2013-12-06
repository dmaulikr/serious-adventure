//
//  SetViewController.m
//  SnapANote
//
//  Created by Thomas on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetViewController.h"
//#import "ViewController.h"
#import "MagicCameraAppUtils.h"


@implementation DataCell

@synthesize title, index, enable;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier INDEX:(int)idx{
	if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.textAlignment = UITextAlignmentLeft;
		title.font = [UIFont boldSystemFontOfSize:16];
        title.textColor = [UIColor blackColor];
		title.backgroundColor = [UIColor clearColor];
        title.text = @"12:45";
        title.numberOfLines = 2;
		[self addSubview:title];
        
        index = idx;
        switchEnable = [[RCSwitchClone alloc] initWithFrame:CGRectZero];
        [switchEnable addTarget:self action:@selector(actionSwtichEnable:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:switchEnable];
    }
	
	return self;
}

- (void) setDelegate:(id)delegate
{
    delegate_ = delegate;
}

- (void)setInfo:(NSString*)str OPTION:(BOOL)option INDEX:(int)idx{
    if (index == idx) {
        title.text = str;
        enable = option;
        [switchEnable setOn:enable];
    }
}

- (void)actionSwtichEnable:(id)sel {
    enable = switchEnable.on;
    [delegate_ setOption:index OPTION:enable];
    
}

- (void) dealloc {
    [switchEnable release];
	[title release];
	[super dealloc];
}

- (void) layoutSubviews {
	[super layoutSubviews];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        title.frame = CGRectMake(20.0f, 5.0f, 150.0f, 50.0f);
        switchEnable.frame = CGRectMake(210.0f, 17.0f, 94.0f, 27.0f);
	} else {
        title.frame = CGRectMake(60.0f, 15.0f, 150.0f, 30.0f);
        switchEnable.frame = CGRectMake(610.0f, 17.0f, 94.0f, 27.0f);
	}
}

@end

@implementation SegmentCell
@synthesize title, index, segmentCtrl;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier INDEX:(int)idx{
	if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.textAlignment = UITextAlignmentLeft;
		title.font = [UIFont boldSystemFontOfSize:16];
        title.textColor = [UIColor blackColor];
		title.backgroundColor = [UIColor clearColor];
        title.text = @"Self timer";
        title.numberOfLines = 2;
		[self addSubview:title];
        index = idx;
        NSArray* array = [NSArray arrayWithObjects:@"0", @"1", @"3", @"5", @"10", nil];
        segmentCtrl = [[UISegmentedControl alloc] initWithItems:array];
        [segmentCtrl setFrame:CGRectZero];
        [segmentCtrl addTarget:self action:@selector(actionSelected:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:segmentCtrl];
    }
	
	return self;
}

- (void) setDelegate:(id)delegate
{
    delegate_ = delegate;
}

- (void)setInfo:(NSString*)str INDEX:(int)idx{
    title.text = str;
    [segmentCtrl setSelectedSegmentIndex:idx];
}
//
- (void)actionSelected:(id)sel {
    index = segmentCtrl.selectedSegmentIndex;
    [delegate_ setSelftimer:index];

}

- (void) dealloc {
    [segmentCtrl release];
	[title release];
	[super dealloc];
}
//
- (void) layoutSubviews {
	[super layoutSubviews];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        title.frame = CGRectMake(20.0f, 5.0f, 100.0f, 50.0f);
        segmentCtrl.frame = CGRectMake(150.0f, 14.0f, 150.0f, 30.0f);
	} else {
        title.frame = CGRectMake(60.0f, 15.0f, 150.0f, 30.0f);
        segmentCtrl.frame = CGRectMake(464.0f, 17.0f, 240.0f, 27.0f);
	}
}

@end

@implementation SetViewController
//@synthesize delegate;
@synthesize fExposureAdjust, fExposureLock, fScreenShutter, fAutoSave, selftimer, strSetRecipient;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    fExposureAdjust = [g_AppUtils useExposureAdjust];//g_GameUtils.bExposureAdjust;
    fExposureLock = [g_AppUtils useExposureLock];//g_GameUtils.bExposureLock;
    fScreenShutter = [g_AppUtils useScreenShutter];//g_GameUtils.bScreenSutter;
    fAutoSave = [g_AppUtils useAutoSave];;//g_GameUtils.bAutoSave;
    selftimer = [g_AppUtils selfTimerIndex];//g_GameUtils.nSetSelfTimer;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) onSave
{
    [g_AppUtils setSelfTimerDelay:selftimer];
    [g_AppUtils setUseExposureAdjust:fExposureAdjust];
    [g_AppUtils setUseExposureLock:fExposureLock];
    [g_AppUtils setUseScreenShutter:fScreenShutter];
    [g_AppUtils setUseAutoSave:fAutoSave];
    [g_AppUtils writeAppSettings];
//     ViewController* controller = (ViewController*)delegate;
//    if (selftimer != 0) {
//        [controller.recordItem setImage:[UIImage imageNamed:@"timer.png"]];
//    }
//    else{
//        [controller.recordItem setImage:[UIImage imageNamed:@"take.png"]];        
//    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) onCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) setOption:(int)index OPTION:(BOOL)option
{
    if (ftableinit ==NO) 
    {
//        if (index == 1) {
//            fExposureAdjust = !fExposureAdjust;
//        } else if (index == 2) {
//            fExposureLock = !fExposureLock;
//        }
        if (index == 1){
            fScreenShutter = !fScreenShutter;
        } else if(index == 2){
            fAutoSave = !fAutoSave;
        }
        
    }
    ftableinit = NO;
}

- (void) setEmailText:(NSString*)str
{
    [self setStrSetRecipient:str];
}

#pragma mark Table dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
        return 3;
    else if (section == 1)
        return 1;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{// fixed font style. use custom view (UILabel) if you want something different
//    if (section == 0) {
//        return @"Automatic Option";
//    } else if (section == 1) {
//        return @"Recipient email address(es)";
//    }

    return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ftableinit = YES;    
    NSString *CellIdentifier = @"Cell1";
    if (indexPath.section == 0) 
    {
        CellIdentifier = @"Cell1";
        if (indexPath.row != 0) {
            DataCell *cell = (DataCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[DataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier INDEX:indexPath.row] autorelease];
            }
            [cell setDelegate:self];
            
//            if (indexPath.row == 1) {
//                [cell setInfo:@"Exposure Adjust" OPTION:fExposureAdjust INDEX:1];
//            } else if (indexPath.row == 2){
//                [cell setInfo:@"Exposure Lock" OPTION:fExposureLock INDEX:2];
//            } 
            if (indexPath.row == 1){
                [cell setInfo:@"Screen Shutter" OPTION:fScreenShutter INDEX:1];
            } else if (indexPath.row == 2){
                [cell setInfo:@"Auto-save " OPTION:fAutoSave INDEX:2];
            }
            return cell;            
        }
        else{
            SegmentCell *cell = (SegmentCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[SegmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier INDEX:indexPath.row] autorelease];
            }
            [cell setDelegate:self];
            [cell setInfo:@"Self Timer" INDEX:selftimer];
            return cell;
        }
    } 
    else if (indexPath.section == 1) 
    {
        CellIdentifier = @"Cell2";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        UITextField*    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 13, 280, 38)];
        [myTextField setText:strSetRecipient];
        
        myTextField.tag = indexPath.row;
        [myTextField setDelegate:self];    
        [myTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        [myTextField setReturnKeyType:UIReturnKeyDone];
        [myTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];

        myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        [cell addSubview:myTextField];
        return cell;
    }

    return nil;
}

#pragma mark Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [txtRecipient resignFirstResponder];
    
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (indexPath.section == 0) {
        height = 60.0f;
    } else if (indexPath.section == 1) {
        height = 44.0f;
    }
    return height;
}

#pragma mark touch proc
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtRecipient resignFirstResponder];
}

#pragma mark UITextFiledDelegate

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder]; 
//    [self checkEmailAddres:txtRecipient.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self checkEmailAddres:textField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtRecipient = textField;
}

-(void) keyboardWillShow:(NSNotification *) note
{
	[self animateTextField:YES]; 
}

-(void) keyboardWillHide:(NSNotification *) note
{
	[self animateTextField:NO]; 
}

- (void) animateTextField:(BOOL) up {
	const int movementDistance = 216; // tweak as needed     352
	const float movementDuration = 0.3f; // tweak as needed      
	int movement = (up ? -movementDistance : movementDistance);      
	[UIView beginAnimations: @"anim" context: nil];     
	[UIView setAnimationBeginsFromCurrentState: YES];     
	[UIView setAnimationDuration: movementDuration];     
	self.view.frame = CGRectOffset(self.view.frame, 0, movement);     
	[UIView commitAnimations]; 
}

- (void) checkEmailAddres:(NSString*)ea
{
    // get the first character, capitalized
    NSString *capital = [[ea substringToIndex:1] capitalizedString];
    
    // then compare to your oldstring
    if ( [[ea substringToIndex:1] isEqualToString:capital] ) {
        // do stuff...
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Snap-A-Note"
                                                            message:@"The first letter of your e-mail address is in uppercase. Please make sure email address."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [self setStrSetRecipient:ea];
}

@end
