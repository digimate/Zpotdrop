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

@dynamic is_login;
-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.is_login = NO;
}
+(AccountModel *)currentAccountModel{
    AccountModel* account = (AccountModel*)[[CoreDataService instance]fetchFirstEntityForName:NSStringFromClass([AccountModel class]) predicate:[NSPredicate predicateWithFormat:@"mid == %@",@"zspotdrop6969"] sortDescriptors:nil];
    if (!account) {
        account = (AccountModel*)[[CoreDataService instance]createEntityForName:NSStringFromClass([AccountModel class])];
        account.mid = @"zspotdrop6969";
    }
    return account;
}
@end
