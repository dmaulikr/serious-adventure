//
//  QuizElement.m
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import "QuizElement.h"


@implementation QuizElement

@synthesize firstWord, secondWord;
@synthesize isActive;

- (id)initWithFirstWord:(NSString *)theFirstWord
			 SecondWord: (NSString *)theSecondWord {
	self = [self init];
    if (self) {
		self.firstWord	= theFirstWord;
		self.secondWord	= theSecondWord;
    }
    return self;
}

- (void)dealloc {
    firstWord = nil;
	secondWord = nil;
}

@end
