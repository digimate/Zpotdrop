//
//  APIService.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "APIService.h"
#import "UserDataModel.h"
#import "CoreDataService.h"
#import "LocationDataModel.h"
#import "NotificationModel.h"
@implementation APIService

+(APIService*)shareAPIService
{
    static APIService *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}
#pragma mark - Location
-(void)addressFromLocationCoordinate:(CLLocationCoordinate2D)coor completion:(void(^)(NSString* address))completion{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString* strAPI = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%lf,%lf&sensor=false&language=%@",coor.latitude,coor.longitude,language];
    NSURL *url = [NSURL URLWithString:strAPI];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray* result = [responseObject objectForKey:@"results"];
            if (result.count > 0) {
                NSDictionary* dict = [result firstObject];
                completion([dict objectForKey:@"formatted_address"]);
                return;
            }
        }
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil);
    }];
    
    // 5
    [operation start];
}
-(void)createLocationWithCoordinate:(CLLocationCoordinate2D)coor params:(NSMutableDictionary*)params completion:(void(^)(id data,NSString* error))completion{
    PFObject* location = [PFObject objectWithClassName:@"Location"];
    location[@"latitude"] = [NSNumber numberWithDouble:coor.latitude];
    location[@"longitude"] = [NSNumber numberWithDouble:coor.longitude];
    location[@"name"] = [params objectForKey:@"name"];
    location[@"address"] = [params objectForKey:@"address"];
    [location saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:location.objectId];
            model.name = location[@"name"];
            model.address = location[@"address"];
            model.latitude = location[@"latitude"];
            model.longitude = location[@"longitude"];
            completion(model,nil);
        }else{
            completion(nil,error.description);
        }
    }];
}

-(void)searchLocationWithName:(NSString*)name withinCoord:(CLLocationCoordinate2D)topLeft coor2:(CLLocationCoordinate2D)botRight completion:(void(^)(NSArray * data,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Location" predicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH %@ AND %@ <= latitude AND latitude <= %@ AND %@ <= longitude AND longitude <= %@",name,[NSNumber numberWithDouble:botRight.latitude],[NSNumber numberWithDouble:topLeft.latitude],[NSNumber numberWithDouble:topLeft.longitude],[NSNumber numberWithDouble:botRight.longitude]]];
    [query setLimit:API_PAGE];
    [query findObjectsInBackgroundWithBlock:^(NSArray * data,NSError* error){
        for (PFObject* location in data) {
            LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:location.objectId];
            model.name = location[@"name"];
            model.address = location[@"address"];
            model.latitude = location[@"latitude"];
            model.longitude = location[@"longitude"];
        }
        completion(data,error.description);
    }];
}

-(void)scanAreaForUserID:(NSString*)userID topLeftCoord:(CLLocationCoordinate2D)topLeft botRightCoord:(CLLocationCoordinate2D)botRight completion:(void(^)(NSArray * data,NSString* error))completion{

    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"latitude" greaterThanOrEqualTo:[NSNumber numberWithDouble:botRight.latitude]];
    [query whereKey:@"latitude" lessThanOrEqualTo:[NSNumber numberWithDouble:topLeft.latitude]];
    [query whereKey:@"longitude" greaterThanOrEqualTo:[NSNumber numberWithDouble:topLeft.longitude]];
    [query whereKey:@"longitude" lessThanOrEqualTo:[NSNumber numberWithDouble:botRight.longitude]];
    [query whereKey:@"user_id" notEqualTo:userID];
    //NSDate* date = [NSDate dateWithTimeIntervalSinceNow:-(60*60)];
    //[query whereKey:@"createdAt" greaterThanOrEqualTo:date];
    //shoud query User table to find Friend Location
    [query setLimit:API_PAGE];
    [query findObjectsInBackgroundWithBlock:^(NSArray * data,NSError* error){
        if (data) {
            NSMutableArray* returnArray = [NSMutableArray array];
            for (PFObject* feedParse in data) {
                FeedDataModel* feedModel = [self updateFeedFromParse:feedParse];
                [returnArray addObject:feedModel];
            }
            completion(returnArray,nil);
        }else{
            completion([NSMutableArray array],error.description);
        }
    }];
}
//send request to get Current Location of this user
-(void)requestLocationOfUserID:(NSString*)friendID completion:(void(^)(BOOL successful,NSString* error))completion{
    
}

//
-(LocationDataModel*)locationModelFromParse:(PFObject*)location{
    LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:location.objectId];
    model.name = location[@"name"];
    model.address = location[@"address"];
    model.latitude = location[@"latitude"];
    model.longitude = location[@"longitude"];
    return model;
}

