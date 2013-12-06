//
//  SaveViewController.h
//  MagicCamera
//
//  Created by snow on 9/23/12.
//
//

#import <UIKit/UIKit.h>
#import "AFPhotoEditorController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <iAd/iAd.h>

@interface SaveViewController : UIViewController<AFPhotoEditorControllerDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, ADBannerViewDelegate>
{
    UIImageView* resultImgView;
    
    AFPhotoEditorController *editorController;
    
    UIImage* processImg;
    
    UIActivityIndicatorView*	m_ctrlThinking;
    
    NSTimer* m_pDelay;
    UILabel* inapplabel;
    
    UIImageView* backCoinView;
    
    ADBannerView *iAdBannerView;
    
    IBOutlet UIButton* btnBack;
    IBOutlet UIButton* btnEdit;
}

@property (nonatomic, retain) UIImage* processImg;
@property (nonatomic, retain) IBOutlet UIImageView* resultImgView;

-(void)initLoad;

-(IBAction)onFacebook:(id)sender;
-(IBAction)onTwitter:(id)sender;
-(IBAction)onAlberm:(id)sender;
-(IBAction)onEmail:(id)sender;

-(IBAction)onBack:(id)sender;
-(IBAction)onImageProcessing:(id)sender;

-(void)startAnimation;
-(void)stopAnimation;

-(void)coinInitProcess;

@end
