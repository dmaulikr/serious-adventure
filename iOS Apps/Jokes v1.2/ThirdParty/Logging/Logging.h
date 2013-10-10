/*
 *  Logging.h
 *
 */

#import "Logger.h"

#ifdef DEBUG
#define debug(format, ...) [self debug:format, __FUNCTION__, __LINE__, ## __VA_ARGS__]
#define info(format, ...) [self info:format, __FUNCTION__, __LINE__, ## __VA_ARGS__]
#define warn(format, ...) [self warn:format, __FUNCTION__, __LINE__, ## __VA_ARGS__]
#define error(format, ...) [self error:format, __FUNCTION__, __LINE__, ## __VA_ARGS__]
#define fatal(format, ...) [self fatal:format, __FUNCTION__, __LINE__, ## __VA_ARGS__]
#else
#define debug(format, ...)
#define info(format, ...)
#define warn(format, ...)
#define error(format, ...)
#define fatal(format, ...)
#endif

