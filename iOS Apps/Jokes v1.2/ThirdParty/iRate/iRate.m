//
//  iRate.m
//  iRate
//
//  Created by Nick Lockwood on 26/01/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iRate.h"
#import "UIDeviceHardware.h"
#import "FlurryAnalytics.h"
#import "AppDelegate.h"

NSString * const iRateRatedVersionKey = @"iRateRatedVersionChecked";
NSString * const iRateDeclinedVersionKey = @"iRateDeclinedVersion";
NSString * const iRateLastRemindedKey = @"iRateLastReminded";
NSString * const iRateLastVersionUsedKey = @"iRateLastVersionUsed";
NSString * const iRateFirstUsedKey = @"iRateFirstUsed";
NSString * const iRateUseCountKey = @"iRateUseCount";
NSString * const iRateEventCountKey = @"iRateEventCount";

NSString * const iRateiOSAppStoreURLFormat = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%i";

#define SECONDS_IN_A_DAY 86400.0

@interface iRate()

@property (nonatomic, retain) NSString *applicationVersion;

@end


@implementation iRate

@synthesize appStoreID;
@synthesize applicationName;
@synthesize applicationVersion;
@synthesize daysUntilPrompt;
@synthesize usesUntilPrompt;
@synthesize eventsUntilPrompt;
@synthesize remindPeriod;
@synthesize messageTitle;
@synthesize message;
@synthesize cancelButtonLabel;
@synthesize remindButtonLabel;
@synthesize rateButtonLabel;
@synthesize ratingsURL;
@synthesize disabled;
@synthesize debug;
@synthesize delegate;

#pragma mark -
#pragma mark Lifecycle methods

+ (iRate *)sharedInstance
{
    static dispatch_once_t predicate;
    static iRate *sharedInstance = nil;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [[iRate alloc] init];
        debug(@"created shared iRate instance");
    });
    
    return sharedInstance;
}

- (iRate *)init
{
	if ((self = [super init]))
	{
		//register for iphone application events
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationLaunched:)
													 name:UIApplicationDidFinishLaunchingNotification
												   object:nil];
		
		if (&UIApplicationWillEnterForegroundNotification)
		{
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(applicationWillEnterForeground:)
														 name:UIApplicationWillEnterForegroundNotification
													   object:nil];
		}
        
		//application name and version
		self.applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
		self.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
		
		//usage settings - these have sensible defaults
		usesUntilPrompt = 10;
		eventsUntilPrompt = 10;
		daysUntilPrompt = 10;
		remindPeriod = 1;
		
		//message text, you may wish to customise these, e.g. for localisation
		self.messageTitle = nil; //set lazily so that appname can be included
		self.message = nil; //set lazily so that appname can be included
		self.cancelButtonLabel = @"No, Thanks";
		self.remindButtonLabel = @"Remind Me Later";
		self.rateButtonLabel = @"Rate It Now";
	}
	return self;
}

- (NSString *)messageTitle
{
	if (messageTitle)
	{
		return messageTitle;
	}
	return [NSString stringWithFormat: NSLocalizedString(@"Rate %@", @"Rate title"), applicationName];
}

- (NSString *)message
{
	if (message)
	{
		return message;
	}
	return [NSString stringWithFormat:@"If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", applicationName];
}

- (NSURL *)ratingsURL
{
	if (ratingsURL)
	{
		return ratingsURL;
	}
    return [NSURL URLWithString:[NSString stringWithFormat: iRateiOSAppStoreURLFormat, appStoreID]];
    
//    return [NSURL URLWithString:@"http://glob.ly/2pU"];
}

- (NSDate *)firstUsed
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:iRateFirstUsedKey];
}

- (void)setFirstUsed:(NSDate *)date
{
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:iRateFirstUsedKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)lastReminded
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:iRateLastRemindedKey];
}

- (void)setLastReminded:(NSDate *)date
{
	[[NSUserDefaults standardUserDefaults] setObject:date forKey:iRateLastRemindedKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)usesCount
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:iRateUseCountKey];
}

