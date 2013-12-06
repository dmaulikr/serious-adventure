//
//  ViewController.m
//  MagicCamera
//
//  Created by i Pro on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MagicCameraViewController.h"
#import "MagicCameraAppDelegate.h"
#import "GLES2View.h"
#import "LivePreview.h"
#import "ExposureSettingView.h"
#import "EditSettingView.h"
#import "AleartWaitView.h"
#import "Imaging.h"
#import "SetViewController.h"

#import "OptionSettingView.h"
#import "SaveViewController.h"


@implementation MagicCameraViewController

@synthesize captureSession = _captureSession;
@synthesize customLayer = _customLayer;
@synthesize livePreviewLayer = _livePreviewLayer;
@synthesize snapshotImage;

-(CGSize)actualSize{
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
    } else {
        viewSize = CGSizeMake(viewSize.width, viewSize.height);
    }
    return viewSize;
}

enum {
    kAlertViewNone = 0,
    kAlertViewLogin2Flickr,
};

- (void)dealloc {
    [self releaseCaptureSession];
    
    [self delTakingPictureTextures];
    [self delEditingPictureTextures];
    [self unloadShaderProgram:&drawTextureProgram];
    
    [exposure_button removeFromSuperview];
    [shutter_button removeFromSuperview];    
    [settings_button removeFromSuperview];
    [cancel_button removeFromSuperview];
    [edit_button removeFromSuperview];
    [save_button removeFromSuperview];
    [main_toolbar removeFromSuperview];
    
    [exposureSettingView removeFromSuperview];
    [editSettingView removeFromSuperview];
    [aleartWaiteView removeFromSuperview];
    
    [livePreview_button removeFromSuperview];
    [torch_button removeFromSuperview];    
    [cameraPosition_button removeFromSuperview];        
    
    [photoPaperView removeFromSuperview];
    [livePreview removeFromSuperview];
    
    [g_AppUtils writeAppSettings];
    [g_AppUtils release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    //Read App Settings
    g_AppUtils = [[MagicCameraAppUtils alloc] init];
    [g_AppUtils readAppSettings];
    
    //Insert User Interface
    [self initMainToolbar];
    [self initControlItemViews];
    [self initPhotoPaperView];
    [self initExposureSettingView];
    [self initEditSettingView];
    [self initAleartWaitView];
    [self initOptionSettingView];
    
    [self.view bringSubviewToFront:main_toolbar];
    
    [exposureSettingView updateViewFromAppSettings];
    [editSettingView updateViewFromAppSettings];
    [optionSettingView initialize];
    
    //Init OpenGL ES
    [self loadVertexShader:@"DrawTextureShader" fragmentShader:@"DrawTextureShader" forProgram:&drawTextureProgram];
    [self initGL];
    
    //Init State Flags
    bShowingExposureView = NO;
    bTakingPictures = NO;
    bShowingEditView = NO;
    bShowingOptionView = NO;

    bShowingLivePreview = NO; 
    bUsingLED = NO; 
    bUsingFrontCamera = NO;

    //Init Capture Session
    [self releaseCaptureSession];
    [self setupCaptureSession];    
}

- (void)viewDidUnload
{  
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [g_AppUtils writeAppSettings];
}

- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
    
    [self changeShutterBtnImage];
    //???
}

- (void)changeShutterBtnImage {
    if ([g_AppUtils selfTimerDelay] > 0) {
        [g_AppUtils loadSkin:shutter_button skinName:@"bt_time"];
    } else {
        [g_AppUtils loadSkin:shutter_button skinName:@"bt_camera"];
    }
}
- (void)viewDidAppear:(BOOL)animated
{        
    [super viewDidAppear:animated];
    
    //Start Capturing
    [self startCapturingFromCamera];
}

- (void)viewWillDisappear:(BOOL)animated
{  
	[super viewWillDisappear:animated];
    
    //Stop Caturing
    [self stopCapturingFromCamera];
}

- (void)viewDidDisappear:(BOOL)animated
{  
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

#pragma mark - App ResignActive/BecomeActive
- (void)appWillResignActive {
    [self stopTakingPictures:nil];
}

- (void)appDidBecomeActive {
    
}

#pragma mark - Init User Interface
- (void)initMainToolbar {
    CGRect frameRect;
    float offsetY;

    float factor = 1;
    //Insert Main Toolbar On Main View
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
    {
        factor = 2;
    }
    frameRect = CGRectMake(0, [self actualSize].height - 53*factor, [self actualSize].width * 2, 54*factor);

    main_toolbar = [[UIImageView alloc] initWithFrame:frameRect];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [main_toolbar setImage:[UIImage imageNamed:[g_AppUtils resourceNameForDevice:@"bg_bottom_first" ofType:@"png"]]];
    else
        [main_toolbar setImage:[UIImage imageNamed:@"bg_bottom_first_iPad.png"]];
    
    main_toolbar.userInteractionEnabled = YES;
    [self.view addSubview:main_toolbar];
    [main_toolbar release];
    
    offsetY = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 6 : 6 * 2;
    //Insert ExposureInactive Button On Main Toolbar
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake(12, offsetY, 87, 43);
    } else {
        frameRect = CGRectMake(17 * SCALE_X, offsetY, 174, 86);
    }
    
    exposure_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkin:exposure_button skinName:@"bt_show"];    
    [exposure_button addTarget:self action:@selector(onExposure:) forControlEvents:UIControlEventTouchUpInside];    
    [main_toolbar addSubview:exposure_button];
    [exposure_button release];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake((320 - 107) / 2, offsetY, 107, 43);
    } else {
        frameRect = CGRectMake((768 - 214) / 2, offsetY, 214, 86);
    }
    shutter_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkin:shutter_button skinName:@"bt_camera"];
    [shutter_button addTarget:self action:@selector(onShutter:) forControlEvents:UIControlEventTouchUpInside];    
    [main_toolbar addSubview:shutter_button];
    [shutter_button release];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake(320 - (87 + 12), offsetY, 87, 43);
    } else {
        frameRect = CGRectMake(768 - (174 + 17 * SCALE_X), offsetY, 174, 86);
    }
    settings_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkin:settings_button skinName:@"bt_setting"];    
    [settings_button addTarget:self action:@selector(onSettings:) forControlEvents:UIControlEventTouchUpInside];    
    [main_toolbar addSubview:settings_button];
    [settings_button release];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake(14 + 320, offsetY, 52, 43);
    } else {
        frameRect = CGRectMake((17 + 320) * SCALE_X, offsetY, 104, 86);
    }    
    cancel_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkin:cancel_button skinName:@"bt_back"];
    [cancel_button addTarget:self action:@selector(onBack1:) forControlEvents:UIControlEventTouchUpInside];
    [main_toolbar addSubview:cancel_button];
    [cancel_button release];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake((320 - 87) / 2 + 320, offsetY, 87, 43);
    } else {
        frameRect = CGRectMake((768 - 174) / 2 + 768, offsetY, 174, 86);
    }    
    edit_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkin:edit_button skinName:@"bt_scroll"];       
    [edit_button addTarget:self action:@selector(onEdit:) forControlEvents:UIControlEventTouchUpInside];    
    [main_toolbar addSubview:edit_button];
    [edit_button release];
    
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        frameRect = CGRectMake(320 - 157 + 320, offsetY, 87, 43);
//    } else {
//        frameRect = CGRectMake((320 - 157 + 320) * SCALE_X, offsetY, 174, 86);
//    }
//    
//    imgP_button = [[UIButton alloc] initWithFrame:frameRect];
//    [g_AppUtils loadSkin:imgP_button skinName:@"bt_effect"];
//    [imgP_button addTarget:self action:@selector(onImageProcess:) forControlEvents:UIControlEventTouchUpInside];
//    [main_toolbar addSubview:imgP_button];
//    [imgP_button release];
    
