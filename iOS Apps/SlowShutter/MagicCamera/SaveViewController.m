//
//  SaveViewController.m
//  MagicCamera
//
//  Created by snow on 9/23/12.
//
//

#import "SaveViewController.h"
#import "MagicCameraAppDelegate.h"
#import "MKStoreManager.h"
#import "Global.h"

#import <Social/Social.h>


@interface SaveViewController ()

@end

@implementation SaveViewController

@synthesize processImg;
@synthesize resultImgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    if ([MKStoreManager featureAPurchased] == NO)
    {
        [self initiAdBanner];
        [self hideADS:NO];
    }
    else
    {
        CGPoint pt1 = btnBack.center;
        CGPoint pt2 = btnEdit.center;
        
        int nHeight = self.view.frame.size.height;
        
        [btnBack setCenter:CGPointMake(pt1.x, pt1.y - nHeight / 13.0)];
        [btnEdit setCenter:CGPointMake(pt2.x, pt2.y - nHeight / 13.0)];
        
        [self hideADS:YES];
    }
    
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.resultImgView.image = self.processImg;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [processImg release];
    
    if (editorController != nil)
        [editorController release];
    
    [super dealloc];
}

-(void)initiAdBanner
{
    if (!iAdBannerView)
    {
        // Get the size of the banner in portrait mode
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];

        // Create a new bottom banner, will be slided into view
        iAdBannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(0.0,
                                                                      -1 * bannerSize.height,
                                                                      bannerSize.width,
                                                                      bannerSize.height)];
        iAdBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        iAdBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        
        iAdBannerView.delegate = self;
        iAdBannerView.hidden = TRUE;
        [self.view addSubview:iAdBannerView];
    }
}

#pragma mark - Animation

-(void)hideBanner:(UIView*)banner
{
    if (banner &&
        ![banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOff" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, -1 * banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = TRUE;
    }
}

-(void)showBanner:(UIView*)banner
{
    if (banner &&
        [banner isHidden])
    {
        [UIView beginAnimations:@"animatedBannerOn" context:nil];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = FALSE;
    }
}

#pragma mark - iAd Banner

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAdBanner loaded");
    
    [self showBanner:iAdBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAdBanner failed");
    NSLog(@"iAdBanner Failed to receive ad with error: %@", [error localizedFailureReason]);
    
    [self hideBanner:iAdBannerView];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view action begins");
    
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"Banner view action did finish");
}

-(void) hideADS:(BOOL) flag
{
    if (!iAdBannerView)  return;
    int width, height;
    width = self.view.frame.size.height;
    height = self.view.frame.size.width;
    
    if (flag == YES)
    {        
        CGRect curRect = iAdBannerView.frame;
        iAdBannerView.frame = CGRectMake(width, curRect.origin.y, curRect.size.width, curRect.size.height);
    }
    else
    {
        CGRect curRect = iAdBannerView.frame;
        iAdBannerView.frame = CGRectMake(0, -curRect.size.height, curRect.size.width, curRect.size.height);
    }
}

-(void)initLoad
{
//    CGRect rect;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        rect = CGRectMake(0, 0, 320, 480);
//    else
//        rect = CGRectMake(0, 0, 320, 480);
//    
//    resultImgView = [[UIImageView alloc] initWithFrame:CG]
    
    resultImgView.image = processImg;
}

-(void)showAlertNeedsPurchase{
    UIAlertView* _alert = [[UIAlertView alloc] initWithTitle:@"Unlock All Features" message:@"Full version required. Do you want to use this function?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [_alert show];
    _alert.tag = 100;
    [_alert release];
}

-(IBAction)onFacebook:(id)sender
{
    if (![MKStoreManager featureAPurchased])
    {
        [self showAlertNeedsPurchase];
        return;
    }
    
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:SHARE_MESSAGE];
        [mySLComposerSheet addImage:processImg];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:APP_URL]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
}

-(IBAction)onTwitter:(id)sender
{
    if (![MKStoreManager featureAPurchased])
    {
        [self showAlertNeedsPurchase];
        return;
    }

    
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [mySLComposerSheet setInitialText:SHARE_MESSAGE];
        [mySLComposerSheet addImage:processImg];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:APP_URL]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
}

-(IBAction)onAlberm:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(processImg, nil, nil, nil);
    
    UIAlertView* _alert = [[UIAlertView alloc] initWithTitle:nil message:@"Save Success!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [_alert show];
    [_alert release];
}

-(IBAction)onEmail:(id)sender
{
    if (![MKStoreManager featureAPurchased])
    {
        [self showAlertNeedsPurchase];
        return;
    }
    
    if ([MFMailComposeViewController canSendMail])
	{
        NSData *myData;
        myData = myData = UIImageJPEGRepresentation(processImg, 0.5f);
		
        MFMailComposeViewController *mcvc = [[[MFMailComposeViewController alloc] init] autorelease];
		mcvc.mailComposeDelegate = self;
        [mcvc setSubject:APP_TITLE];
        
        // Set up recipients
        //        NSArray *toRecipients = [NSArray arrayWithObject:@""];
        //        NSArray *ccRecipients = [NSArray arrayWithObjects:@"", @"", nil];
        //        NSArray *bccRecipients = [NSArray arrayWithObject:@""];        
        
        // Attach an image to the email
        [mcvc addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"mypic"];
        
        // Fill out the email body text
        NSString* szMessage;
        
        [mcvc setMessageBody:SHARE_MESSAGE isHTML:YES];
        
        [self presentModalViewController:mcvc animated:YES];
        //        [mcvc release];
        
	}
}

-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onImageProcessing:(id)sender
{
    if (editorController != nil)
        [editorController release];
        
    editorController = [[AFPhotoEditorController alloc] initWithImage:processImg];
    [editorController setDelegate:self];
    
    [self.navigationController pushViewController:editorController animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark AFPhotoEditorControllerDelegate

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    self.processImg = image;
    resultImgView.image = processImg;
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	UIAlertView* _alert = [[UIAlertView alloc] init];
	[_alert addButtonWithTitle:@"Ok"];
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[_alert setMessage:@"Mail cancelled"];
			break;
		case MFMailComposeResultSaved:
			[_alert setMessage:@"Mail saved"];
			break;
		case MFMailComposeResultSent:
			[_alert setMessage:@"Mail sent"];
			break;
		case MFMailComposeResultFailed:
			[_alert setMessage:@"Mail sending failed"];
			break;
		default:
			[_alert setMessage:@"Mail not sent"];
			break;
	}

	[_alert show];
	[_alert release];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            if (![MKStoreManager featureAPurchased])
            {
                [self coinInitProcess];
                [[MKStoreManager sharedManager] buyFeatureA];
                
                return;
            }
        }
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
    
    backCoinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
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

@end
