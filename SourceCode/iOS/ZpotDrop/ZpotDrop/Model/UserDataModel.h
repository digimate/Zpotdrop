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

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber* gender;
@property (nonatomic, retain) NSString* hometown;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSNumber* privateProfile;
@property (nonatomic, retain) NSNumber* enableAllZpot;
-(NSString*)name;
+(id)UserFromParse:(id)data;

@end
