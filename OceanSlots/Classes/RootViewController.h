//
//  RootViewController.h
//  SurfSlotMachine
//
//  Created by snow on 19/03/2013.
//
//

#import <UIKit/UIKit.h>
#import "GameKit/GameKit.h"
#import "GameCenterManager.h"

@interface RootViewController : UIViewController<UIActionSheetDelegate,
GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate,
GameCenterManagerDelegate> {
    
    GameCenterManager *gameCenterManager;
    int64_t  currentScore;
    NSString* currentLeaderBoard;
    
    NSError* lastError;
    bool isGameCenterAvailable;
}
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

- (void) submitScore : (int) curScore;
- (void) checkAchievements :(int)checkType;
- (void) showLeaderboard;
- (void) showAchievements;
-(void) authenticate;

@end
