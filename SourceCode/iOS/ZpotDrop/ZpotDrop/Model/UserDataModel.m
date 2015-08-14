//
//  UserDataModel.m
//  ZpotDrop
//
//  Created by Son Truong on 8/3/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UserDataModel.h"
#import "APIService.h"

@implementation UserDataModel

@dynamic username,first_name,last_name;
@dynamic avatar,gender,birthday,email;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.username = @"";
    self.avatar = @"";
    self.first_name = @"";
    self.last_name = @"";
    self.gender = [NSNumber numberWithBool:NO];
    self.birthday = [NSDate date];
    self.email = @"";
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
@end
