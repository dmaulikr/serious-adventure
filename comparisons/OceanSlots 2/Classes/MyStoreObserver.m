//
//  MyStoreObserver.m
//  LetsSlot
//
//  Created by Tanut Apiwong on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyStoreObserver.h"
#import "GameVariables.h"

@implementation MyStoreObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
				NSLog(@"Transaction Purchased");
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
				NSLog(@"Transaction Failed");
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
				NSLog(@"Transaction Restored");
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}


- (void) provideContent: (NSString *) productIndentifier {
	if ([productIndentifier isEqualToString:kPayoutUnlockProduct]) {
		bPayoutLocked = NO;
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setBool:NO forKey:KEY_PAYOUTLOCKED];
		[userDefaults synchronize];
	}
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
	// Your application should implement these two methods.
    //[self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
	
	// Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //[self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)restoreFunc
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


@end
