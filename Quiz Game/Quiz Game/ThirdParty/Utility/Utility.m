

#import "Utility.h"
#import "LoadingView.h"

#define kTimeInterval 0.50





@implementation Utility

static LoadingView *loadingView = nil;
static UIView *backgroundView = nil;


+ (void)showLoadingView
{
    if (loadingView == nil) {
        loadingView = [[LoadingView alloc]
                       initWithFrame:CGRectMake(35, 170, kUIWidth, kUIHeight)];
    } else {
        loadingView.frame = CGRectMake(35, 170, kUIWidth, kUIHeight);
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:keyWindow.frame];
    }
    
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    [keyWindow addSubview:backgroundView];
    [keyWindow addSubview:loadingView];
}

+ (void)showLoadingViewWithTitle:(NSString*)title
{
    if (loadingView == nil) {
        loadingView = [[LoadingView alloc]
                       initWithFrame:CGRectMake(35, 170, kUIWidth, kUIHeight)];
    } else {
        loadingView.frame = CGRectMake(35, 170, kUIWidth, kUIHeight);
    }
    loadingView.loadingLabel.text =title;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:keyWindow.frame];
    }
    
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    [keyWindow addSubview:backgroundView];
    [keyWindow addSubview:loadingView];
}

+ (void)showLoadingViewOnFrame:(CGRect)frame
{
    if (loadingView == nil) {
        loadingView = [[LoadingView alloc] initWithFrame:frame];
    } else {
        loadingView.frame = frame;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:keyWindow.frame];
    }
    
    [backgroundView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    [keyWindow addSubview:backgroundView];
    
    [keyWindow addSubview:loadingView];
}

+ (void)hideLoadingView
{
    [loadingView removeFromSuperview];  
    loadingView = nil;
    [backgroundView removeFromSuperview];
    backgroundView = nil;
}




+(void) appearViewWithFadeAnimation :(UIView*)view{

	view.alpha = 0;
	[UIView animateWithDuration:kTimeInterval animations:^{
        view.alpha = 1;
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }completion:^(BOOL finished){

    }];

	
}


+(void) disAppearViewWithFadeAnimation :(UIView*)view{

	view.alpha = 1;
	[UIView animateWithDuration:kTimeInterval animations:^{
        view.alpha = 0;
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    }completion:^(BOOL finished){
		[view removeFromSuperview];
    }];
	
}


+(NSString*) nullCheck :(NSString *)str
{
	if (str) {
		return str;
	}
	return @"";
}


@end
