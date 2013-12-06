//
//  GamePlayVC.m
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import "GamePlayVC.h"
#import "GamePlayController.h"

#import "QuizElement.h"
#import "Constants.h"
#import "EndStageVC.h"
#import "EndLevelVC.h"


// Device Types
#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)

@implementation GamePlayVC
@synthesize warningView;

@synthesize currentPointsLabel, currentWordLabel, timeRemainingLabel;
@synthesize firstWordButton     = _firstWordButton;
@synthesize secondWordButton    = _secondWordButton;
@synthesize thirdWordButton     = _thirdWordButton;
@synthesize fourthWordButton    = _fourthWordButton;

@synthesize thePointsAlertView;
@synthesize theEndLevelAlertView;

#pragma mark - 
-(void)setFonts{
    if (IS_IPHONE) {
        [currentWordLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [currentPointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:18]];
        [timeRemainingLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:18]];
        [lbl_points setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:18]];
        [lbl_time setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:18]];
        
        [lbl_answer1 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:16]];
        [lbl_answer2 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:16]];
        [lbl_answer3 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:16]];
        [lbl_answer4 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:16]];
        
//        [self.firstWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
//        [self.secondWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
//        [self.thirdWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
//        [self.fourthWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
    }else{
        [currentWordLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:34]];
        [currentPointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [timeRemainingLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_points setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_time setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        
        [lbl_answer1 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
        [lbl_answer2 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
        [lbl_answer3 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
        [lbl_answer4 setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
        
//        [self.firstWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
//        [self.secondWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
//        [self.thirdWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
//        [self.fourthWordButton.titleLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
    
    }
    
}

#pragma mark -
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    sharedGamePlayController = [GamePlayController sharedGamePlayController];
    [super viewDidLoad];
    [self setFonts];
}

#pragma mark -
#pragma mark GamePlayDelegate Methods
#pragma mark

- (void)timerWasUpdated:(int)updatedTime {
    [timeRemainingLabel setText:[NSString stringWithFormat:@"%i", ((int)updatedTime)/(100)]];
}
- (void)pointsWereAdded:(int)totalPoints {
    [self updatePointsLabelWithPoints:totalPoints];
    [self notifyAnswerWasCorrect:YES];
}
- (void)pointsWereLost:(int)totalPoints {
    [self updatePointsLabelWithPoints:totalPoints];
    [self notifyAnswerWasCorrect:NO];
}

- (void)newWord:(NSString *)quizWord withChoices:(NSArray *)choicesArray {
    
    [lbl_answer1	setText:[choicesArray objectAtIndex:0]];
	[lbl_answer2	setText:[choicesArray objectAtIndex:1]];
	[lbl_answer3	setText:[choicesArray objectAtIndex:2]];
	[lbl_answer4	setText:[choicesArray objectAtIndex:3]];
    
//	[_firstWordButton	setTitle:[choicesArray objectAtIndex:0]	forState: UIControlStateNormal];
//	[_secondWordButton	setTitle:[choicesArray objectAtIndex:1]	forState: UIControlStateNormal];
//	[_thirdWordButton	setTitle:[choicesArray objectAtIndex:2]	forState: UIControlStateNormal];
//	[_fourthWordButton	setTitle:[choicesArray objectAtIndex:3]	forState: UIControlStateNormal];
	
	[currentWordLabel setText:quizWord];    
}
/*
- (IBAction)helpClicked:(id)sender {
  [self pointsWereAdded:YES];
  UIImage *selectedImage = [UIImage imageNamed:@"tableItem.png"];
//  [helpButton setImage:selectedImage forState:UIControlStateSelected];
}
*/
//Challenge Mode Only!

- (void)endLevel:(int)level points:(int)points bonusPoints:(int)bonusPoints {
    EndStageVC *endStageVC = [[EndStageVC alloc] initWithNibName:@"EndStageVC" bundle:[NSBundle mainBundle]];
    [self addChildViewController:endStageVC];
    [self.view addSubview:endStageVC.view];
    [endStageVC setDelegate:self];
    [endStageVC setLabelsForStage:level withPoints:points withBonus:bonusPoints];
    [endStageVC.view setAlpha:0];
    
    [UIView animateWithDuration:.35 animations:^(void) {
        [endStageVC.view setAlpha:1.0f];
    }];	
}
- (void)endGameWithPoints:(int)points topic:(NSString *)topic { 
    EndLevelVC *endLevelVC = [[EndLevelVC alloc] initWithNibName:@"EndLevelVC" bundle:[NSBundle mainBundle]];
    [self addChildViewController:endLevelVC];
    [endLevelVC.view setFrame:self.view.frame];
    [self.view addSubview:endLevelVC.view];
    [endLevelVC setDelegate:self];
    [endLevelVC setScore:points];
    [endLevelVC setCategory:topic];
    [endLevelVC.totalPointsLabel setText:[NSString stringWithFormat:@"%i", points]];
    [endLevelVC.view setAlpha:0];
    
    [UIView animateWithDuration:.35 animations:^(void) {
        [endLevelVC.view setAlpha:1.0f];
    }];
}

- (void)returnToMainMenu {
    [sharedGamePlayController resetGame];
    [self.view removeFromSuperview];    
}

#pragma mark -
#pragma mark Winning Conditions
#pragma mark

- (void)updatePointsLabelWithPoints:(int)points {
	[currentPointsLabel setText:[NSString stringWithFormat:@"%i", points]];
}

-(void)notifyAnswerWasCorrect:(BOOL)answer {
	
    int x=240;
    if (IS_IPAD) {
        x=510;
    }
	if (answer == TRUE) {
		UIImageView *pointsAlertView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 40, 48, 48)];
		[pointsAlertView setImage:[UIImage imageNamed:@"Correct.png"]];
		[self.view addSubview:pointsAlertView];
        
        [UIView animateWithDuration:.55 animations:^(void) {
            [pointsAlertView setFrame:CGRectOffset(pointsAlertView.frame, 20, -30)];
            [pointsAlertView setAlpha:0];
        }];
	}else {
        [warningView setAlpha:1.0f];
 		UIImageView *pointsAlertView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 40, 48, 48)];
		[pointsAlertView setImage:[UIImage imageNamed:@"Wrong.png"]];
		[self.view addSubview:pointsAlertView];
        
        [UIView animateWithDuration:.55 animations:^(void) {
            [pointsAlertView setFrame:CGRectOffset(pointsAlertView.frame, 20, -30)];
            [pointsAlertView setAlpha:0];
            [warningView setAlpha:0.0f];
        }];
    }
	
}

#pragma mark -
#pragma mark Interactions
#pragma mark

- (IBAction) didClickWordButtonWithID:(id)sender {
    [sharedGamePlayController checkWordForTag:[sender tag]];
}
- (IBAction)didClickReturnToMainMenu {
    [self returnToMainMenu];
}

#pragma mark -
#pragma mark Maintenance
#pragma mark

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self removeFromParentViewController];
    [self setWarningView:nil];
    lbl_answer1 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
}


@end
