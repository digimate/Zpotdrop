//
//  BaseDataModel.m
//  ZpotDrop
//
//  Created by Son Truong on 8/3/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseDataModel.h"
#import "CoreDataService.h"

@implementation BaseDataModel
@dynamic mid;
@synthesize dataDelegate;

//fetch object with unique MID
+(BaseDataModel*)fetchObjectWithID:(NSString*)mid{
    BaseDataModel* object = (BaseDataModel*)[[CoreDataService instance] fetchFirstEntityForName:NSStringFromClass([self class]) predicate:[NSPredicate predicateWithFormat:@"mid == %@",mid] sortDescriptors:nil];
    if (object == nil) {
        object = (BaseDataModel*)[[CoreDataService instance]createEntityForName:NSStringFromClass([self class])];
        [object setMid:mid];
        [[CoreDataService instance]saveContext];
    }
    return object;
}

+(NSArray*)fetchObjectsWithPredicate:(NSPredicate*)predicate sorts:(NSArray*)sorts{
    return [[CoreDataService instance]fetchEntitiesForName:NSStringFromClass([self class]) predicate:predicate sortDescriptors:sorts];
}
-(void)updateObjectForUse:(void (^)())completion{
    completion();
}

-(void)deleteFromDB{
    [[CoreDataService instance]deleteEntity:self];
    [[CoreDataService instance]saveContext];
}
@end
