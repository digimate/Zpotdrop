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
        
        MainViewController* mainViewC = [[MainViewController alloc]init];
        [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:mainViewC] animated:YES completion:nil];
    }else{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSucceed) name:KEY_LOGIN_SUCCEED object:nil];
        
        LoginViewController* lg = [[LoginViewController alloc]init];
        [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:lg] animated:YES completion:nil];
    }
}

-(void)loginSucceed{
    [AccountModel currentAccountModel].access_token = @"1";
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