#pragma mark - POST
-(void)getFeedWithID:(NSString*)fid completion:(void(^)(BOOL successful,NSString* error))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo: fid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            [self updateFeedFromParse:objects.lastObject];
            completion(YES,nil);
        }else{
            completion(NO,error.description);
        }
    }];
}
-(void)postZpotWithCoordinate:(CLLocationCoordinate2D)coor params:(NSMutableDictionary*)params completion:(void(^)(id data,NSString* error))completion{
    PFObject* feedParse = [PFObject objectWithClassName:@"Post"];
    feedParse[@"latitude"] = [NSNumber numberWithDouble:coor.latitude];
    feedParse[@"longitude"] = [NSNumber numberWithDouble:coor.longitude];
    feedParse[@"user_id"] = [PFUser currentUser].objectId;
    feedParse[@"location_id"] = [params objectForKey:@"location"];
    feedParse[@"title"] = [params objectForKey:@"title"];
    feedParse[@"like_count"] = @(0);
    feedParse[@"comment_count"] = @(0);
    feedParse[@"like_userIds"] = @"";
    feedParse[@"comment_userIds"] = @"";
    [feedParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            FeedDataModel* model = [self updateFeedFromParse:feedParse];
            completion(model,nil);
        }else{
            completion(nil,error.description);
        }
    }];
}

-(void)countFeedsForUserID:(NSString*)userID completion:(void(^)(NSInteger count,NSString*error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"user_id" equalTo:userID];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError* error){
        completion(number,error.description);
    }];
}

-(void)getFeedsFromServerForUserID:(NSString*)userID completion:(void(^)(NSMutableArray* returnArray,NSString*error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"user_id" equalTo:userID];
    [query setLimit:API_PAGE];
    [query orderBySortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * data,NSError* error){
        if (data) {
            NSMutableArray* returnArray = [NSMutableArray array];
            for (PFObject* feedParse in data) {
                FeedDataModel* feedModel = [self updateFeedFromParse:feedParse];
                [returnArray addObject:feedModel];
            }
            completion(returnArray,nil);
        }else{
            completion([NSMutableArray array],error.description);
        }
    }];
}

-(void)getFeedsFromServer:(void(^)(NSMutableArray* returnArray,NSString*error))completion{
    [self getOldFeedsFromServer:nil completion:completion];
}

-(void)getOldFeedsFromServer:(NSDate*)time completion:(void(^)(NSMutableArray* returnArray,NSString*error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query setLimit:API_PAGE];
    [query orderBySortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    if (time) {
        [query whereKey:@"createdAt" lessThan:time];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * data,NSError* error){
        if (data) {
            NSMutableArray* returnArray = [NSMutableArray array];
            for (PFObject* feedParse in data) {
                FeedDataModel* feedModel = [self updateFeedFromParse:feedParse];
                [returnArray addObject:feedModel];
            }
            completion(returnArray,nil);
        }else{
            completion([NSMutableArray array],error.description);
        }
    }];
}

-(void)increaseFeedCommentCountForFeedID:(NSString*)feedID{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo: feedID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            PFObject* parseObject = [objects firstObject];
            NSInteger count = [parseObject[@"comment_count"] integerValue];
            count++;
            parseObject[@"comment_count"] = [NSNumber numberWithInteger:count];
            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (succeeded) {
                    FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                    [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                }
            }];
        }
    }];
}

-(FeedDataModel*)updateFeedFromParse:(PFObject*)parse{
    FeedDataModel* feedModel = (FeedDataModel*)[FeedDataModel fetchObjectWithID:parse.objectId];
    feedModel.title = parse[@"title"];
    feedModel.time = parse.createdAt;
    feedModel.latitude = parse[@"latitude"];
    feedModel.longitude = parse[@"longitude"];
    feedModel.user_id = parse[@"user_id"];
    feedModel.location_id = parse[@"location_id"];
    feedModel.like_count = parse[@"like_count"];
    feedModel.comment_count = parse[@"comment_count"];
    feedModel.like_userIds = parse[@"like_userIds"];
    feedModel.comming_userIds = parse[@"comming_userIds"];
    return feedModel;
}

-(void)likeFeedWithID:(NSString*)feedID completion:(void(^)(BOOL successful,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo: feedID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            PFObject* parseObject = [objects firstObject];
            
            //send notification
            if (![parseObject[@"user_id"] isEqualToString:[AccountModel currentAccountModel].user_id]) {
                NotificationModel* model  = (NotificationModel*)[NotificationModel fetchObjectWithID:[NSDate date].description];
                model.type = NOTIFICATION_LIKE;
                model.sender_id = [AccountModel currentAccountModel].user_id;
                model.receiver_id = parseObject[@"user_id"];
                model.feed_id = feedID;
                model.time = [NSDate date];
                [self sendNotification:model completion:^(BOOL successful, NSString *error) {
                    
                }];
            }
            
            NSString* likeIDs = parseObject[@"like_userIds"];
            if ([likeIDs rangeOfString:[AccountModel currentAccountModel].user_id].location == NSNotFound) {
                if (likeIDs && likeIDs.length > 0) {
                    likeIDs = [NSString stringWithFormat:@"%@,%@",likeIDs,[AccountModel currentAccountModel].user_id];
                }else{
                    likeIDs = [AccountModel currentAccountModel].user_id;
                }
                parseObject[@"like_userIds"] = likeIDs;
                NSInteger count = [parseObject[@"like_count"] integerValue];
                count++;
                parseObject[@"like_count"] = [NSNumber numberWithInteger:count];
                [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (succeeded) {
                        FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                        [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                    }
                    completion(succeeded,error.description);
                }];
            }else{
                FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                completion(YES,nil);
            }
        }else{
            completion(NO,error.description);
        }
        
    }];
}

