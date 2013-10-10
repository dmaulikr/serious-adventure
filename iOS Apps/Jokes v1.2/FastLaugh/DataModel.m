//
//  DataModel.m
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/20/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import "DataModel.h"
#import "CategoryEntity.h"
#import "InsultEntity.h"
#import "PurchaseEntity.h"
#import "AppDelegate.h"

static NSString *kRemoveAdsProductId = @"com.brightnewt.fastlaughjokes.remove_banner_ad";

static NSString *kNSUserDefaultsShouldShowBannerAds = @"kNSUserDefaultsShouldShowBannerAds";


@interface DataModel ()


- (int)minInsultShowCountInCategory: (CategoryEntity*)category;
- (NSArray*)minCountInsultsInCategory: (CategoryEntity*)category;
- (NSSet*)productIDs;


- (void)importInsultsFromFileNamed: (NSString*)fileName intoCategoryNamed: (NSString*)categoryName withBoughtFlag: (BOOL)isBought;
- (NSArray*)insultsFromFileNamed: (NSString*)fileName;

- (BOOL)userDefaultsBoolFlagWithName: (NSString*)flagName;

- (void)setUserDefaultsBoolFlagWithName: (NSString*)flagName toValue: (BOOL)value;
- (BOOL)keyExistsInUserDefaults: (NSString*)key;

@end


@implementation DataModel

@synthesize managedObjectContext = __managedObjectContext;
@synthesize packsArray = __packsArray;
@synthesize paymentManager = __paymentManager;
@synthesize redrawPacksView = __redrawPacksView;

@synthesize purchaseDelegate = __purchaseDelegate;
@dynamic shouldShowBannerAds;

#pragma LifyCycle

+(DataModel*)sharedInstance {
    static dispatch_once_t predicate;
    static DataModel *sharedModel = nil;
    
    dispatch_once(&predicate, ^{
        sharedModel = [[DataModel alloc] init];
    });
    
    return sharedModel;
}


- (id)init
{
    self = [super init];
    if ( self ) {
        [self copyMustachePlistToDocuments];

        __paymentManager = [[InAppStorePaymentManager alloc] init];
        self.paymentManager.delegate = self;
        [self.paymentManager requestProductsFromApple: [self productIDs]];
        
        
        if ( ![self keyExistsInUserDefaults: kNSUserDefaultsShouldShowBannerAds] ) {
            self.shouldShowBannerAds = YES;
        }
         
    }
    self.redrawPacksView = NO;
    return self;
}

#pragma mark - Public

- (int)categoriesCount
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"CategoryEntity"
                                    inManagedObjectContext: self.managedObjectContext]];
    
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest: request
                                                                 error: &error];
    if (!error) {
        debug(@"available categories count: %d", count);
        return count;
    }
    else {
        error(@"Error: %@", [error description]);
        return 0;
    }
}


- (void)importInsults
{
    [self importInsultsFromFileNamed: @"Jokes.txt" intoCategoryNamed: @"Jokes" withBoughtFlag: YES];
    [self importInsultsFromFileNamed: @"KnockKnock.txt" intoCategoryNamed: @"KnockKnock" withBoughtFlag: NO];
    [self importInsultsFromFileNamed: @"OneLiners.txt" intoCategoryNamed: @"OneLiners" withBoughtFlag: NO];
    [self importInsultsFromFileNamed: @"ToughGuy.txt" intoCategoryNamed: @"ToughGuy" withBoughtFlag: NO];

}


- (CategoryEntity*)categoryWithName: (NSString*)name
{
    if ( nil == name ) {
        error(@"nil argument supplied");
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity: [NSEntityDescription entityForName: @"CategoryEntity"
                                    inManagedObjectContext: self.managedObjectContext]];
    request.predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@", name];
    
    NSError *error = nil;
    NSArray *categories = [self.managedObjectContext executeFetchRequest: request
                                                                   error: &error];
    if (!error) {
        if ( 0 < [categories count] ) {
            return [categories objectAtIndex: 0];
        }
        else {
            error(@"0 categories with name: %@", name);
            return nil;
        }
    }
    else {
        error(@"error %@", [error description]);
        return nil;
    }
}


- (InsultEntity*)randomInsultInCategory: (CategoryEntity*)category
{
    if ( nil == category ) {
        error(@"nil category supplied");
        return nil;
    }
    
    NSArray *insultsArray = [self minCountInsultsInCategory: category]; 
    
    if ( 0 == [insultsArray count] ) {
        error(@"empty insultsArray retrieved. using all insults");
        insultsArray = [category.insults allObjects];
    }
    
    debug(@"[insultsArray count]: %d", [insultsArray count]);
    
    int randomIndex = arc4random() % ([insultsArray count]);
    debug(@"randomIndex: %d", randomIndex);

    return [insultsArray objectAtIndex: randomIndex];
}


