//
//  InAppStorePaymentManager.m
//  StacheMash
//
//  Created by Konstantin Sokolinskyi on 3/16/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <StoreKit/SKError.h>

#import "InAppStorePaymentManager.h"
#import "GUIHelper.h"
#import "PlayHavenSDK.h"
#import "DataModel.h"

@interface InAppStorePaymentManager ()

- (void)dumpProduct: (SKProduct*)product;
- (void)dumpTransaction: (SKPaymentTransaction*)transaction;

- (void)completeTransaction: (SKPaymentTransaction*)transaction;
- (void)failedTransaction: (SKPaymentTransaction*)transaction;
- (void)restoreTransaction: (SKPaymentTransaction*)transaction;
- (void)finishTransaction: (SKPaymentTransaction*)transaction;

@end


@implementation InAppStorePaymentManager

@synthesize products = __products;
@synthesize delegate = __delegate;

- (id)init
{
	if ( self = [super init] ) {
		[[SKPaymentQueue defaultQueue ] addTransactionObserver: self];
	}
	return self;
}


- (void)requestProductsFromApple: (NSSet*)productIDs
{
    if ( 0 == [productIDs count] ) {
        error(@"empty products set supplied");
        return;
    }
	
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers: productIDs];
	request.delegate = self;
	[request start];
}


- (void)makePaymentWithProductIdentifier: (NSString*)productIdentifier
{
    if ([SKPaymentQueue canMakePayments]) {
        debug( @"making payment with product identifier: %@", productIdentifier );
        
        SKPayment *payment = [SKPayment paymentWithProductIdentifier: productIdentifier];
        [[SKPaymentQueue defaultQueue] addPayment: payment];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                        message: NSLocalizedString(@"It looks like you have disabled In-App purchases in your settings. Please enable them and try again.", @"Disabled IAP alert message text")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
    }
}


- (void)restorePurchases
{
    debug(@"initiating restoring tranasction");
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


- (void)dumpProduct: (SKProduct*)product
{
	debug( @"localizedDescription: %@", product.localizedDescription );
	debug( @"localizedTitle: %@", product.localizedTitle );
	debug( @"price: %@", product.price );
	debug( @"priceLocale: %@", product.priceLocale );
	debug( @"productIdentifier: %@", product.productIdentifier );	
}


- (void)dumpTransaction: (SKPaymentTransaction*)transaction
{
	debug( @"error: %@", transaction.error );
	debug( @"transactionState: %d", transaction.transactionState );
	debug( @"transactionIdentifier: %@", transaction.transactionIdentifier );
	debug( @"transactionReceipt: %@", transaction.transactionReceipt );
	debug( @"transactionDate: %@", transaction.transactionDate );
}


#pragma mark - SKRequestDelegate

- (void)requestDidFinish: (SKRequest*)request
{
    debug(@"request DID finish: %@", request);
}
          

- (void)request: (SKRequest*)request didFailWithError: (NSError*)error
{
	error(@"error getting products: %@ for request: %@", [error localizedDescription], request);
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest: (SKProductsRequest*)request didReceiveResponse: (SKProductsResponse*)response
{
	debug( @"valid products received count: %d", [response.products count]);
	
    __products = response.products;
	
	debug(@"invalid products identifiers received count: %d", [response.invalidProductIdentifiers count]);
	for ( NSString *invalidIdentifier in response.invalidProductIdentifiers ) {
		debug( @"invalid product identifier: %@", invalidIdentifier );
	}
}


#pragma mark SKPaymentTransactionObserver

- (void) paymentQueue: (SKPaymentQueue*)queue updatedTransactions: (NSArray*)transactions
{
    debug(@"UPDATED transactions");
    
	for (SKPaymentTransaction* transaction in transactions) {
		
        switch ( transaction.transactionState )
        {
            case SKPaymentTransactionStatePurchased:
				debug( @"state = SKPaymentTransactionStatePurchased" );
                [self completeTransaction: transaction ];
                break;
            case SKPaymentTransactionStateFailed:
				debug( @"state = SKPaymentTransactionStateFailed" );
                [self failedTransaction: transaction ];
                break;
            case SKPaymentTransactionStateRestored:
				debug( @"state = SKPaymentTransactionStateRestored" );
                [self restoreTransaction: transaction ];
			case SKPaymentTransactionStatePurchasing:
				debug( @"state = SKPaymentTransactionStatePurchasing... going on" );
				break;
            default:
				debug( @"state = unknown. WTF?" );
                break;
        }
    }
}


- (void)paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentQueue*)queue
{
    debug(@"RESTORING complete");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Restoring Complete", @"Restore purchases OK alert title")
                                                    message: NSLocalizedString(@"All purchases have been successfully restored. Enjoy your insults!", @"Restore purchases OK alert text")
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                          otherButtonTitles: nil];
    [alert show];
}


- (void)paymentQueue: (SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError: (NSError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                    message: [NSString stringWithFormat: NSLocalizedString(@"Restoring purchases failed with error: %@", @"Restore purchases error alert text"), [error localizedDescription]]
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                          otherButtonTitles: nil];
    [alert show];
}



#pragma mark - Transaction completion

- (void)completeTransaction: (SKPaymentTransaction*)transaction
{
    debug(@"completed transaction: %@", transaction);

    [self.delegate didPurchaseProductWithIdentifier: transaction.payment.productIdentifier];
    [self finishTransaction: transaction];
    //Quang Start
    [[PHPublisherIAPTrackingRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret product: transaction.payment.productIdentifier quantity: 1 resolution:PHPurchaseResolutionBuy receiptData:nil] send];
    
    //End
    
}


- (void)restoreTransaction: (SKPaymentTransaction*)transaction
{
    debug(@"restore transaction: %@", transaction);
    
    [self.delegate didRestoreProductWithIdentifier: transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction: transaction];
}


- (void)failedTransaction: (SKPaymentTransaction*)transaction
{
    error( @"transaction failed with error: code = %d, description = %@ ",
		  [transaction.error code],
		  [transaction.error localizedDescription]);
	
	if ( SKErrorPaymentCancelled != transaction.error.code ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                        message: [NSString stringWithFormat: NSLocalizedString(@"Purchase failed with error: %@", @"Purchases failed error alert title"), [transaction.error localizedDescription]]
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
	}
    
    [self finishTransaction: transaction];
    //Quang Start
    [[PHPublisherIAPTrackingRequest requestForApp: [DataModel sharedInstance].playHavenToken secret: [DataModel sharedInstance].playHavenSecret product: transaction.payment.productIdentifier quantity: 1 error: transaction.error receiptData:nil] send];
    
    //End
    
    
}



- (void)finishTransaction: (SKPaymentTransaction*)transaction
{
    debug(@"finishing transaction");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end