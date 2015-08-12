//
//  APIService.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
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
-(void)checkIsExistUsername:(NSString*)username completion:(void(^)(BOOL isExist))completion;
-(void)createAccountWithData:(NSDictionary*)data :(dataResponse)response;

-(void)loginWithData:(NSDictionary*)data :(dataResponse)response;
-(void)forgotPasswordWithData:(NSDictionary*)data :(dataResponse)response;

-(void)createLocationWithCoordinate:(CLLocationCoordinate2D)coor params:(NSMutableDictionary*)params completion:(void(^)(id data,NSString* error))completion;
-(void)addressFromLocationCoordinate:(CLLocationCoordinate2D)coor completion:(void(^)(NSString* address))completion;
-(void)searchLocationWithName:(NSString*)name withinCoord:(CLLocationCoordinate2D)topLeft coor2:(CLLocationCoordinate2D)botRight completion:(void(^)(NSArray * data,NSString* error))completion;
-(void)postZpotWithCoordinate:(CLLocationCoordinate2D)coor params:(NSMutableDictionary*)params completion:(void(^)(id data,NSString* error))completion;
@end