-(void)unlikeFeedWithID:(NSString*)feedID completion:(void(^)(BOOL successful,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo: feedID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            PFObject* parseObject = [objects firstObject];
            
            //remove notification
            if (![parseObject[@"user_id"] isEqualToString:[AccountModel currentAccountModel].user_id]) {
                [self removeNotificationType:NOTIFICATION_LIKE receiver:parseObject[@"user_id"] postID:feedID completion:^(BOOL successful, NSString *error) {
                    
                }];
            }
            
            NSString* likeIDs = parseObject[@"like_userIds"];
            NSMutableArray* likeIDArray = [NSMutableArray arrayWithArray:[likeIDs componentsSeparatedByString:@","]];
            if ([likeIDArray containsObject:[AccountModel currentAccountModel].user_id]) {
                [likeIDArray removeObject:[AccountModel currentAccountModel].user_id];
                likeIDs = [likeIDArray componentsJoinedByString:@","];
                parseObject[@"like_userIds"] = likeIDs;
                NSInteger count = [parseObject[@"like_count"] integerValue];
                count--;
                parseObject[@"like_count"] = [NSNumber numberWithInteger:count];
                [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (succeeded) {
                        FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                        [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                    }
                    completion(succeeded,error.description);
                }];
            }else{
                FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                completion(YES,nil);
            }
        }else{
            completion(NO,error.description);
        }
        
    }];
}

-(void)sendCommingNotifyForFeedID:(NSString*)fid completion:(void(^)(BOOL isSuccess,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo: fid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            PFObject* parseObject = [objects firstObject];
            
            //send notification
            if (![parseObject[@"user_id"] isEqualToString:[AccountModel currentAccountModel].user_id]) {
                NotificationModel* model = (NotificationModel*)[NotificationModel fetchObjectWithID:[NSDate date].description];
                model.type = NOTIFICATION_COMMING;
                model.sender_id = [AccountModel currentAccountModel].user_id;
                model.receiver_id = parseObject[@"user_id"];
                model.feed_id = fid;
                [self sendNotification:model completion:^(BOOL successful, NSString *error) {
                    
                }];
            }
            
            
            NSString* likeIDs = parseObject[@"comming_userIds"];
            if ([likeIDs rangeOfString:[AccountModel currentAccountModel].user_id].location == NSNotFound) {
                if (likeIDs && likeIDs.length > 0) {
                    likeIDs = [NSString stringWithFormat:@"%@,%@",likeIDs,[AccountModel currentAccountModel].user_id];
                }else{
                    likeIDs = [AccountModel currentAccountModel].user_id;
                }
                parseObject[@"comming_userIds"] = likeIDs;
                [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (succeeded) {
                        FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                        [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                    }
                    completion(succeeded,error.description);
                }];
            }else{
                FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                completion(YES,nil);
            }
        }else{
            completion(NO,error.description);
        }
        
    }];
}

-(void)sendUnCommingNotifyForFeedID:(NSString*)fid completion:(void(^)(BOOL isSuccess,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo: fid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            PFObject* parseObject = [objects firstObject];
            
            //remove notification
            if (![parseObject[@"user_id"] isEqualToString:[AccountModel currentAccountModel].user_id]) {
                [self removeNotificationType:NOTIFICATION_COMMING receiver:parseObject[@"user_id"] postID:fid completion:^(BOOL successful, NSString *error) {
                    
                }];
            }
            
            NSString* likeIDs = parseObject[@"comming_userIds"];
            NSMutableArray* likeIDArray = [NSMutableArray arrayWithArray:[likeIDs componentsSeparatedByString:@","]];
            if ([likeIDArray containsObject:[AccountModel currentAccountModel].user_id]) {
                [likeIDArray removeObject:[AccountModel currentAccountModel].user_id];
                likeIDs = [likeIDArray componentsJoinedByString:@","];
                parseObject[@"comming_userIds"] = likeIDs;
                [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (succeeded) {
                        FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                        [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                    }
                    completion(succeeded,error.description);
                }];
            }else{
                FeedDataModel* feedModel = [self updateFeedFromParse:parseObject];
                [feedModel.dataDelegate updateUIForDataModel:feedModel options:nil];
                completion(YES,nil);
            }
        }else{
            completion(NO,error.description);
        }
        
    }];
}

#pragma mark - Account
-(void)logoutWithCompletion:(void(^)(BOOL successful,NSString* error))completion{
    [PFUser logOutInBackgroundWithBlock:^(NSError *error){
        if (error) {
            completion(NO,error.description);
        }else{
            completion(YES,nil);
        }
    }];
}
-(void)checkIsExistUsername:(NSString*)username completion:(void(^)(BOOL isExist))completion{
    [self fetchUserWithUsername:username callback:^(PFObject *user, NSString *error) {
        if (user == nil) {
            completion(NO);
        }else{
            completion(YES);
        }
    }];
}

