//
//  Category.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *topic;
@property (nonatomic, retain) NSSet *scores;
@property (nonatomic, retain) NSSet *quizzes;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addScoresObject:(NSManagedObject *)value;
- (void)removeScoresObject:(NSManagedObject *)value;
- (void)addScores:(NSSet *)values;
- (void)removeScores:(NSSet *)values;

- (void)addQuizzesObject:(NSManagedObject *)value;
- (void)removeQuizzesObject:(NSManagedObject *)value;
- (void)addQuizzes:(NSSet *)values;
- (void)removeQuizzes:(NSSet *)values;

@end
