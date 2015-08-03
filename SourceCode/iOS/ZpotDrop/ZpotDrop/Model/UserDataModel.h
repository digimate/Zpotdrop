//
//  UserDataModel.h
//  ZpotDrop
//
//  Created by Son Truong on 8/3/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface UserDataModel : BaseDataModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * avatar;

@end
