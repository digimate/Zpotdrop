//
//  APIService.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "APIService.h"
#import <Parse/Parse.h>

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
        response(nil, error.localizedDescription);
    }];
}

-(void)loginWithData:(NSDictionary *)data :(dataResponse)response
{
    [PFUser logInWithUsernameInBackground:[data objectForKey:@"email"] password:[data objectForKey:@"password"] block:^(PFUser *user, NSError *error){
        response(user, error.localizedDescription);
    }];
}

-(void)forgotPasswordWithData:(NSDictionary *)data :(dataResponse)response
{
    [PFUser requestPasswordResetForEmailInBackground:[data objectForKey:@"email"] block:^(BOOL succeeded, NSError* error){
        response(nil, error.localizedDescription);
    }];
}
@end
