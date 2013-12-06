//
//  MenuViewController.m
//  MagicCamera
//
//  Created by snow on 9/23/12.
//
//

#import "MenuViewController.h"
#import "MagicCameraAppDelegate.h"
#import "MagicCameraViewController.h"
#import "MKStoreManager.h"
#import "Global.h"
 #define IS_IPHONE5 (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height==568)

@interface MenuViewController ()

@end

@implementation MenuViewController

-(CGSize)actualSize{
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
    } else {
        viewSize = CGSizeMake(viewSize.width, viewSize.height);
    }
    return viewSize;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLoad];
    if (IS_IPHONE5) {
        bgMain.image = [UIImage imageNamed:@"bg_main-568h@2x"];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void)initLoad
{
    if ([MKStoreManager featureAPurchased] == YES)
    {
        [btnRestore setHidden:YES];
        [btnBuyFull setHidden:YES];
    }
}

-(IBAction)onStart:(id)sender
{
    MagicCameraViewController* viewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        viewController = [[MagicCameraViewController alloc] initWithNibName:@"MagicCameraViewController_iPhone" bundle:[NSBundle mainBundle]];
    else
        viewController = [[MagicCameraViewController alloc] initWithNibName:@"MagicCameraViewController_iPad" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(IBAction)onMoreApps:(id)sender
{
    MagicCameraAppDelegate* del = (MagicCameraAppDelegate*)[UIApplication sharedApplication].delegate;
    [del dispMoreGames];
}

-(IBAction)onRestore:(id)sender
{
    [[MKStoreManager sharedManager] restoreFunc];
}

-(IBAction)onBuyFull:(id)sender
{
    if (![MKStoreManager featureAPurchased])
    {
        [self coinInitProcess];
        [[MKStoreManager sharedManager] buyFeatureA];
        
        return;
    }
}

-(void)startAnimation
{
    [self stopAnimation];
    
    m_pDelay = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

-(void)stopAnimation
{
    if (m_pDelay != nil)
    {
        [m_pDelay invalidate];
        m_pDelay = nil;
    }
}

-(void)onTimer:(id)sender
{
    if (g_fCoin)
        return;
    
    [self stopAnimation];
    
    [backCoinView removeFromSuperview];
    
    if (m_ctrlThinking != nil)
    {
        [m_ctrlThinking stopAnimating];
        [m_ctrlThinking removeFromSuperview];
        [m_ctrlThinking release];
        m_ctrlThinking = nil;
    }
    
    [inapplabel removeFromSuperview];
    
    g_fCoin = NO;
    self.view.userInteractionEnabled = YES;
}

-(void)coinInitProcess
{
    g_fCoin = YES;
    
    self.view.userInteractionEnabled = NO;
    
    [self startAnimation];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        backCoinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [self actualSize].height)];
    else
        backCoinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, [self actualSize].height)];
    
    backCoinView.backgroundColor = [UIColor blackColor];
    [backCoinView setAlpha:0.7];
    [self.view addSubview:backCoinView];
    [backCoinView release];
    
    m_ctrlThinking = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.view addSubview:m_ctrlThinking];
    [m_ctrlThinking startAnimating];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [m_ctrlThinking setFrame:CGRectMake(132, 200, 58, 58)];
    else
        [m_ctrlThinking setFrame:CGRectMake(326, 454, 116, 116)];
    
    inapplabel = [[UILabel alloc] init];
    
    UIFont* font;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        font = [UIFont fontWithName:@"Arial" size:16];
    else
        font = [UIFont fontWithName:@"Arial" size:32];
    
    UIColor* color = [UIColor whiteColor];
    
    [inapplabel setFont:font];
    [inapplabel setTextColor:color];
    [inapplabel setBackgroundColor:[UIColor clearColor]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [inapplabel setFrame:CGRectMake(20, 230, 280, 70)];
    else
        [inapplabel setFrame:CGRectMake(80, 500, 560, 140)];
    
    [inapplabel setText:@"Your request is being processed..."];
    [inapplabel setTextAlignment:UITextAlignmentCenter];
    
    [self.view addSubview:inapplabel];
    [inapplabel release];
}

- (void)dealloc {
    [bgMain release];
    [super dealloc];
}
@end
