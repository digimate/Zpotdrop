//
//  FacebookService.h
//  MiniGames
//
//  Created by ME on 7/17/15.
//  Copyright (c) 2015 TEDMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookService : NSObject{
    BOOL isLoggedIn;
    NSString* userName;
    NSString* userID;
    FBSDKLoginManager* manager;
    NSMutableArray* friendArray;
    NSInteger totalFriendCount;
}
@property(nonatomic,readonly)BOOL isLoggedIn;
+(FacebookService*)instance;
-(void)login:(void (^)(BOOL result,NSString* error))callback;
-(void)logout;
-(void)getFriends:(void(^)(NSArray* friends,NSInteger total))callback;
-(void)requestInfoForMe:(void(^)())completion;
@end
