//
//  1.m
//  MagicCamera
//
//  Created by i Pro on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MagicCameraAppUtils.h"

#pragma mark - AppUtils Instence
MagicCameraAppUtils*	g_AppUtils;


float shutterSpeedValue[] = {0.5, 1.0f, 2.0f, 4.0f, 8.0f, 15.0f, -1.0f};
float sensitivityValue[] = {1.0f, 0.5f, 0.25f, 0.125f, 0.0625f, 0.03125f, 0.015625f};
int selfTimer[] = {0, 1, 3, 5, 10};

@implementation MagicCameraAppUtils

#pragma mark - Load Resource 
- (NSString*)resourceNameForDevice:(NSString*)name ofType:(NSString *)type
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return [NSString stringWithFormat:@"%@.%@", name, type];
    } else {
        return [NSString stringWithFormat:@"%@@2x.%@", name, type];
    }
    
    return @"";
}

- (void)loadSkin:(UIButton *)button skinName:(NSString *)skinName {
    UIImage * skinImage;
    
    skinImage = [UIImage imageNamed:[self resourceNameForDevice:[NSString stringWithFormat:@"%@01", skinName] ofType:@"png"]];
    [button setImage:skinImage forState:UIControlStateNormal];
    
    skinImage = [UIImage imageNamed:[self resourceNameForDevice:[NSString stringWithFormat:@"%@02", skinName] ofType:@"png"]];
    [button setImage:skinImage forState:UIControlStateHighlighted];
    
    skinImage = [UIImage imageNamed:[self resourceNameForDevice:[NSString stringWithFormat:@"%@01", skinName] ofType:@"png"]];
    [button setImage:skinImage forState:UIControlStateDisabled];
}

- (void)loadSkinForOnlyNormalState:(UIButton *)button skinName:(NSString *)skinName {
    UIImage * skinImage;
    skinImage = [UIImage imageNamed:[self resourceNameForDevice:skinName ofType:@"png"]];
    [button setImage:skinImage forState:UIControlStateNormal];
}

#pragma mark - Access App Settings Values
- (enum CaptureMode_Type)captureModeType {
    return _captureModeType;
}

- (void)setCaptureModeType:(enum CaptureMode_Type)aType {
    _captureModeType = aType;
}

- (enum ShutterSpeed_Type)ShutterSpeedType {
    return _shutterSpeedType;
}

- (float)shutterSpeed {
    return shutterSpeedValue[_shutterSpeedType];
}

- (void)setShutterSpeedType:(enum ShutterSpeed_Type)aType {
    _shutterSpeedType = aType;
}

- (enum Sensitivity_Type)sensitivityType {
    return _sensitivityType;
}

- (float)sensitivity {
    return sensitivityValue[_sensitivityType];
}

- (void)setSensitivityType:(enum Sensitivity_Type)aType {
    _sensitivityType = aType;
}

- (float)freeze {
    if (_captureModeType == AUTOMATIC_MODE)
        return _freezeAuto;
    else
        return _freezeLightTrail;
}

- (void)setFreeze:(float)aValue {
    if (_captureModeType == AUTOMATIC_MODE)
        _freezeAuto = aValue;
    else
        _freezeLightTrail = aValue;
}

- (float)exposure {
    if (_captureModeType == AUTOMATIC_MODE)
        return _exposureAuto;
    else if (_captureModeType == MANUAL_MODE)
        return _exposureManual;
    else
        return 0;
}

- (void)setExposure:(float)aValue {
    if (_captureModeType == AUTOMATIC_MODE)
        _exposureAuto = aValue;
    else
        _exposureManual = aValue;
}

- (int)selfTimerIndex {
    return _selfTimerDelay;
}

- (int)selfTimerDelay {
    return selfTimer[_selfTimerDelay];
}

- (void)setSelfTimerDelay:(float)aValue {
    _selfTimerDelay = aValue;
}

- (BOOL)useExposureAdjust {
    return _useExposureAdjust;
}

- (void)setUseExposureAdjust:(BOOL)aValue {
    _useExposureAdjust = aValue;
}

