//
//  BaseViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _api = [APIService shareAPIService];
    _rule = [RuleService shareRuleService];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:MAIN_COLOR]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
