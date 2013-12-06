//
//  MenuViewController.h
//  MagicCamera
//
//  Created by snow on 9/23/12.
//
//

#import <UIKit/UIKit.h>
#import "StoreKit/StoreKit.h"

@interface MenuViewController : UIViewController
{
    IBOutlet UIButton* btnRestore;
    IBOutlet UIButton* btnBuyFull;
    
    UIActivityIndicatorView*	m_ctrlThinking;
    
    NSTimer* m_pDelay;
    UILabel* inapplabel;
    
    UIImageView* backCoinView;
    IBOutlet UIImageView *bgMain;
}

-(IBAction)onStart:(id)sender;
-(IBAction)onMoreApps:(id)sender;
-(IBAction)onRestore:(id)sender;
-(IBAction)onBuyFull:(id)sender;

-(void)initLoad;

-(void)startAnimation;
-(void)stopAnimation;

-(void)coinInitProcess;

@end
