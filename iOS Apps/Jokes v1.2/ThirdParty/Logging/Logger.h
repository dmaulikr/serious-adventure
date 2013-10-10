//
//  Logger.h
//

#import <UIKit/UIKit.h>

#define LEVEL_DEBUG 0
#define LEVEL_INFO 10
#define LEVEL_WARN 20
#define LEVEL_ERROR 30
#define LEVEL_FATAL 40

@interface NSObject (Logger)
-(void)debug:(NSString *)message,...;
-(void)info:(NSString *)message,...;
-(void)warn:(NSString *)message,...;
-(void)error:(NSString *)message,...;
-(void)fatal:(NSString *)message,...;
-(void)setLogLevel:(int)level;
-(void)setLogLevel:(Class)theClass level:(int)level;
-(BOOL)checkLogLevel:(int)desired;
-(Class)firstClass:(Class)one two:(Class)two;
@end
