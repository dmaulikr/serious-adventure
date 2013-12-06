//
//  ColorTrackingGLView.m
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/7/2010.
//

#import "GLES2View.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>

@implementation GLES2View

#pragma mark -
#pragma mark Accessors

@synthesize positionRenderTexture;
@synthesize backingWidth;
@synthesize backingHeight;

#pragma mark -
#pragma mark Initialization and teardown

// Override the class method to return the OpenGL layer, as opposed to the normal CALayer
+ (Class) layerClass 
{
	return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		// Do OpenGL Core Animation layer setup
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		// Set scaling to account for Retina display	
//		if ([self respondsToSelector:@selector(setContentScaleFactor:)])
//		{
//			self.contentScaleFactor = [[UIScreen mainScreen] scale];
//		}
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		
		if (!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffers]) 
		{
			[self release];
			return nil;
		}
		
        // Initialization code
        
    }
    return self;
}


- (void)dealloc 
{
    [self destroyFramebuffer];
    
	if([EAGLContext currentContext] == context) {
		[EAGLContext setCurrentContext:nil];
	}	
	[context release];

    [super dealloc];
}

#pragma mark -
#pragma mark OpenGL drawing

- (BOOL)createFramebuffers
{	
	glEnable(GL_TEXTURE_2D);
	glDisable(GL_DEPTH_TEST);

	// Onscreen framebuffer object
	glGenFramebuffers(1, &viewFramebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
	
	glGenRenderbuffers(1, &viewRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
	
	[context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
	
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
//	NSLog(@"Backing width: %d, height: %d", backingWidth, backingHeight);
	
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
	
	if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) 
	{
		NSLog(@"Failure with framebuffer generation");
		return NO;
	}
	
//	// Offscreen position framebuffer object
//	glGenFramebuffers(1, &positionFramebuffer);
//    glBindFramebuffer(GL_FRAMEBUFFER, positionFramebuffer);
//
//	glGenRenderbuffers(1, &positionRenderbuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, positionRenderbuffer);
//	
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, FBO_WIDTH, FBO_HEIGHT);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, positionRenderbuffer);	
//    
//
//	// Offscreen position framebuffer texture target
//	glGenTextures(1, &positionRenderTexture);
//    glBindTexture(GL_TEXTURE_2D, positionRenderTexture);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//	glHint(GL_GENERATE_MIPMAP_HINT, GL_NICEST);
////	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
//	//GL_NEAREST_MIPMAP_NEAREST
//
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, FBO_WIDTH, FBO_HEIGHT, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
////    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, FBO_WIDTH, FBO_HEIGHT, 0, GL_RGBA, GL_FLOAT, 0);
//
//	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, positionRenderTexture, 0);
////	NSLog(@"GL error15: %d", glGetError());
	
//	GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
//    if (status != GL_FRAMEBUFFER_COMPLETE) 
//	{
//		NSLog(@"Incomplete FBO: %d", status);
//        exit(1);
//    }
	
	return YES;
}

- (void)destroyFramebuffer;
{	
	if (viewFramebuffer)
	{
		glDeleteFramebuffers(1, &viewFramebuffer);
		viewFramebuffer = 0;
	}
	
	if (viewRenderbuffer)
	{
		glDeleteRenderbuffers(1, &viewRenderbuffer);
		viewRenderbuffer = 0;
	}
}

- (void)setDisplayFramebuffer;
{
    if (context)
    {
        if ([EAGLContext currentContext] != context)
            [EAGLContext setCurrentContext:context];
        
        if (!viewFramebuffer)
		{
            [self createFramebuffers];
		}
        
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        
        glViewport(0, 0, backingWidth, backingHeight);
    }
}

- (void)setPositionThresholdFramebuffer;
{
    if (context)
    {
        if ([EAGLContext currentContext] != context)
            [EAGLContext setCurrentContext:context];
        
        if (!positionFramebuffer)
		{
            [self createFramebuffers];
		}
        
        glBindFramebuffer(GL_FRAMEBUFFER, positionFramebuffer);
        
        glViewport(0, 0, backingWidth, backingHeight);
        
        glClearColor(1, 0, 0, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
    }
}

- (BOOL)presentFramebuffer;
{
    BOOL success = FALSE;
    
    if (context)
    {
        if ([EAGLContext currentContext] != context)
            [EAGLContext setCurrentContext:context];
        
        glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
        
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
    }

    return success;
}

- (UIImage*)snapshot;
{    
    // Bind the color renderbuffer used to render the OpenGL ES view
    // If your application only creates a single color renderbuffer which is already bound at this point, 
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
//    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
//    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    
    // Get the size of the backing CAEAGLLayer
//    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
//	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    // Read pixel data from the framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 1);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    // Create a CGImage with the pixel data
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    // otherwise, use kCGImageAlphaPremultipliedLast
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, ref, NULL, true, kCGRenderingIntentDefault);
    
    // OpenGL ES measures data in PIXELS
    // Create a graphics context with the target size measured in POINTS
    NSInteger widthInPoints, heightInPoints;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        // so that you get a high-resolution snapshot when its value is greater than 1.0
        CGFloat scale = self.contentScaleFactor;
        widthInPoints = width / scale;
        heightInPoints = height / scale;

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    }
    else {
        // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
        widthInPoints = width;
        heightInPoints = height;
        UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
    }
    
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    // Flip the CGImage by rendering it to the flipped bitmap context
    // The size of the destination area is measured in POINTS
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
    // Retrieve the UIImage from the current context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // Clean up
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
    
    return image;
}

- (void)clearView {
    [self setDisplayFramebuffer];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self presentFramebuffer];
}

@end
