//
//  AccountModel.h
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface AccountModel : BaseDataModel

-(BOOL)isLoggedIn;

+(AccountModel*)currentAccountModel;
@property (nonatomic) NSString* access_token;
@property (nonatomic) NSString* user_id;

@end
