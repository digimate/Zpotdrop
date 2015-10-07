//
//  FacebookService.m
//  MiniGames
//
//  Created by ME on 7/17/15.
//  Copyright (c) 2015 TEDMate. All rights reserved.
//

#import "FacebookService.h"

@implementation FacebookService
@synthesize isLoggedIn;

+(FacebookService *)instance{
    static dispatch_once_t once;
    static FacebookService* instance = nil;
    dispatch_once(&once, ^{
        instance = [[FacebookService alloc]init];
    });
    return instance;
}

-(void)login:(void (^)(BOOL result,NSString* error))callback
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email", @"public_profile", @"user_friends",
                            nil];
    if (!manager) {
        manager = [[FBSDKLoginManager alloc] init];
    }
    [manager logInWithReadPermissions:permissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            callback(false,error.description);
        } else if (result.isCancelled) {
            // Handle cancellations
            callback(false,@"user_cancel");
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"] && [result.grantedPermissions containsObject:@"user_friends"]) {
                // Do work
                callback(true,nil);
            }else{
                callback(false,@"missing_permission");
            }
        }
    }];
}

-(void)requestInfoForMe:(void(^)())completion{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"email,name,birthday,gender"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         completion();
     }];
}

-(BOOL)isLoggedIn{
    if ([FBSDKAccessToken currentAccessToken]) {
        return YES;
    }
    return NO;
}

-(void)logout{
    if (!manager) {
        manager = [[FBSDKLoginManager alloc] init];
    }
    [friendArray removeAllObjects];
    totalFriendCount = 0;
    [manager logOut];
}


-(void)getFriends:(void(^)(NSArray* friends,NSInteger total))callback{
    if (!friendArray) {
        friendArray = [NSMutableArray array];
    }
    if (friendArray.count > 0) {
        callback(friendArray,totalFriendCount);
    }else{
        totalFriendCount = 0;
        [self getLoopFriendArrayWithToken:nil andCallback:callback];
    }
    
}
-(void)getLoopFriendArrayWithToken:(NSString*)token andCallback:(void(^)(NSArray* friends,NSInteger total))callback{
    if (token) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:token
                                      parameters:nil
                                      ];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error ) {
                NSArray* data = [result objectForKey:@"data"];
                [friendArray addObjectsFromArray:data];
                NSString *nextUrl = [[result objectForKey:@"paging"] objectForKey:@"next"];
                if (nextUrl) {
                    //remove the 'https://graph.facebook.com/v2.3/'
                    nextUrl = [nextUrl substringFromIndex:32];
                    [self getLoopFriendArrayWithToken:nextUrl andCallback:callback];
                }else{
                    callback(friendArray,totalFriendCount);
                }
                
            }else{
                callback(friendArray,totalFriendCount);
            }
        }];
    }else{
        NSMutableString *facebookRequest = [NSMutableString new];
        [facebookRequest appendString:@"/me/friends"];
        [facebookRequest appendString:@"?limit=100"];
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:facebookRequest
                                      parameters:nil
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSArray* data = [result objectForKey:@"data"];
                [friendArray addObjectsFromArray:data];
                totalFriendCount = [[[[result objectForKey:@"summary"] objectForKey:@"total_count"] description] integerValue];
                NSString *nextUrl = [[result objectForKey:@"paging"] objectForKey:@"next"];
                if (nextUrl) {
                    //remove the 'https://graph.facebook.com/v2.3/'
                    nextUrl = [nextUrl substringFromIndex:32];
                    [self getLoopFriendArrayWithToken:nextUrl andCallback:callback];
                }else{
                    callback(friendArray,totalFriendCount);
                }
            }else{
                callback(friendArray,totalFriendCount);
            }
        }];

    }
}
@end