- (BOOL)useExposureLock {
    return _useExposureLock;
}

- (void)setUseExposureLock:(BOOL)aValue {
    _useExposureLock = aValue;
}

- (BOOL)useScreenShutter {
    return _useScreenSutter;
}

- (void)setUseScreenShutter:(BOOL)aValue {
    _useScreenSutter = aValue;
}

- (BOOL)useAutoSave {
    return _useAutoSave;
}

- (void)setUseAutoSave:(BOOL)aValue {
    _useAutoSave = aValue;
}

- (enum PictureSize_Type)pictureSizeType {
    return _pictureSizeType;
}

- (void)setPictureSizeType:(enum PictureSize_Type)aType {
    _pictureSizeType = aType;
}

#pragma mark - Read/Write App Settings
- (void)readAppSettings {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL bFirstRun = ![defaults boolForKey:@"NotFirstRun"];
    if (bFirstRun) {
        _captureModeType = AUTOMATIC_MODE;
        _shutterSpeedType = SPEED_4;
        _sensitivityType = SENSITIVITY_1p8;
        
        _freezeAuto = 0.0f;
        _exposureAuto = 0.0f;
        _freezeLightTrail = 0.0f;
        _exposureManual = 0.0f;
        
        _selfTimerDelay = 0;
        _useExposureAdjust = NO;
        _useExposureLock = NO;
        _useScreenSutter = NO;
        _useAutoSave = NO;
        _pictureSizeType = MEDIUM_SIZE;
        
        [self writeAppSettings];
    } else {
        _captureModeType = (enum CaptureMode_Type)[defaults integerForKey:@"CaptureModeType"];
        _shutterSpeedType = (enum ShutterSpeed_Type)[defaults integerForKey:@"ShutterSpeedType"];
        _sensitivityType = (enum Sensitivity_Type)[defaults integerForKey:@"SensitivityType"];
        
        _freezeAuto = [defaults floatForKey:@"FreezeValueAuto"];
        _exposureAuto = [defaults floatForKey:@"ExposureValueAuto"];
        _exposureManual = [defaults floatForKey:@"ExposureValueManual"];
        _freezeLightTrail = [defaults floatForKey:@"FreezeValueLightTrail"];
        
        _selfTimerDelay = [defaults integerForKey:@"SelfTimerDelay"];
        _useExposureAdjust = [defaults boolForKey:@"ExposureAdjust"];
        _useExposureLock = [defaults boolForKey:@"ExposureLock"];
        _useScreenSutter = [defaults boolForKey:@"ScreenSutter"];
        _useAutoSave = [defaults boolForKey:@"AutoSave"];
        _pictureSizeType = (enum PictureSize_Type)[defaults integerForKey:@"PictureSizeType"];    
    }
}

- (void)writeAppSettings {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"NotFirstRun"];
    
    [defaults setInteger:_captureModeType forKey:@"CaptureModeType"];
    [defaults setInteger:_shutterSpeedType forKey:@"ShutterSpeedType"];
    [defaults setInteger:_sensitivityType forKey:@"SensitivityType"];
    
    [defaults setFloat:_freezeAuto forKey:@"FreezeValueAuto"];
    [defaults setFloat:_exposureAuto forKey:@"ExposureValueAuto"];
    [defaults setFloat:_exposureManual forKey:@"ExposureValueManual"];
    [defaults setFloat:_freezeLightTrail forKey:@"FreezeValueLightTrail"];
    
    [defaults setInteger:_selfTimerDelay forKey:@"SelfTimerDelay"];
    [defaults setBool:_useExposureAdjust forKey:@"ExposureAdjust"];
    [defaults setBool:_useExposureLock forKey:@"ExposureLock"];
    [defaults setBool:_useScreenSutter forKey:@"ScreenSutter"];
    [defaults setBool:_useAutoSave forKey:@"AutoSave"];
    [defaults setInteger:_pictureSizeType forKey:@"PictureSizeType"];
    
	[defaults synchronize];    
}

@end
