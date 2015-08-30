//
//  AccountModel.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "AccountModel.h"
#import "CoreDataService.h"

@implementation AccountModel

@dynamic access_token;
@dynamic user_id;
@dynamic follower_ids,following_ids;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.access_token = @"";
    self.user_id = @"";
    self.following_ids = @"";
    self.follower_ids = @"";
}

-(BOOL)isLoggedIn{
    if (self.access_token.length > 0) {
        return YES;
    }
    return NO;
}

+(AccountModel *)currentAccountModel{
    AccountModel* account = (AccountModel*)[[CoreDataService instance]fetchFirstEntityForName:NSStringFromClass([AccountModel class]) predicate:[NSPredicate predicateWithFormat:@"mid == %@",@"zspotdrop6969"] sortDescriptors:nil];
    if (!account) {
        account = (AccountModel*)[[CoreDataService instance]createEntityForName:NSStringFromClass([AccountModel class])];
        account.mid = @"zspotdrop6969";
    }
    return account;
}

-(void)deleteFromDB{
    [self awakeFromInsert];
}
@end
