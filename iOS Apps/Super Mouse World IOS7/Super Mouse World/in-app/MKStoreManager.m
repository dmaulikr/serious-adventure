

#import "MKStoreManager.h"
#import "AppSettings.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;

// all your features should be managed one and only by StoreManager

#if FREE_ELE_VERSION

static NSString *featureGetCoin50 = @"com.topgame.supermousefree.coin50";
static NSString *featureGetCoin400 = @"com.topgame.supermousefree.coin400";
static NSString *featureGetCoin1500 = @"com.topgame.supermousefree.coin1500";
static NSString *featureGetCoin5000 = @"com.topgame.supermousefree.coin5000";

//static NSString *featureOpenLevel1 = @"com.twotenmobile.supermousefree.openlevel1";
static NSString *featureOpenLevel2 = @"com.topgame.supermousefree.openlevel2";
static NSString *featureOpenLevel3 = @"com.topgame.supermousefree.openlevel3";
static NSString *featureOpenLevel4 = @"com.topgame.supermousefree.openlevel4";

static NSString *featureAllOpenLevel = @"com.topgame.supermousefree.allopenlevel";

static NSString * kConsumableIdPaidVersion    = @"com.topgame.supermouse.removeAds";


#elif PAID_ELE_VERSION

static NSString *featureGetCoin50 = @"com.topgame.supermousefreeHD.coin50";
static NSString *featureGetCoin400 = @"com.topgame.supermousefreeHD.coin400";
static NSString *featureGetCoin1500 = @"com.topgame.supermousefreeHD.coin1500";
static NSString *featureGetCoin5000 = @"com.topgame.supermousefreeHD.coin5000";

//static NSString *featureOpenLevel1 = @"com.twotenmobile.supermousefreeHD.openlevel1";
static NSString *featureOpenLevel2 = @"com.topgame.supermousefreeHD.openlevel2";
static NSString *featureOpenLevel3 = @"com.topgame.supermousefreeHD.openlevel3";
static NSString *featureOpenLevel4 = @"com.topgame.supermousefreeHD.openlevel4";

static NSString *featureAllOpenLevel = @"com.topgame.supermousefreeHD.allopenlevels";

static NSString * kConsumableIdPaidVersion    = @"com.topgame.supermouseHD.removeAds";



#elif FREEHD_ELE_VERSION

static NSString *featureGetCoin50 = @"com.topgame.supermousefreeHD.coin50";
static NSString *featureGetCoin400 = @"com.topgame.supermousefreeHD.coin400";
static NSString *featureGetCoin1500 = @"com.topgame.supermousefreeHD.coin1500";
static NSString *featureGetCoin5000 = @"com.topgame.supermousefreeHD.coin5000";

//static NSString *featureOpenLevel1 = @"com.twotenmobile.supermousefreeHD.openlevel1";
static NSString *featureOpenLevel2 = @"com.topgame.supermousefreeHD.openlevel2";
static NSString *featureOpenLevel3 = @"com.topgame.supermousefreeHD.openlevel3";
static NSString *featureOpenLevel4 = @"com.topgame.supermousefreeHD.openlevel4";

static NSString *featureAllOpenLevel = @"com.topgame.supermousefreeHD.allopenlevels";

static NSString * kConsumableIdPaidVersion    = @"com.topgame.supermouseHD.removeAds";


#elif PAIDHD_ELE_VERSION

static NSString *featureGetCoin50 = @"com.topgame.supermousepaidHD.coin50";
static NSString *featureGetCoin400 = @"com.topgame.supermousepaidHD.coin400";
static NSString *featureGetCoin1500 = @"com.topgame.supermousepaidHD.coin1500";
static NSString *featureGetCoin5000 = @"com.topgame.supermousepaidHD.coin5000";

//static NSString *featureOpenLevel1 = @"com.twotenmobile.supermousepaidHD.openlevel1";
static NSString *featureOpenLevel2 = @"com.topgame.supermousepaidHD.openlevel2";
static NSString *featureOpenLevel3 = @"com.topgame.supermousepaidHD.openlevel3";
static NSString *featureOpenLevel4 = @"com.topgame.supermousepaidHD.openlevel4";

static NSString *featureAllOpenLevel = @"com.topgame.supermousepaidHD.allopenlevel";

static NSString * kConsumableIdPaidVersion    = @"com.topgame.supermouseHD.removeAds";

#else

static NSString *featureGetCoin50 = @"com.topgame.supermousefree.coin50";
static NSString *featureGetCoin400 = @"com.topgame.supermousefree.coin400";
static NSString *featureGetCoin1500 = @"com.topgame.supermousefree.coin1500";
static NSString *featureGetCoin5000 = @"com.topgame.supermousefree.coin5000";

//static NSString *featureOpenLevel1 = @"com.twotenmobile.supermousefree.openlevel1";
static NSString *featureOpenLevel2 = @"com.topgame.supermousefree.openlevel2";
static NSString *featureOpenLevel3 = @"com.topgame.supermousefree.openlevel3";
static NSString *featureOpenLevel4 = @"com.topgame.supermousefree.openlevel4";

static NSString *featureAllOpenLevel = @"com.topgame.supermousefree.allopenlevel";

static NSString * kConsumableIdPaidVersion    = @"com.topgame.supermouse.removeAds";

#endif

BOOL featureGetCoin50Purchased;
BOOL featureGetCoin400Purchased;
BOOL featureGetCoin1500Purchased;
BOOL featureGetCoin5000Purchased;

