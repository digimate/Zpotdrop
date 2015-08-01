//
//  APIService.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^dataResponse)(id data, NSString* error);

@interface APIService : NSObject
/*
 @abstract Get static API instance
 
 @param: Nothing
 
 @returns instance of APIService
 */
+(APIService*)shareAPIService;

/*!
 @abstract Create new account
 
 @param data with dictionary include keys: "email", "password", "firstName", "lastName",
        "dob", "gender".
 
 @returns data receive will be return on block code response.
 */
-(void)createAccountWithData:(NSDictionary*)data :(dataResponse)response;

-(void)loginWithData:(NSDictionary*)data :(dataResponse)response;
-(void)forgotPasswordWithData:(NSDictionary*)data :(dataResponse)response;

@end
