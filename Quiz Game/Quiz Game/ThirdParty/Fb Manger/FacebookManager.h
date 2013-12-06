//
//  FacebookManager.h
//  FacebookIntegration
//
//  Created by Sohaib Muhammad on 03/05/2013.
//  Copyright (c) 2013 coeus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  FBUser;

typedef void(^GetUserDetailsCompletionHandler)(FBUser* user, NSError* error);
typedef void(^FbUserLikesWithCompletionHandler)(NSArray* userLikes, NSError* error);
typedef void(^PostOnFacebookCompletionHandler)(NSError* error);
typedef void(^OpenSessionCompletionHandler) (NSError* error);
typedef void(^FbDialogCompletionHandler) (NSDictionary* result, NSError* error);
typedef void(^FbFriendPickerViewCompletionHandler) (NSError *error);

@interface FacebookManager : NSObject

// set Permissions

-(void)permissions:(NSArray*)permissions;


//if permissions are not set then create session with default option otherwise create session with given permissions

-(void)openSessionWithCompletionHandler:(OpenSessionCompletionHandler)handler;


// close Session

-(void)closeSession;


// get user details

-(void)populateUserDetailsWithCompletionHandler:(GetUserDetailsCompletionHandler)handler;


// post status on facebook only

-(void)postOnFacebookStatus:(NSString *)status WithCompletionHandler:(PostOnFacebookCompletionHandler)handler;


// upload image on facebook only

-(void)postOnFacebookImage:(UIImage *)image WithCompletionHandler:(PostOnFacebookCompletionHandler)handler;

// Example of the dictionary
//NSDictionary* dict = @{
//                            @"link" : @"https://developers.facebook.com/ios",
//                            @"message":@"Your temp message here",
//                            @"name" : @"MyApp",
//                            @"caption" : @"TestPost",
//                            @"description" : @"Integrating Facebook in ios",
//
//};


-(void)postOnFacebookWithParameters:(NSDictionary *)parameters WithCompletionHandler:(PostOnFacebookCompletionHandler)handler;

// choose friends 

-(UIViewController *)openFriendPickerViewControllerWithTitle:(NSString *)title andCompletionHandler:(FbFriendPickerViewCompletionHandler) handler;


// get User like Pages

-(void)getUserLikesWithCompletionHandler:(FbUserLikesWithCompletionHandler) handler;

// facebook Dialog 
-(void)openFacebookDialogWithUrl:(NSURL *)url andCompletionHandler:(FbDialogCompletionHandler)handler;


-(void)shareOnFacebookPageWithPageId: (NSString *)pageId andParameters:(NSDictionary *)dictionary WithCompletionHandler:(PostOnFacebookCompletionHandler)handler;

+(FacebookManager *)sharedFacebookManager;

-(BOOL)handleOpenURL:(NSURL *)url;

//https://developers.facebook.com/blog/post/2011/08/04/how-to--use-the-graph-api-to-upload-a-video--ios/

@end