//BOOL featureGetLevel1Pruchased;
BOOL featureGetLevel2Pruchased;
BOOL featureGetLevel3Pruchased;
BOOL featureGetLevel4Pruchased;

BOOL featureAllOpenLevelPurchased;
BOOL featurePaidVersion;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
	
	[_sharedStoreManager release];
	[storeObserver release];
	[super dealloc];
}

+ (BOOL) featureAllOpenLevelPurchased {	
	return featureAllOpenLevelPurchased;
}


+ (MKStoreManager*)sharedManager
{
	NSLog(@"pass sharedManager");
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
			[_sharedStoreManager requestProductData];
			
			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

//- (void)release
//{
//    //do nothing
//}

- (id)autorelease
{
    return self;	
}


- (void) requestProductData
{
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: 
								 [NSSet setWithObjects: 
								  featureAllOpenLevel,
//                                  featureOpenLevel1,
                                  featureOpenLevel2,
                                  featureOpenLevel3,
                                  featureOpenLevel4,
                                  kConsumableIdPaidVersion,
								  nil]]; // add any other product here
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
			  [[product price] doubleValue], [product productIdentifier]);
	}
	
	[request autorelease];
}

- (void) buyFeatureGetCoin50 {
	[self buyFeature:featureGetCoin50];
}
- (void) buyFeatureGetCoin400 {
	[self buyFeature:featureGetCoin400];
}
- (void) buyFeatureGetCoin1500 {
	[self buyFeature:featureGetCoin1500];
}

- (void) buyFeatureGetCoin5000 {
	[self buyFeature:featureGetCoin5000];
}
//
//- (void) buyFeatureOpenLevel1{
//    [ self buyFeature:featureOpenLevel1 ];
//}

- (void) buyFeatureOpenLevel2{
    [ self buyFeature:featureOpenLevel2 ];
}

- (void) buyFeatureOpenLevel3{
    [ self buyFeature:featureOpenLevel3 ];
}

- (void) buyFeatureOpenLevel4{
    [ self buyFeature:featureOpenLevel4 ];
}

- (void) buyfeatureAllOpenLevel {
	[self buyFeature:featureAllOpenLevel];	
}

- (void) buyFeaturePaidRemoveADS{
    [self buyFeature:kConsumableIdPaidVersion ];
}

- (void) buyFeature:(NSString*) featureId
{
//	[self setLockKey: featureId];
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SuperMario" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void) setLockKey: (NSString*) productIdentifier
{
	
	if([productIdentifier isEqualToString:featureGetCoin50]){
		[AppSettings addCoin:50];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshCoinCount" object:nil];
    }
	if([productIdentifier isEqualToString:featureGetCoin400]){
    
		[AppSettings addCoin:400];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshCoinCount" object:nil];

    }
	if([productIdentifier isEqualToString:featureGetCoin1500]){
		[AppSettings addCoin:1500];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshCoinCount" object:nil];

    }
    if([productIdentifier isEqualToString:featureGetCoin1500]){
		[AppSettings addCoin:5000];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshCoinCount" object:nil];

    }

//    if([productIdentifier isEqualToString:featureOpenLevel1]){
//		[ AppSettings setLockLevelStae:1 bFlag:NO ];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshStageLayer" object:nil];
//        
//    }
    
    if([productIdentifier isEqualToString:featureOpenLevel2]){
		[ AppSettings setLockLevelStae:2 bFlag:NO ];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshStageLayer" object:nil];
        
    }
    
    if([productIdentifier isEqualToString:featureOpenLevel3]){
		[ AppSettings setLockLevelStae:3 bFlag:NO ];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshStageLayer" object:nil];
        
    }
    
    if([productIdentifier isEqualToString:featureOpenLevel4]){
		[ AppSettings setLockLevelStae:4 bFlag:NO ];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_RefreshStageLayer" object:nil];
        
    }


	if([productIdentifier isEqualToString:featureAllOpenLevel])
		[AppSettings lockAllStage:NO];
    
}

-(void) provideContent: (NSString*) productIdentifier
{
    
    if([productIdentifier isEqualToString:featureGetCoin50])
		featureGetCoin50Purchased = YES;
	if([productIdentifier isEqualToString:featureGetCoin400])
		featureGetCoin400Purchased = YES;
	if([productIdentifier isEqualToString:featureGetCoin1500])
		featureGetCoin1500Purchased = YES;
    if([productIdentifier isEqualToString:featureGetCoin5000])
		featureGetCoin5000Purchased = YES;
        
	if([productIdentifier isEqualToString:featureAllOpenLevel])
		featureAllOpenLevelPurchased = YES;
	
    if([productIdentifier isEqualToString:kConsumableIdPaidVersion])
		featurePaidVersion = YES;

	[MKStoreManager updatePurchases];
    
}


+(void) loadPurchases 
{
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	featureAllOpenLevelPurchased = [userDefaults boolForKey:featureAllOpenLevel];
    featurePaidVersion = [userDefaults boolForKey:kConsumableIdPaidVersion];

}


+(void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:featureAllOpenLevelPurchased forKey:featureAllOpenLevel];
    [userDefaults setBool:featurePaidVersion forKey:kConsumableIdPaidVersion ];

}
-(void)restorePurchase
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}

+(void) makePaidVersion
{
    featurePaidVersion  =   YES;
    [ self updatePurchases ];
}

+ (BOOL) featurePaidVersionPurchase {
    return featurePaidVersion;
}


@end
