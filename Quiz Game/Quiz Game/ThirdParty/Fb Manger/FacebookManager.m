//
//  FacebookManager.m
//  FacebookIntegration
//
//  Created by Sohaib Muhammad on 03/05/2013.
//  Copyright (c) 2013 coeus. All rights reserved.

//  Add the Facebook SDK for iOS Framework by dragging the FacebookSDK.framework folder from the SDK installation folder into the Frameworks section of your Project Navigator.
//  Add the Facebook SDK for iOS resource bundle by dragging the FacebookSDKResources.bundle file from the FacebookSDK.framework/Resources folder into the Frameworks section of your Project Navigator.
//  The SDK relies on five other frameworks and libraries (AdSupport, Accounts, libsqlite3, Security and Social) to use the Facebook features built into iOS6.
//  And if u want to support ios5 than make the above frameworks optional
//  Remember:  handleOpenURL method must be implemented in AppDelegate
#import "FacebookManager.h"
#import "FBUser.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FBPermssionConstants.h"
#import <CoreLocation/CoreLocation.h>
    //#import "LocationManager.h"

@interface FacebookManager() <FBFriendPickerDelegate,FBPlacePickerDelegate,UIApplicationDelegate>

@property (strong, nonatomic) FBUser* user;
@property (strong, nonatomic) NSArray *permissions;
@property (strong, nonatomic) NSMutableArray *likePages;
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) FBRequest *request;
@property (strong, nonatomic) FBAppCall *fbAppCall;
@property (strong, nonatomic) FBRequestConnection *connection;
@property (strong, nonatomic) FBFriendPickerViewController *friendPicker;
@property (strong, nonatomic) NSMutableArray *selectedFriends;
@property (strong, nonatomic) NSMutableArray *selectedPlaceIds;
@property (copy) FbFriendPickerViewCompletionHandler friendPickerHandler;
@property (copy) OpenSessionCompletionHandler openSessionHandler;



// 
//@property (strong, nonatomic) LocationManager *locationManager;
//@property (assign) CLLocationCoordinate2D coordinate;

@end
static FacebookManager *instance = nil;
@implementation FacebookManager

-(id) init{
    
    NSAssert(instance, @"There can only be one FacebookManager instance");
    NSAssert(!instance, @"There can only be one FacebookManager instance");
    
    return nil;
}
-(id) initSharedInstance{
    
    self    = [super init];
    if (self) {
        
    }
    return self;
}


+(FacebookManager *)sharedFacebookManager{
    
          if (!instance) {
        
        instance = [[FacebookManager alloc] initSharedInstance];
    }
    return instance;
}


-(void)permissions:(NSArray *)permissions{
    
    if (!self.permissions) {
        
        self.permissions = [[NSArray alloc] initWithArray:permissions];
    }
}

-(void)createRequestWithGraphPath:(NSString *)graphPath andDictionary:(NSDictionary *)dictionary andHTTPMethod:(NSString *) HTTPmethod{
    
    if (self.session != nil && self.request == nil) {
        
        self.request = [[FBRequest alloc] initWithSession:self.session graphPath:graphPath parameters:dictionary HTTPMethod:HTTPmethod];
        
    }else if(self.session == nil) {
        
        NSAssert(!self.session, @"create session first");
    }
}

-(void)createRequestWithGraphPath:(NSString *)graphPath{
    
    if (self.session != nil && self.request == nil) {
        
        self.request = [[FBRequest alloc] initWithSession:self.session graphPath:graphPath];
        
    }else if(self.session == nil) {
        
        NSAssert(!self.session, @"create session first");
    }
}

-(void)createRequestConnection{
    
    if (self.session != nil && self.connection == nil) {
        
        self.connection = [[FBRequestConnection alloc] initWithTimeout:100];
        
    }else if(self.session == nil) {
        
        NSAssert(!self.session, @"create session first");
    }
    
}