-(void)createAccountWithData:(NSDictionary *)data :(dataResponse)response
{
    PFUser* user = [PFUser user];
    user.username = [data objectForKey:@"email"];
    user.password = [data objectForKey:@"password"];
    user.email = [data objectForKey:@"email"];
    user[@"firstName"] = [data objectForKey:@"firstName"];
    user[@"lastName"] = [data objectForKey:@"lastName"];
    user[@"gender"] = [data objectForKey:@"gender"];
    user[@"dob"] = [data objectForKey:@"dob"];
    user[@"phoneNumber"] = [data objectForKey:@"phoneNumber"];
    user[@"hometown"] =[data objectForKey:@"hometown"];
    user[@"facebook_id"] =[data objectForKey:@"facebook_id"];
    user[@"enableAllZpot"] = [NSNumber numberWithBool:YES];
    user[@"privateProfile"] = [NSNumber numberWithBool:YES];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            UserDataModel* userModel = [self updateUserModel:user.objectId withParse:user];;
            [AccountModel currentAccountModel].user_id = userModel.mid;
            [[CoreDataService instance]saveContext];
            response(userModel, error.localizedDescription);
        }else{
            response(nil, error.localizedDescription);
        }
    }];
}

-(void)loginUserWithFID:(NSString*)facebookID :(dataResponse)response{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"email,name,birthday,gender"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSString* email = result[@"email"];
                 NSString* gender = result[@"gender"];
                 
                 void (^onFetchUser)(NSArray *objects) = ^(NSArray *objects){
                     if (objects.count == 1) {
                         PFUser* user = objects.firstObject;
                         user[@"facebookID"] = facebookID;
                         [user saveInBackground];
//                         response(objects.firstObject, error.localizedDescription);
                         __block int count = 2;
                         [self getFollowMe:^(NSArray *result, NSString *error) {
                             if (result) {
                                 [AccountModel currentAccountModel].follower_ids = [result componentsJoinedByString:@","];
                             }
                             count--;
                             if (count == 0) {
                                 [[CoreDataService instance]saveContext];
                                 response([self updateUserModel:user.objectId withParse:user],nil);
                             }
                         }];
                         [self getFollowingListOfUser:[AccountModel currentAccountModel].user_id completion:^(NSArray *result, NSString *error) {
                             if (result) {
                                 [AccountModel currentAccountModel].following_ids = [result componentsJoinedByString:@","];
                             }
                             count--;
                             if (count == 0) {
                                 [[CoreDataService instance]saveContext];
                                  response([self updateUserModel:user.objectId withParse:user],nil);
                             }
                         }];
                     }else{
                         PFUser* user = [PFUser user];
                         user.username = email;
                         user.password = @"";
                         user.email = email;
                         user[@"firstName"] = [FBSDKProfile currentProfile].firstName;
                         user[@"lastName"] = [FBSDKProfile currentProfile].lastName;
                         if ([gender isEqualToString:@"male"]) {
                             user[@"gender"] = @(0);
                         }else if ([gender isEqualToString:@"female"]){
                             user[@"gender"] = @(2);
                         }else{
                             user[@"gender"] = @(1);
                         }
                         user[@"dob"] = [NSDate date];
                         user[@"phoneNumber"] = @"";
                         user[@"hometown"] = @"";
                         user[@"facebook_id"] = facebookID;
                         user[@"enableAllZpot"] = [NSNumber numberWithBool:YES];
                         user[@"privateProfile"] = [NSNumber numberWithBool:YES];
                         [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                             if (succeeded) {
                                 UserDataModel* userModel = [self updateUserModel:user.objectId withParse:user];;
                                 [AccountModel currentAccountModel].user_id = userModel.mid;
                                 [[CoreDataService instance]saveContext];
                                 response(userModel, error.localizedDescription);
                             }else{
                                 response(nil, error.localizedDescription);
                             }
                         }];

                     }
                 };
                 
                 PFQuery *query = [PFUser query];
                 [query whereKey:@"facebook_id" equalTo:facebookID];
                 if (email) {
                     PFQuery *query1 = [PFUser query];
                     [query1 whereKey:@"username" equalTo:email];
                     PFQuery* orQuery = [PFQuery orQueryWithSubqueries:@[query,query1]];
                     [orQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                         if (error) {
                             response(nil,error.description);
                         }else{
                             onFetchUser(objects);
                         }
                     }];
                 }else{
                     email = @"";
                     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                         if (error) {
                             response(nil,error.description);
                         }else{
                             onFetchUser(objects);
                         }
                     }];
                 }
             }else{
                 response(nil,error.description);
             }
         }];
    }
}

-(void)loginWithData:(NSDictionary *)data :(dataResponse)response
{
    [PFUser logInWithUsernameInBackground:[data objectForKey:@"email"] password:[data objectForKey:@"password"] block:^(PFUser *user, NSError *error){
        if (error) {
            response(nil, error.localizedDescription);
        }else{
            UserDataModel* userModel = [self updateUserModel:user.objectId withParse:user];
            [AccountModel currentAccountModel].user_id = userModel.mid;
            __block int count = 2;
            [self getFollowMe:^(NSArray *result, NSString *error) {
                if (result) {
                    [AccountModel currentAccountModel].follower_ids = [result componentsJoinedByString:@","];
                }
                count--;
                if (count == 0) {
                    [[CoreDataService instance]saveContext];
                    response(userModel,nil);
                }
            }];
            [self getFollowingListOfUser:[AccountModel currentAccountModel].user_id completion:^(NSArray *result, NSString *error) {
                if (result) {
                    [AccountModel currentAccountModel].following_ids = [result componentsJoinedByString:@","];
                }
                count--;
                if (count == 0) {
                    [[CoreDataService instance]saveContext];
                    response(userModel,nil);
                }
            }];
            
        }
    }];
}

