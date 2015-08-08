//
//  RightNotificationViewController.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@protocol rightNotificationDelegate <NSObject>

-(void)didPressedOnNotificationWithAction:(NOTIFICATION_ACTION)command andData:(id)data;
-(void)closeRightNotification;

@end

@interface RightNotificationViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentSelectedRow;
    UIRefreshControl* _refresh;
    NSMutableArray* _notificationData;
}

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) id<rightNotificationDelegate> delegate;

@end
