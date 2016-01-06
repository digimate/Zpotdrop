//
//  RightNotificationViewController.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@protocol rightNotificationDelegate <NSObject>

-(void)didPressedOnNotificationWithData:(id)data;
-(void)closeRightNotification;
-(void)showFindViewFromNotification;

@end

@interface RightNotificationViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentSelectedRow;
    UIRefreshControl* _refresh;
    NSMutableArray* _notificationData;
}
+ (RightNotificationViewController *) instance;
-(void)setupData;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) id<rightNotificationDelegate> delegate;

@end