-(void)createSessionWithPermissions{
    
    if (self.session == nil && self.permissions == nil) {
        // open session with default permissions
        self.session = [[FBSession alloc] init];
  
        
        
    }else if(self.session == nil && self.permissions != nil) {
        // open session with given permissions
        self.session = [[FBSession alloc] initWithPermissions:self.permissions];
 
           }
    
}
-(void)openSessionWithCompletionHandler:(OpenSessionCompletionHandler)handler{
    
    
    if ([self isSessionOpen]) {
        handler(nil);
    }
    else{
        [self createSessionWithPermissions];
        
        self.openSessionHandler = handler;  // assign handler
        
        if (self.session != nil) {
            [self.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                
                
                
                [self sessionStateChanged:session state:status error:error];
                
            }];
        }
    }
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
            
    
            
        case FBSessionStateOpen:
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateCreated:
            break;
        case FBSessionStateCreatedOpening:
            break;
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
    
    if (error) {
          NSLog(@"Error ====== %@",error.description);
    }
    else
        self.openSessionHandler(nil);
}
-(void)closeSession{
    
    if ([self isSessionOpen]) {
        [self.session closeAndClearTokenInformation];
    }

}

-(BOOL)isSessionOpen{
    BOOL result = NO;
    if (self.session.isOpen) {
        result = YES;
    }
    
    return result;
}

-(BOOL)handleOpenURL:(NSURL *)url{
    
    BOOL result = NO;
    if (self.session != nil) {
        
        result =[self.session handleOpenURL:url];
    }else{
        NSAssert(!self.session, @"create session first");
    }
    
    return result;
    
}

-(void)setNilToObjects{
    
    self.request = nil;
    self.connection =nil;
}


- (void)setLikePagesArray:(NSDictionary *)likes {
    
//      __weak typeof(self) weakSelf = self;
//    [likesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//     
//        NSDictionary *dict = (NSDictionary *)obj;
//        [weakSelf.likePages addObject:[dict objectForKey:@"id"]];
//    
//        
//    }];
      NSArray *likesArray = [likes objectForKey:@"data"];
    for (int start = 0; start<likesArray.count; start++) {
         NSDictionary *dict = (NSDictionary *) [likesArray objectAtIndex:start];
        [self.likePages addObject:[dict objectForKey:@"id"]];
    }

}

-(void)getUserLikesWithCompletionHandler:(FbUserLikesWithCompletionHandler) handler{
    
    __weak typeof(self) weakSelf = self;
    
    if ([self isSessionOpen]) {
        
        if (!self.likePages ) {
            self.likePages  = [[NSMutableArray alloc] init];
        }
        
        [self setNilToObjects];
        [self createRequestWithGraphPath:@"me/likes"];
        [self createRequestConnection];
        
        if (self.connection != nil &&  self.request != nil) {
            [self.connection addRequest:self.request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                NSDictionary *likes = (NSDictionary *)result;
                [weakSelf setLikePagesArray:likes];
                NSLog(@"%@",likes);
                if (!error) {
                   handler(weakSelf.likePages,nil);
                }
                else
                    NSLog(@"Error ====== %@",error.description);
                handler(nil, error);
            }];
            
            [self.connection start];
        }
    }
}



// https://developers.facebook.com/docs/reference/api/page/#photos

-(void)shareOnFacebookPageWithPageId: (NSString *)pageId andParameters:(NSDictionary *)dictionary WithCompletionHandler:(PostOnFacebookCompletionHandler)handler{
    
    if ([self isSessionOpen]) {
        [self setNilToObjects];
        [self createRequestWithGraphPath:@"276335264932/feed" andDictionary:dictionary andHTTPMethod:@"POST"];
        [self createRequestConnection];
        
        if (self.connection != nil &&  self.request != nil) {
            [self.connection addRequest:self.request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
               // NSLog(@"%@",result);
                if (!error) {
                    handler(nil);
                }
                else
                    NSLog(@"Error ====== %@",error.description);
                handler( error);
            }];
            
            [self.connection start];
        }
    }
}



