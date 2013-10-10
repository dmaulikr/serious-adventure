//
//  CategoryEntity.h
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/20/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InsultEntity;

@interface CategoryEntity : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *isBought;
@property (nonatomic, retain) NSSet *insults;
@end

@interface CategoryEntity (CoreDataGeneratedAccessors)

- (void)addInsultsObject:(InsultEntity *)value;
- (void)removeInsultsObject:(InsultEntity *)value;
- (void)addInsults:(NSSet *)values;
- (void)removeInsults:(NSSet *)values;
@end
