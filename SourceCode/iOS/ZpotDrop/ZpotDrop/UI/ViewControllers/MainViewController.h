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
#import "LeftMenuViewController.h"
#import "RightNotificationViewController.h"

@interface MainViewController : BaseViewController{
    //Menu view
    BOOL _menuOpening;
    LeftMenuViewController* _leftMenuViewController;
    
    //Notification view
    BOOL _notificationOpening;
    RightNotificationViewController* _rightMenuViewController;
    
    UISwipeGestureRecognizer* swipeRightGesture;
    UISwipeGestureRecognizer* swipeLeftGesture;
}

-(void)openMenu;
-(void)openNotification;
@end
