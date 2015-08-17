//
//  BaseDataModel.h
//  ZpotDrop
//
//  Created by Son Truong on 8/3/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <CoreData/CoreData.h>
@class BaseDataModel;
@protocol DataModelChangedDelegate <NSObject>
@optional
-(void)updateUIForDataModel:(BaseDataModel*)model options:(NSDictionary*)params;
@end
@interface BaseDataModel : NSManagedObject
@property (nonatomic, retain) NSString * mid;

+(BaseDataModel*)fetchObjectWithID:(NSString*)mid;
+(NSArray*)fetchObjectsWithPredicate:(NSPredicate*)predicate sorts:(NSArray*)sorts;
-(void)updateObjectForUse:(void(^)())completion;
@property(nonatomic, retain)id<DataModelChangedDelegate>dataDelegate;
-(void)deleteFromDB;
@end
