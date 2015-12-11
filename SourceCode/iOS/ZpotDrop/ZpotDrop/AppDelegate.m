//
//  AppDelegate.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "CoreDataService.h"
#import "Utils.h"
#import "APIService.h"
@import GoogleMaps;

@interface AppDelegate ()<CLLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"ppZUHCYYoJNe1V6ZpAdJfOzJ6vL6mWKKll3V8MM4" clientKey:@"sBpKO7QEP3jLS73hSoMAB8NyObATl7vlo4e0qLfC"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [[CoreDataService instance] setDatabaseName:@"zpotdrop"];
    [Utils instance].locationManager.delegate = self;
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:MAIN_COLOR]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
        NSFontAttributeName: [UIFont fontWithName:@"PTSans-Regular" size:0.0],
                                                           }];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    if (launchOptions != nil) {
        // Launched from push notification
        NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"Notification : %@",notification);
        
        if ([AccountModel currentAccountModel].isLoggedIn) {
            [self handleRequestLocation:notification];
        }
    }
    
    [GMSServices provideAPIKey:@"AIzaSyDQYtsThC5qIgZUZdKoTWjVQafhFlzJCWw"];
    

    return [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Notification : %@",userInfo);
    /*
     {
     aps =     {
     alert = "Tune in for the World Series, tonight at 8pm EDT";
     };
     "user_id" = Increment;
     }
     
     */
    if ([AccountModel currentAccountModel].isLoggedIn) {
        [self handleRequestLocation:userInfo];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[FBSDKApplicationDelegate sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [Utils instance].mapView.showsUserLocation = NO;
    [[Utils instance].locationManager stopUpdatingLocation];
    [[CoreDataService instance]saveContext];
    static UIBackgroundTaskIdentifier backgroundTask;
    backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    [[APIService shareAPIService]updateUserInfoToServerWithID:[AccountModel currentAccountModel].user_id params:@{@"device_token":token} completion:^(BOOL success, NSString *error) {
        
    }];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation[@"user_id"] = [AccountModel currentAccountModel].user_id;
    [currentInstallation saveInBackground];
    
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CoreDataService instance]saveContext];
}

-(void)handleRequestLocation:(NSDictionary*)dict{
    NSDictionary *alertDict = [dict objectForKey:@"aps"];
    [[Utils instance]showAlertWithTitle:@"ZpotDrop" message:[alertDict objectForKey:@"alert"] yesTitle:@"OK" noTitle:@"NO" handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            
            if ([[Utils instance] isGPS]){
                [Utils instance].locationManager.delegate = self;
                [[Utils instance].locationManager startUpdatingLocation];
            }else{
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }
            
            // Push notification back
            [[APIService shareAPIService] notifyLocationToUserID:[dict objectForKey:@"user_id"] completion:^(BOOL successful, NSString *error) {
                if (error) {
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
            }];
        }
    }];
}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations.count > 0) {
        CLLocation* loc = [locations lastObject];
        [[APIService shareAPIService]updateUserInfoToServerWithID:[AccountModel currentAccountModel].user_id params:@{@"latitude":@(loc.coordinate.latitude),@"longitude" : @(loc.coordinate.longitude),@"updated_loc":[NSDate date]} completion:^(BOOL success, NSString *error) {
            
        }];
    }
    [manager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error.description yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    }];
    [manager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }else{
        [manager stopUpdatingLocation];
    }
}
@end