//    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake(320 - (52 + 14) + 320, offsetY, 52, 43);
    } else {
        frameRect = CGRectMake(768 * 2 - 104 - 17.0 * SCALE_X, offsetY, 104, 86);
    }
    
    save_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkin:save_button skinName:@"bt_next"];    
    [save_button addTarget:self action:@selector(onNext:) forControlEvents:UIControlEventTouchUpInside];
    [main_toolbar addSubview:save_button];
    [save_button release];
    
////
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        frameRect = CGRectMake(640 + 11, offsetY, 52, 43);
//    } else {
//        frameRect = CGRectMake((640 + 11) * SCALE_X, offsetY, 104, 86);
//    }
//    
//    lastBack_button = [[UIButton alloc] initWithFrame:frameRect];
//    [g_AppUtils loadSkin:lastBack_button skinName:@"bt_back"];
//    [lastBack_button addTarget:self action:@selector(onBack2:) forControlEvents:UIControlEventTouchUpInside];
//    [main_toolbar addSubview:lastBack_button];
//    [lastBack_button release];
//    
//// face
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        frameRect = CGRectMake(640 + 69, offsetY, 52, 43);
//    } else {
//        frameRect = CGRectMake((640 + 69) * SCALE_X, offsetY, 104, 86);
//    }
//    
//    face_button = [[UIButton alloc] initWithFrame:frameRect];
//    [g_AppUtils loadSkin:face_button skinName:@"bt_facebook"];
//    [face_button addTarget:self action:@selector(onFacebook:) forControlEvents:UIControlEventTouchUpInside];
//    [main_toolbar addSubview:face_button];
//    [face_button release];
//
////    twitter
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        frameRect = CGRectMake(640 + 131, offsetY, 52, 43);
//    } else {
//        frameRect = CGRectMake((640 + 131) * SCALE_X, offsetY, 104, 86);
//    }
//    
//    twitter_button = [[UIButton alloc] initWithFrame:frameRect];
//    [g_AppUtils loadSkin:twitter_button skinName:@"bt_twitter"];
//    [twitter_button addTarget:self action:@selector(onTwitter:) forControlEvents:UIControlEventTouchUpInside];
//    [main_toolbar addSubview:twitter_button];
//    [twitter_button release];
//
////  Alberm
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        frameRect = CGRectMake(640 + 193, offsetY, 52, 43);
//    } else {
//        frameRect = CGRectMake((640 + 193) * SCALE_X, offsetY, 104, 86);
//    }
//    
//    alberm_button = [[UIButton alloc] initWithFrame:frameRect];
//    [g_AppUtils loadSkin:alberm_button skinName:@"bt_save"];
//    [alberm_button addTarget:self action:@selector(onAlberm:) forControlEvents:UIControlEventTouchUpInside];
//    [main_toolbar addSubview:alberm_button];
//    [alberm_button release];
//
//// Email
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        frameRect = CGRectMake(640 + 256, offsetY, 52, 43);
//    } else {
//        frameRect = CGRectMake((640 + 256) * SCALE_X, offsetY, 104, 86);
//    }
//    
//    email_button = [[UIButton alloc] initWithFrame:frameRect];
//    [g_AppUtils loadSkin:email_button skinName:@"bt_mail"];
//    [email_button addTarget:self action:@selector(onEmail:) forControlEvents:UIControlEventTouchUpInside];
//    [main_toolbar addSubview:email_button];
//    [email_button release];
}

- (void)initControlItemViews {
    CGRect frameRect;
    
    CGFloat offsetY = 0;
    
#ifdef FREE_VERSION
    offsetY = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 48 : 80;
#endif
    //Insert LivePreiView Button
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake(15, 10+offsetY, 60, 30);
    } else {
        frameRect = CGRectMake(15 * SCALE_X, 10 * SCALE_Y+offsetY, 120, 60);
    }    
    livePreview_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkinForOnlyNormalState:livePreview_button skinName:@"LivePreview"];    
    [livePreview_button addTarget:self action:@selector(onLivePreview:) forControlEvents:UIControlEventTouchUpInside];    
    [self.view addSubview:livePreview_button];
    [livePreview_button release];
    
    //Insert Torch Button
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake((320 - 60) / 2, 10+offsetY, 60, 30);
    } else {
        frameRect = CGRectMake((768 - 120) / 2, 10 * SCALE_Y+offsetY, 120, 60);
    }    
    torch_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkinForOnlyNormalState:torch_button skinName:@"TorchOff"];    
    [torch_button addTarget:self action:@selector(onTorch:) forControlEvents:UIControlEventTouchUpInside];    
    [self.view addSubview:torch_button];
    [torch_button release];

    //Insert CameraPosition Button
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake(320 - (60 + 15), 10+offsetY, 60, 30);
    } else {
        frameRect = CGRectMake(768 - (120 + 15 * SCALE_X), 10 * SCALE_Y+offsetY, 120, 60);
    }    
    cameraPosition_button = [[UIButton alloc] initWithFrame:frameRect];
    [g_AppUtils loadSkinForOnlyNormalState:cameraPosition_button skinName:@"CameraPosition"];    
    [cameraPosition_button addTarget:self action:@selector(onCameraPosition:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraPosition_button];
    [cameraPosition_button release];    
}

- (void)initPhotoPaperView {    
    CGRect frameRect;
    CGFloat border;
    
    //Insert LivePreview
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        border = 3;
        frameRect = CGRectMake(0 - border, 0 - border, 320 + border * 2, [self actualSize].height + border * 2);
    } else {
        frameRect = CGRectMake(0 - border, 0 - border, 768 + border * 2, 1024 + border * 2);
    }
    livePreview = [[LivePreview alloc] initWithFrame:frameRect];
    [self.view addSubview:livePreview];
    [livePreview release];
    [self.view sendSubviewToBack:livePreview];    
    
    //Insert PhotoPaperView
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {    
        frameRect = CGRectMake(0, 0, [self actualSize].width, [self actualSize].height);
    } else {
        frameRect = CGRectMake(0, 0, 768, 1024);
    }
    photoPaperView = [[GLES2View alloc] initWithFrame:frameRect];
    [self.view addSubview:photoPaperView];
    [photoPaperView release];
    [self.view sendSubviewToBack:photoPaperView];    
    [photoPaperView clearView];
}

