//
//  BaseViewController.m
//  CampusHandBook
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	
    
      
	if (IS_IPAD) {
	
        if (nibNameOrNil) {
            nibNameOrNil = [nibNameOrNil stringByAppendingFormat:@"_iPad"];
        }
	}
    
 
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