-(UserDataModel*)updateUserModel:(NSString*)uid withParse:(PFUser*)user{
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

-(void)forgotPasswordWithData:(NSDictionary *)data :(dataResponse)response
{
    [PFUser requestPasswordResetForEmailInBackground:[data objectForKey:@"email"] block:^(BOOL succeeded, NSError* error){
        response(nil, error.localizedDescription);
    }];
}

-(void)fetchUserWithUsername:(NSString*)username callback:(void(^)(PFObject* user,NSString* error))callback{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo: username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && objects.count > 0) {
            callback(objects.firstObject,nil);
        }else{
            callback(nil,error.description);
        }
    }];
}

-(void)updateUserInfoToServerWithID:(NSString*)userID params:(NSDictionary*)params completion:(void(^)(BOOL success,NSString* error))completion{
    PFUser* user = [PFUser currentUser];
    for (NSString* key in [params allKeys]) {
        user[key] = [params objectForKey:key];
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [self updateUserModel:userID withParse:user];
        completion(succeeded,error.description);
    }];
}

-(void)findUserWithPhones:(NSArray*)phones emails:(NSArray*)email completion:(void(^)(NSArray* users))completion{
    PFQuery *query1 = [PFUser query];
    [query1 whereKey:@"phoneNumber" containedIn:phones];
    PFQuery *query2 = [PFUser query];
    [query2 whereKey:@"username" containedIn:email];
    [[PFQuery orQueryWithSubqueries:@[query1,query2]] findObjectsInBackgroundWithBlock:^(NSArray* objects,NSError* error){
        NSMutableArray* returnArray = [NSMutableArray array];
        for (PFUser* user in objects) {
            UserDataModel* userModel = [self updateUserModel:user.objectId withParse:user];
            [returnArray addObject:userModel];
        }
        completion(returnArray);
    }];
}
#pragma mark - CoreDataModel Update
-(void)updateUserModelWithFacebookID:(NSString*)fid completion:(void(^)(UserDataModel* userModel))completion{
    PFQuery *query = [PFUser query];
    [query whereKey:@"facebook_id" equalTo: fid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        UserDataModel* userReturn;
        for (PFUser* user in objects) {
            userReturn = [self updateUserModel:user.objectId withParse:user];
        }
        [[CoreDataService instance]saveContext];
        completion(userReturn);
    }];
}

-(void)updateUserModelWithID:(NSString*)mid completion:(VoidBlock)completion{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo: mid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFUser* user in objects) {
            [self updateUserModel:user.objectId withParse:user];
        }
        [[CoreDataService instance]saveContext];
        completion();
    }];
}
-(void)updateLocationModelWithID:(NSString*)mid completion:(VoidBlock)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"objectId" equalTo: mid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject* location in objects) {
            [self locationModelFromParse:location];
        }
        [[CoreDataService instance]saveContext];
        completion();
    }];
}

-(void)updateFeedModelWithID:(NSString*)mid completion:(VoidBlock)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"objectId" equalTo: mid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject* feed in objects) {
            [self updateFeedFromParse:feed];
        }
        [[CoreDataService instance]saveContext];
        completion();
    }];
}

#pragma mark - Commment
-(void)getCommentsFromServerForFeedID:(NSString*)fid completion:(void(^)(NSMutableArray* returnData,NSString* error))completion{
    [self getOldCommentsFromServerForFeedID:fid time:nil completion:completion];
}

-(void)getOldCommentsFromServerForFeedID:(NSString*)fid time:(NSDate*)time completion:(void(^)(NSMutableArray* returnData,NSString* error))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query setLimit:API_PAGE];
    [query whereKey:@"post_id" equalTo: fid];
    [query orderBySortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    if (time) {
        [query whereKey:@"createdAt" lessThan:time];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        NSMutableArray* returnArray = [NSMutableArray array];
        if (objects) {
            for (PFObject* objectParse in objects) {
                FeedCommentDataModel* feedModel = (FeedCommentDataModel*)[FeedCommentDataModel fetchObjectWithID:objectParse.objectId];
                feedModel.message = objectParse[@"content"];
                feedModel.feed_id = objectParse[@"post_id"];
                feedModel.user_id = objectParse[@"user_id"];
                feedModel.time = objectParse.createdAt;
                feedModel.type = objectParse[@"type"];
                feedModel.status = STATUS_DELIVER;
                [returnArray addObject:feedModel];
            }
        }
        completion(returnArray,error.description);
    }];
}

