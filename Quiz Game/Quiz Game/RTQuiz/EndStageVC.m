//
//  EndStageVC.m
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import "EndStageVC.h"
#import "Constants.h"

@implementation EndStageVC

@synthesize delegate;

@synthesize currentStageLabel;
@synthesize pointsLabel;
@synthesize timeBonusLabel;
@synthesize totalPointsLabel;
@synthesize mainMenuButton;
@synthesize nextStageButton;

#pragma mark - 
-(void)setFonts{
    if (IS_IPHONE) {
        [lbl_points setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [lbl_time setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [pointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        [timeBonusLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:20]];
        
        [totalPointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:22]];
        [currentStageLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:26]];
    }else{
        [lbl_points setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [lbl_time setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [pointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [timeBonusLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        
        [totalPointsLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:32]];
        [currentStageLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:33]];
    }
    
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setLabelsForStage:(int)stage withPoints:(int)points withBonus:(int)bonus {
    [self.currentStageLabel setText:[NSString stringWithFormat:@"Stage %i", stage+1]];
    [self.pointsLabel setText:[NSString stringWithFormat:@"%i", points]];
    [self.timeBonusLabel setText:[NSString stringWithFormat:@"%i", bonus]];
    [self.totalPointsLabel setText:[NSString stringWithFormat:@"%i", points+bonus]];
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
    [self setCurrentStageLabel:nil];
    [self setPointsLabel:nil];
    [self setTimeBonusLabel:nil];
    [self setTotalPointsLabel:nil];
    [self setMainMenuButton:nil];
    [self setNextStageButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didClickMainMenu {
    [delegate returnToMainMenu];
}

- (IBAction)didClickNextStage {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
        
}

@end
