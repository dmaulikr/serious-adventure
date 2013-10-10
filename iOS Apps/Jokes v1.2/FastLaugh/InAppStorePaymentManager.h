//
//  InAppStorePaymentManager.h
//  StacheMash
//
//  Created by Konstantin Sokolinskyi on 3/16/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPaymentQueue.h>

@protocol InAppStorePaymentManagerProtocol <NSObject>

- (void)didPurchaseProductWithIdentifier: (NSString*)productId;
- (void)didRestoreProductWithIdentifier: (NSString*)productId;

@end


@interface InAppStorePaymentManager : NSObject
    <SKProductsRequestDelegate,
    SKRequestDelegate,
    SKPaymentTransactionObserver>

@property (strong, readonly, nonatomic) NSArray *products;
@property (assign, nonatomic) id<InAppStorePaymentManagerProtocol> delegate;

- (void)requestProductsFromApple: (NSSet*)productIDs;
- (void)makePaymentWithProductIdentifier: (NSString*)productIdentifier;
- (void)restorePurchases;

@end