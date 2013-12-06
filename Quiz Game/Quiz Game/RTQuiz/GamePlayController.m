//
//  GamePlayController.m
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import "GamePlayController.h"
#import "SynthesizeSingleton.h"

#import "QuizElement.h"

#define kRandomLimit 4 // the number of answer choices
#define kMaxLevels 4 // the total number of levels per topic
#define kMaxErrors 10 // the number of missed guesses allowed
#define kReward 2 // the number of points earned for correct answer
#define kPenalty 1 // the number of points lost for wrong answer
#define kTimerRate 100.f // how quickly the timer counts up

@implementation GamePlayController

SYNTHESIZE_SINGLETON_FOR_CLASS(GamePlayController);

@synthesize currentGameScene;

@synthesize errorCount      = _errorCount;

@synthesize currentWord     = _currentWord;
@synthesize currentWordInt  = _currentWordInt;

@synthesize currentPoints   = _currentPoints;
@synthesize totalPoints     = _totalPoints;

@synthesize currentTopicLevelsList = _currentTopicLevelsList;
@synthesize currentTopic    = _currentTopic;
@synthesize currentLevel    = _currentLevel;
@synthesize currentQuiz     = _currentQuiz;

@synthesize theTimer        = _theTimer;
@synthesize timeLeft        = _timeLeft;

-(id)init {
    self = [super init];
    if (self) {
        sharedDataManager = [SharedDataManager sharedDataManager];
        self.currentTopicLevelsList = [[NSArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Timer
#pragma mark 

- (void)initializeTimer {
	_timeLeft = 0.0f * (100.0f); 
    
    [currentGameScene timerWasUpdated:_timeLeft];
		
	float theInterval = 1;
	
	self.theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval target:self 
                                                   selector:@selector(incrementTimer) userInfo:nil repeats:YES];
}

- (void)incrementTimer {
    _timeLeft += kTimerRate;
    
    [currentGameScene timerWasUpdated:_timeLeft];
}

- (void)reduceTimerIndicator {
	_timeLeft -= kTimerRate;
    
	if (_timeLeft < 0) {
		[self endLevel];
	}else {
        [currentGameScene timerWasUpdated:_timeLeft];
	}
}

- (void)killTimer {
    if (_theTimer != nil) {
        [_theTimer invalidate];
        _theTimer = nil;
    }
}

#pragma mark -
#pragma mark Words
#pragma mark 

- (void)setNewCurrentWord {
    _currentWordInt = arc4random() % kRandomLimit;
    _currentWord = [_currentQuiz objectAtIndex:_currentWordInt];
    
    QuizElement *firstWord	= [_currentQuiz objectAtIndex:0];
	QuizElement *secondWord = [_currentQuiz objectAtIndex:1];
	QuizElement *thirdWord	= [_currentQuiz objectAtIndex:2];
	QuizElement *fourthWord = [_currentQuiz objectAtIndex:3];
    
    NSArray *choicesArray = [[NSArray alloc] initWithObjects:firstWord.firstWord, 
                                                secondWord.firstWord,
                                                thirdWord.firstWord,
                                                fourthWord.firstWord,
                                                nil];
    [currentGameScene newWord:_currentWord.secondWord withChoices:choicesArray];
}

- (void)checkWordForTag:(int)tag {
    if (tag == _currentWordInt) {
		// the selection was correct
        _currentWord.isActive = NO;
        [_currentQuiz removeObjectAtIndex:_currentWordInt];
		_currentPoints += self.reward;
        [currentGameScene pointsWereAdded:_currentPoints];
	}else {
		//the selection was not correct
        if(_currentPoints > 0) {
            _currentPoints -= self.panelty;
        }
        _errorCount += 1;
        [currentGameScene pointsWereLost:_currentPoints];
	}
	if (_currentQuiz.count>0) {
        [sharedDataManager shuffleQuiz:_currentQuiz];
    }
    if(_errorCount == self.errorsAllowed){
        // end gameplay and clear bonus points
        [self killTimer];
        [self endGame];
    }else {
        if ([_currentQuiz count] <= kMaxLevels) {
            [self endLevel];
        }else {
            [self setNewCurrentWord];
        }        
    }
}

#pragma mark -
#pragma mark Score
#pragma mark 

- (int)calculateBonusPoints {
    int bonusPoints = _currentPoints - (_timeLeft/100);
    
    //ensure that bonus points are not negative
    if(bonusPoints < 0) {
        bonusPoints = 0;
    }    
    _currentPoints += bonusPoints;
    _totalPoints += _currentPoints;
    
    return bonusPoints;
}

#pragma mark -
#pragma mark Game State
#pragma mark 

- (void)newGame {
    [self resetGame];
}

- (void)startGame {
    
   
    
    _currentQuiz = [sharedDataManager getQuizForTopic:_currentTopic forLevel:_currentLevel];
    [self setNewCurrentWord];
    [self initializeTimer];
}

- (void)endLevel {    
    int bonusPoints = [self calculateBonusPoints];
    
    int topicsCount = [_currentTopicLevelsList count];
    
    [currentGameScene endLevel:_currentLevel points:_currentPoints bonusPoints:bonusPoints];
        
    if (_currentLevel+1 >= topicsCount) {
        [self endGame];
    }else {
        _currentLevel += 1;
        [self startGame];
    }
    
}

- (void)endGame {
    [self calculateBonusPoints];
    
    [currentGameScene endGameWithPoints:_totalPoints topic:_currentTopic];
    [self resetGame];
}

- (void)resetGame {
    //reset game variables
    _totalPoints    = 0;
    _currentPoints  = 0;
    _currentWordInt = 0;
    _currentLevel   = 0;
    _errorCount     = 0;
    _timeLeft       = 0;
    [self.theTimer invalidate];
}

@end
