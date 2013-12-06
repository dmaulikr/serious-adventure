//
//  LivePreview.m
//  MagicCamera
//
//  Created by i Pro on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LivePreview.h"

@implementation LivePreview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        livePreivewLayer = nil;
        
        CGRect frameRect;
        NSString *imageName;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {  
            imageName = @"CameraPreviewBorder.png";
            frameRect = CGRectMake(0, 0, 81, 106);
        } else {
            imageName = @"CameraPreviewBorder@2x.png";            
            frameRect = CGRectMake(0, 0, 162, 212);
        }
        borderImageView = [[UIImageView alloc] initWithFrame:frameRect];
        UIImage *skinImage;
        skinImage = [UIImage imageNamed:imageName];
        [borderImageView setImage:skinImage];

        [self addSubview:borderImageView];
        [borderImageView release];
        
        [borderImageView setHidden:YES];
    }
    return self;
}

- (void)dealloc {
    livePreivewLayer = nil;
    [borderImageView removeFromSuperview];
    
    [super dealloc];
}

- (void)resizeLivePreviewLayerToFit {
    int border = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 3 : 6;
    border = 0;
    CGRect frameRect = CGRectMake(border, border, self.bounds.size.width - border * 2, self.bounds.size.height - border * 2);
    livePreivewLayer.frame = frameRect;
    [self bringSubviewToFront:borderImageView];

}
- (void)addLivePreivewLayer:(CALayer *)aLayer {
    [self.layer addSublayer:aLayer];
    livePreivewLayer = aLayer;
    [self resizeLivePreviewLayerToFit];
}

- (void)removeLivePreviewLayer:(CALayer *)aLayer {
    [aLayer removeFromSuperlayer];
}

- (void)setFrame:(CGRect)frameRect hiddenBorder:(BOOL)hiddenBorder {
    self.frame = frameRect;
    [borderImageView setHidden:hiddenBorder];
//    [self resizeLivePreviewLayerToFit];    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
