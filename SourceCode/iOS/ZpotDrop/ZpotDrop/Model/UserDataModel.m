//
//  UserDataModel.m
//  ZpotDrop
//
//  Created by Son Truong on 8/3/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UserDataModel.h"
#import "APIService.h"
#import <Parse/Parse.h>

@implementation UserDataModel

@dynamic username,first_name,last_name;
@dynamic avatar,gender,birthday,email;
@dynamic hometown,phone,enableAllZpot,privateProfile;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.username = @"";
    self.avatar = @"";
    self.first_name = @"";
    self.last_name = @"";
    self.gender = [NSNumber numberWithBool:NO];
    self.birthday = [NSDate date];
    self.email = @"";
    self.hometown = @"";
    self.phone = @"";
    self.privateProfile = [NSNumber numberWithBool:YES];
    self.enableAllZpot = [NSNumber numberWithBool:YES];
}

-(void)awakeFromFetch{
    if (self.hometown == nil) {
        self.hometown = @"";
    }
    if (self.phone == nil) {
        self.phone = @"";
    }
    if (self.privateProfile == nil) {
        self.privateProfile = [NSNumber numberWithBool:YES];
    }if (self.enableAllZpot == nil) {
        self.enableAllZpot = [NSNumber numberWithBool:YES];
    }
}

-(NSString *)name{
    return [NSString stringWithFormat:@"%@ %@",self.first_name,self.last_name];
}

-(void)updateObjectForUse:(void(^)())completion{
    if (self.username == nil || self.username.length == 0) {
        [[APIService shareAPIService] updateUserModelWithID:self.mid completion:^{
            completion();
        }];
    }else{
        completion();
    }
}

+(id)UserFromParse:(id)data
{
    PFUser* user = data;
    return [[APIService shareAPIService]updateUserModel:user.objectId withParse:user];
}
@end
