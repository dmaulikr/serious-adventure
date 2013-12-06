//
//  FBUser.h
//  FacebookIntegration
//
//  Created by Sohaib Muhammad on 03/05/2013.
//  Copyright (c) 2013 coeus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUser : NSObject<NSCoding>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* fId;
@property (strong, nonatomic) NSString* birthday;
@property (strong, nonatomic) NSString* imgUrl;

+(FBUser *)loadFBUser;
-(void)saveFBUser;

@end
