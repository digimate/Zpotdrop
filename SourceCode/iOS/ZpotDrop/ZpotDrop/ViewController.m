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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (![AccountModel currentAccountModel].is_login) {
        MainViewController* mainViewC = [[MainViewController alloc]init];
        [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:mainViewC] animated:YES completion:nil];
    }else{
        LoginViewController* lg = [[LoginViewController alloc]init];
        [self presentViewController:[[BaseNavigationController alloc] initWithRootViewController:lg] animated:YES completion:nil];
    }
}

@end
