//
//  APIService.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "APIService.h"
#import <Parse/Parse.h>
#import "Utils.h"
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
@end
