//
//  RTAppDelegate.h
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MainMenuViewController;

@interface RTAppDelegate : UIResponder <UIApplicationDelegate> {
    
@private
    SharedDataManager *sharedDataManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainMenuViewController *mainMenuViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
