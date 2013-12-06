

#import <Foundation/Foundation.h>

@interface Utility : NSObject
//+(BOOL)isNetworkAvailable;

+ (void)showLoadingView;
+ (void)hideLoadingView;
+ (void)showLoadingViewOnFrame:(CGRect)frame;
+ (void)showLoadingViewWithTitle:(NSString*)title;

+(void) setImageViaLazyLoading :(UIImageView *) iv againstPath:(NSString*) imgPath;
//for tableviewcells
+(void) setImageViaLazyLoading :(UIImageView *) iv againstPath:(NSString*) imgPath usingTag:(int)tag;

+(BOOL) isValidEmail :(NSString *)str;
+(void) appearViewWithFadeAnimation :(UIView*)view;
+(void) disAppearViewWithFadeAnimation :(UIView*)view;
+(BOOL)NSStringIsValidTelNum:(NSString*)phoneNumber;
+(NSString*) nullCheck :(NSString *)str;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+(NSString*)removeSpacesFromString:(NSString*)string;

+(NSString*)getDeviceId;
@end
