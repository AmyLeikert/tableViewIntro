//
//  GCAppDelegate.m
//  Table View Intro
//
//  Created by Thomas Crawford on 11/4/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import "GCAppDelegate.h"
#import "GCMainViewController.h"

@implementation GCAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

NSString *const kModelDB = @"Table_View_Intro.sqlite";
NSString *const kModelDBWAL = @"Table_View_Intro.sqlite-wal";
NSString *const kModelDBSHM = @"Table_View_Intro.sqlite-shm";
NSString *const kModelDBResource = @"Table_View_Intro";
NSString *const kModelDBType     = @"sqlite";
NSString *const kModelDBWALType  = @"sqlite-wal";
NSString *const kModelDBSHMType  = @"sqlite-shm";

#pragma mark - Database Methods

- (NSString *) dbPath {
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	path = [[NSString pathWithComponents: [NSArray arrayWithObjects: path, kModelDB, nil]] stringByStandardizingPath];
	return path;
}

- (BOOL) doesDBExistAtPath: (NSString *) path {
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: path];
	return fileExists;
}

- (void) copyDBToPath: (NSString *) path {
	NSError *error = nil;
	NSString *dbBundlePath	= [[NSBundle mainBundle] pathForResource: kModelDBResource ofType: kModelDBType];
    NSString *dbWALBundlePath = [[NSBundle mainBundle] pathForResource: kModelDBResource ofType: kModelDBWALType];
    NSString *dbSHMBundlePath = [[NSBundle mainBundle] pathForResource: kModelDBResource ofType: kModelDBSHMType];
	if (dbBundlePath) {
		[[NSFileManager defaultManager] copyItemAtPath: dbBundlePath toPath: path error: &error];
        
        NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *destPathWAL = [[NSString pathWithComponents: [NSArray arrayWithObjects: destPath, kModelDBWAL, nil]] stringByStandardizingPath];
		[[NSFileManager defaultManager] copyItemAtPath: dbWALBundlePath toPath: destPathWAL error: &error];

        NSString *destPathSHM = [[NSString pathWithComponents: [NSArray arrayWithObjects: destPath, kModelDBSHM, nil]] stringByStandardizingPath];
		[[NSFileManager defaultManager] copyItemAtPath: dbSHMBundlePath toPath: destPathSHM error: &error];
	}
}

#pragma mark - Core Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![self doesDBExistAtPath: self.dbPath]) {
        [self copyDBToPath: self.dbPath];
    }
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    GCMainViewController *controller = (GCMainViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kModelDBResource withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kModelDB];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
