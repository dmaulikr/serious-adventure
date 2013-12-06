//
//  GamePlayController.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GamePlayDelegate.h"

@class QuizElement;

@interface GamePlayController : NSObject {
    
@private
    SharedDataManager *sharedDataManager;
}

@property (unsafe_unretained) id<GamePlayDelegate> currentGameScene;
@property (nonatomic,assign) int errorsAllowed;
@property (nonatomic) int errorCount;
@property (nonatomic) int reward;
@property (nonatomic) int panelty;

@property (nonatomic) int currentWordInt;
@property (nonatomic, strong) QuizElement *currentWord;

@property (nonatomic) int currentPoints;
@property (nonatomic) int totalPoints;

@property (nonatomic, copy) NSArray *currentTopicLevelsList;
@property (nonatomic, strong) NSString *currentTopic;
@property (nonatomic) int currentLevel;
@property (nonatomic, copy) NSMutableArray *currentQuiz;

@property (strong, nonatomic) NSTimer *theTimer;
@property (nonatomic) float timeLeft;

- (void)initializeTimer;
- (void)incrementTimer;
- (void)reduceTimerIndicator;
- (void)killTimer;

- (void)setNewCurrentWord;
- (void)checkWordForTag:(int)tag;

- (void)newGame;
- (void)startGame;
- (void)endLevel;
- (void)endGame;
- (void)resetGame;

- (int)calculateBonusPoints;

+ (GamePlayController *)sharedGamePlayController;

@end
