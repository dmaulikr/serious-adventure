//
//  QuizElement.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface QuizElement : NSObject

@property (strong, nonatomic) NSString *firstWord;
@property (strong, nonatomic) NSString *secondWord;

@property (nonatomic) BOOL isActive;

- (id)initWithFirstWord:(NSString *)theFirstWord
			 SecondWord: (NSString *)theSecondWord;
@end