-(void)postComment:(FeedCommentDataModel*)commentModel completion:(void(^)(BOOL isSuccess,NSString* error))completion{
    PFObject* location = [PFObject objectWithClassName:@"Comment"];
    location[@"content"] = commentModel.message;
    location[@"post_id"] = commentModel.feed_id;
    location[@"user_id"] = commentModel.user_id;
    location[@"type"] = commentModel.type;
    [location saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            commentModel.mid = location.objectId;
            commentModel.status = STATUS_DELIVER;
            commentModel.time = location.createdAt;
            //change number of comment for FeedDataModel
            if ([commentModel.type isEqualToString:TYPE_COMMENT]) {
                [self increaseFeedCommentCountForFeedID:commentModel.feed_id];
            }
            
        }else{
            commentModel.status = STATUS_ERROR;
        }
        [[CoreDataService instance]saveContext];
        completion(succeeded,error.description);
    }];
    
    //send notification
    if (![commentModel.user_id isEqualToString:[AccountModel currentAccountModel].user_id]) {
        NotificationModel* model  = (NotificationModel*)[NotificationModel fetchObjectWithID:[NSDate date].description];
        model.type = NOTIFICATION_COMMENT;
        model.comment = commentModel.message;
        model.sender_id = [AccountModel currentAccountModel].user_id;
        model.receiver_id = commentModel.user_id;
        model.feed_id = commentModel.feed_id;
        model.time = [NSDate date];
        [self sendNotification:model completion:^(BOOL successful, NSString *error) {
            
        }];
    }
}

#pragma mark SEARCH USER
-(void)searchUserWithData:(NSString*)data completion:(void(^)(BOOL successful,NSArray* result))completion
{
    PFQuery* cond1 = [PFUser query]; [cond1 whereKey:@"username" containsString:data];
    PFQuery* cond2 = [PFUser query]; [cond1 whereKey:@"firstName" containsString:data];
    PFQuery* cond3 = [PFUser query]; [cond1 whereKey:@"lastName" containsString:data];
    PFQuery* userQuery = [PFQuery orQueryWithSubqueries:@[cond1,cond2,cond3]];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error){
            NSMutableArray* returnData = [NSMutableArray array];
            for (PFUser* user in objects) {
                UserDataModel* userModel = [self updateUserModel:user.objectId withParse:user];
                [returnData addObject:userModel];
            }
            completion(YES, returnData);
        }
        else{
            completion(YES, @[]);
        }
    }];
}

#pragma mark FOLLOW
-(void)checkFriendWithUserID:(NSString*)friendID completion:(void(^)(BOOL isFriend,NSString* error))completion{
    PFQuery* query1 = [PFQuery queryWithClassName:@"Follow"];
    //[query1 whereKey:@"isFriend" equalTo:[NSNumber numberWithBool:YES]];
    [query1 whereKey:@"followUser" equalTo:friendID];
    [query1 whereKey:@"followedUser" equalTo:[AccountModel currentAccountModel].user_id];
    
    PFQuery* query2 = [PFQuery queryWithClassName:@"Follow"];
    //[query2 whereKey:@"isFriend" equalTo:[NSNumber numberWithBool:YES]];
    [query2 whereKey:@"followedUser" equalTo:friendID];
    [query2 whereKey:@"followUser" equalTo:[AccountModel currentAccountModel].user_id];
    
    [[PFQuery orQueryWithSubqueries:@[query1,query2]] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (objects && objects.count > 0) {
            completion(YES,nil);
        }else{
            completion(NO,error.description);
        }
    }];
}

-(void)searchFriendWithName:(NSString*)userName completion:(void(^)(NSMutableArray* returnArray,NSString*error))completion{
    NSMutableArray* returnArray = [NSMutableArray array];
    PFQuery* query1 = [PFUser query];
    [query1 whereKey:@"firstName" containsString:userName];
    [query1 whereKey:@"objectId" notEqualTo:[AccountModel currentAccountModel].user_id];
    
    PFQuery* query2 = [PFUser query];
    [query2 whereKey:@"lastName" containsString:userName];
    [query2 whereKey:@"objectId" notEqualTo:[AccountModel currentAccountModel].user_id];
    
    PFQuery* query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFUser* user in objects) {
            UserDataModel* userModel = (UserDataModel*)[UserDataModel fetchObjectWithID:user.objectId];
            userModel.email = user.email;
            userModel.username = user.username;
            userModel.first_name = user[@"firstName"];
            userModel.last_name = user[@"lastName"];
            userModel.gender = user[@"gender"];
            userModel.birthday = user[@"dob"];
            userModel.phone = user[@"phoneNumber"];
            userModel.hometown = user[@"hometown"];
            [returnArray addObject:userModel];
        }
        [[CoreDataService instance]saveContext];
        completion(returnArray,error.description);
    }];
    
}

-(void)countFollowingForUserID:(NSString*)userID completion:(void(^)(NSInteger count,NSString* error))completion{
    PFQuery* follow = [PFQuery queryWithClassName:@"Follow"];
    [follow whereKey:@"followUser" equalTo:userID];
    [follow countObjectsInBackgroundWithBlock:^(int number,NSError* error){
        completion(number,error.description);
    }];
}
-(void)getFollowingListOfUser:(NSString*)data completion:(void(^)(NSArray* result,NSString* error))completion
{
    PFQuery* follow = [PFQuery queryWithClassName:@"Follow"];
    [follow whereKey:@"followUser" equalTo:data];
    [follow findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if (objects && objects.count > 0)
         {
             NSMutableArray* returnArray = [NSMutableArray array];
             for (PFObject* follow in objects) {
                 NSString* followedID = follow[@"followedUser"];
                 [returnArray addObject:followedID];
             }
             completion(returnArray,nil);
         }
         else
         {
             completion(@[],error.description);
         }
     }];
    
}

