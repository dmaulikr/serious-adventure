//
//  HighScoresViewController.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface HighScoresViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
    
@private
    SharedDataManager *sharedDataManager;
}

@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) NSArray *scoresArray;

- (IBAction)didClickClose;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSString*)categoryName;

@end