- (void)initExposureSettingView {    
    CGRect frameRect;
    
    //Insert ExposureSettingView
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {    
        frameRect = CGRectMake(0, main_toolbar.frame.origin.y, 320, 185);
    } else {
        frameRect = CGRectMake(0, main_toolbar.frame.origin.y, 768, 185 * 2);
    }
    exposureSettingView = [[ExposureSettingView alloc] initWithFrame:frameRect];
    [self.view addSubview:exposureSettingView];
    [exposureSettingView release];
    
    [exposureSettingView setDelegateController:self];    
}

- (void)initEditSettingView {    
    CGRect frameRect;
    
    CGRect bounds = self.view.frame;
    
    //Insert ExposureSettingView
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {    
        frameRect = CGRectMake(0, [self actualSize].height - main_toolbar.frame.size.height, 320, 76);
    } else {
        frameRect = CGRectMake(0, [self actualSize].height - main_toolbar.frame.size.height, 768, 76 * 2);
    }
    editSettingView = [[EditSettingView alloc] initWithFrame:frameRect];
    [self.view addSubview:editSettingView];
    [editSettingView release];
    
    [editSettingView setDelegateController:self];
}

- (void)initAleartWaitView {    
    CGRect frameRect;
    
    //Insert ExposureSettingView
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {    
        frameRect = CGRectMake(0, [self actualSize].height - main_toolbar.frame.size.height, 320, [self actualSize].height);
    } else {
        frameRect = CGRectMake(0, [self actualSize].height - main_toolbar.frame.size.height, 768, [self actualSize].height);
    }
    aleartWaiteView = [[AleartWaitView alloc] initWithFrame:frameRect];
    [aleartWaiteView setMessage:@"Wait..."];
    [self.view addSubview:aleartWaiteView];
    [aleartWaiteView release];
}

- (void)initOptionSettingView {
    NSString* strNib;
    CGRect frameRect;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        strNib = @"OptionSettingView_iPhone";
    }
    else {
        strNib = @"OptionSettingView_iPad";
    }
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:strNib owner:nil options:nil];
    optionSettingView = [nibViews objectAtIndex:0];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frameRect = CGRectMake(0, main_toolbar.frame.origin.y, 320, 132);
    }
    else {
        frameRect = CGRectMake(0, main_toolbar.frame.origin.y, 768, 132*2);
    }
    [optionSettingView setFrame:frameRect];
    [self.view addSubview:optionSettingView];
    [optionSettingView setDelegateController:self];
}
#pragma mark - User Interface Action
- (void)onExposure:(id)sender {  
    if (bShowingOptionView)
        [self onSettings:nil];
    bShowingExposureView = !bShowingExposureView;
    
    if (bShowingExposureView) {
        [self setExposureSettingViewHidden:NO withAnimation:YES];
    } else {
        [self setExposureSettingViewHidden:YES withAnimation:NO];
    }
}

- (void)onShutter:(id)sender {
    [self procShutter];
//    if (bTakingPictures) {  //Stop Taking Picture Now
//        [self stopTakingPictures:nil];
//    } else {                //Make Taking Pictures  From Camera Now
//        //Hidden Control ItemViews And Translate Main Toolbar Toward Left
//        [g_AppUtils loadSkin:shutter_button skinName:@"Stop"];
//        [cameraPosition_button setHidden:YES];   
//        
//        //Start Taking Picture With SelfTimer Delay
//        int selfTimerDelay = [g_AppUtils selfTimerDelay];
//        if (selfTimerDelay > 0) {
//            startSelfDelayTimer = [[NSTimer scheduledTimerWithTimeInterval:selfTimerDelay  target:self selector:@selector(startTakingPictures:) userInfo:nil repeats:NO] retain];
//        } else {
//            [self startTakingPictures:nil];
//        }
//    }
}

- (void)onSettings:(id)sender {
//	SetViewController* controller;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        controller = [[SetViewController alloc] initWithNibName:@"SetViewController_iPhone" bundle:[NSBundle mainBundle]];
//    else
//        controller = [[SetViewController alloc] initWithNibName:@"SetViewController_iPad" bundle:[NSBundle mainBundle]];
//
//	[self presentModalViewController:controller animated:YES];
//	[controller release];
    
    if (bShowingExposureView)
        [self onExposure:nil];
    
    bShowingOptionView = !bShowingOptionView;
    
    if (bShowingOptionView) {
        [self setOptionSettingViewHidden:NO withAnimation:YES];
    } else {
        [self setOptionSettingViewHidden:YES withAnimation:NO];
    }
}

- (void)onBack1:(id)sender {
    //Show Control ItemViews And Translate Main Toolbar Toward Right
    [self showControlItemViews:YES];
    [photoPaperView clearView];
    [self animateMainToolbar:NO];
    
    if (bShowingEditView) {
        [self setEditSettingViewHidden:YES withAnimation:NO];        
    }
}

- (void)onEdit:(id)sender {
    bShowingEditView = !bShowingEditView; 
    
    if (bShowingEditView) {
        [self setEditSettingViewHidden:NO withAnimation:YES];
    } else {
        [self setEditSettingViewHidden:YES withAnimation:NO];
    }
}

- (void)onNext:(id)sender {
    if (bShowingEditView)
        [self onEdit:nil];
    
    [self savePhotoPaperImageToPhotoAlbum];

//
    return;
    
//    [self animateMainToolbar:YES];
    
    return;
    
    if (bShowingEditView) {
        [self onEdit:nil];
    }
    
    [cancel_button setEnabled:NO];
    [edit_button setEnabled:NO];
    [save_button setEnabled:NO]; 
    
    [self savePhotoPaperImageToPhotoAlbum];
}

- (void)onLivePreview:(id)sender {
    bShowingLivePreview = !bShowingLivePreview;

    if (bShowingLivePreview) {          //
        [livePreview_button setHidden:YES];
        [self animateLivePreivew:NO];
    } else {
        [livePreview_button setHidden:NO];        
        [self animateLivePreivew:YES];        
    }
}

