//
//  BaseDataModel.h
//  ZpotDrop
//
//  Created by Son Truong on 8/3/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface BaseDataModel : NSManagedObject
@property (nonatomic, retain) NSString * mid;

-(BaseDataModel*)fetchObjectWithID:(NSString*)mid;
@end
