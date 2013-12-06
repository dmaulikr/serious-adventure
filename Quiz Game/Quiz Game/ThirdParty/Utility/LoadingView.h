

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

// uiLoadView
#define kUIWidth 250
#define kUIHeight 150

@interface LoadingView : UIView
{
  UILabel *loadingLabel;
  UIView *backView;
  UIView *rectangleView;
  UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIView *rectangleView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;



@end
