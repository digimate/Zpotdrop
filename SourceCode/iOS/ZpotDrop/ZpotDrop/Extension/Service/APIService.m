//
//  APIService.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "APIService.h"
#import <Parse/Parse.h>
#import "UserDataModel.h"
#import "CoreDataService.h"
#import "LocationDataModel.h"

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

#pragma mark - POST
-(void)postZpotWithCoordinate:(CLLocationCoordinate2D)coor params:(NSMutableDictionary*)params completion:(void(^)(id data,NSString* error))completion{
    PFObject* feedParse = [PFObject objectWithClassName:@"Post"];
    feedParse[@"latitude"] = [NSNumber numberWithDouble:coor.latitude];
    feedParse[@"longitude"] = [NSNumber numberWithDouble:coor.longitude];
    feedParse[@"user_id"] = [PFUser currentUser].objectId;
    feedParse[@"location_id"] = [params objectForKey:@"location"];
    feedParse[@"title"] = [params objectForKey:@"title"];
    [feedParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            FeedDataModel* model = [self updateFeedFromParse:feedParse];
            completion(model,nil);
        }else{
            completion(nil,error.description);
        }
    }];
}

-(void)getFeedsFromServer:(void(^)(NSMutableArray* returnArray,NSString*error))completion{
    PFQuery* query = [PFQuery queryWithClassName:@"Post"];
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
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            UserDataModel* userModel = (UserDataModel*)[UserDataModel fetchObjectWithID:user.objectId];
            userModel.email = user.email;
            userModel.username = user.username;
            userModel.first_name = user[@"firstName"];
            userModel.last_name = user[@"lastName"];
            userModel.gender = user[@"gender"];
            userModel.birthday = user[@"dob"];
            [AccountModel currentAccountModel].user_id = userModel.mid;
            [[CoreDataService instance]saveContext];
            response(userModel, error.localizedDescription);
        }else{
            response(nil, error.localizedDescription);
        }
    }];
}

-(void)loginWithData:(NSDictionary *)data :(dataResponse)response
{
    [PFUser logInWithUsernameInBackground:[data objectForKey:@"email"] password:[data objectForKey:@"password"] block:^(PFUser *user, NSError *error){
        if (error) {
            response(nil, error.localizedDescription);
        }else{
            UserDataModel* userModel = (UserDataModel*)[UserDataModel fetchObjectWithID:user.objectId];
            userModel.email = user.email;
            userModel.username = user.username;
            userModel.first_name = user[@"firstName"];
            userModel.last_name = user[@"lastName"];
            userModel.gender = user[@"gender"];
            userModel.birthday = user[@"dob"];
            [AccountModel currentAccountModel].user_id = userModel.mid;
            [[CoreDataService instance]saveContext];
            response(userModel, error.localizedDescription);
        }
    }];
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

#pragma mark - DataModel
-(void)updateUserModelWithID:(NSString*)mid completion:(VoidBlock)completion{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo: mid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFUser* user in objects) {
            UserDataModel* userModel = (UserDataModel*)[UserDataModel fetchObjectWithID:user.objectId];
            userModel.email = user.email;
            userModel.username = user.username;
            userModel.first_name = user[@"firstName"];
            userModel.last_name = user[@"lastName"];
            userModel.gender = user[@"gender"];
            userModel.birthday = user[@"dob"];
            [[CoreDataService instance]saveContext];
        }
        completion();
    }];
}
-(void)updateLocationModelWithID:(NSString*)mid completion:(VoidBlock)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"objectId" equalTo: mid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject* location in objects) {
            LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:location.objectId];
            model.name = location[@"name"];
            model.address = location[@"address"];
            model.latitude = location[@"latitude"];
            model.longitude = location[@"longitude"];
        }
        [[CoreDataService instance]saveContext];
        completion();
    }];
}

#pragma mark - Commment
-(void)getCommentsFromServerForFeedID:(NSString*)fid completion:(void(^)(NSMutableArray* returnData,NSString* error))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"post_id" equalTo: fid];
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
            [self increaseFeedCommentCountForFeedID:commentModel.feed_id];
            
        }else{
            commentModel.status = STATUS_ERROR;
        }
        [[CoreDataService instance]saveContext];
        completion(succeeded,error.description);
    }];
}


@end
