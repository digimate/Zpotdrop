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
    MainViewController* mainViewC = [[MainViewController alloc]init];
    [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:mainViewC] animated:NO completion:nil];

//    if ([AccountModel currentAccountModel].is_login) {
//        [[NSNotificationCenter defaultCenter]removeObserver:self];
//        
//        MainViewController* mainViewC = [[MainViewController alloc]init];
//        [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:mainViewC] animated:NO completion:nil];
//    }else{
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSucceed) name:KEY_LOGIN_SUCCEED object:nil];
//        
//        LoginViewController* lg = [[LoginViewController alloc]init];
//        [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:lg] animated:NO completion:nil];
//    }
}

-(void)loginSucceed{
    [AccountModel currentAccountModel].is_login = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
