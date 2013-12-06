//
//  1.h
//  MagicCamera
//
//  Created by i Pro on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCALE_X     768.0f / 320.0f
#define SCALE_Y     1024.0f / 480.0f

enum CaptureMode_Type
{
    AUTOMATIC_MODE = 0,
    MANUAL_MODE,
    LIGHTTRAIL_MODE,
};

enum ShutterSpeed_Type
{
    SPEED_0p5 = 0,
    SPEED_1,
    SPEED_2,
    SPEED_4,
    SPEED_8,
    SPEED_16,
    SPEED_B
};

enum Sensitivity_Type
{
    SENSITIVITY_1 = 0,
    SENSITIVITY_1p2,
    SENSITIVITY_1p4,
    SENSITIVITY_1p8,
    SENSITIVITY_1p16,
    SENSITIVITY_1p32,
    SENSITIVITY_1p64,
};

enum PictureSize_Type
{
    SMALL_SIZE = 0,
    MEDIUM_SIZE,
    LARGE_SIZE,
};

@interface MagicCameraAppUtils: NSObject {
    enum CaptureMode_Type       _captureModeType;
    enum ShutterSpeed_Type      _shutterSpeedType;
    enum Sensitivity_Type       _sensitivityType;
    
    float                       _freezeAuto;
    float                       _exposureAuto;
    float                       _exposureManual;
    float                       _freezeLightTrail;

    int                         _selfTimerDelay;
    BOOL                        _useExposureAdjust;
    BOOL                        _useExposureLock;
    BOOL                        _useScreenSutter;
    BOOL                        _useAutoSave;
    enum PictureSize_Type       _pictureSizeType;
}

#pragma mark - Load Resource 
- (NSString*)resourceNameForDevice:(NSString*)name ofType:(NSString *)type;
- (void)loadSkin:(UIButton *)button skinName:(NSString *)skinName;
- (void)loadSkinForOnlyNormalState:(UIButton *)button skinName:(NSString *)skinName;

#pragma mark - Access App Settings Values
- (enum CaptureMode_Type)captureModeType;
- (void)setCaptureModeType:(enum CaptureMode_Type)aType;
- (enum ShutterSpeed_Type)ShutterSpeedType;
- (float)shutterSpeed;
- (void)setShutterSpeedType:(enum ShutterSpeed_Type)aType;
- (enum Sensitivity_Type)sensitivityType;
- (float)sensitivity;
- (void)setSensitivityType:(enum Sensitivity_Type)aType;

- (float)freeze;
- (void)setFreeze:(float)aValue;
- (float)exposure;
- (void)setExposure:(float)aValue;

- (int)selfTimerIndex;
- (int)selfTimerDelay;
- (void)setSelfTimerDelay:(float)aValue;
- (BOOL)useExposureAdjust;
- (void)setUseExposureAdjust:(BOOL)aValue;
- (BOOL)useExposureLock;
- (void)setUseExposureLock:(BOOL)aValue;
- (BOOL)useScreenShutter;
- (void)setUseScreenShutter:(BOOL)aValue;
- (BOOL)useAutoSave;
- (void)setUseAutoSave:(BOOL)aValue;
- (enum PictureSize_Type)pictureSizeType;
- (void)setPictureSizeType:(enum PictureSize_Type)aType;

#pragma mark - Read/Write App Settings
- (void)readAppSettings;
- (void)writeAppSettings;
@end

#pragma mark - AppUtils Instence
extern MagicCameraAppUtils*	g_AppUtils;
