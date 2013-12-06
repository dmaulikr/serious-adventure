//
//  TwitterLogin.mm
//  FatBooth
//
//  Created by user on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterLogin.h"
#import "MainEditController.h"
#import "BraceFaceAppDelegate.h"

int kTableSectionCount = 1;
int kTableSectionOneItemCount = 2;
int kTableSectionTwoItemCount = 1;

enum {
    kTableSectionOne		= 0,      // rows are kServerValidationXxx
    kTableSectionTwo,
    kTableSectionThree
};

enum 
{
    kTableItemName		= 0,      // rows are kServerValidationXxx
    kTableItemPassword,
};
enum 
{
    kTableItemRememberMe		= 0,      // rows are kServerValidationXxx
};


@implementation TwitterLogin
@synthesize controller;
@synthesize m_fIsRating;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	m_pTabelView.dataSource = self;
	[m_pTabelView reloadData];
    
    m_fSelectedRemember = NO;
    if(m_fIsRating == NO)
        self.navigationItem.title = @"Twitter (TwitPic)";
    else
        self.navigationItem.title = @"Twitter";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)] autorelease];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	NSString* strNibName;
	if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		strNibName = [NSString stringWithFormat:@"%@_iPhone", nibNameOrNil];
	else
		strNibName = [NSString stringWithFormat:@"%@_iPad", nibNameOrNil];
	
	self = [super initWithNibName:strNibName bundle:nibBundleOrNil];
	
	
    if (self) {
        // Custom initialization.
    }
    return self;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return kTableSectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case kTableSectionOne:
			return kTableSectionOneItemCount;
		case kTableSectionTwo:
			return kTableSectionTwoItemCount;
	}
    return 0;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"SettingTableCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	switch (indexPath.section) 
	{
		case kTableSectionOne: 
		{
			//Creting Cell
			if (cell == nil) 
			{
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			CGRect rect = [cell bounds];
			
			//Creating Switch 
			
			switch (indexPath.row)
			{
				case kTableItemName:
					cell.textLabel.text = @"Username";
					cell.accessoryType = UITableViewCellAccessoryNone;

					m_pUserName = [[[UITextField alloc] initWithFrame:CGRectMake(rect.size.width - 200, 9, 94, 27)] autorelease];
					
					[m_pUserName setPlaceholder:@"Required"];
					if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
						m_pUserName.frame = CGRectMake(768.0 - 464.0, 9, 94, 327);
					[cell addSubview:m_pUserName];
					
					break;
				case kTableItemPassword:
					cell.textLabel.text = @"Password";	
					cell.accessoryType = UITableViewCellAccessoryNone;

					m_pPassword = [[[UITextField alloc] initWithFrame:CGRectMake(rect.size.width - 200, 9, 94, 27)] autorelease];
					[m_pPassword setSecureTextEntry:YES];
					[m_pPassword setPlaceholder:@"Required"];

					if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
						m_pPassword.frame = CGRectMake(768.0 - 464.0, 9, 94, 327);
					[cell addSubview:m_pPassword];
					
					break;
			}
			return cell;
		}
		case kTableSectionTwo:
		{
            break;
//			if (cell == nil) 
//			{
//				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//			}
//			CGRect rect = [cell bounds];
//			
//			//Creating Switch 
//			
//			UISwitch* btn = [[[UISwitch alloc] initWithFrame:CGRectMake(rect.size.width - 160, 9, 94, 27)] autorelease];
//			if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//				btn.frame = CGRectMake(768.0 - 164, 9, 94, 27);
//			[btn addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];
//			[cell addSubview:btn];
//			
//			if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//			{
//				btn.frame = CGRectMake(768.0 - 250.0, 9, 94, 27);
//			}
//			switch (indexPath.row)
//			{
//				case kTableItemRememberMe:
//					cell.textLabel.text = @"Remember Me";
//					cell.accessoryType = UITableViewCellAccessoryNone;
//				break;
//									
//			}
		}
	}
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.row == 1)
		{
			
		}
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}
-(IBAction)actionSwitch:(id)sender
{
	m_fSelectedRemember = !m_fSelectedRemember;
}

-(void)actionCancel:(id)sender
{
	[controller Return];
}

-(IBAction)onSignIn:(id)sender
{
	if(m_pUserName.text == nil || m_pPassword == nil)
	{
		UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Can't Sign." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alt show];
		[alt release];
		return;
	}
	
    if(m_fSelectedRemember == YES)
    {
        BraceFaceAppDelegate* appDelegate = (BraceFaceAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.m_fSelectedRemember = m_fSelectedRemember;
        appDelegate.m_szTwitPass = m_pPassword.text;
        appDelegate.m_szTwitUserName = m_pUserName.text;
    }
    
	[controller TwitterSignIn:m_pUserName.text And:m_pPassword.text];
}

@end

