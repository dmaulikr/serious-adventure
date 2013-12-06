//
//  ColorTrackingGLView.h
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/7/2010.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLES2View : UIView 
{
	/* The pixel dimensions of the backbuffer */
	GLint backingWidth, backingHeight;
	
	EAGLContext *context;
	
	/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
	GLuint viewRenderbuffer, viewFramebuffer;
	
    /* Additional buffers to inprove performance */
	GLuint positionRenderTexture;
	GLuint positionRenderbuffer, positionFramebuffer;
}

@property(readonly) GLuint positionRenderTexture;
@property(readonly) GLint backingWidth;
@property(readonly) GLint backingHeight;

// OpenGL drawing
- (BOOL)createFramebuffers;
- (void)destroyFramebuffer;
- (void)setDisplayFramebuffer;
- (void)setPositionThresholdFramebuffer;
- (BOOL)presentFramebuffer;
- (void)clearView;

- (UIImage*)snapshot;

@end
