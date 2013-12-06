//
//  Element.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Element : NSManagedObject

@property (nonatomic, retain) NSNumber * isBookmarked;
@property (nonatomic, retain) NSNumber * isMastered;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSManagedObject *quiz;

@end