#pragma mark - Private - Insults Selection

- (int)minInsultShowCountInCategory: (CategoryEntity*)category
{
    if ( nil == category ) {
        error(@"nil category supplied");
        return -1;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"InsultEntity"
                                    inManagedObjectContext: self.managedObjectContext]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"showCount" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    request.predicate = [NSPredicate predicateWithFormat: @"category == %@", category];
    debug(@"category: %@", category);

    NSError *error = nil;
    NSArray *objectArray = [self.managedObjectContext executeFetchRequest: request error: &error];
    debug(@"sorted array count: %d", [objectArray count]);
    
    if (error) {
        error(@"Error retrieving insults category '%@' to get min showCount for: %@", category, [error description]);
        return -1;
    }
    
    InsultEntity *insult = [objectArray  objectAtIndex: 0];
    debug(@"min count: %d", [insult.showCount intValue]);
    return [insult.showCount intValue];
}


- (NSArray*)minCountInsultsInCategory: (CategoryEntity*)category
{
    if ( nil == category ) {
        error(@"nil category supplied");
        return nil;
    }
    
    int minShowCount = [self minInsultShowCountInCategory: category];
    debug(@"minShowCount: %d", minShowCount);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"InsultEntity"
                                    inManagedObjectContext: self.managedObjectContext]];
    
    if ( minShowCount != -1 ) {
        request.predicate = [NSPredicate predicateWithFormat:@"showCount <= %d AND category == %@", minShowCount, category];
    }
    
    NSError *error = nil;
    NSArray *objectArray = [self.managedObjectContext executeFetchRequest: request error: &error];
    debug(@"objectArray count: %d", [objectArray count]);
    
    if (error) {
        error(@"Error retrieving min count insults for category '%@': %@", category, [error description]);
        return nil;
    }
    
    return objectArray;
}


#pragma mark - Private - Insults Import

- (void)dumpObjectsForEntityNamed: (NSString*)entityName
{
    if ( 0 == [entityName length] ) {
        error(@"empty entityName provided");
        return;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity: [NSEntityDescription entityForName: entityName
                                    inManagedObjectContext: self.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *entities = [self.managedObjectContext executeFetchRequest: request
                                                                 error: &error];
    
    if ( nil != error ) {
        error(@"error fetching entity '%@': %@", entityName, error);
    }
    else {
        debug(@"object for entity: %@", entityName);
        [DebugHelper dumpArray: entities];
    }
}


- (void)importInsultsFromFileNamed: (NSString*)fileName intoCategoryNamed: (NSString*)categoryName withBoughtFlag: (BOOL)isBought
{
    if ( 0 == [fileName length] || 0 == [categoryName length] ) {
        error(@"empty argument provided");
        return;
    }
    
    NSArray *insultsArray = [self insultsFromFileNamed: fileName];
    if ( 0 == [insultsArray count] ) {
        error(@"zero insults retrieved from file named: %@", fileName);
    }
    
    CategoryEntity *category =
    (CategoryEntity*) [NSEntityDescription insertNewObjectForEntityForName: @"CategoryEntity"
                                                    inManagedObjectContext: self.managedObjectContext];
    
    category.name = categoryName;
    category.isBought = [NSNumber numberWithBool: isBought];
    
    for ( NSString* insultString in insultsArray ) {
        InsultEntity *insult =
        (InsultEntity*)[NSEntityDescription insertNewObjectForEntityForName: @"InsultEntity"
                                                     inManagedObjectContext: self.managedObjectContext];
        
        insult.insult = insultString;
        [category addInsultsObject: insult];
    }
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save: &error]) {
        abort();
        //[[DataModel sharedInstance] handleSaveContextError: error];
    }
}