//users follow me
-(void)countFollowersForUserID:(NSString*)userID completion:(void(^)(NSInteger count,NSString* error))completion{
    PFQuery* follow = [PFQuery queryWithClassName:@"Follow"];
    [follow whereKey:@"followedUser" equalTo:userID];
    [follow countObjectsInBackgroundWithBlock:^(int number,NSError* error){
        completion(number,error.description);
    }];
}

-(void)getFollowerListOfUser:(NSString*)data completion:(void(^)(NSArray* result,NSString* error))completion
{
    PFQuery* follow = [PFQuery queryWithClassName:@"Follow"];
    [follow whereKey:@"followedUser" equalTo:data];
    [follow findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
    {
        if (objects && objects.count > 0)
        {
            NSMutableArray* returnArray = [NSMutableArray array];
            for (PFObject* follow in objects) {
                NSString* followedID = follow[@"followUser"];
                [returnArray addObject:followedID];
            }
            completion(returnArray,nil);
        }
        else
        {
            completion(@[], error.description);
        }
    }];
    
}

-(void)getFollowMe:(void(^)(NSArray* result,NSString* error))completion
{
    [self getFollowerListOfUser:[AccountModel currentAccountModel].user_id completion:completion];
}

-(void)setFollowWithUser:(NSString*)data completion:(void(^)(BOOL successful,NSString* error))completion
{
    //send notification
    NotificationModel* model = (NotificationModel*)[NotificationModel fetchObjectWithID:[NSDate date].description];
    model.type = NOTIFICATION_FOLLOW;
    model.sender_id = [AccountModel currentAccountModel].user_id;
    model.receiver_id = data;
    [self sendNotification:model completion:^(BOOL successful, NSString *error) {
        
    }];
    
    PFQuery* query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"followUser" equalTo:[AccountModel currentAccountModel].user_id];
    [query whereKey:@"followedUser" equalTo:data];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects,NSError* error){
        if (objects && objects.count == 0) {
            PFObject* follow = [PFObject objectWithClassName:@"Follow"];
            follow[@"followUser"] = [AccountModel currentAccountModel].user_id;
            follow[@"followedUser"] = data;
            follow[@"isFriend"] = @NO;
            [follow saveInBackgroundWithBlock:^(BOOL successful,NSError* error){
                NSMutableArray* array = [NSMutableArray arrayWithArray:[[AccountModel currentAccountModel].following_ids componentsSeparatedByString:@","]];
                if (![array containsObject:data]) {
                    [array addObject:data];
                    [AccountModel currentAccountModel].following_ids = [array componentsJoinedByString:@","];
                }
                completion(successful,error.description);
            }];
        }else if(objects && objects.count == 1){
            completion(YES,nil);
        }else{
            completion(NO,error.description);
        }
    }];
}

-(void)setUnFollowWithUser:(NSString*)data completion:(void(^)(BOOL successful,NSString* error))completion
{
    [self removeNotificationType:NOTIFICATION_FOLLOW receiver:data postID:nil completion:^(BOOL successful, NSString *error) {
        
    }];
    
    PFQuery* query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"followUser" equalTo:[AccountModel currentAccountModel].user_id];
    [query whereKey:@"followedUser" equalTo:data];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects,NSError* error){
        if (objects && objects.count == 1) {
            PFObject* follow = objects.lastObject;
            [follow deleteInBackgroundWithBlock:^(BOOL successful,NSError* error){
                NSMutableArray* array = [NSMutableArray arrayWithArray:[[AccountModel currentAccountModel].following_ids componentsSeparatedByString:@","]];
                if ([array containsObject:data]) {
                    [array removeObject:data];
                    [AccountModel currentAccountModel].following_ids = [array componentsJoinedByString:@","];
                }
                completion(successful,error.description);
            }];
        }else if(objects && objects.count == 0){
            completion(YES,nil);
        }else{
            completion(NO,error.description);
        }
    }];
    
}