- (void)onTorch:(id)sender {
    if (!bUsingFrontCamera && [device hasTorch]) {
        bUsingLED = !bUsingLED;
        
        if (bUsingLED) {                //Make Use LED Now
            [device lockForConfiguration:nil];
            [ device setTorchMode:AVCaptureTorchModeOn];
            [device unlockForConfiguration];          
            [g_AppUtils loadSkinForOnlyNormalState:torch_button skinName:@"TorchOn"];
        } else {                       //Make Unuse LED Now
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];
            [device unlockForConfiguration];                    
            [g_AppUtils loadSkinForOnlyNormalState:torch_button skinName:@"TorchOff"];
        }
    }
}

- (void)onCameraPosition:(id)sender {
    bUsingFrontCamera = !bUsingFrontCamera;

    AVCaptureDevice *new_device;
    if (bUsingFrontCamera) {
        new_device = [self frontFacingCamera];
    } else {
        new_device = [self backFacingCamera];
    }
    
    if (new_device) {
        AVCaptureDeviceInput *new_captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:new_device error:nil];
        if (new_captureInput) {
            [self.captureSession stopRunning];
            [self.captureSession beginConfiguration];
            
            if (captureInput) {
                [self.captureSession removeInput:captureInput];
                [captureInput release];
                captureInput = nil;
            }
            
            if ([self.captureSession canAddInput:new_captureInput]) {
                [self.captureSession addInput:new_captureInput];
            } else {
                [new_captureInput release];
            }
            
            [self.captureSession commitConfiguration];           
            [self.captureSession startRunning];
            
            captureInput = new_captureInput;
            device = new_device;
            
            [self unUseLED];
            if ([device hasTorch] == NO) {
                [torch_button setHidden:YES];
            }
            else {
                [torch_button setHidden:bUsingFrontCamera];
            }
            
            return;
        }
    }
    
    bUsingFrontCamera = !bUsingFrontCamera;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *)[touches anyObject];
    BOOL bTakePic = NO;
    if (livePreview.hidden == YES)
        return;
    if ([touch view] == livePreview) {
        //Get Tourched Point
      	CGPoint pointInView = [touch locationInView:self.view];

        //If Tourced in LivePreview Area, Treate As LP Button Click
        if (bShowingLivePreview && CGRectContainsPoint(livePreview.frame, pointInView)) {
            [self onLivePreview:nil];
        } else {
            bTakePic = YES;
        }
    }
    else {
        bTakePic = YES;
    }
    if (bTakePic) {
        if (bTakingPictures == NO && [g_AppUtils useScreenShutter] == YES) {
            [self procShutter];
//            [g_AppUtils loadSkin:shutter_button skinName:@"Stop"];
//            [cameraPosition_button setHidden:YES];   
//            int selfTimerDelay = [g_AppUtils selfTimerDelay];
//            if (selfTimerDelay > 0) {
//                startSelfDelayTimer = [[NSTimer scheduledTimerWithTimeInterval:selfTimerDelay  target:self selector:@selector(startTakingPictures:) userInfo:nil repeats:NO] retain];
//            } else {
//                [self startTakingPictures:nil];
//            }
        }
    }
}
- (void) enableUserAction:(BOOL)enable {
    self.view.userInteractionEnabled = enable;
}
- (void)enableBottomBtns:(BOOL)enable {
    [exposure_button setEnabled:enable];
    [settings_button setEnabled:enable];
}
#pragma mark - Taking Picutre
//kgh
- (void) procShutter
{
    if (m_nRecordStatus == RECORD_DOING)
    {  //Stop Taking Picture Now
        [self enableBottomBtns:YES];
        [self stopTakingPictures:nil];
    }
    else if (m_nRecordStatus == RECORD_STOP)
    {                //Make Taking Pictures  From Camera Now
        //Hidden Control ItemViews And Translate Main Toolbar Toward Left
        [self enableBottomBtns:NO];
        if (bShowingOptionView)
            [self onSettings:nil];
        [g_AppUtils loadSkin:shutter_button skinName:@"bt_rec"];
        [cameraPosition_button setHidden:YES];   
        
        //Start Taking Picture With SelfTimer Delay
        int selfTimerDelay = [g_AppUtils selfTimerDelay];
        if (selfTimerDelay > 0) {
            m_nRecordStatus = RECORD_WAITING;
            startSelfDelayTimer = [[NSTimer scheduledTimerWithTimeInterval:selfTimerDelay  target:self selector:@selector(startTakingPictures:) userInfo:nil repeats:NO] retain];
        } else {
            [self startTakingPictures:nil];
        }
    }
    else {
        [self enableBottomBtns:YES];
        [self cancelTakingPictures:nil];
    }
}

- (void)startTakingPictures:(id)sender {
    if (bTakingPictures)
        return;
    
    [[MagicCameraAppDelegate sharedDelegate] playSE:SE_SHUTTERSTART];
    m_nRecordStatus = RECORD_DOING;
    if (startSelfDelayTimer) {
        [startSelfDelayTimer invalidate];
        [startSelfDelayTimer release];
        startSelfDelayTimer = nil;
    }
    
    //Init Taking Picture
    isFirstFrame = YES;
    [self delTakingPictureTextures];
    
    //Start Taking Picture
    if (bShowingExposureView)
        [self onExposure:nil];
    if (bShowingOptionView)
        [self onSettings:nil];
    
    //Set Stop Timer
    float shutter_speed = [g_AppUtils shutterSpeed];
    if (shutter_speed > 0) {
        stopSelfDelayTimer = [[NSTimer scheduledTimerWithTimeInterval:shutter_speed target:self selector:@selector(stopTakingPictures:) userInfo:nil repeats:NO] retain];
    }
    
    switch ([g_AppUtils  pictureSizeType]) {
        case SMALL_SIZE:
//            photoPaperView.contentScaleFactor = 0.5f;
            break;
        case MEDIUM_SIZE:
//            photoPaperView.contentScaleFactor = 1.0f;
            break;
        case LARGE_SIZE:
//            photoPaperView.contentScaleFactor = 2.0f;
        default:
            photoPaperView.contentScaleFactor = 1.0f;
            break;
    }

    bTakingPictures = YES;   
}

