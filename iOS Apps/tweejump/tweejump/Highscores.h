//
//  Highscores.h
//  tweejump
//
//  Created by Johannes Strydom on 5/11/2013.
//  Copyright (c) 2013 Incredible Adventure. All rights reserved.
//
#import "cocos2d.h"
#import "Main.h"

@interface Highscores : Main <UITextFieldDelegate>
{
	NSString *currentPlayer;
	int currentScore;
	int currentScorePosition;
	NSMutableArray *highscores;
	UIAlertView *changePlayerAlert;
	UITextField *changePlayerTextField;
}
+ (CCScene *)sceneWithScore:(int)lastScore;
- (id)initWithScore:(int)lastScore;
@end