//
//  ViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton setImage:[UIImage imageNamed:@"item_menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    UIButton* notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton setFrame:CGRectMake(0, 0, 30, 30)];
    [notificationButton setImage:[UIImage imageNamed:@"item_notification.png"] forState:UIControlStateNormal];
    [notificationButton addTarget:self action:@selector(notificationPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* notificationItem = [[UIBarButtonItem alloc]initWithCustomView:notificationButton];
    self.navigationItem.rightBarButtonItem = notificationItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    //LoginViewController* lg = [[LoginViewController alloc]init];
    //[self presentViewController:[[UINavigationController alloc] initWithRootViewController:lg] animated:YES completion:nil];
}

- (IBAction)menuPressed:(id)sender {
    [self openMenu];
}

-(IBAction)notificationPressed:(id)sender
{
    [self openNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
