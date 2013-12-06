//
//  GameStoreViewController.h
//  LetsSlot
//
//  Created by Tanut Apiwong on 9/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>
#import "GameVariables.h"

@interface GameStoreViewController : UIViewController <SKProductsRequestDelegate> {
	
	UIActivityIndicatorView *activityIndicatorView;
	UILabel *lblLoading;
	UILabel *lblProductTitle;
	UITextView *txtProductDescription;
	UITextView *txtGamecenterDescription;
	UITextView *txtRestoreDescription;
	UITextView *txtMoreGamesDescription;
	UIButton *btnBuyProduct;
	UIButton *btnGameCenter;
	UIButton *btnMoreGame;
	UIButton *btnRestore;
	UIButton *btnReturn;
	UIImageView *unlockInfoImage;
	
	UIActivityIndicatorView *activityIndicatorPurchasingView;
	UILabel *lblPurchasing;
	
	NSTimer *timer;
	
	id mainGameParent;
	bool bErrorOnConnection;
}

- (void)setMainGameParent:(id) parent;
- (void)requestProductData;
- (IBAction) closePressed:(id) sender;
- (IBAction) purchaseUnlock:(id) sender;
- (IBAction) gameCenter:(id) sender;
- (IBAction) restore:(id) sender;
- (IBAction) moreGames:(id) sender;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) IBOutlet UILabel *lblLoading;
@property (nonatomic, retain) IBOutlet UILabel *lblProductTitle;
@property (nonatomic, retain) IBOutlet UITextView *txtProductDescription;
@property (nonatomic, retain) IBOutlet UITextView *txtGamecenterDescription;
@property (nonatomic, retain) IBOutlet UITextView *txtRestoreDescription;
@property (nonatomic, retain) IBOutlet UITextView *txtMoreGamesDescription;
@property (nonatomic, retain) IBOutlet UIButton *btnBuyProduct;
@property (nonatomic, retain) IBOutlet UIButton *btnGameCenter;
@property (nonatomic, retain) IBOutlet UIButton *btnRestore;
@property (nonatomic, retain) IBOutlet UIButton *btnMoreGame;
@property (nonatomic, retain) IBOutlet UIButton *btnReturn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorPurchasingView;
@property (nonatomic, retain) IBOutlet UILabel *lblPurchasing;
@property (nonatomic, retain) IBOutlet UIImageView *unlockInfoImage;

@end
