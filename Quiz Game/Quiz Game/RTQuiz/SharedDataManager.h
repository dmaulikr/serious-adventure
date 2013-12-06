//
//  SharedDataManager.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Category;

@interface SharedDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSArray*)getArrayFromTopic:(NSString*)topicName;
- (NSMutableDictionary*)getDictionaryForQuiz:(NSString*)quizName;
- (NSMutableArray*)getQuizForTopic:(NSString*)topicName forLevel:(int)level;
- (NSMutableArray*)shuffleQuiz:(NSMutableArray*)theQuiz;

- (Category*)getCategoryWithName:(NSString*)name;
- (NSArray*)getHighScoresForCategoryNamed:(NSString*)categoryName;

- (BOOL)didSaveScore:(int)points ForCategoryNamed:(NSString*)categoryName ForUserNamed:(NSString*)userName;

+(SharedDataManager*)sharedDataManager;

@end
