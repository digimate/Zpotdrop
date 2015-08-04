//
//  BaseViewController.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HexColors.h"
#import "UIAlertView+Blocks.h"
#import "NSDate+Helper.h"
#import "RuleService.h"
#import "APIService.h"
#import "UINavigationBar+FixedHeightWhenStatusBarHidden.h"
#define MAIN_COLOR @"b1cb89"

@interface BaseViewController : UIViewController
{
    RuleService* _rule;
    APIService* _api;
}


@end
