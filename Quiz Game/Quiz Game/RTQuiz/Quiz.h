//
//  Quiz.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Element;

@interface Quiz : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *elements;
@end

@interface Quiz (CoreDataGeneratedAccessors)

- (void)addElementsObject:(Element *)value;
- (void)removeElementsObject:(Element *)value;
- (void)addElements:(NSSet *)values;
- (void)removeElements:(NSSet *)values;

@end
