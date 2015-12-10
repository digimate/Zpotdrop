//
//  ViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "AccountModel.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "Utils.h"
#import "CoreDataService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([[AccountModel currentAccountModel] isLoggedIn]) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self registerDeviceToken];
        MainViewController* mainViewC = [[MainViewController alloc]init];
        [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:mainViewC] animated:YES completion:nil];
    }else{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSucceed) name:KEY_LOGIN_SUCCEED object:nil];
        
        LoginViewController* lg = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        BaseNavigationController* navigation = [[BaseNavigationController alloc] initWithRootViewController:lg];
        navigation.navigationBar.tintColor = [UIColor lightGrayColor];
        navigation.navigationBar.barTintColor = [UIColor lightGrayColor];
        [navigation.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        [navigation.navigationBar setBackgroundColor:[UIColor clearColor]];
        navigation.navigationBar.shadowImage = [[UIImage alloc]init];
        [self presentViewController:navigation animated:YES completion:nil];
    }
}

-(void)registerDeviceToken{
#ifdef __IPHONE_8_0
    // Register for Push Notification
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
}

-(void)loginSucceed{
    [AccountModel currentAccountModel].access_token = @"1";
    [[CoreDataService instance] saveContext];
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
