//
//  PurchaseViewController.m
//  FastLaugh
//
//  Created by Tatyana Remayeva on 7/3/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import "PurchaseViewController.h"
#import "InfoScreenButton.h"
#import "GUIHelper.h"
#import "DataModel.h"
#import "PurchaseEntity.h"

@interface PurchaseViewController ()

@property (strong, nonatomic) NSMutableArray *purchases;
@property (strong, nonatomic) NSMutableArray *renderedPurchases;


- (void)goBack: (id)sender;

@end

@implementation PurchaseViewController

@synthesize purchases = _purchases;
@synthesize renderedPurchases = _renderedPurchases;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(updatePackView:)
                                                     name: @"UserDidPurchasePack"
                                                   object: nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	     
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame: self.view.bounds];
    //bgImageView.image = [UIImage imageNamed: @"background_rest.png"];
    //Quang
    if ( [GUIHelper isPhone5] ) {
        bgImageView.image = [UIImage imageNamed: @"background_rest_568h.png"];
    }
    else {
        bgImageView.image = [UIImage imageNamed: @"background_rest.png"];
    }
    bgImageView.userInteractionEnabled = YES;
    bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: bgImageView];
        
    [self createNavBar];
    self.renderedPurchases = [[NSMutableArray alloc] init];   
    
    NSArray *purchasePackArray = [DataModel sharedInstance].packsArray;
    [purchasePackArray enumerateObjectsUsingBlock: ^(PurchaseEntity* pack, NSUInteger idx, BOOL *stop) {
        [self renderPack: pack withIndex: idx];
    }];
    
    // RESTORE button
    UIImage *buttonImage = [UIImage imageNamed: @"restore_purchases_normal.png"];
    UIImage *buttonPressedImage = [UIImage imageNamed: @"restore_purchases_active.png"];
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setBackgroundImage: buttonImage forState: UIControlStateNormal];
    [button setBackgroundImage: buttonPressedImage forState: UIControlStateHighlighted];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        button.frame= CGRectMake(round(0.3*(self.view.bounds.size.width - buttonImage.size.width)),
                                 (self.view.frame.size.height - 2*buttonImage.size.height),
                                 2*buttonImage.size.width,
                                 2*buttonImage.size.height);
    }
    else{
        button.frame= CGRectMake(round(0.5 * (self.view.bounds.size.width - buttonImage.size.width)),
                                 self.view.frame.size.height - buttonImage.size.height,
                                 buttonImage.size.width,
                                 buttonImage.size.height);
    }

   
    [button addTarget: self action: @selector(restorePurchasesPressed:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: button];
    CGFloat xShift = 20.0, fontSize = 18;
    UILabel *titleLabel;
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
         titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(1.5*xShift, 0, 1.5*(buttonImage.size.width - xShift), 1.5*buttonImage.size.height)];
         fontSize += 9;
     }
     else{
         titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, -6, buttonImage.size.width - xShift, buttonImage.size.height)];
     }
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.shadowColor = [GUIHelper defaultShadowColor];
    titleLabel.shadowOffset = [GUIHelper defaultShadowOffset];
    titleLabel.text = NSLocalizedString(@"Restore Purchases", @"");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Forte" size: fontSize];

    [button addSubview: titleLabel];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDidPurchasePack" object:nil];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)renderPack: (PurchaseEntity*)pack withIndex: (int)index
{
    
    SKProduct *product = [[DataModel sharedInstance] productForPack: pack];
    
    debug(@"pack %@",[NSString stringWithFormat:@"%@.png", pack.image]);
    UIImage *buttonImage = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png", pack.image]];
    UIImage *buttonPressedImage = [UIImage imageNamed: [NSString stringWithFormat:@"%@_pressed.png", pack.image]];
	
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    CGFloat xShift = 20.0;
    UILabel *titleLabel;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, -20 , 2*(buttonImage.size.width - xShift), 2*buttonImage.size.height)];
    }
    else{
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, -20 , buttonImage.size.width - xShift, buttonImage.size.height)];
    }
    titleLabel.font = [UIFont fontWithName:@"Eras Bold ITC" size: 20];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.shadowColor = [GUIHelper defaultShadowColor];
    titleLabel.shadowOffset = [GUIHelper defaultShadowOffset];
    titleLabel.text = pack.name;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage: buttonImage forState: UIControlStateNormal];
    [button setBackgroundImage: buttonPressedImage forState: UIControlStateHighlighted];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        button.frame= CGRectMake(0.5 * (self.view.bounds.size.width - buttonImage.size.width),
                                 0,
                                 2*buttonImage.size.width,
                                 2*buttonImage.size.height);
        button.center = CGPointMake(self.view.center.x, round(2*(15 + ( index + 1) * buttonImage.size.height)));
    }
    else{
        button.frame= CGRectMake(0.5 * (self.view.bounds.size.width - buttonImage.size.width),
                                 0,
                                 buttonImage.size.width,
                                 buttonImage.size.height);
        button.center = CGPointMake(self.view.center.x, round(15 + ( index + 1) * buttonImage.size.height));
    }
	
    [button addTarget: self action: @selector(purchasePressed:) forControlEvents: UIControlEventTouchUpInside];
    //button.center = CGPointMake(self.view.center.x, round(8*15 + ( index + 1) * buttonImage.size.height));
    [button addSubview: titleLabel];
    
    [self.view addSubview: button];
    [self.renderedPurchases addObject: button];
    // CHECK image
    if ( [pack.isBought boolValue] ) {
        UIImage *checkImage = [UIImage imageNamed: @"purchased.png"];
        [button setBackgroundImage: checkImage forState: UIControlStateNormal];
        [button setBackgroundImage: checkImage forState: UIControlStateHighlighted];
    }
    
    // format localized price
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale: product.priceLocale];
    NSString *localizedPrice = [numberFormatter stringFromNumber: product.price];
    
    
    CGFloat pricexShift = 20.0;
    UILabel *priceLabel;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(pricexShift, 20 , 2*(buttonImage.size.width - pricexShift), 2*buttonImage.size.height)];
    }
    else{
        priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(pricexShift, 20 , buttonImage.size.width - pricexShift, buttonImage.size.height)];
    }
    priceLabel.font = [UIFont fontWithName:@"Eras Bold ITC" size: 23];
    priceLabel.textAlignment = UITextAlignmentLeft;
    priceLabel.shadowColor = [GUIHelper defaultShadowColor];
    priceLabel.shadowOffset = [GUIHelper defaultShadowOffset];
    priceLabel.text = localizedPrice;
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.backgroundColor = [UIColor clearColor];
    [button addSubview: priceLabel];

        CGFloat descrxShift = 20.0;
        UILabel *descrLabel;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        descrLabel = [[UILabel alloc] initWithFrame: CGRectMake(descrxShift, -4, buttonImage.size.width - descrxShift, 2*buttonImage.size.height)];
    }
    else{
        descrLabel = [[UILabel alloc] initWithFrame: CGRectMake(descrxShift, -4 , buttonImage.size.width - descrxShift, buttonImage.size.height)];
    }
        descrLabel.font = [UIFont fontWithName:@"Forte" size: 18];
        descrLabel.textAlignment = UITextAlignmentLeft;
        descrLabel.shadowColor = [GUIHelper defaultShadowColor];
        descrLabel.shadowOffset = [GUIHelper defaultShadowOffset];
        descrLabel.text =  pack.descr;
        descrLabel.textColor = [UIColor colorWithRed: 0.73 green: 0.58 blue: 0.37 alpha: 1.0];
        descrLabel.backgroundColor = [UIColor clearColor];
       // [button addSubview: descrLabel];
    

}


