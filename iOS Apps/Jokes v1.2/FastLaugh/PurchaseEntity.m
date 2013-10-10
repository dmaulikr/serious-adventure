//
//  PurchaseEntity.m
//  FastLaugh
//
//  Created by Tatyana Remayeva on 7/3/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import "PurchaseEntity.h"


@implementation PurchaseEntity

@synthesize name;
@synthesize isBought;
@synthesize iap_id;
@synthesize image;
@synthesize path;
@synthesize descr;


- (id) initWithDictionary: (NSDictionary*)dict
{	
	if ( self = [super init] ) {
		
		if ( nil != dict ) {
            self.name = [dict objectForKey: @"name"];
            self.isBought = [dict objectForKey: @"isBought"];
            self.path = [dict objectForKey: @"path"];
            self.image = [dict objectForKey: @"image"];
            self.descr = [dict objectForKey: @"descr"];
            self.iap_id = [dict objectForKey: @"iap_id"];
        }    
    }
	return self;
}


@end
