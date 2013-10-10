//
//  PopperPacks.h
//  CrazyPlay
//
//  Created by Alan Trippe on 2/23/12.
//  Copyright (c) 2012 Trippin' Software. All rights reserved.
//
// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>
#import "cocos2d.h"

// Popper Packs 
@interface PopperPacks : NSObject {
}
+(id) requestLevelID:(int)pack level:(int)level;
@end