- (NSArray*)insultsFromFileNamed: (NSString*)fileName
{
    if ( 0 == [fileName length] ) {
        error(@"empty fileName provided");
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource: fileName ofType: nil];
    NSError *error = nil;
    NSString *insultsString = [NSString stringWithContentsOfFile: filePath encoding: NSUTF8StringEncoding error: &error];
    
    if ( nil != error ) {
        error(@"error reading file '%@': %@", filePath, error);
    }
    
    NSString *insultSeparator;
    if ([fileName isEqualToString:@"KnockKnock.txt"] ||[fileName isEqualToString:@"Jokes.txt"]){
        insultSeparator = [NSString stringWithFormat: @"\n---\n"];
  //      [insultSeparator formUnionWithCharacterSet:[NSCharacterSet newlineCharacterSet]];
    }
    else
        insultSeparator = [NSString stringWithFormat:@"\n"];
    debug(@"file : %@",insultsString);
    NSArray *insultsArray = [insultsString componentsSeparatedByString: insultSeparator];
    debug(@"insultsArray: %@", insultsArray);
    debug(@"insultsArray: %c",  insultSeparator);

    return insultsArray;
}


#pragma mark - @property (readonly, nonatomic) NSArray *packsArray;

- (NSArray*)packsArray
{
    if ( nil == __packsArray ) {
        __packsArray = [self loadPacksList];
    }
    return __packsArray;
}


- (NSSet*)productIDs
{
    NSMutableSet *products = [[NSMutableSet alloc] init];
    for ( PurchaseEntity *pack in self.packsArray ) {
        if ( 0 < [pack.iap_id length] ) {
            [products addObject: pack.iap_id];
        }
    }
    
    return products;
}



- (void)purchasePack: (PurchaseEntity*) pack
{
    if ( [pack.isBought boolValue] ) {
        warn(@"pack is already bought");
        return;
    }
    
    if ( 0 == [pack.iap_id length] ) {
        error(@"empty pack.IAP_id");
        return;
    }
    
    if ( nil != [self productForPack: pack] ) {
        debug(@"starting payment");
        [self.paymentManager makePaymentWithProductIdentifier: pack.iap_id];
    }
    else {
        error(@"could not find product with id: %@", pack.iap_id);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                        message: NSLocalizedString(@"Unable to retrieve product from iTunes Store. Check your internet connection and try again.", @"No products for IAP error - alert text")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
    }
}


- (void)restorePurchases
{
    debug(@"NOW will RESTORE");
    [self.paymentManager restorePurchases];
}


- (SKProduct*)productForPack: (PurchaseEntity*)pack
{
    return [self productWithIdentifier: pack.iap_id];
}


- (SKProduct*)productWithIdentifier: (NSString*)productId
{

    for ( SKProduct *product in self.paymentManager.products ) {
        if ( [product.productIdentifier isEqualToString: productId] ) {
            return  product;
        }
    }
    
    return nil;    
}

- (PurchaseEntity*) packWithIdentifier: (NSString*)productId
{
    for (PurchaseEntity *pack in self.packsArray ) {
        if ( [pack.iap_id isEqualToString: productId] ) {
            return pack;
        }
    }
    
    return nil;
}



#pragma mark - Pack lists loading

- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject];
}


- (NSArray*)loadPacksList
{
    NSDictionary* packsPlistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: [[[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"Purchases.plist"] path]];
    
    NSArray *packsPlistArray = [packsPlistDict objectForKey: @"purchases"];
    NSMutableArray *packsArray = [[NSMutableArray alloc] init];
    
    for ( NSDictionary *plistPack in packsPlistArray ) {
        PurchaseEntity *pack = [[PurchaseEntity alloc] initWithDictionary: plistPack];
        [packsArray addObject: pack];
    }
    
    return packsArray;
}

- (void)copyMustachePlistToDocuments
{
    if ( ![[NSFileManager defaultManager] fileExistsAtPath: [self purchasePlistPath]] ) {
        warn(@"no Purchases.plist in document. Copying");
        
        NSError *error = nil;
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource: @"Purchases" ofType: @"plist"];
        
        [[NSFileManager defaultManager] copyItemAtPath: sourcePath
                                                toPath: [self purchasePlistPath]
                                                 error: &error];
        
        if ( error ) {
            error(@"error copying file:\n %@\n to path:\n%@", sourcePath, [self purchasePlistPath]);
        }
        else {
            debug(@"Purchases.plist copied ok to: %@", [self purchasePlistPath]);
        }
    }
    else {
        debug(@"Purchases.plist IS in documents");
    }
}