- (void)stopTakingPictures:(id)sender {
    if (!bTakingPictures) 
        return;
    
    [[MagicCameraAppDelegate sharedDelegate] playSE:SE_SHUTTEREND];
    [self enableBottomBtns:YES];
    m_nRecordStatus = RECORD_STOP;
   if (stopSelfDelayTimer) {
        [stopSelfDelayTimer invalidate];
        [stopSelfDelayTimer release];
        stopSelfDelayTimer = nil;
    }
    
    if (startSelfDelayTimer) {
        [startSelfDelayTimer invalidate];
        [startSelfDelayTimer release];
        startSelfDelayTimer = nil;
    }
    
    bTakingPictures = NO;
    
    //Unuse LED
    [self unUseLED];
    
    //Hidden Control ItemViews And Translate Main Toolbar Toward Left
    if ([g_AppUtils selfTimerDelay] > 0) {
        [g_AppUtils loadSkin:shutter_button skinName:@"bt_time"];
    } else {
        [g_AppUtils loadSkin:shutter_button skinName:@"bt_camera"];
    }
    if ([g_AppUtils useAutoSave] == NO) {
        [editSettingView updateViewFromAppSettings];
        [self showControlItemViews:NO];
        [self changeEditSettings];
        [self animateMainToolbar:YES];
        if (bShowingEditView)
            [self setEditSettingViewHidden:NO withAnimation:YES];
    }
    else {
//        [self showControlItemViews:YES];
        [self savePhotoPaperImageToPhotoAlbum];
    }
    
    //???
}
- (void)cancelTakingPictures:(id)sender {
    [self enableBottomBtns:YES];
    m_nRecordStatus = RECORD_STOP;
    if (stopSelfDelayTimer) {
        [stopSelfDelayTimer invalidate];
        [stopSelfDelayTimer release];
        stopSelfDelayTimer = nil;
    }
    
    if (startSelfDelayTimer) {
        [startSelfDelayTimer invalidate];
        [startSelfDelayTimer release];
        startSelfDelayTimer = nil;
    }
    
    bTakingPictures = NO;
    
    //Unuse LED
    [self unUseLED];
    
    //Hidden Control ItemViews And Translate Main Toolbar Toward Left
    if ([g_AppUtils selfTimerDelay] > 0) {
        [g_AppUtils loadSkin:shutter_button skinName:@"bt_time"];
    } else {
        [g_AppUtils loadSkin:shutter_button skinName:@"bt_camera"];
    }
    [self showControlItemViews:YES];
}

#pragma mark - Save Captured Image
- (void)photoPaperImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self setAleartWaitViewHidden:YES withAnimation:NO];
    
    [cancel_button setEnabled:YES];
    [edit_button setEnabled:YES];
    [save_button setEnabled:YES]; 

    if ([g_AppUtils useAutoSave] == YES) {
        [photoPaperView clearView];
        [self showControlItemViews:YES];
    }
    
    SaveViewController* viewController;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        viewController = [[SaveViewController alloc] initWithNibName:@"SaveViewController_iPhone" bundle:[NSBundle mainBundle]];
    else
        viewController = [[SaveViewController alloc] initWithNibName:@"SaveViewController_iPad" bundle:[NSBundle mainBundle]];

//    UIImage *snapshotImage = [photoPaperView snapshot];

    viewController.processImg = self.snapshotImage;

//    NSData* Dat = UIImagePNGRepresentation(snapshotImage);
//    [Dat writeToFile:@"1.png" atomically:YES];
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController initLoad];
    [viewController release];
}

- (void)savePhotoPaperImageToPhotoAlbum {
    [self setAleartWaitViewHidden:NO withAnimation:NO];
    self.snapshotImage = [photoPaperView snapshot];
    
//    [self performSelector: @selector(photoPaperImage:didFinishSavingWithError:contextInfo:) withObject:self afterDelay:0.1];    
    
    UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(photoPaperImage:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - View Move And Animations 
- (void)showControlItemViews:(BOOL)showViews {
    BOOL hiddenViews = !showViews;
    [livePreview setHidden:hiddenViews];    
    [livePreview_button setHidden:hiddenViews || bShowingLivePreview];
    [cameraPosition_button setHidden:hiddenViews];
    
    if ([device hasTorch] == NO)
        [torch_button setHidden:YES];
    else
        [torch_button setHidden:hiddenViews || bUsingFrontCamera];
    
    [exposure_button setHidden:hiddenViews];
    [settings_button setHidden:hiddenViews];
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"animateMainToolbar"]) {
        NSLog(@"%@", @"Finish animateMainToolbar");
    } else if ([animationID isEqualToString:@"animateLivePreivew"]) {
        NSLog(@"%@", @"Finish animateLivePreivew");
    } else if ([animationID isEqualToString:@"animateExposureSettingView"]) {
//        [exposure_button setEnabled:YES];
    }else if ([animationID isEqualToString:@"animateOptionSettingView"]) {
        NSLog(@"%@", @"Finish animateOptionSettingView");
    }
}

