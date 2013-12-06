//
//  MyStoreObserver.h
//  LetsSlot
//
//  Created by Tanut Apiwong on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/SKPayment.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <StoreKit/SKError.h>

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver>  {

}

- (void) provideContent: (NSString *) productIndentifier;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreFunc;

@end
