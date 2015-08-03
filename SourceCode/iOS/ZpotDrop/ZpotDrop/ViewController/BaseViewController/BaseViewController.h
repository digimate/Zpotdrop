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

#define MAIN_COLOR @"b1cb89"

@interface BaseViewController : UIViewController <UIScrollViewDelegate>
{
    RuleService* _rule;
    APIService* _api;
    
    //Menu view
    BOOL _menuOpening;
    UIScrollView* _menuScrollBackground;
    UITableView* _menuContentView;
    UIView* _menuScreenShot;
    UIView* _menuBlurMask;
    
    //Notification view
    BOOL _notificationOpening;
    UIScrollView* _notificationScrollBackground;
    UITableView* _notificationContentView;
    UIView* _notificationScreenShot;
    UIView* _notificationBlurMask;
}

-(void)openMenu;
-(void)openNotification;

@end
