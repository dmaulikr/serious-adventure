//
//  FacebookManager.m
//  StacheMash
//
//  Created by Konstantin Sokolinskyi on 1/22/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import "FacebookManager.h"
#import "Reachability.h"
//#import "Flurry.h"
#import "SBJSON.h"
#import <Accounts/Accounts.h>
#import "DataModel.h"
//Sun
#import "AppDelegate.h"

//static NSString *kAppId = @"383103988439632";




static NSString *kAppId = FACEBOOK_APP_ID;//533119193421338;//FACEBOOK_APP_ID;//@"238923342858696";



NSString *const InsultSessionStateChangedNotification = @"com.brightnewt.insultshake:SCSessionStateChangedNotification";

@interface FacebookManager ()
{
    EFacebookAPICall _currentAPICall;
}

@property (nonatomic, strong) Reachability *hostReach;
@property (assign, nonatomic) NSInteger totalSharesToFriends;
@property (assign, nonatomic) NSInteger successSharesToFriends;


- (NSDictionary*)parseURLParams: (NSString*)query;


@end


@implementation FacebookManager

@synthesize loginDelegate = __loginDelegate;
@synthesize shareDelegate = __shareDelegate;
@synthesize facebook = __facebook;

@synthesize hostReach = _hostReach;
@synthesize successSharesToFriends = _successSharesToFriends;
@synthesize totalSharesToFriends = _totalSharesToFriend;


@dynamic isFacebookReachable;


#pragma mark - @property (assign, nonatomic, readonly) BOOL isFacebookReachable;

- (BOOL)isFacebookReachable
{
    return [self.hostReach isReachable];
}


#pragma LifyCycle

+ (FacebookManager*)sharedInstance {
    static dispatch_once_t predicate;
    static FacebookManager *sharedFacebook = nil;
    
    dispatch_once(&predicate, ^{
        sharedFacebook = [[FacebookManager alloc] init];
    });
    
    return sharedFacebook;
}


- (id)init
{
    self = [super init];
    if (self) {
        self.hostReach = [Reachability reachabilityWithHostName: @"www.facebook.com"];
        
        __facebook = [[Facebook alloc] initWithAppId:kAppId
                                         andDelegate:nil];
        
    }
    
    return self;
}

#pragma mark - Authorization

- (BOOL)isLoggedIn
{
    return FBSession.activeSession.isOpen;
}


- (void)logIn
{
    [self openSessionWithAllowLoginUI:YES];
}


- (void)logOut
{
    //[Flurry logEvent: @"LogOutFacebook"];
    [FBSession.activeSession close];
}


- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
    
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    
    switch (state) {
        case FBSessionStateOpen: {
            if (!error){
                [FBSession setActiveSession:session];
                
                FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
                [cacheDescriptor prefetchAndCacheForSession:session];
                
                
                // Store the Facebook session information
                //SUN fix
                //self.facebook.accessToken = FBSession.activeSession.accessToken;
                //self.facebook.expirationDate = FBSession.activeSession.expirationDate;
                self.facebook.accessToken = [FBSession.activeSession accessTokenData].accessToken;
                self.facebook.expirationDate = [FBSession.activeSession accessTokenData].expirationDate;
                [self.loginDelegate facebookDidLogIn];
                
                debug(@"Facebook session state: FBSessionStateOpen");
            }
        }
            break;
        case FBSessionStateCreatedTokenLoaded: {
            debug(@"Facebook session state: FBSessionStateCreatedTokenLoaded");
            //    [self.loginDelegate facebookDidLogIn];
            
        }
            break;
        case FBSessionStateOpenTokenExtended:{
            debug(@"Facebook session state: FBSessionStateOpenTokenExtended");
            //      [self.loginDelegate facebookDidLogIn];
            
        }
            break;
        case FBSessionStateClosed: {
            debug(@"Facebook session state: FBSessionStateClosed");
            [FBSession.activeSession closeAndClearTokenInformation];
            [self.loginDelegate facebookDidLogOut];
        }
            break;
            
            
        case FBSessionStateClosedLoginFailed: {
            [FBSession.activeSession closeAndClearTokenInformation];
            error(@"did NOT login. cancelled: %@", error);
            
            [self.loginDelegate facebookDidNotLogin: NO];
        }
            break;
        default:
            break;
    }
    
    //thesun
    //org
    //[[NSNotificationCenter defaultCenter] postNotificationName:MBSessionStateChangedNotification object:session];
    //--fixed
    [[NSNotificationCenter defaultCenter] postNotificationName:InsultSessionStateChangedNotification
                                                        object:session];
    
    
    
    if (error) {
        debug(@"error %@", error);
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Warning", @"Warning")
        //                                                        message: NSLocalizedString(@"Your Facebook session has expired.", @"Your Facebook session has expired.")
        //                                                       delegate: nil
        //                                              cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
        //                                              otherButtonTitles: nil, nil];
        //        [alertView show];
    }
}


// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    //[DataModel sharedInstance].shouldShowInterstitial = NO;
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        //Sun fix warning https://developers.facebook.com/docs/tutorial/iossdk/upgrading-from-3.1-to-3.2/
        //        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
        //                                                   defaultAudience:FBSessionDefaultAudienceFriends
        //                                                 completionHandler:^(FBSession *session, NSError *error) {
        //                                                     if (!error) {
        //                                                         action();
        //                                                     }
        //                                                     else
        //                                                         [self.shareDelegate facebookDidCanceled];
        //                                                 }];
        
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                else
                                                    [self.shareDelegate facebookDidCanceled];
                                            }];
    } else {
        action();
    }
    
}


// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishStreamAction:(void (^)(void)) action {
    //[DataModel sharedInstance].shouldShowInterstitial = NO;
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        //Sun fix warning https://developers.facebook.com/docs/tutorial/iossdk/upgrading-from-3.1-to-3.2/
        
        //        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
        //                                                   defaultAudience:FBSessionDefaultAudienceFriends
        //                                                 completionHandler:^(FBSession *session, NSError *error) {
        //                                                     if (!error) {
        //                                                         action();
        //                                                     }
        //                                                     else{
        //                                                         [self.shareDelegate facebookDidCanceled];
        //                                                     }
        //                                                     //For this example, ignore errors (such as if user cancels).
        //                                                 }];
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                else{
                                                    [self.shareDelegate facebookDidCanceled];
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}


/*
 * Graph API: Upload a photo. By default, when using me/photos the photo is uploaded
 * to the application album which is automatically created if it does not exist.
 */
- (void)apiGraphUserPhotosPostWithImage: (UIImage*)image title: (NSString*)title;
{
    if ( nil == image ) {
        error(@"nil img supplied");
    }
    
    if ( nil == title ) {
        title = @"";
    }
    
    debug(@"posting pic to user's photos");
    
    
    [self performPublishAction:^{
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       UIImagePNGRepresentation(image), @"source",
                                       title, @"message",
                                       nil];
        
        
        [FBRequestConnection startWithGraphPath:@"me/photos"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error)
         {
             if (error)
             {
                 debug(@"Photo uploaded unsuccessfully.");
                 [self.shareDelegate facebookDidFailWithError: error];
             }
             else
             {
                 debug(@"Photo uploaded successfully.");
                 [self.shareDelegate facebookDidShare];
                 
             }
             
         }];
        
    }];
    
    
}


- (void)apiGraphUserPhotosPostWithImage: (UIImage*)image toFriends: (NSArray*) friends title: (NSString*)title {
    [self performPublishStreamAction:^{
        for (id<FBGraphUser> user in friends) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           UIImagePNGRepresentation(image), @"source",
                                           title, @"message",
                                           nil];
            self.totalSharesToFriends = 0;
            self.successSharesToFriends = 0;
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/photos",user.id]
                                         parameters:params HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error)
             {
                 if (error)
                 {
                     debug(@"Photo friend uploaded unsuccessfully.");
                     self.totalSharesToFriends ++;
                     if (self.totalSharesToFriends == [friends count]){
                         if (self.successSharesToFriends > 0)
                             [self.shareDelegate facebookDidShare];
                         else
                             [self.shareDelegate facebookDidFailWithError: error];
                     }
                     
                 }
                 else
                 {
                     debug(@"Photo friend uploaded successfully.");
                     self.totalSharesToFriends++;
                     self.successSharesToFriends++;
                     if (self.totalSharesToFriends == [friends count])
                         [self.shareDelegate facebookDidShare];
                     
                 }
                 
             }];
        }
    }];
    
}




/**
 * --------------------------------------------------------------------------
 * News Feed
 * --------------------------------------------------------------------------
 */

/*
 * Dialog: Feed for the user
 */


