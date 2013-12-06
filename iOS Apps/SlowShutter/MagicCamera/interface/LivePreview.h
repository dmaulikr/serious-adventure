//
//  LivePreview.h
//  MagicCamera
//
//  Created by i Pro on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>

@interface LivePreview : UIView {
    CALayer *        livePreivewLayer;
    UIImageView *    borderImageView;
}

- (void)addLivePreivewLayer:(CALayer *)layer;
- (void)removeLivePreviewLayer:(CALayer *)layer;
- (void)resizeLivePreviewLayerToFit;
- (void)setFrame:(CGRect)frameRect hiddenBorder:(BOOL)hiddenBorder;

@end
