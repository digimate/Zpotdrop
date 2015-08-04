//
//  MainViewController.h
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HexColors.h"
#import "UIAlertView+Blocks.h"
#import "NSDate+Helper.h"
#import "BaseViewController.h"
@interface MainViewController : BaseViewController{
    //Menu view
    BOOL _menuOpening;
    UIView* _menuBackground;
    UITableView* _menuContentView;

    
    //Notification view
    BOOL _notificationOpening;
    UIView* _notificationBackground;
    UITableView* _notificationContentView;
}

-(void)openMenu;
-(void)openNotification;
@end
