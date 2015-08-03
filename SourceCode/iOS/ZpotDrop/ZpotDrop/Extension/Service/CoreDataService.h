//
//  TMCoreDataUtil.h
//  TNCS
//
//  Created by Hoiio on 8/8/14.
//  Copyright (c) 2014 TEDMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataService : NSObject{
    NSString* _dbName;
}
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setDatabaseName:(NSString*)dbname;
- (void)deleteEntity:(NSManagedObject*)entity;
- (NSManagedObject*)createEntityForName:(NSString*)name;
- (NSUInteger)countEntityForName:(NSString*)name;
- (NSUInteger)countEntityForName:(NSString*)name
                       predicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors;
- (NSManagedObject *) fetchFirstEntityForName:(NSString *)name
                                    predicate:(NSPredicate *)predicate
                              sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *) fetchEntitiesForName:(NSString *)name
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
               prefetchingKeyPaths:(NSArray *)keypaths;
- (NSArray *) fetchEntitiesForName:(NSString *)name
                         predicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors;
// Create a new instance for global access
+ (CoreDataService *) instance;
@end