- (void)animateMainToolbar:(BOOL)toLeft
{
    [UIView beginAnimations:@"animateMainToolbar" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

    float offsetX;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        offsetX = 320;
    else
        offsetX = 768;

    if (toLeft)
        offsetX = -offsetX;
    
    main_toolbar.center = CGPointMake(main_toolbar.center.x + offsetX, main_toolbar.center.y);    
    [UIView commitAnimations];
}

- (void)animateLivePreivew:(BOOL)zoomPlus {
    CGRect frameRect;
    int border;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (zoomPlus)
        {
            border = 3;
            frameRect = CGRectMake(0 - border, 0 - border, 320 + border * 2, [self actualSize].height + border * 2);
        }
        else
        {
            frameRect = CGRectMake(10, 10, 81, 106);
        }
    }
    else
    {
        if (zoomPlus)
        {
            border = 0;
            frameRect = CGRectMake(0 - border, 0 - border, 768 + border * 2, 1024 + border * 2);
        }
        else
            frameRect = CGRectMake(10 * SCALE_X, 10 * SCALE_Y, 81 * 2, 106 * 2);
    }
    
    [livePreview setFrame:frameRect hiddenBorder:zoomPlus];
    
    [UIView beginAnimations:@"animateLivePreivew" context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

    [livePreview resizeLivePreviewLayerToFit];
    [UIView commitAnimations];
}

- (void)setExposureSettingViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation {
    float newOriginY;
    CGRect newFrameRect;
    
    newOriginY = main_toolbar.frame.origin.y;
    if (!hidden) {
        float offsetY;
        offsetY = ([g_AppUtils captureModeType] == LIGHTTRAIL_MODE) ? 185 : 123;
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {   //iPad
            offsetY *= 2;
        }
        newOriginY -= offsetY;
    }
    
    newFrameRect = exposureSettingView.frame;
    newFrameRect.origin.y = newOriginY;
    if (withAnimation) {
        [UIView beginAnimations:@"animateExposureSettingView" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        exposureSettingView.frame = newFrameRect;
        [UIView commitAnimations];
    } else {
        exposureSettingView.frame = newFrameRect;
    }
}

- (void)setEditSettingViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation {
    float newOriginY;
    CGRect newFrameRect;
    
    newOriginY = main_toolbar.frame.origin.y;
    if (!hidden) {
        float offsetY;
        
        switch ([g_AppUtils captureModeType]) {
            case AUTOMATIC_MODE:
                [editSettingView modifyLayoutToFEOrder:YES];
                offsetY = 76;
                break;
            case MANUAL_MODE:
                [editSettingView modifyLayoutToFEOrder:NO];
                offsetY = 38;
                break;
            case LIGHTTRAIL_MODE:
                [editSettingView modifyLayoutToFEOrder:YES];
                offsetY = 38;
                break;                
            default:
                break;
        }
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {   //iPad
            offsetY *= 2;
        }
        newOriginY -= offsetY;
    }
    
    newFrameRect = editSettingView.frame;
    newFrameRect.origin.y = newOriginY;
    if (withAnimation) {
        [UIView beginAnimations:@"animateEditSettingView" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        editSettingView.frame = newFrameRect;
        [UIView commitAnimations];
    } else {
        editSettingView.frame = newFrameRect;
    }
}

- (void)setOptionSettingViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation {
    float newOriginY;
    CGRect newFrameRect;
    
    newOriginY = main_toolbar.frame.origin.y;
    if (!hidden) {
        newOriginY -= optionSettingView.frame.size.height;
    }
    
    newFrameRect = optionSettingView.frame;
    newFrameRect.origin.y = newOriginY;
    if (withAnimation) {
        [UIView beginAnimations:@"animateOptionSettingView" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        optionSettingView.frame = newFrameRect;
        [UIView commitAnimations];
    } else {
        optionSettingView.frame = newFrameRect;
    }
}

- (void)setAleartWaitViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation {
    float newOriginY;
    CGRect newFrameRect;
    
    newOriginY = (hidden) ? main_toolbar.frame.origin.y : 0;

    newFrameRect = aleartWaiteView.frame;
    newFrameRect.origin.y = newOriginY;
    if (withAnimation) {
        [UIView beginAnimations:@"animateAleartWaitView" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        aleartWaiteView.frame = newFrameRect;
        [UIView commitAnimations];
    } else {
        aleartWaiteView.frame = newFrameRect;
    }
}

#pragma mark - Camera Device And Captured Data Control
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *dev in devices) {
        if ([dev position] == position) {
            return dev;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)unUseLED {
    if (bUsingLED) {
        [self onTorch:nil];
    }
}
- (void)setupCaptureSession {
	/*We setup the input*/
    device = [self backFacingCamera];
    
	if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    else {
        [torch_button setHidden:YES];
    }
    captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];

	/*We setupt the output*/
	captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
	/*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
	 If you don't want this behaviour set the property to NO */
	captureOutput.alwaysDiscardsLateVideoFrames = YES; 
    
	/*We specify a minimum duration for each frame (play with this settings to avoid having too many frames waiting
	 in the queue because it can cause memory issues). It is similar to the inverse of the maximum framerate.
	 In this example we set a min frame duration of 1/10 seconds so a maximum framerate of 10fps. We say that
	 we are not able to process more than 10 frames per second.*/
	//captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
	/*We create a serial queue to handle the processing of our frames*/
	[captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

	// Set the video output to store frame in BGRA (It is supposed to be faster)
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
	[captureOutput setVideoSettings:videoSettings];
    
	/*And we create a capture session*/
	self.captureSession = [[AVCaptureSession alloc] init];
	[self.captureSession beginConfiguration];
    
    /*We add input and output*/
    if ([self.captureSession canAddInput:captureInput]) {
         [self.captureSession addInput:captureInput];
    } else {
        [captureInput release];
        captureInput = nil;
    }
    
    if ([self.captureSession canAddOutput:captureOutput]) {    
        [self.captureSession addOutput:captureOutput];
    } else {
        [captureOutput release];
        captureOutput = nil;
    }
    
    /*We use medium quality, ont the iPhone 4 this demo would be laging too much, the conversion in UIImage and CGImage demands too much ressources for a 720p resolution.*/
    //  AVCaptureSessionPresetPhoto:    852 * 640
    //  AVCaptureSessionPresetHigh:     1280 * 720
    //  AVCaptureSessionPresetMedium:   480 * 360
    //  AVCaptureSessionPresetLow:      192 * 144
    
    //  AVCaptureSessionPreset352x288
    //  AVCaptureSessionPreset640x480
    //  AVCaptureSessionPreset1280x720
    //  AVCaptureSessionPreset1920x1080
    //  AVCaptureSessionPresetiFrame960x540
    //  AVCaptureSessionPresetiFrame1280x720
    [self.captureSession setSessionPreset:AVCaptureSessionPresetMedium];
	
    /*We add the preview layer*/
    self.livePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
    self.livePreviewLayer.frame = self.view.bounds;
    self.livePreviewLayer.videoGravity = AVLayerVideoGravityResize;

  	[self.captureSession commitConfiguration];    
}

- (void)releaseCaptureSession {
    [self.captureSession stopRunning];
    
    [self.captureSession beginConfiguration];
    if (captureInput) {
        [self.captureSession removeInput:captureInput];
        [captureInput release];
        captureInput = nil;
    }

    if (captureOutput) {
        [self.captureSession removeOutput:captureOutput];
        [captureInput release];
        captureInput = nil;
    }
    [self.captureSession commitConfiguration];
    
    if (self.captureSession) {
        [self.captureSession release];
        self.captureSession = nil;
    }
}

- (void)startCapturingFromCamera {    
	/*We start the capture*/
    if (![self.captureSession isRunning]) {
        [livePreview addLivePreivewLayer:self.livePreviewLayer];
        [self.captureSession startRunning];
    }
}

- (void)stopCapturingFromCamera {
	/*We stop the capture*/
    [self.captureSession stopRunning];
    [livePreview removeLivePreviewLayer:self.livePreviewLayer];
}

- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame;
{
	CVPixelBufferLockBaseAddress(cameraFrame, 0);
    
    //Get Camera Frame Data Info
    int width, height;
	width = CVPixelBufferGetWidth(cameraFrame);
	height = CVPixelBufferGetHeight(cameraFrame);
    
    //Generate Texture From New Camera Frame
    [self genTextureFromPixelBuffer:CVPixelBufferGetBaseAddress(cameraFrame) width:width height:height isCameraData:YES textureIDPtr:&lastFrameTextureID];

	[self drawFrameInPhotoPaperView];

    //If New Frame Is First, Generate Texture From This Frame
    if (isFirstFrame) {
        [self genTextureFromPixelBuffer:CVPixelBufferGetBaseAddress(cameraFrame) width:width height:height isCameraData:YES textureIDPtr:&firstFrameTextureID];
        isFirstFrame = NO;
    }
    
	CVPixelBufferUnlockBaseAddress(cameraFrame, 0);
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{   
    if (bTakingPictures) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        if( CMSampleBufferDataIsReady(sampleBuffer) )
        {
            {
                CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                [self processNewCameraFrame:pixelBuffer];
            }
        }
        else {
            NSLog( @"sample buffer is not ready. Skipping sample" );
        }
        [pool drain];
    }
}

#pragma mark - OpenGL ES 2.0 Setup
- (void) initGL {
    RendererInfo renderer;
	// Query renderer capabilities that affect this app's rendering paths
	renderer.extension[APPLE_texture_2D_limited_npot] =
    (0 != strstr((char *)glGetString(GL_EXTENSIONS), "GL_APPLE_texture_2D_limited_npot"));
	renderer.extension[IMG_texture_format_BGRA8888] =
    (0 != strstr((char *)glGetString(GL_EXTENSIONS), "GL_IMG_texture_format_BGRA8888"));
	glGetIntegerv(GL_MAX_TEXTURE_SIZE, &renderer.maxTextureSize);
}

- (BOOL)loadVertexShader:(NSString *)vertexShaderName fragmentShader:(NSString *)fragmentShaderName forProgram:(GLuint *)programPointer {
    GLuint vertexShader, fragShader;
	
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    *programPointer = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vertexShaderName ofType:@"vsh"];
    if (![self compileShader:&vertexShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fragmentShaderName ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(*programPointer, vertexShader);
    
    // Attach fragment shader to program.
    glAttachShader(*programPointer, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(*programPointer, ATTRIB_VERTEX, "position");
    glBindAttribLocation(*programPointer, ATTRIB_TEXTUREPOSITON, "inputTextureCoordinate");
    
    // Link program.
    if (![self linkProgram:*programPointer])
    {
        NSLog(@"Failed to link program: %d", *programPointer);
        
        if (vertexShader)
        {
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (*programPointer)
        {
            glDeleteProgram(*programPointer);
            *programPointer = 0;
        }
        
        return FALSE;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_VIDEOFRAME] = glGetUniformLocation(*programPointer, "videoFrame");
    uniforms[UNIFORM_INPUTCOLOR] = glGetUniformLocation(*programPointer, "inputColor");
    uniforms[UNIFORM_SOLIDCOLOR] = glGetUniformLocation(*programPointer, "solidColor");
    uniforms[UNIFORM_INPUTCONTRAST] = glGetUniformLocation(*programPointer, "inputContrast");
    uniforms[UNIFORM_INPUTBRIGHTNESS] = glGetUniformLocation(*programPointer, "inputBrightness");
    uniforms[UNIFORM_INPUTSATURATION] = glGetUniformLocation(*programPointer, "inputSaturation");
    uniforms[UNIFORM_ENABLEBW] = glGetUniformLocation(*programPointer, "enableBW");
    uniforms[UNIFORM_ENABLESEPIA] = glGetUniformLocation(*programPointer, "enableSepia");
    uniforms[UNIFORM_SCREENMODE] = glGetUniformLocation(*programPointer, "screenMode");
    uniforms[UNIFORM_ALPHA] = glGetUniformLocation(*programPointer, "Alpha");
    uniforms[UNIFORM_LUMCOEFF] = glGetUniformLocation(*programPointer, "lumCoeff");
    
    // Release vertex and fragment shaders.
    if (vertexShader)
	{
        glDeleteShader(vertexShader);
	}
    if (fragShader)
	{
        glDeleteShader(fragShader);
	}
    
    return TRUE;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog {
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog {
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (void)unloadShaderProgram:(GLuint *)programPointer {
    if (*programPointer) {
        glDeleteProgram(*programPointer);
        *programPointer = 0;
    }
}

- (void)genTextureFromPixelBuffer:(uint8_t *)pixelBuffer width:(int)width height:(int)height isCameraData:(BOOL)isCameraData textureIDPtr:(GLuint *)textureIDPtr {
    //Destroy prev texture
    if (*textureIDPtr)
        glDeleteTextures(1, textureIDPtr);
    
	// Create a new texture from the camera frame data, display that using the shaders
	glGenTextures(1, textureIDPtr);
	glBindTexture(GL_TEXTURE_2D, *textureIDPtr);
    
    
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
    // This is necessary for non-power-of-two textures
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    // Using BGRA extension to pull in video frame data directly
    // else RGBA framebuffer data
    GLenum format = (isCameraData) ? GL_BGRA : GL_RGBA;
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, format, GL_UNSIGNED_BYTE,  pixelBuffer);
}

- (void)genTextureFromFrameBuffer:(GLuint *)textureIDPtr {
    if (*textureIDPtr)
        glDeleteTextures(1, textureIDPtr);
	glGenTextures(1, textureIDPtr);
    
    glBindTexture(GL_TEXTURE_2D, *textureIDPtr);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	// This is necessary for non-power-of-two textures
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 0, 0, photoPaperView.backingWidth, photoPaperView.backingHeight, 0);    
}

- (void)delTakingPictureTextures {
    if (firstFrameTextureID) {
        glDeleteTextures(1, &firstFrameTextureID);
        firstFrameTextureID = 0;
    }
    
    if (lastFrameTextureID) {
        glDeleteTextures(1, &lastFrameTextureID);    
        lastFrameTextureID = 0;
    }
    
    if (tmpFrameTextureID) {
        glDeleteTextures(1, &tmpFrameTextureID);        
        tmpFrameTextureID = 0;
    }
}

- (void)delEditingPictureTextures {
    if (backTextureID) {
        glDeleteTextures(1, &backTextureID);
        backTextureID = 0;
    }
}

#pragma mark - OpenGL ES 2.0 Effect Drawing
- (void)drawFrameInPhotoPaperView
{
    [photoPaperView setDisplayFramebuffer];

    //Draw New Frame Texture With Previous Framebuffer By Using Blend Tech
    [self drawCapturedFrame];
    if (!isFirstFrame) {
        [self drawFrameBuffer];
    }

    //Get Framebuffer As Texture
    [self genTextureFromFrameBuffer:&tmpFrameTextureID];

    [photoPaperView presentFramebuffer];    
}

- (void)drawCapturedFrame {
    glUseProgram(drawTextureProgram);
    glBindTexture(GL_TEXTURE_2D, lastFrameTextureID);
    glUniform1f(uniforms[UNIFORM_ALPHA], 1.0);
    glUniform1i(uniforms[UNIFORM_SCREENMODE], 7);
    
    // Update attribute values.
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f,
    };
    
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
	glEnableVertexAttribArray(ATTRIB_VERTEX);

    if (!bUsingFrontCamera) {
        static const GLfloat textureVertices[] = {
            1.0f, 1.0f,
            1.0f, 0.0f,
            0.0f, 1.0f,
            0.0f, 0.0f,
        };
        glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
        glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);        
    }
    else {
        static const GLfloat textureVertices[] = {
            1.0f, 0.0f,
            1.0f, 1.0f,
            0.0f, 0.0f,
            0.0f, 1.0f,            
        };
        glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
        glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);
    }

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)drawFrameBuffer {
    glUseProgram(drawTextureProgram);
    glBindTexture(GL_TEXTURE_2D, tmpFrameTextureID);
    glEnable(GL_BLEND);
    
    switch ([g_AppUtils captureModeType]) {
        case AUTOMATIC_MODE:
            glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ZERO, GL_ONE);
            glUniform1f(uniforms[UNIFORM_ALPHA], 0.975f);
            break;
        case MANUAL_MODE:
            glBlendFuncSeparate(GL_ONE, GL_ONE, GL_ZERO, GL_ONE);
            glUniform1f(uniforms[UNIFORM_ALPHA], 0.1f);
            break;
        case LIGHTTRAIL_MODE:
            glBlendFuncSeparate(GL_ONE, GL_ONE, GL_ZERO, GL_ONE);
            glBlendEquationSeparate(GL_FUNC_REVERSE_SUBTRACT, GL_FUNC_ADD);
            glUniform1f(uniforms[UNIFORM_ALPHA], 1.0f);
            break;
    }  
    glUniform1i(uniforms[UNIFORM_SCREENMODE], 7);
    
    // Update attribute values.
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f,
    };
    
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    static const GLfloat textureVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);        
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    if ([g_AppUtils captureModeType] == LIGHTTRAIL_MODE) {
        glBlendFuncSeparate(GL_ONE, GL_SRC_ALPHA, GL_ZERO, GL_ONE);
        glBlendEquationSeparate(GL_FUNC_ADD, GL_FUNC_ADD);
        glUniform1f(uniforms[UNIFORM_ALPHA], [g_AppUtils sensitivity]);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    
    glDisable(GL_BLEND);    
}

- (void)drawCamFrameTexture:(GLuint)textureID withAlpha:(float)alpha useBlend:(BOOL)useBlend {
    glUseProgram(drawTextureProgram);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glUniform1f(uniforms[UNIFORM_ALPHA], alpha);
    glUniform1i(uniforms[UNIFORM_SCREENMODE], 7);

    if (useBlend) {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }
    // Update attribute values.
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f,
    };
    
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    if (!bUsingFrontCamera) {
        static const GLfloat textureVertices[] = {
            1.0f, 1.0f,
            1.0f, 0.0f,
            0.0f, 1.0f,
            0.0f, 0.0f,
        };
        glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
        glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);        
    }
    else {
        static const GLfloat textureVertices[] = {
            1.0f, 0.0f,
            1.0f, 1.0f,
            0.0f, 0.0f,
            0.0f, 1.0f,            
        };
        glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
        glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);
    }
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    if (useBlend) {
        glDisable(GL_BLEND);
    }
}

- (void)drawFrameBufferTexture:(GLuint)textureID withAlpha:(float)alpha useBlend:(BOOL)useBlend {
    glUseProgram(drawTextureProgram);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    glUniform1f(uniforms[UNIFORM_ALPHA], alpha);
    glUniform1i(uniforms[UNIFORM_SCREENMODE], 7);
    
    if (useBlend) {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }

    // Update attribute values.
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f,
    };
    
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    static const GLfloat textureVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);        
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
    
    if (useBlend) {
        glDisable(GL_BLEND);
    } 
}

