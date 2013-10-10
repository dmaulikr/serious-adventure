//
//  DebugHelper.h
//  SamoletikiPrototype
//
//  Created by Konstantin Sokolinskyi on 10/17/10.
//  Copyright 2010 SROST studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DebugHelper : NSObject
{

}

+ ( void ) dumpDictionary: ( NSDictionary* ) dict;
+ ( void ) dumpArray: ( NSArray* ) array;

+ ( void ) dumpRect: ( CGRect ) rect;
+ ( void ) dumpRect: ( CGRect ) rect withMessage: ( NSString* ) msg;

+ ( void ) logMemoryUsage;
+ ( NSString* ) memoryUsage;

@end
