//
//  TMCoreDataUtil.m
//  TNCS
//
//  Created by Hoiio on 8/8/14.
//  Copyright (c) 2014 TEDMate. All rights reserved.
//

#import "CoreDataService.h"

@implementation CoreDataService
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Multi Thread Using CoreData
+ (CoreDataService *) instance {
    static CoreDataService *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[CoreDataService alloc] init];
    });
    return _sharedInstance;
}
#pragma mark - Database Read/Write Methods
/*-------------------------------------------
 Return a array of Entity in CoreData with Filter and Sorter
 @params(name) : using NSStringFromClass(class)
 -------------------------------------------*/

- (NSArray *) fetchEntitiesForName:(NSString *)name
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    [request setPredicate:predicate];
	[request setSortDescriptors:sortDescriptors];
    
	NSError *error = nil;
	NSArray *entities = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error) {
        NSLog(@"fetch %@ error : %@",name,error.localizedDescription);
        return nil;
    }
    
	return entities;
}

- (NSArray *) fetchEntitiesForName:(NSString *)name
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
               prefetchingKeyPaths:(NSArray *)keypaths {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    [request setPredicate:predicate];
	[request setSortDescriptors:sortDescriptors];
    [request setRelationshipKeyPathsForPrefetching:keypaths];
    
	NSError *error = nil;
	NSArray *entities = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error) {
        NSLog(@"fetch %@ error : %@",name,error.localizedDescription);
        return nil;
    }
    
	return entities;
}

// Fetch the first entity only
- (NSManagedObject *) fetchFirstEntityForName:(NSString *)name
                                    predicate:(NSPredicate *)predicate
                              sortDescriptors:(NSArray *)sortDescriptors {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    [request setPredicate:predicate];
	[request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:1];
    
	NSError *error = nil;
	NSArray *entities = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(error) {
        NSLog(@"fetch %@ error : %@",name,error.localizedDescription);
        return nil;
    }
    
    if([entities count] > 0)
        return [entities objectAtIndex:0];
    else
        return nil;
}

// Count the number of entities
- (NSUInteger)countEntityForName:(NSString*)name
                       predicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    
	NSError *error = nil;
	NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if(error) {
        NSLog(@"count %@ error : %@",name,error.localizedDescription);
        return 0;
    }
    
    return count;
}


- (NSUInteger)countEntityForName:(NSString*)name {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:name
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	NSError *error = nil;
	NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if(error) {
        NSLog(@"count %@ error : %@",name,error.localizedDescription);
        return 0;
    }
    
	return count;
}
/*-------------------------------------------
When create or delete a Entity in CoreData,remember call [self saveContext] to
 make a effect.
 -------------------------------------------*/
- (NSManagedObject*)createEntityForName:(NSString*)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name
										 inManagedObjectContext:self.managedObjectContext];
}

- (void)deleteEntity:(NSManagedObject*)entity {
    [entity.managedObjectContext deleteObject:entity];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
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
// Set name for Database
-(void)setDatabaseName:(NSString *)dbname{
    _dbName = dbname;
}
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (!_dbName) {
        return nil;
    }
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_dbName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"db.sqlite"];
    NSDictionary* storeOptions = @{NSMigratePersistentStoresAutomaticallyOption : [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption : [NSNumber numberWithBool:YES]};

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
