//
//  NotificationTableViewCell.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"
#import "BaseTableViewCell.h"
//typedef void(^notifiactionCellHandler)(id data, NOTIFICATION_ACTION action);

@interface NotificationTableViewCell : BaseTableViewCell <UIScrollViewDelegate>
{
    UIScrollView* _mScrollView;
    UIImageView* _avatarImage;
    UILabel* _content;
    UIView* viewButtons;
}
@property(nonatomic,copy)void(^onShowPost)(NotificationModel*notif);
@property(nonatomic,copy)void(^onFollowUser)(NotificationModel*notif);
@property(nonatomic,copy)void(^onUnFollowUser)(NotificationModel*notif);
-(void)scrollBack;

@end
