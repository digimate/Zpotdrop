//
//  UserService.m
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/20/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "UserService.h"
#import <Parse/Parse.h>

@implementation UserService
- (void)getFolloweeOfUserId:(NSString *)userId
                 completion:(void (^) (NSArray *users, NSError *error))completion
{
    PFQuery* follow = [PFQuery queryWithClassName:@"Follow"];
    [follow whereKey:@"followedUser" equalTo:userId];
    [follow findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if (objects && objects.count > 0)
         {
             NSMutableArray* returnArray = [NSMutableArray array];
             for (PFObject* follow in objects) {
                 NSString* followedID = follow[@"followUser"];
                 [returnArray addObject:followedID];
             }
             [self getUserInArrayId:returnArray completion:completion];
         }
         else
         {
             completion(@[], error);
         }
     }];
}

- (void)getUserInArrayId:(NSArray *)arrId completion:(void (^) (NSArray *users, NSError *error))completion
{
    PFQuery* userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" containedIn:arrId];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         NSMutableArray* returnData = [NSMutableArray array];
         for (PFUser* user in objects) {
             UserDataModel* userModel = [self updateUserModel:user.objectId withParse:user];
             [returnData addObject:userModel];
         }
         completion(returnData, error);
     }];
}


#pragma mark -
- (UserDataModel*)updateUserModel:(NSString*)uid withParse:(PFUser*)user{
    UserDataModel* userModel = (UserDataModel*)[UserDataModel fetchObjectWithID:uid];
    userModel.email = user.email;
    userModel.username = user.username;
    userModel.first_name = user[@"firstName"];
    userModel.last_name = user[@"lastName"];
    userModel.gender = user[@"gender"];
    userModel.birthday = user[@"dob"];
    userModel.phone = user[@"phoneNumber"];
    userModel.hometown = user[@"hometown"];
    userModel.enableAllZpot = user[@"enableAllZpot"];
    userModel.privateProfile = user[@"privateProfile"];
    userModel.facebook_id = user[@"facebook_id"];
    userModel.zpot_all_time = user[@"zpot_all_time"];
    userModel.device_token = user[@"device_token"];
    userModel.latitude = user[@"latitude"];
    userModel.longitude = user[@"longitude"];
    userModel.updated_loc = user[@"updated_loc"];
    
    PFFile* avatar = user[@"avatar"];
    if (avatar) {
        [avatar getDataInBackgroundWithBlock:^(NSData* data,NSError* error){
            if (data && data.length > 0) {
                userModel.avatar = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            }
        }];
    }
    return userModel;
}
@end
