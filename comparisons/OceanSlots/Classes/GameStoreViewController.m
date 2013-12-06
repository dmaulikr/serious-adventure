//
//  GameStoreViewController.m
//  LetsSlot
//
//  Created by Tanut Apiwong on 9/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameStoreViewController.h"
#import "Reachability.h"
#import "SurfSlotMachineAppDelegate.h"

@implementation GameStoreViewController
@synthesize activityIndicatorView;
@synthesize lblLoading;
@synthesize lblProductTitle;
@synthesize txtProductDescription;
@synthesize txtGamecenterDescription;
@synthesize txtRestoreDescription;
@synthesize txtMoreGamesDescription;
@synthesize btnBuyProduct;
@synthesize btnGameCenter;
@synthesize btnRestore;
@synthesize btnReturn;
@synthesize btnMoreGame;
@synthesize activityIndicatorPurchasingView;
@synthesize lblPurchasing;
@synthesize unlockInfoImage;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
    
//    SurfSlotMachineAppDelegate* del = (SurfSlotMachineAppDelegate*)[UIApplication sharedApplication].delegate;
//    [del hideADS:YES];
	
	bErrorOnConnection = NO;
	self.lblProductTitle.hidden = YES;
	self.txtProductDescription.hidden = YES;
    self.txtGamecenterDescription.hidden = YES;
    self.txtRestoreDescription.hidden = YES;
    self.txtMoreGamesDescription.hidden = YES;
	self.btnBuyProduct.hidden = YES;
	self.btnRestore.hidden = YES;
	self.btnGameCenter.hidden = YES;
	self.btnMoreGame.hidden = YES;
	
	self.lblLoading.hidden = YES;
	self.activityIndicatorPurchasingView.hidden = YES;
	self.lblPurchasing.hidden = YES;
	self.unlockInfoImage.hidden = YES;
	
	// Check network reachability
	Reachability* reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [reachability currentReachabilityStatus];
	if (internetStatus != ReachableViaWiFi && internetStatus != ReachableViaWWAN) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" 
														message:@"You require an internet connection via WiFi or cellular network for connecting to online store" 
													   delegate:nil 
											  cancelButtonTitle:@"Dismiss" 
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		bErrorOnConnection = YES;
	}
	
	
	
	
	if ([SKPaymentQueue canMakePayments])
	{
		[self requestProductData];
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In-App Purchases are disabled" 
														message:@"Please check your restrictions for In-App Purchases in Settings->General->Restrictions." 
													   delegate:nil 
											  cancelButtonTitle:@"Dismiss" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		bErrorOnConnection = YES;
	}
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
	[timer retain];
}