- (void)setUsesCount:(NSUInteger)count
{
	[[NSUserDefaults standardUserDefaults] setInteger:count forKey:iRateUseCountKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)eventCount;
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:iRateEventCountKey];
}

- (void)setEventCount:(NSUInteger)count
{
	[[NSUserDefaults standardUserDefaults] setInteger:count forKey:iRateEventCountKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)declinedThisVersion
{
	return [[[NSUserDefaults standardUserDefaults] objectForKey:iRateDeclinedVersionKey] isEqualToString:applicationVersion];
}

- (void)setDeclinedThisVersion:(BOOL)declined
{
	[[NSUserDefaults standardUserDefaults] setObject:(declined? applicationVersion: nil) forKey:iRateDeclinedVersionKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)ratedThisVersion
{
	return [[[NSUserDefaults standardUserDefaults] objectForKey:iRateRatedVersionKey] isEqualToString:applicationVersion];
}

- (void)setRatedThisVersion:(BOOL)rated
{
	[[NSUserDefaults standardUserDefaults] setObject:(rated? applicationVersion: nil) forKey:iRateRatedVersionKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark -
#pragma mark Methods

- (void)incrementUseCount
{
	self.usesCount ++;
}

- (void)incrementEventCount
{
	self.eventCount ++;
}

- (BOOL)shouldPromptForRating
{	
   // return YES;
	//debug mode?
	if (debug)
	{
		return YES;
	}
	
	//check if we've rated this version
	else if (self.ratedThisVersion)
	{
		return NO;
	}
	
	//check if we've declined to rate this version
	else if (self.declinedThisVersion)
	{
		return NO;
	}
	
	//check how long we've been using this version
//	else if (self.firstUsed == nil)
//	{
//		return NO;
//	}
	
	//check how many times we've used it and the number of significant events
	else if (self.usesCount < usesUntilPrompt && self.eventCount < eventsUntilPrompt)
	{
		return NO;
	}
	
	//check if within the reminder period
//	else if (self.lastReminded != nil && [[NSDate date] timeIntervalSinceDate:self.lastReminded] < remindPeriod * SECONDS_IN_A_DAY)
//	{
//		return NO;
//	}
//	
	//lets prompt!
	return YES;
}

- (void)promptForRating
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.messageTitle
													message:self.message
												   delegate:self
										  cancelButtonTitle: cancelButtonLabel
										  otherButtonTitles: rateButtonLabel, nil];
	
	if (remindButtonLabel)
	{
		[alert addButtonWithTitle:remindButtonLabel];
	}
	
	[alert show];
}

- (void)promptIfNetworkAvailable
{
	//test for app store connectivity the simplest, most reliable way - by accessing apple.com
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://apple.com"] 
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:10.0];
	//send request
	[[NSURLConnection connectionWithRequest:request delegate:self] start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//good enough; don't download any more data
	[connection cancel];
	
	//confirm with delegate
	if ([(NSObject *)delegate respondsToSelector:@selector(iRateShouldPromptForRating)])
	{
		if (![delegate iRateShouldPromptForRating])
		{
			return;
		}
	}
	
	//prompt user
	[self promptForRating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//could not connect
	if ([(NSObject *)delegate respondsToSelector:@selector(iRateCouldNotConnectToAppStore:)])
	{
		[delegate iRateCouldNotConnectToAppStore:error];
	}
}

- (void)applicationLaunched:(NSNotification *)notification
{
	//check if this is a new version
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![[defaults objectForKey:iRateLastVersionUsedKey] isEqualToString:applicationVersion])
	{
		//reset counts
		[defaults setObject:applicationVersion forKey:iRateLastVersionUsedKey];
		[defaults setObject:[NSDate date] forKey:iRateFirstUsedKey];
		[defaults setInteger:0 forKey:iRateUseCountKey];
		[defaults setInteger:0 forKey:iRateEventCountKey];
		[defaults setObject:nil forKey:iRateLastRemindedKey];
		[defaults synchronize];
	}
	
	[self incrementUseCount];
//	if (!disabled && [self shouldPromptForRating])
//	{
//		[self promptIfNetworkAvailable];
//	}
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
	[self incrementUseCount];
    self.firstUsed = NO;
//	if (!disabled && [self shouldPromptForRating])
//	{
//		[self promptIfNetworkAvailable];
//	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)openRatingsPageInAppStore
{
//    [(AppDelegate*)[UIApplication sharedApplication].delegate openReferralURL: self.ratingsURL];
	[[UIApplication sharedApplication] openURL:self.ratingsURL];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex)
	{
		//ignore this version
		//self.declinedThisVersion = YES;
        [FlurryAnalytics logEvent: @"iRateNO"];
       // self.lastReminded = [NSDate date];
        
        [self setUsesCount:0];
        [self setEventCount:0];
        //[self showEmailComplaint];
	}
	else if (buttonIndex == 2)
	{
		//remind later
		self.lastReminded = [NSDate date];
	}
	else
	{
		//mark as rated
		self.ratedThisVersion = YES;
        [FlurryAnalytics logEvent: @"iRateYES"];
		
		//go to ratings page
		[self openRatingsPageInAppStore];
	}
}

- (void)logEvent:(BOOL)deferPrompt
{
	[self incrementEventCount];
	if (!deferPrompt && !disabled && [self shouldPromptForRating])
	{
		[self promptIfNetworkAvailable];
	}
}

- (void)showEmailComplaint
{
    if ( ![MFMailComposeViewController canSendMail] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                        message: NSLocalizedString(@"Looks like there's no email account setup. Please, check your email settings", @"")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // get device properties
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceHardware *hardware = [[UIDeviceHardware alloc] init];
    
    NSMutableString *deviceProperties = [[NSMutableString alloc] init];
    [deviceProperties appendFormat: NSLocalizedString(@"device: %@\n", @""), [hardware platformString]];
    [deviceProperties appendFormat: NSLocalizedString(@"system: %@ %@\n", @""), device.systemName, device.systemVersion];
    
    // create email composer
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate: self];
    
    [controller setToRecipients: [NSArray arrayWithObject: @"support@brightnewt.com"]];
    
    [controller setSubject:
     [NSString stringWithFormat: NSLocalizedString(@"Your app makes me sad - ver %@", @""),
      [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleVersion"]]];
    
    [controller setMessageBody:
     [NSString stringWithFormat: NSLocalizedString(@"Hi there,\n\n Your app is frustrating to use because...\n\n\n\n\nMy device properties are:\n%@", @""), deviceProperties]
                        isHTML: NO];
    
    // show email composer
    [[[UIApplication sharedApplication] delegate].window.rootViewController presentModalViewController: controller animated: YES];
}


#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController: (MFMailComposeViewController*)controller
          didFinishWithResult: (MFMailComposeResult)result
                        error: (NSError*)error
{
	[[[UIApplication sharedApplication] delegate].window.rootViewController dismissModalViewControllerAnimated: YES];
	
	if ( MFMailComposeResultFailed == result ) {
        [FlurryAnalytics logEvent: @"iRateEmailFailed"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error" , @"") 
														message: [NSString stringWithFormat: NSLocalizedString(@"Error sending email: %@", @""), [error localizedDescription]]
													   delegate: nil 
											  cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
											  otherButtonTitles: nil]; 
		[alert show];
	}
    else if ( MFMailComposeResultSaved == result ) {
        debug(@"email SAVED");
        [FlurryAnalytics logEvent: @"iRateEmailSaved"];
    }
    else if ( MFMailComposeResultCancelled == result ) {
        debug(@"email CANCELLED");
        [FlurryAnalytics logEvent: @"iRateEmailCancelled"];
    }
	else if ( MFMailComposeResultSent == result ) {
        debug(@"email SENT");
        [FlurryAnalytics logEvent: @"iRateEmailSent"];
	}
}

@end