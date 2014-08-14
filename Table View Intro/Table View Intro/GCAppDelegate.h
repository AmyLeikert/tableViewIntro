//
//  GCAppDelegate.h
//  Table View Intro
//
//  Created by Thomas Crawford on 11/4/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
