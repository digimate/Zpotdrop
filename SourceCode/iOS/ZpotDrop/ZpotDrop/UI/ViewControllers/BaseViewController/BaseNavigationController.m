//
//  BaseNavigationController.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MainViewController.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:16];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName              : font,
                                               NSForegroundColorAttributeName   : [UIColor whiteColor]};
}

@end
