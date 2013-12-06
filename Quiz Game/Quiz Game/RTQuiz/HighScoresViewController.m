//
//  HighScoresViewController.m
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import "HighScoresViewController.h"

#import "Score.h"
#import "CustomCell.h"

@implementation HighScoresViewController
@synthesize theTableView;
@synthesize scoresArray = _scoresArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSString*)categoryName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sharedDataManager = [SharedDataManager sharedDataManager];
        
        _scoresArray = [sharedDataManager getHighScoresForCategoryNamed:categoryName];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTheTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_scoresArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    
	if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CustomCell *) currentObject;
                break;
            }
        }
        
	}    
    
    Score *score = [_scoresArray objectAtIndex:indexPath.row];
    
    NSString *playerName = [score player];
    [cell.nameLabel setText:playerName];
    
    NSString *points = [NSString stringWithFormat:@"%@", [score points]];
    [cell.scoreLabel setText:points];
    
    return cell;
}


- (IBAction)didClickClose {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