- (void)drawColorEffeectTexture:(GLuint)textureID withEffect:(float)k useBlend:(BOOL)useBlend {
    glUseProgram(drawTextureProgram);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    glUniform1f(uniforms[UNIFORM_ALPHA], 1.0);
    glUniform1f(uniforms[UNIFORM_INPUTCONTRAST], k);    
    glUniform1i(uniforms[UNIFORM_SCREENMODE], 8);
    
    if (useBlend) {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }
    
    // Update attribute values.
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f,
    };
    
	glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
	glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    static const GLfloat textureVertices[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    glVertexAttribPointer(ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTUREPOSITON);        
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4); 
    
    if (useBlend) {
        glDisable(GL_BLEND);
    } 
}

#pragma mark - OpenGL ES 2.0 Editing
- (void)drawEditFrameInPhotoPaperView {
    [photoPaperView setDisplayFramebuffer];
    
//    [photoPaperView clearView];
    switch ([g_AppUtils captureModeType]) {
        case AUTOMATIC_MODE:
            [self drawCamFrameTexture:targetTextureID withAlpha:1.0f useBlend:NO];
            [self drawFrameBufferTexture:tmpFrameTextureID withAlpha:1.0f - blendValueToTarget useBlend:YES];
            [self genTextureFromFrameBuffer:&backTextureID];
            [self drawColorEffeectTexture:backTextureID withEffect:blendValueToBack useBlend:NO];
            break;
        case MANUAL_MODE:
//            [self drawFrameBufferTexture:tmpFrameTextureID withAlpha:1.0f useBlend:NO];
            [self drawCamFrameTexture:firstFrameTextureID withAlpha:1.0f useBlend:NO];
            [self genTextureFromFrameBuffer:&backTextureID];
            [self drawColorEffeectTexture:backTextureID withEffect:blendValueToBack useBlend:NO];
            break;
        case LIGHTTRAIL_MODE:
            [self drawCamFrameTexture:targetTextureID withAlpha:1.0f useBlend:NO];
            [self drawFrameBufferTexture:tmpFrameTextureID withAlpha:1.0f - blendValueToTarget useBlend:YES];
            break;
        default:
            break;
    }
    
    [photoPaperView presentFramebuffer];
}

