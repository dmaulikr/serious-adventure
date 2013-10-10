//
//  BaseViewController.m
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 2/12/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import "BaseViewController.h"


@implementation BaseViewController

@synthesize toolbar = _toolbar;
@synthesize navBar = _navBar;
@synthesize navBarTitleLabel = _navBarTitleLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    error(@"ACHTUNG! DID Receive Memory WARNING");
//	[DebugHelper logMemoryUsage];

    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    debug(@"BASE VIEW: did unload");
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)canSendMail
{
    BOOL canSendMail = YES;
    if ( ![MFMailComposeViewController canSendMail] ) {
        [FlurryAnalytics logEvent: @"CannotSendMail"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                        message: NSLocalizedString(@"Looks like there's no email account setup. Please, check your email settings", @"")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
        canSendMail = NO;
    }
    
    return canSendMail;
}


- (void)createNavBar
{
    // CREATE nav bar
    UIImage *barImage = [UIImage imageNamed: @"bar-up.png"];
    if ([[UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPad ){
        self.navBar = [[UIImageView alloc] initWithFrame:
                       CGRectMake(0, 0, self.view.frame.size.width,
                                  barImage.size.height + 40)];
    }
    else{
        self.navBar = [[UIImageView alloc] initWithFrame:
                       CGRectMake(0, 0, self.view.frame.size.width,
                                  barImage.size.height)];
    }
   
    self.navBar.userInteractionEnabled = YES;
    self.navBar.image = barImage;
    [self.view addSubview: self.navBar];
}


- (void)createLeftNavBarButtonWithTitle: (NSString*)title target: (id)target action: (SEL)action
{
    UIImage *buttonImage = [UIImage imageNamed: @"btn-Left.png"];
    UIImage *buttonPressedImage = [UIImage imageNamed: @"btn-Left-pressed.png"];
	
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [button setBackgroundImage: buttonImage forState: UIControlStateNormal];
    [button setBackgroundImage: buttonPressedImage forState: UIControlStateHighlighted];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        button.frame= CGRectMake(6, 0.5 * (self.navBar.bounds.size.height - buttonImage.size.height) - 15,
                                 buttonImage.size.width + 20, buttonImage.size.height + 20);
    }else
    
	button.frame= CGRectMake(6, 0.5 * (self.navBar.bounds.size.height - buttonImage.size.height) - 2,
                             buttonImage.size.width, buttonImage.size.height);
	
    [button addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    
    [self.navBar addSubview: button];
}


- (void)createRightNavBarButtonWithTitle: (NSString*)title target: (id)target action: (SEL)action
{
    UIImage *buttonImage = [UIImage imageNamed: @"btn-Right.png"];
    UIImage *buttonPressedImage = [UIImage imageNamed: @"btn-Right-pressed.png"];
	
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [button setBackgroundImage: buttonImage forState: UIControlStateNormal];
    [button setBackgroundImage: buttonPressedImage forState: UIControlStateHighlighted];
    
	button.frame= CGRectMake(self.navBar.bounds.size.width - buttonImage.size.width - 6,
                             0.5 * (self.navBar.bounds.size.height - buttonImage.size.height),
                             buttonImage.size.width, buttonImage.size.height);
	
    [button setTitle: title forState: UIControlStateNormal];
    button.titleLabel.textColor = [UIColor colorWithRed: 0.88 green: 0.80 blue: 0.58 alpha: 1.0];
    button.titleLabel.font = [UIFont systemFontOfSize: 13];
    
    [button addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    
    [self.navBar addSubview: button];
}


- (void)createNavBarTitleWithText: (NSString*)text

{
    // TITLE label
    CGFloat labelWidth = 200.0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.navBarTitleLabel = [[UILabel alloc] initWithFrame:
                                 CGRectMake(70 + 200, 0,
                                            labelWidth, self.navBar.frame.size.height)];
        
    }else
    {
        self.navBarTitleLabel = [[UILabel alloc] initWithFrame:
                                 CGRectMake(70, 0,
                                            labelWidth, self.navBar.frame.size.height)];
    }
    
    self.navBarTitleLabel.font = [UIFont boldSystemFontOfSize: 20];
    self.navBarTitleLabel.textColor = [UIColor colorWithRed: 0.17 green: 0.1 blue: 0.04 alpha: 1.0];
    self.navBarTitleLabel.backgroundColor = [UIColor clearColor];
    self.navBarTitleLabel.shadowOffset = CGSizeMake(0, -0.5);
    self.navBarTitleLabel.shadowColor = [UIColor colorWithRed: 0.94 green: 0.90 blue: 0.75 alpha: 1.0];
    self.navBarTitleLabel.text = text;
    [self.navBar addSubview: self.navBarTitleLabel];
}


@end
