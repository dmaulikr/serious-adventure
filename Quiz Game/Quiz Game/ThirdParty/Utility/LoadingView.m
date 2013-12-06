

#import "LoadingView.h"



@implementation LoadingView

@synthesize backView;
@synthesize rectangleView;
@synthesize loadingLabel;
@synthesize activityIndicator;





- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {

    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.0]];
    [self addSubview:self.backView];
    [self addSubview:self.rectangleView];
    [self addSubview:self.activityIndicator];
    [self addSubview:self.loadingLabel];
  }

  return self;
}


- (void)drawRect:(CGRect)rect
{
  // Drawing code
}


#pragma mark -
#pragma mark Getters


- (UIView *)backView
{
  if (backView != nil) {
    return backView;
  }

  backView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, kUIWidth, self.frame.size.height)];
  [backView setBackgroundColor:[UIColor blackColor]];
  [backView setAlpha:0.0];
  return backView;
}


- (UIView *)rectangleView
{
  if (rectangleView != nil) {
    return rectangleView;
  }

  CGFloat ycoord = self.frame.size.height / 2;
  CGFloat widthDiff = 70; 
  CGFloat height = 140;
  rectangleView = [[UIView alloc]
      initWithFrame:CGRectMake(widthDiff/2, ycoord - (height / 2), kUIWidth-widthDiff, height)];
  [rectangleView setBackgroundColor:[UIColor blackColor]];
  [rectangleView setAlpha:0.5];
  rectangleView.layer.cornerRadius = 10.0;
  return rectangleView;
}


- (UILabel *)loadingLabel
{
  if (loadingLabel != nil) {
    return loadingLabel;
  }

  loadingLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, self.frame.size.height/2 - 30, kUIWidth, 20)];
    [loadingLabel setText:[NSString stringWithFormat:@"%@...",NSLocalizedString(@"loading", @"loading")]];
  [loadingLabel setTextColor:[UIColor whiteColor]];
  [loadingLabel setTextAlignment:UITextAlignmentCenter];
  [loadingLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
  [loadingLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.0]];
  return loadingLabel;
}


- (UIActivityIndicatorView *)activityIndicator
{
  if (activityIndicator != nil) {
    return activityIndicator;
  }

  activityIndicator = [[UIActivityIndicatorView alloc]
      initWithFrame:CGRectMake(kUIWidth/2-16, self.frame.size.height/2, 32, 32)];
  [activityIndicator startAnimating];
  return activityIndicator;
}


@end