- (NSString*)purchasePlistPath
{
    return [[[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"Purchases.plist"] path];
}


#pragma mark - InAppStorePaymentManagerProtocol

- (void)didPurchaseProductWithIdentifier: (NSString*)productId
{
    if ( [self markAsBoughtProductWithIdentifier: productId] ) {
        SKProduct *product = [self productWithIdentifier: productId];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Purchase complete", @"alert title")
                                                        message: [NSString stringWithFormat: NSLocalizedString(@"%@ has been purchased!", @"purchase alert text"), product. localizedTitle]
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
        
        [FlurryAnalytics logEvent: @"PurchasedPack"
                   withParameters: [NSDictionary dictionaryWithObjectsAndKeys: product.localizedTitle, @"PackName", nil]
                            timed: NO];
    }
    else {
        error(@"didn't find product with id: %@", productId);
    }
}


- (void)didRestoreProductWithIdentifier: (NSString*)productId
{
    [self markAsBoughtProductWithIdentifier: productId];
}


- (BOOL)markAsBoughtProductWithIdentifier: (NSString*)productId 
{
    PurchaseEntity *pack = [self packWithIdentifier: productId];
    
    if ( [productId isEqualToString: kRemoveAdsProductId] ) {
        pack.isBought = [NSNumber numberWithBool: YES];
        self.shouldShowBannerAds = NO;
        [self.purchaseDelegate removeAdBanner];
        [self updatePlistWithBoughtProductIdentifier: productId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidPurchasePack"
                                                            object:pack
                                                          userInfo:nil];
        
        
        return YES;
    }
    
    if ( nil != pack ){
            pack.isBought = [NSNumber numberWithBool: YES];
            self.redrawPacksView = YES;
                    
            [self updatePlistWithBoughtProductIdentifier: productId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidPurchasePack"
                                              object:pack
                                            userInfo:nil];

            return YES;
        }
    else {
            error(@"didn't find product with id: %@", productId);
            return NO;
        }
   
}


- (void)updatePlistWithBoughtProductIdentifier: (NSString*)productId
{
    NSMutableDictionary* packsPlistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: [self purchasePlistPath]];
    
    for ( NSMutableDictionary *pack in [packsPlistDict objectForKey: @"purchases"] ) {
        NSString *IAP_id = [pack objectForKey: @"iap_id"];
        
        if ( [IAP_id isEqualToString: productId] ) {
            [pack setObject: [NSNumber numberWithBool: YES] forKey: @"isBought"];
            [packsPlistDict writeToFile: [self purchasePlistPath] atomically: YES];
            return;
        }
    }
    
    warn(@"didn't find product with IAP id: %@ in plist", productId);
}


- (void)removeBannerAd
{
    if ( !self.shouldShowBannerAds ) {
        warn(@"banners are already disabled");
        return;
    }
    
    if ( nil != [self productWithIdentifier: kRemoveAdsProductId] ) {
        debug(@"starting payment");
        [self.paymentManager makePaymentWithProductIdentifier: kRemoveAdsProductId];
    }
    else {
        error(@"could not find product with id: %@", kRemoveAdsProductId);
        [self showNoiTunesProductsError];
    }
}


- (void)showNoiTunesProductsError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"")
                                                    message: NSLocalizedString(@"Unable to retrieve product from iTunes Store. Check your internet connection and try again.", @"No products for IAP error - alert text")
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                          otherButtonTitles: nil];
    [alert show];
}

- (BOOL)shouldShowBannerAds
{
    return [self userDefaultsBoolFlagWithName: kNSUserDefaultsShouldShowBannerAds];
}

- (BOOL)userDefaultsBoolFlagWithName: (NSString*)flagName
{
	NSNumber *flag = [[NSUserDefaults standardUserDefaults] objectForKey: flagName];
	return [flag boolValue];
}
- (void)setShouldShowBannerAds: (BOOL)flag
{
    [self setUserDefaultsBoolFlagWithName: kNSUserDefaultsShouldShowBannerAds toValue: flag];
}
- (void)setUserDefaultsBoolFlagWithName: (NSString*)flagName toValue: (BOOL)value
{
	NSNumber *flag = [NSNumber numberWithBool: value];
	
	[[NSUserDefaults standardUserDefaults] setObject: flag forKey: flagName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)keyExistsInUserDefaults: (NSString*)key
{
    return nil != [[NSUserDefaults standardUserDefaults] objectForKey: key];
}

#pragma mark - @property (strong, nonatomic, readonly) NSString *playHavenToken;


- (NSString*)playHavenToken
{
    return PLAYHAVEN_TOKEN;//@"799fa1340b0040b8a47347756cbace78";
}

#pragma mark - @property (strong, nonatomic, readonly) NSString *playHavenSecret;

- (NSString*)playHavenSecret
{
    return PLAYHAVEN_SECRET;//@"2089fcfb27a5485a85f607762c3b8a3b";
}



@end