- (void)apiDialogFeedUser
{
    [self performPublishAction:^{
        
        // ACTION LINKS are not properly working with FB SDK 3.1.1
        //        SBJSON *jsonWriter = [[SBJSON alloc] init];
        //        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: @"http://google.com",@"link", nil], nil];
        //        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
        NSMutableDictionary *postParams =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         @"https://www.facebook.com/brightnewt", @"link",
         @"http://brightnewt.com/wp-content/uploads/2013/08/1024.png", @"picture",
         NSLocalizedString(@"Check out the stupid jokes and puns in this app.", @"Facebook Wall post action item"), @"name",
         NSLocalizedString(@"Best Stupid Jokes and Puns Free", @"Facebook Wall post caption"), @"caption",
         NSLocalizedString(self.shareTextFB, @"Facebook Wall post descritpion"), @"description",
         // actionLinksStr, @"actions",
         nil];
        
        [FBRequestConnection
         startWithGraphPath:@"me/feed"
         parameters: postParams
         HTTPMethod:@"POST"
         completionHandler:^(FBRequestConnection *connection,
                             id result,
                             NSError *error) {
             if (error) {
                 debug(@"posted to users feed FAILED");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error alert")
                                                                     message:error.localizedDescription
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
             } else {
                 debug(@"posted to users feed OK");
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Shared successfully", @"successfully susscess alert title")
                                                                     message: NSLocalizedString(@"Thanks for sharing!", @"Thanks for sharing dialog -  alert text")
                                                                    delegate: nil
                                                           cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
                                                           otherButtonTitles: nil];
                 [alertView show];
             }
             
         }];
    }];
    
}



#pragma mark - Private

/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary*)parseURLParams: (NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	for ( NSString *pair in pairs ) {
		NSArray *kv = [pair componentsSeparatedByString: @"="];
		NSString *val = [[kv objectAtIndex: 1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
		[params setObject: val forKey: [kv objectAtIndex: 0]];
	}
    return params;
}


#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
    if (![url query]) {
        error(@"User canceled dialog or there was an error");
        return;
    }
    
    NSDictionary *params = [self parseURLParams: [url query]];
    
    switch (_currentAPICall) {
            
        case kDialogRequestsSendToMany:
        {
            NSMutableArray *invitedUsers = [[NSMutableArray alloc] init];
            for (NSString *paramKey in params) {
                
                if ([paramKey hasPrefix:@"to"]) {
                    [invitedUsers addObject:[params objectForKey:paramKey]];
                }
            }
            [self.dialogDelegate facebookDidSendToFriends: invitedUsers];
            break;
        }
            
        case kDialogRequestsSendToSelect:
        case kDialogRequestsSendToTarget:
        {
            // Successful requests return one or more request_ids.
            // Get any request IDs, will be in the URL in the form
            // request_ids[0]=1001316103543&request_ids[1]=10100303657380180
            NSMutableArray *requestIDs = [[NSMutableArray alloc] init];
            for (NSString *paramKey in params) {
                if ([paramKey hasPrefix:@"request_ids"]) {
                    [requestIDs addObject:[params objectForKey:paramKey]];
                }
            }
            if ([requestIDs count] > 0) {
                debug(@"request to friends sent OK");
                debug(@"Request ID(s): %@", requestIDs);
            }
            break;
        }
        default:
            error(@"unsupported _currentAPICall: %d", _currentAPICall);
            break;
    }
    
    debug(@"dialog complete with url: %@", url);
}


- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    debug(@"Dialog dismissed.");
}


- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    //   error(@"Error message: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Facebook Error", @"error alert title")
                                                    message: NSLocalizedString(@"Oops... something went haywire. Try it again", @"Facebook failed to open dialog - error alert text")
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
                                          otherButtonTitles: nil];
    [alert show];
}

/**
 * Called when the user granted additional permissions.
 */
- (void)userDidGrantPermission
{
    error(@"Extended permissions DID grant.");
}

/**
 * Called when the user canceled the authorization dialog.
 */
- (void)userDidNotGrantPermission
{
    error(@"Extended permissions NOT granted.");
}


#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    debug(@"received response");
}


/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request: (FBRequest*)request didLoad: (id)result
{
    debug(@"request: %@ didLoad result: %@", request, result);
    
    if ( [result isKindOfClass: [NSArray class]] && ([result count] > 0) ) {
        result = [result objectAtIndex: 0];
    }
    
    switch (_currentAPICall) {
        case kAPIGraphUserPhotosPost:
        {
            debug(@"Photo uploaded successfully.");
            [self.shareDelegate facebookDidShare];
            break;
        }
        default:
            error(@"unsupported _currentAPICall: %d", _currentAPICall);
            break;
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    error(@"Error: %@ with code: %d", [error localizedDescription], [error code]);
    
    switch (_currentAPICall) {
        case kAPIGraphUserPhotosPost:
        {
            debug(@"Photo uploaded successfully.");
            [self.shareDelegate facebookDidFailWithError: error];
            break;
        }
        default:
            error(@"unsupported _currentAPICall: %d", _currentAPICall);
            break;
    }
}


@end
