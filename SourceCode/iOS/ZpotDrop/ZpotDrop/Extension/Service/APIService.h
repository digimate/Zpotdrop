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
#import "Utils.h"
#import "UserDataModel.h"
#import <Parse/Parse.h>

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
-(void)checkIsExistUsername:(NSString*)username completion:(void(^)(BOOL isExist))completion;

-(void)loginWithData:(NSDictionary*)data :(dataResponse)response;
-(void)forgotPasswordWithData:(NSDictionary*)data :(dataResponse)response;

-(void)createLocationWithCoordinate:(CLLocationCoordinate2D)coor params:(NSMutableDictionary*)params completion:(void(^)(id data,NSString* error))completion;
-(void)addressFromLocationCoordinate:(CLLocationCoordinate2D)coor completion:(void(^)(NSString* address))completion;
-(void)searchLocationWithName:(NSString*)name withinCoord:(CLLocationCoordinate2D)topLeft coor2:(CLLocationCoordinate2D)botRight completion:(void(^)(NSArray * data,NSString* error))completion;
-(void)postZpotWithCoordinate:(CLLocationCoordinate2D)coor params:(NSMutableDictionary*)params completion:(void(^)(id data,NSString* error))completion;
-(void)getFeedsFromServer:(void(^)(NSMutableArray* returnArray,NSString*error))completion;
-(void)updateUserModelWithID:(NSString*)mid completion:(VoidBlock)completion;
-(void)updateLocationModelWithID:(NSString*)mid completion:(VoidBlock)completion;
-(void)postComment:(FeedCommentDataModel*)commentModel completion:(void(^)(BOOL isSuccess,NSString* error))completion;
-(void)getCommentsFromServerForFeedID:(NSString*)fid completion:(void(^)(NSMutableArray* returnData,NSString* error))completion;
-(void)likeFeedWithID:(NSString*)feedID completion:(void(^)(BOOL successful,NSString* error))completion;
-(void)unlikeFeedWithID:(NSString*)feedID completion:(void(^)(BOOL successful,NSString* error))completion;

-(void)searchUserWithData:(NSString*)data completion:(void(^)(BOOL successful,NSArray* result))completion;
-(void)getFolowerListOfUser:(NSString*)data completion:(void(^)(BOOL successful,NSArray* result))completion;
-(void)getFollowMe:(void(^)(BOOL successful,NSArray* result))completion;
-(void)setFolowWithUser:(NSString*)data completion:(void(^)(BOOL successful,NSArray* result))completion;
-(void)setUnFollowWithUser:(NSString*)data completion:(void(^)(BOOL successful,NSArray* result))completion;

-(void)sendCommingNotifyForFeedID:(NSString*)fid completion:(void(^)(BOOL isSuccess,NSString* error))completion;
-(void)sendUnCommingNotifyForFeedID:(NSString*)fid completion:(void(^)(BOOL isSuccess,NSString* error))completion;
-(void)updateUserInfoToServerWithID:(NSString*)userID params:(NSDictionary*)params completion:(void(^)(BOOL success,NSString* error))completion;
-(UserDataModel*)updateUserModel:(NSString*)uid withParse:(PFUser*)user;
-(void)logoutWithCompletion:(void(^)(BOOL successful,NSString* error))completion;
-(void)scanAreaForUserID:(NSString*)userID topLeftCoord:(CLLocationCoordinate2D)topLeft botRightCoord:(CLLocationCoordinate2D)botRight completion:(void(^)(NSArray * data,NSString* error))completion;
-(void)searchFriendWithName:(NSString*)userName completion:(void(^)(NSMutableArray* returnArray,NSString*error))completion;
-(void)requestLocationOfUserID:(NSString*)friendID completion:(void(^)(BOOL successful,NSString* error))completion;
-(void)checkFriendWithUserID:(NSString*)friendID completion:(void(^)(BOOL isFriend,NSString* error))completion;
-(void)getFeedsFromServerForUserID:(NSString*)userID completion:(void(^)(NSMutableArray* returnArray,NSString*error))completion;
@end
