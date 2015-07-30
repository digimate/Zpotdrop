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
    PFObject* user = [PFObject objectWithClassName:@"User"];
    user[@"email"] = [data objectForKey:@"email"];
    user[@"password"] = [data objectForKey:@"password"];
    user[@"firstName"] = [data objectForKey:@"firstName"];
    user[@"lastName"] = [data objectForKey:@"lastName"];
    user[@"gender"] = [data objectForKey:@"gender"];
    user[@"dob"] = [data objectForKey:@"dob"];
    [user saveInBackgroundWithBlock:^(BOOL successed, NSError* error){
        
    }];
}

-(void)loginWithData:(NSDictionary *)data :(dataResponse)response
{
    
}

-(void)forgotPasswordWithData:(NSDictionary *)data :(dataResponse)response
{
    
}
@end
