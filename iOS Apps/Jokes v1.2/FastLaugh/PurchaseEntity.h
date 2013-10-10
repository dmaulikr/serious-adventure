//
//  PurchaseEntity.h
//  InsultShake
//
//  Created by Tatyana Remayeva on 7/3/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PurchaseEntity : NSObject

@property (nonatomic, retain) NSString * name;

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * isBought;
@property (nonatomic, retain) NSString * iap_id;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * descr;


- (id) initWithDictionary: (NSDictionary*)dict;

@end