- (UIButton*)buttonWithImageNamed: (NSString*)imageName
                           target: (id)target
                           action: (SEL)action
{
    if ( nil == imageName ) {
        error(@"nil image supplied");
        return nil;
    }
    
    UIImage *buttonImage = [UIImage imageNamed: imageName];
    UIImage *buttonPressedImage = [UIImage imageNamed: [NSString stringWithFormat: @"%@_pressed", imageName]];
	
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [button setImage: buttonImage forState: UIControlStateNormal];
    [button setImage: buttonPressedImage forState: UIControlStateHighlighted];
    //  button.backgroundColor = [UIColor greenColor];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        button.frame= CGRectMake(0, 0, 1.5*buttonImage.size.width, 1.5*buttonImage.size.height);
    }
    else{
        button.frame= CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    }
	//button.frame= CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
	[button addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    
    return button;
}


- (void)createNavBar
{
    [super createNavBar];
    
    [self createLeftNavBarButtonWithTitle: NSLocalizedString(@"", @"Info screen nav bar button") target: self action: @selector(goBack:)];
    [self createNavBarTitleWithText: [NSString stringWithFormat: NSLocalizedString(@"Shop", @"Info screen nav bar title"),
                                      [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]]];
    
    CGRect navBarTitleLabelFrame = self.navBarTitleLabel.frame;
    
   // navBarTitleLabelFrame.size.width += 50;
    self.navBarTitleLabel.textAlignment = UITextAlignmentCenter;   
    self.navBarTitleLabel.frame = navBarTitleLabelFrame;
    self.navBarTitleLabel.textColor = [UIColor whiteColor];
    self.navBarTitleLabel.font = [UIFont fontWithName:@"Forte" size: 25];

}


- (void) purchasePressed: (id)sender
{
    if ( [sender isKindOfClass: [UIButton class]] ) {
        PurchaseEntity *pressedPack = [[DataModel sharedInstance].packsArray objectAtIndex: [self.renderedPurchases indexOfObject: sender]];
        [[DataModel sharedInstance] purchasePack: pressedPack];
        
        debug(@"pressd pack %@", pressedPack);   
        [FlurryAnalytics logEvent: @"BuyNowPack"
                   withParameters: [NSDictionary dictionaryWithObjectsAndKeys: pressedPack.name, @"PackName", nil]
                            timed: NO];

    }
}


- (void)restorePurchasesPressed: (id)sender
{
    debug(@"WILL restore");
    [FlurryAnalytics logEvent: @"RestorePurchases"];
    [[DataModel sharedInstance] restorePurchases];
}

- (void)goBack: (id)sender
{
    [FlurryAnalytics logEvent: @"GoBackToStartPage"];
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}



- (void) updatePackView: (NSNotification *)notification
{
    //    [self.segmentedControl updatePurchased: pack];
    //Quang
    [self.renderedPurchases removeAllObjects];
    NSArray *purchasePackArray = [DataModel sharedInstance].packsArray;
    
    [purchasePackArray enumerateObjectsUsingBlock: ^(PurchaseEntity* pack, NSUInteger idx, BOOL *stop) {
        [self renderPack: pack withIndex: idx];
    }];
    
}


@end
