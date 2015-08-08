//
//  BaseViewController.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuleService.h"
#import "APIService.h"
#import "Utils.h"
#import "UINavigationBar+FixedHeightWhenStatusBarHidden.h"

@interface BaseViewController : UIViewController
{
    RuleService* _rule;
    APIService* _api;
}


@end
