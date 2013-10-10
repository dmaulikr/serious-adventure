//
//  DataModel.h
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/20/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InAppStorePaymentManager.h"
#import "FlurryAnalytics.h"

@class CategoryEntity;
@class InsultEntity;
@class PurchaseEntity;
@protocol DataModelPurchaseDelegate <NSObject>

- (void)removeAdBanner;

@end

@interface DataModel : NSObject<InAppStorePaymentManagerProtocol>


+(DataModel*)sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly, nonatomic) NSArray *packsArray;
@property (strong, readonly, nonatomic) InAppStorePaymentManager *paymentManager;
@property (assign, nonatomic) BOOL redrawPacksView;
@property (assign, nonatomic) BOOL shouldShowBannerAds;
@property (assign, nonatomic) id<DataModelPurchaseDelegate> purchaseDelegate;
@property (strong, nonatomic, readonly) NSString *playHavenToken;
@property (strong, nonatomic, readonly) NSString *playHavenSecret;

- (int)categoriesCount;
- (void)importInsults;

- (CategoryEntity*)categoryWithName: (NSString*)name;
- (InsultEntity*)randomInsultInCategory: (CategoryEntity*)category;

- (void)purchasePack: (PurchaseEntity*) pack;
- (void)restorePurchases;

- (PurchaseEntity*) packWithIdentifier: (NSString*)productId;
- (SKProduct*)productForPack: (PurchaseEntity*)pack;
- (void) removeBannerAd;
- (BOOL) shouldShowBannerAds;


@end