#pragma mark -
#pragma mark - FB get user details method
- (void)populateUserDetailsWithCompletionHandler:(GetUserDetailsCompletionHandler)handler
{

    __weak typeof(self) weakSelf = self;
    
    if (!self.user) {
        _user= [[FBUser alloc] init];
        
    }
    if ([self isSessionOpen]) {
        [self setNilToObjects];
        [self createRequestWithGraphPath:@"me" andDictionary:nil andHTTPMethod:@"GET"];
        [self createRequestConnection];
        
        if (self.connection != nil &&  self.request != nil) {
            
            [self.connection addRequest:self.request completionHandler:^(FBRequestConnection *connection, NSDictionary <FBGraphUser> *user, NSError *error) {
                
                if (!error) {
                    
                    weakSelf.user.name         = user.name;
                    weakSelf.user.fId          = user.id;
                    weakSelf.user.firstName    = user.first_name;
                    weakSelf.user.lastName     = user.last_name;
                    weakSelf.user.birthday     = user.birthday;
                    weakSelf.user.imgUrl       = [weakSelf profilePicture];
                    weakSelf.user.email        = [user objectForKey:@"email"];
                    weakSelf.user.userName     = user.username;
                    handler(weakSelf.user, nil);
                    
                    FBUser *fb = [FBUser loadFBUser];
                    [fb saveFBUser];
                    
                }else{
                    
                    NSLog(@"Error ====== %@",error.description);
                    handler(nil, error);
                }
                
                
            }];
            
            [self.connection start];
        }
    }
}

-(NSString *)profilePicture{
    
    NSString *imgUrl = nil;
    
    imgUrl  = [NSString stringWithFormat:@ "http://graph.facebook.com/%@/picture",self.user.fId];
    
    return imgUrl;
    
}

#pragma mark -
#pragma mark - FB update status with different ways

-(void)postOnFacebookStatus:(NSString *)status WithCompletionHandler:(PostOnFacebookCompletionHandler)handler{
    
    
    NSDictionary *dictionary =[ [NSDictionary alloc] initWithObjectsAndKeys:status,@"message", nil];
    
    if ([self isSessionOpen]) {
        [self setNilToObjects];
        [self createRequestWithGraphPath:@"me/feed" andDictionary:dictionary andHTTPMethod:@"POST"];
        [self createRequestConnection];
        
        if (self.connection != nil &&  self.request != nil) {
            [self.connection addRequest:self.request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                if (!error) {
                    handler(nil);
                }
                else{
                    NSLog(@"Error ====== %@",error.description);
                handler( error);
                }
            }];
            
            [self.connection start];
        }
    }
}

-(void)postOnFacebookWithParameters:(NSDictionary *)dictionary WithCompletionHandler:(PostOnFacebookCompletionHandler)handler{
    
    if ([self isSessionOpen]) {
        [self setNilToObjects];
        [self createRequestWithGraphPath:@"me/feed" andDictionary:dictionary andHTTPMethod:@"POST"];
        [self createRequestConnection];
        
        if (self.connection != nil &&  self.request != nil) {
            [self.connection addRequest:self.request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                if (!error) {
                    handler(nil);
                }
                else{
                    NSLog(@"Error ====== %@",error.description);
                handler( error);
                }
            }];
            
            [self.connection start];
            
        }
        
    }
}

#pragma mark -
#pragma mark - FB sharing image only

-(void)postOnFacebookImage:(UIImage *)image WithCompletionHandler:(PostOnFacebookCompletionHandler) handler{
    
    NSDictionary *dictionary =[ [NSDictionary alloc] initWithObjectsAndKeys:image,@"picture", nil];
    
    if ([self isSessionOpen]) {
        [self setNilToObjects];
        [self createRequestWithGraphPath:@"me/photos" andDictionary:dictionary andHTTPMethod:@"POST"];
        [self createRequestConnection];
        
        if (self.connection != nil &&  self.request != nil) {
            [self.connection addRequest:self.request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                if (!error) {
                    handler(nil);
                }
                else{
                    NSLog(@"Error ====== %@",error.description);
                handler( error);
                }
            }];
            
            [self.connection start];
            
        }
        
    }
}



#pragma mark -
#pragma mark - FB dialog opening