- (void)setMainGameParent:(id) parent {
	mainGameParent = parent;
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	[timer invalidate];
	[timer release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	self.activityIndicatorView = nil;
	self.lblLoading = nil;
	self.lblProductTitle = nil;
	self.txtProductDescription = nil;
    self.txtRestoreDescription = nil;
    self.txtGamecenterDescription = nil;
    self.txtMoreGamesDescription = nil;
	self.btnBuyProduct = nil;
	self.btnGameCenter = nil;
	self.btnRestore = nil;
	self.btnMoreGame = nil;
	self.btnBuyProduct = nil;
	self.unlockInfoImage = nil;
	
	mainGameParent = nil;
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) closePressed:(id) sender {
	[mainGameParent GameStoreClosed];
	[self.view removeFromSuperview];
}

- (IBAction) purchaseUnlock:(id) sender {
	
	bool bPaymentInQueue = NO;
	for (SKPaymentTransaction *transaction in [SKPaymentQueue defaultQueue].transactions) {
		if ([transaction.payment.productIdentifier isEqualToString:kPayoutUnlockProduct]) {
			bPaymentInQueue = YES;
			NSLog(@"Payment already in queue!");
			break;
		}
	}
	if (!bPaymentInQueue) {
		NSLog(@"Adding new payment...");
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:kPayoutUnlockProduct];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	//[self.view removeFromSuperview];
}

- (IBAction) gameCenter:(id)sender {
    SurfSlotMachineAppDelegate* del = (SurfSlotMachineAppDelegate*)[UIApplication sharedApplication].delegate;
    RootViewController *rootViewController = del.viewController;
    [rootViewController showLeaderboard];
}

- (IBAction) restore:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (IBAction) moreGames:(id)sender {
    SurfSlotMachineAppDelegate* del = (SurfSlotMachineAppDelegate*)[UIApplication sharedApplication].delegate;
    [del dispMoreApps];
}

- (void)requestProductData {
	
	lblLoading.hidden = NO;
	[activityIndicatorView startAnimating];
	
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kPayoutUnlockProduct]];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSArray *myProducts = response.products;

	if ([myProducts count] > 0) {
		SKProduct *product = [myProducts objectAtIndex:0];
		
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
		NSString *priceString = [numberFormatter stringFromNumber:product.price];
		
		NSLog(@"Title: %@", product.localizedTitle);
		NSLog(@"Desc: %@", product.localizedDescription);
		NSLog(@"Price: %@", priceString);
		
		self.lblProductTitle.text = product.localizedTitle;
		self.txtProductDescription.text = product.localizedDescription;
		[self.btnBuyProduct setTitle:[NSString stringWithFormat:@"Purchase now! %@", priceString] forState:UIControlStateNormal];
		[self.btnGameCenter setTitle:[NSString stringWithFormat:@"Leaderboard"] forState:UIControlStateNormal];
		[self.btnRestore setTitle:[NSString stringWithFormat:@"Restore"] forState:UIControlStateNormal];
		[self.btnMoreGame setTitle:[NSString stringWithFormat:@"More Games"] forState:UIControlStateNormal];
		
		self.lblProductTitle.hidden = NO;
		self.txtProductDescription.hidden = NO;
		self.txtGamecenterDescription.hidden = NO;
		self.txtRestoreDescription.hidden = NO;
		self.txtMoreGamesDescription.hidden = NO;
		self.btnBuyProduct.hidden = NO;
        self.btnGameCenter.hidden = NO;
        self.btnRestore.hidden = NO;
        self.btnMoreGame.hidden = NO;
		self.unlockInfoImage.hidden = NO;
		
		[numberFormatter release];
	}
	
	lblLoading.hidden = YES;
	[activityIndicatorView stopAnimating];
	
	[request release];
}


- (void)tick:(id)sender {
	
	bool bPaymentInQueue = NO;
	for (SKPaymentTransaction *transaction in [SKPaymentQueue defaultQueue].transactions) {
		if ([transaction.payment.productIdentifier isEqualToString:kPayoutUnlockProduct]) {
			
			bPaymentInQueue = YES;
			break;
		}
	}
	
	
	if (bPaymentInQueue) {
		[self.activityIndicatorPurchasingView startAnimating];
		self.activityIndicatorPurchasingView.hidden = NO;
		self.lblPurchasing.hidden = NO;
		self.btnReturn.enabled = NO;
		self.btnBuyProduct.enabled = NO;
	} else {
		[self.activityIndicatorPurchasingView stopAnimating];
		self.activityIndicatorPurchasingView.hidden = YES;
		self.lblPurchasing.hidden = YES;
		self.btnReturn.enabled = YES;
		self.btnBuyProduct.enabled = YES;
	}
	
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	if ([userDefault objectForKey:KEY_PAYOUTLOCKED] != nil && [userDefault boolForKey:KEY_PAYOUTLOCKED] == NO) {
		[mainGameParent GameStoreClosed];
		[self.view removeFromSuperview];
	}
	
	if (bErrorOnConnection) {
		[mainGameParent GameStoreClosed];
		[self.view removeFromSuperview];
	}
}
@end
