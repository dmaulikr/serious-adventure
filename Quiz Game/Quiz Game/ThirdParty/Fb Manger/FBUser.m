//
//  FBUser.m
//  FacebookIntegration
//
//  Created by Sohaib Muhammad on 03/05/2013.
//  Copyright (c) 2013 coeus. All rights reserved.
//

#import "FBUser.h"
#define EMAIL           @"email"
#define NAME            @"name"
#define FIRST_NAME      @"first_name"
#define LAST_NAME       @"last_name"
#define BIRTHDAY        @"brithday"
#define ID              @"id"
#define IMAGE_URL       @"image_url"
@implementation FBUser

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.name       = [aDecoder decodeObjectForKey:NAME];
        self.firstName  = [aDecoder decodeObjectForKey:FIRST_NAME];
        self.lastName   = [aDecoder decodeObjectForKey:LAST_NAME];
        self.imgUrl     = [aDecoder decodeObjectForKey:IMAGE_URL];
        self.fId        = [aDecoder decodeObjectForKey:ID];
        self.birthday   = [aDecoder decodeObjectForKey:BIRTHDAY];
        self.email      = [aDecoder decodeObjectForKey:EMAIL];
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:NAME];
    [aCoder encodeObject:self.firstName forKey:FIRST_NAME];
    [aCoder encodeObject:self.lastName  forKey:LAST_NAME];
    [aCoder encodeObject:self.email forKey:EMAIL];
    [aCoder encodeObject:self.birthday forKey:BIRTHDAY];
    [aCoder encodeObject:self.fId forKey:ID];
    [aCoder encodeObject:self.imgUrl forKey:IMAGE_URL];
}

+(FBUser *) loadFBUser{
    
    
    NSData *archivedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"FBUser"];
    
    if (archivedObject)
        return (FBUser *)[NSKeyedUnarchiver unarchiveObjectWithData: archivedObject];
    else{
        
        FBUser *fbUser = [FBUser new];
        return fbUser;
    }
}

-(void)saveFBUser{
    
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:@"FBUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