// read this link before sharing on fbDialogs
// https://developers.facebook.com/ios/share-dialog/

-(void)openFacebookDialogWithUrl:(NSURL *)url andCompletionHandler:(FbDialogCompletionHandler)handler{
    
    
    [FBDialogs presentShareDialogWithLink:url
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          handler(nil,error);
                                      } else {
                                          handler(results,nil);
                                      }
                                  }];
    
    
}

//
//#pragma mark - 
//#pragma mark - FB Tag friends in status
//
//
//-(void)getCurrentCoordinate{
//    
//    self.locationManager = [LocationManager sharedLocationManager];
//    [self.locationManager startUpdatingLocaitonWithCompletionHandler:^(LocationUpdateStatus status, NSError *error) {
//        
//        self.coordinate = [self.locationManager currentCoordinate];
//        [self getPlaceIds];
//    }];
//    
//}
//
//- (void)setPlaceIdsArray:(NSDictionary *)pageIds {
//    
//    NSArray *pageIdsArray = [pageIds objectForKey:@"data"];
//    for (int start = 0; start<pageIdsArray.count; start++) {
//        NSDictionary *dict = (NSDictionary *) [pageIdsArray objectAtIndex:start];
//        [self.selectedPlaceIds addObject:[NSString stringWithFormat:@"%@",dict[@"page_id"]]];
//    }
//    
//}
////https://developers.facebook.com/tools/explorer?method=GET&path=1731101747%3Ffields%3Did%2Cname
//-(void) getPlaceIds{
//    
//    __weak typeof(self) weakSelf = self;
//    NSString *query = [NSString stringWithFormat:
//                       @"SELECT page_id "
//                       @"FROM place "
//                       @"WHERE is_city and distance(latitude, longitude, \"%f\", \"%f\") < 100000 " ,
//                       self.coordinate.latitude,self.coordinate.longitude
//                       ];
//    
//    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
//    
//    if ([self isSessionOpen]) {
//        [self setNilToObjects];
//        [self createRequestWithGraphPath:@"/fql" andDictionary:queryParam andHTTPMethod:@"GET"];
//        [self createRequestConnection];
//        
//        if (self.connection != nil &&  self.request != nil) {
//            [self.connection addRequest:self.request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                
//                if (!error) {
//                    
//                    if (result) {
//                        NSDictionary *places = (NSDictionary *)result;
//                        [weakSelf setPlaceIdsArray:places];
//                    }
//                }
//                else
//                    NSLog(@"Error ====== %@",error.description);
//                
//            }];
//            
//            [self.connection start];
//        }
//    }
//    
//}

#pragma mark -
#pragma mark - FBFriendPickerViewController

-(UIViewController *)openFriendPickerViewControllerWithTitle:(NSString *)title andCompletionHandler:(FbFriendPickerViewCompletionHandler) handler{
    
       
    if (!self.friendPicker) {
        
        self.friendPicker = [[FBFriendPickerViewController alloc] init];
    }
    
    if (!self.selectedFriends) {
        self.selectedFriends = [[NSMutableArray alloc] init];
    }
    
    if ([self isSessionOpen]) {
        
        [self.friendPicker setSession:self.session];
        self.friendPicker.delegate = self;
        [self.friendPicker setTitle:title];
        [self.friendPicker loadData];
       // self.friendPicker.cancelButton
       // self.friendPicker.doneButton
        
        
        self.friendPickerHandler = handler;
    }

    return self.friendPicker;

}

- (void)facebookViewControllerCancelWasPressed:(id)sender{
    [self.selectedFriends removeAllObjects];
    [self.friendPicker dismissModalViewControllerAnimated:YES];
}
- (void)facebookViewControllerDoneWasPressed:(id)sender{
    [self.friendPicker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - FBFriendPickerDelegate

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker{
    
    if (self.selectedFriends) {
        
        [self.selectedFriends removeAllObjects];
        [self.selectedFriends addObjectsFromArray:friendPicker.selection];
    }
    
}

- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error{
    
    self.friendPickerHandler (error);
}






@end


