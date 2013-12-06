//
//  ViewController.h
//  MagicCamera
//
//  Created by i Pro on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "MagicCameraAppUtils.h"


// Uniform index.
enum {
    UNIFORM_VIDEOFRAME,
	UNIFORM_INPUTCOLOR,
    UNIFORM_SOLIDCOLOR,
    UNIFORM_INPUTCONTRAST,
    UNIFORM_INPUTBRIGHTNESS,
    UNIFORM_INPUTSATURATION,
    UNIFORM_ENABLEBW,
    UNIFORM_ENABLESEPIA,
    UNIFORM_ALPHA,
    UNIFORM_SCREENMODE,
    UNIFORM_LUMCOEFF,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_TEXTUREPOSITON,
    NUM_ATTRIBUTES
};

enum RECORD_STATUS {
    RECORD_STOP,
    RECORD_WAITING,
    RECORD_DOING,
};

@class AdMobView;

@class GLES2View, LivePreview, ExposureSettingView, EditSettingView, AleartWaitView, OptionSettingView;

@interface MagicCameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, UIActionSheetDelegate> {
    
    //Interface Items
    
    UIImageView*    bottomButton;
    UIImageView *   main_toolbar;               //
    
    UIButton *      exposure_button;            //
    UIButton *      shutter_button;             //    
    UIButton *      settings_button;            //    
    UIButton *      cancel_button;              //    
    UIButton *      edit_button;                //    
    UIButton *      save_button;                //
//    UIButton *      imgP_button;                //    
//    
//    UIButton *      lastBack_button;
//    UIButton *      face_button;
//    UIButton *      twitter_button;
//    UIButton *      alberm_button;
//    UIButton *      email_button;
    
    UIButton *      livePreview_button;         //    
    UIButton *      torch_button;               //    
    UIButton *      cameraPosition_button;      //

    ExposureSettingView *   exposureSettingView;  //
    EditSettingView *       editSettingView;      //
    AleartWaitView *        aleartWaiteView;
    OptionSettingView*      optionSettingView;
    
    NSTimer *       startSelfDelayTimer;        //
    NSTimer *       stopSelfDelayTimer;         //
    
    LivePreview *   livePreview;                //
    GLES2View *     photoPaperView;             //

	GLuint          drawTextureProgram;         //
    
    GLuint          firstFrameTextureID;        //    
    GLuint          lastFrameTextureID;         //
    GLuint          tmpFrameTextureID;          //
    
    BOOL            isFirstFrame;               //
    
    //Edit
    GLuint          backTextureID;              //NO DEL
    
    GLuint          targetTextureID;            //NO DEL
    GLuint          editedTextureID;            //
    
    float           blendValueToTarget;
    float           blendValueToBack;
    
    //Iterface Item Status Flag
    BOOL            bShowingExposureView;
    BOOL            bShowingOptionView;
    BOOL            bTakingPictures;  
    BOOL            bShowingEditView;

    BOOL            bShowingLivePreview; 
    BOOL            bUsingLED; 
    BOOL            bUsingFrontCamera; 
    
    int             m_nRecordStatus;
    
    //Capture Device And Controllers
    AVCaptureDevice *               device;
    AVCaptureSession *              _captureSession;
	CALayer *                       _customLayer;
	AVCaptureVideoPreviewLayer *    _livePreviewLayer;
    AVCaptureDeviceInput *          captureInput;
    AVCaptureVideoDataOutput *      captureOutput;
    
    UIImage* snapshotImage;
}

#pragma mark - Property Definition
@property (nonatomic, retain) AVCaptureSession *            captureSession;
@property (nonatomic, retain) CALayer *                     customLayer;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *  livePreviewLayer;
@property (nonatomic, retain) UIImage* snapshotImage;

#pragma mark - App ResignActive/BecomeActive
- (void)appWillResignActive;
- (void)appDidBecomeActive;

#pragma mark - Init User Interface
- (void)initControlItemViews;
- (void)initMainToolbar;
- (void)initPhotoPaperView;
- (void)initExposureSettingView;
- (void)initEditSettingView;
- (void)initAleartWaitView;
- (void)initOptionSettingView;
- (void)changeShutterBtnImage;

#pragma mark - User Interface Action
- (void)onExposure:(id)sender;
- (void)onShutter:(id)sender;
- (void)onSettings:(id)sender;
- (void)onCancel:(id)sender;
- (void)onEdit:(id)sender;
- (void)onSave:(id)sender;

- (void)onLivePreview:(id)sender;
- (void)onTorch:(id)sender;
- (void)onCameraPosition:(id)sender;

- (void)enableUserAction:(BOOL)enable;
- (void)enableBottomBtns:(BOOL)enable;
#pragma mark - Taking Picutre
- (void) procShutter;
- (void)startTakingPictures:(id)sender;
- (void)stopTakingPictures:(id)sender;
- (void)cancelTakingPictures:(id)sender;

#pragma mark - View Animations 
- (void)showControlItemViews:(BOOL)showViews;
- (void)animateMainToolbar:(BOOL)toLeft;
- (void)animateLivePreivew:(BOOL)zoomPlus;
- (void)setExposureSettingViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation;
- (void)setEditSettingViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation;
- (void)setAleartWaitViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation;
- (void)setOptionSettingViewHidden:(BOOL)hidden withAnimation:(BOOL)withAnimation;

#pragma mark - Camera Device And Captured Data Control
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position;
- (AVCaptureDevice *)frontFacingCamera;
- (AVCaptureDevice *)backFacingCamera;
- (void)unUseLED;
- (void)setupCaptureSession;
- (void)releaseCaptureSession;
- (void)startCapturingFromCamera;
- (void)stopCapturingFromCamera;

#pragma mark -Save Captured Image
- (void)savePhotoPaperImageToPhotoAlbum;

#pragma mark - OpenGL ES 2.0 Setup
- (void) initGL;
- (BOOL)loadVertexShader:(NSString *)vertexShaderName fragmentShader:(NSString *)fragmentShaderName forProgram:(GLuint *)programPointer;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
- (void)unloadShaderProgram:(GLuint *)programPointer;
- (void)genTextureFromPixelBuffer:(uint8_t *)pixelBuffer width:(int)width height:(int)height isCameraData:(BOOL)isCameraData textureIDPtr:(GLuint *)textureIDPtr;
- (void)genTextureFromFrameBuffer:(GLuint *)textureIDPtr;
- (void)delTakingPictureTextures;
- (void)delEditingPictureTextures;

#pragma mark - OpenGL ES 2.0 Draw
- (void)drawFrameInPhotoPaperView;
- (void)drawCapturedFrame;
- (void)drawFrameBuffer;

#pragma mark - OpenGL ES 2.0 Editing
- (void)drawEditFrameInPhotoPaperView;

#pragma mark - App Setting Change Delegate
- (void)changeExposureSettings;
- (void)changeEditSettings;

#pragma mark - Admob for free version
- (void)setHiddenAdMobView:(BOOL)hidden;

#pragma mark -
#pragma mark UIAlertView
- (void)alertSimpleAction:(NSString*) strMessage;
- (void)alertOkAction:(NSString*) strMessage;
- (void)alertOKCancelAction;
- (void)alertOtherAction;

@end
