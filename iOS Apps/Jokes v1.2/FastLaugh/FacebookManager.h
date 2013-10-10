//
//  FacebookManager.h
//  StacheMash
//
//  Created by Konstantin Sokolinskyi on 1/22/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <FacebookSDK/FacebookSDK.h> //thesun comment
#import "Facebook.h" //thesun

typedef enum apiCall {
    kAPINone,
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} EFacebookAPICall;

@protocol FacebookManagerLoginDelegate <NSObject>

- (void)facebookDidLogIn;
- (void)facebookDidLogOut;
- (void)facebookDidNotLogin: (BOOL)cancelled;

@end


@protocol FacebookManagerShareDelegate <NSObject>

- (void) facebookDidShare;
- (void) facebookDidFailWithError: (NSError*)error;
- (void) facebookDidCanceled;

@end

@protocol FacebookManagerDialogDelegate <NSObject>

- (void)facebookDidSendToFriends: (NSArray*)friends;
- (void)facebookDidFailWithError: (NSError*)error;

@end

extern NSString *const MBSessionStateChangedNotification;

@interface FacebookManager : NSObject
<FBRequestDelegate,
FBDialogDelegate>

@property (assign, nonatomic, readonly) BOOL isFacebookReachable;
@property (strong, nonatomic, readonly) Facebook *facebook;

@property (assign, nonatomic) id<FacebookManagerLoginDelegate> loginDelegate;
@property (strong, nonatomic) id<FacebookManagerShareDelegate> shareDelegate;
@property (assign, nonatomic) id<FacebookManagerDialogDelegate> dialogDelegate;
//Sun - share favourite
@property (assign, nonatomic) NSString *shareTextFB;


+ (FacebookManager*)sharedInstance;

- (BOOL)isLoggedIn;
- (void)logIn;
- (void)logOut;

- (void)apiGraphUserPhotosPostWithImage: (UIImage*)image title: (NSString*)title;
- (void)apiGraphUserPhotosPostWithImage: (UIImage*)image toFriends: (NSArray*) friends title: (NSString*)title ;
- (void)apiDialogFeedUser;
- (void) performPublishAction:(void (^)(void)) action;


@end
