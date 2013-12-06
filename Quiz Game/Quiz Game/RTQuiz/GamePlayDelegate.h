//
//  GamePlayDelegate.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol GamePlayDelegate <NSObject>

@required
- (void)returnToMainMenu;

@optional
- (void)timerWasUpdated:(int)updatedTime;
- (void)pointsWereAdded:(int)totalPoints;
- (void)pointsWereLost:(int)totalPoints;
- (void)newWord:(NSString*)quizWord withChoices:(NSArray*)choicesArray;
- (void)endLevel:(int)level points:(int)points bonusPoints:(int)bonusPoints;
- (void)endGameWithPoints:(int)points topic:(NSString*)topic;
@end