#pragma mark - Notification
//remove for coming and follow
-(void)removeNotificationType:(NSString*)type receiver:(NSString*)receiverID postID:(NSString*)postID completion:(void(^)(BOOL successful,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"type" equalTo:type];
    [query whereKey:@"sender_id" equalTo:[AccountModel currentAccountModel].user_id];
    [query whereKey:@"receiver_id" equalTo:receiverID];
    if (postID && postID.length > 0) {
        [query whereKey:@"post_id" equalTo:postID];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
        if (error) {
            completion(NO,error.description);
        }else if(objects && objects.count == 1){
            PFObject* notification = objects.lastObject;
            [notification deleteInBackgroundWithBlock:^(BOOL successful,NSError* error){
                completion(successful,error.description);
            }];
        }else{
            completion(YES,nil);
        }
    }];
}
-(void)sendNotification:(NotificationModel*)model completion:(void(^)(BOOL successful,NSString* error))completion{
    if ([model.type isEqualToString:NOTIFICATION_COMMING] || [model.type isEqualToString:NOTIFICATION_FB_Friend]
        || [model.type isEqualToString:NOTIFICATION_FOLLOW] || [model.type isEqualToString:NOTIFICATION_LIKE]) {
        //have one
        PFQuery* query = [PFQuery queryWithClassName:@"Notification"];
        [query whereKey:@"type" equalTo:model.type];
        [query whereKey:@"sender_id" equalTo:[AccountModel currentAccountModel].user_id];
        [query whereKey:@"receiver_id" equalTo:model.receiver_id];
        [query whereKey:@"post_id" equalTo:model.feed_id];
        [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
            if (error) {
                completion(NO,error.description);
            }else if(objects && objects.count == 1){
                completion(YES,nil);
            }else{
                PFObject* notification = [PFObject objectWithClassName:@"Notification"];
                notification[@"comment"] = model.comment;
                notification[@"post_id"] = model.feed_id;
                notification[@"sender_id"] = model.sender_id;
                notification[@"type"] = model.type;
                notification[@"receiver_id"] = model.receiver_id;
                [notification saveInBackgroundWithBlock:^(BOOL successful,NSError* error){
                    model.mid = notification.objectId;
                    [self notificationModelFromParse:notification];
                    completion(successful,error.description);
                }];
            }
        }];

    }else{
        //like and comment have many
        PFObject* notification = [PFObject objectWithClassName:@"Notification"];
        notification[@"comment"] = model.comment;
        notification[@"post_id"] = model.feed_id;
        notification[@"sender_id"] = model.sender_id;
        notification[@"type"] = model.type;
        notification[@"receiver_id"] = model.receiver_id;
        [notification saveInBackgroundWithBlock:^(BOOL successful,NSError* error){
            model.mid = notification.objectId;
            [self notificationModelFromParse:notification];
            completion(successful,error.description);
        }];
    }
}

-(void)getNotificationFromServerForUser:(NSString*)userID oldestNotifcation:(NotificationModel*)notif completion:(void(^)(NSArray* returnArray,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Notification"];
    if (notif) {
        [query whereKey:@"updatedAt" lessThan:notif.time];
    }
    [query setLimit:API_PAGE];
    [query whereKey:@"receiver_id" equalTo:[AccountModel currentAccountModel].user_id];
    [query whereKey:@"sender_id" notEqualTo:[AccountModel currentAccountModel].user_id];
    [query orderBySortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if (objects && objects.count > 0)
         {
             NSMutableArray* returnArray = [NSMutableArray array];
             for (PFObject* notif in objects) {
                 NotificationModel* model = [self notificationModelFromParse:notif];
                 [returnArray addObject:model];
             }
             completion(returnArray,nil);
         }
         else
         {
             completion(@[],error.description);
         }
     }];
}
-(void)getNotificationFromServerForUser:(NSString*)userID lastestNotifcation:(NotificationModel*)notif completion:(void(^)(NSArray* returnArray,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Notification"];
    if (notif) {
        [query whereKey:@"updatedAt" greaterThan:notif.time];
    }
    [query whereKey:@"receiver_id" equalTo:[AccountModel currentAccountModel].user_id];
    [query whereKey:@"sender_id" notEqualTo:[AccountModel currentAccountModel].user_id];
    [query orderBySortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if (objects && objects.count > 0)
         {
             NSMutableArray* returnArray = [NSMutableArray array];
             for (PFObject* notif in objects) {
                 NotificationModel* model = [self notificationModelFromParse:notif];
                 [returnArray addObject:model];
             }
             completion(returnArray,nil);
         }
         else
         {
             completion(@[],error.description);
         }
     }];

}
-(void)getNotificationFromServerForUser:(NSString*)userID completion:(void(^)(NSArray* returnArray,NSString* error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Notification"];
    [query setLimit:API_PAGE];
    [query whereKey:@"receiver_id" equalTo:[AccountModel currentAccountModel].user_id];
    [query whereKey:@"sender_id" notEqualTo:[AccountModel currentAccountModel].user_id];
    [query orderBySortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error)
     {
         if (objects && objects.count > 0)
         {
             NSMutableArray* returnArray = [NSMutableArray array];
             for (PFObject* notif in objects) {
                 NotificationModel* model = [self notificationModelFromParse:notif];
                 [returnArray addObject:model];
             }
             completion(returnArray,nil);
         }
         else
         {
             completion(@[],error.description);
         }
     }];
}
-(NotificationModel*)notificationModelFromParse:(PFObject*)parse{
    NotificationModel* model = (NotificationModel*)[NotificationModel fetchObjectWithID:parse.objectId];
    model.comment = parse[@"comment"];
    model.feed_id = parse[@"post_id"];
    model.sender_id = parse[@"sender_id"];
    model.receiver_id = parse[@"receiver_id"];
    model.type = parse[@"type"];
    model.time = parse.updatedAt;
    return model;
}
@end