#pragma mark - App Setting Change Delegate
- (void)changeExposureSettings {
    //Capture Mode
    [self setExposureSettingViewHidden:NO withAnimation:YES];
}

- (void)changeEditSettings {
    //Calc Freeze Params
    float freezeValue = [g_AppUtils freeze];
    if (freezeValue < 0.0f) {
        targetTextureID = firstFrameTextureID;
        freezeValue = -freezeValue;
    } else {
        targetTextureID = lastFrameTextureID;
    }
    blendValueToTarget = freezeValue / 100.0f;
    
    //Calc Exposure Params    
    float exposureValue = [g_AppUtils exposure];  
    if ([g_AppUtils captureModeType] != MANUAL_MODE) {
        if (exposureValue < 0.0f) {
            blendValueToBack = exposureValue / 2.0f * 0.5f;
        } else {
            blendValueToBack = exposureValue / 2.0f * 3.0f;
        }
    }
    else {
        blendValueToBack = (4.0+exposureValue) * 2.5f;
        if ([g_AppUtils shutterSpeed] < 0)
            blendValueToBack += 10;
        else
            blendValueToBack += ([g_AppUtils shutterSpeed]/2);
    }
    
    //Do Editing
    [self drawEditFrameInPhotoPaperView];
}

-(void)onImageProcess:(id)sender
{
    if (bShowingEditView)
        [self onEdit:nil];
    
}

-(void)onBack2:(id)sender
{
    [self animateMainToolbar:NO];
}

-(void)onFacebook:(id)sender
{
    
}

-(void)onTwitter:(id)sender
{

}

-(void)onAlberm:(id)sender
{

}

-(void)onEmail:(id)sender
{
    
}


@end
