//
//  UserService.h
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/20/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDataModel.h"

@interface UserService : NSObject
- (void)getFolloweeOfUserId:(NSString *)userId
                 completion:(void (^) (NSArray *users, NSError *error))completion;
@end
