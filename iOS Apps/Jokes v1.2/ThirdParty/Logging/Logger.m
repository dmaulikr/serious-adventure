//
//  Logger.m
//

#import "Logger.h"

int logLevel = LEVEL_DEBUG;
NSMutableDictionary *classLevels=nil;

@implementation NSObject (Logger)
-(void)debug:(NSString *)message,...{
	if([self checkLogLevel:LEVEL_DEBUG]){
		va_list args;
		va_start(args, message);
		char *func=va_arg(args,char*);
		int line=va_arg(args, int);

		NSString *info = [[NSString alloc] initWithFormat:message arguments:args];
		NSLog([NSString stringWithFormat: @"%-35@ \t\t\t\t| DEBUG [%s:%d]", info, func, line], nil);
		va_end(args);
	}
}

-(void)info:(NSString *)message,...{
	if([self checkLogLevel:LEVEL_INFO]){
		va_list args;
		va_start(args, message);
		char *func=va_arg(args,char*);
		int line=va_arg(args, int);
		
		NSString* info = [[NSString alloc] initWithFormat:message arguments:args];
		NSLog([NSString stringWithFormat: @"%-35@ | INFO [%s:%d]", info, func, line], nil);
		va_end(args);
	}
	
}

-(void)warn:(NSString *)message,...{
	if([self checkLogLevel:LEVEL_WARN]){
		va_list args;
		va_start(args, message);
		char *func=va_arg(args,char*);
		int line=va_arg(args, int);
		
		NSString* info = [[NSString alloc] initWithFormat:message arguments:args];
		NSLog([NSString stringWithFormat: @"%-35@ | WARN [%s:%d]", info, func, line], nil);
		va_end(args);
	}
	
}

-(void)error:(NSString *)message,...{
	if([self checkLogLevel:LEVEL_ERROR]){
		va_list args;
		va_start(args, message);
		char *func=va_arg(args,char*);
		int line=va_arg(args, int);
		
		NSString* info = [[NSString alloc] initWithFormat:message arguments:args];
		NSLog([NSString stringWithFormat: @"%-35@ | ERROR [%s:%d]", info, func, line], nil);
		va_end(args);
	}
	
}

-(void)fatal:(NSString *)message,...{
	if([self checkLogLevel:LEVEL_FATAL]){
		va_list args;
		va_start(args, message);
		char *func=va_arg(args,char*);
		int line=va_arg(args, int);
		
		NSString* info = [[NSString alloc] initWithFormat:message arguments:args];
		NSLog([NSString stringWithFormat: @"%-35@ | FATAL [%s:%d]", info, func, line], nil);
		va_end(args);
	}
	
}

-(void)setLogLevel:(int)level{
	logLevel = level;
}

-(void)setLogLevel:(Class)class level:(int)level{
	if(nil == classLevels){
		classLevels = [[NSMutableDictionary alloc] init];
	}
	//[classLevels setObject:[NSValue value:&level withObjCType:@encode(int)] forKey:class];
    [classLevels setObject:[NSValue value:&level withObjCType:@encode(int)] forKey:(id)class];
}

-(BOOL)checkLogLevel:(int)desired{
	int level = logLevel;
	if(nil != classLevels){
		Class highestClass = nil;
		for(Class theClass in [classLevels keyEnumerator]){
			if([self isKindOfClass:theClass]){
				if([self firstClass:highestClass two:theClass] == theClass){
					highestClass = theClass;
					NSValue *val = [classLevels objectForKey:theClass];
					[val getValue:&level];
				}
			}
		}
	}
	if(desired >= level){
		return YES;
	}
	return NO;
}

-(Class)firstClass:(Class)one two:(Class)two{
	Class superclass = [self class];
	while(superclass != nil){
		if(superclass == one){
			return one;
		}
		if(superclass == two){
			return two;
		}
		superclass = [superclass superclass];
	}
	return one;
}

@end