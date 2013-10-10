

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;	
	
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;

- (void) requestProductData;

- (void) buyFeatureGetCoin50;
- (void) buyFeatureGetCoin400;
- (void) buyFeatureGetCoin1500;
- (void) buyFeatureGetCoin5000;

//- (void) buyFeatureOpenLevel1;
- (void) buyFeatureOpenLevel2;
- (void) buyFeatureOpenLevel3;
- (void) buyFeatureOpenLevel4;

- (void) buyfeatureAllOpenLevel;
- (void) buyFeaturePaidRemoveADS;

// do not call this directly. This is like a private method
- (void) buyFeature:(NSString*) featureId;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier;

+ (MKStoreManager*)sharedManager;

+ (BOOL) featureAllOpenLevelPurchased;

+(void) loadPurchases;
+(void) updatePurchases;
-(void)restorePurchase;
-(void) setLockKey: (NSString*) productIdentifier;

+(void) makePaidVersion;
+ (BOOL) featurePaidVersionPurchase;

@end
