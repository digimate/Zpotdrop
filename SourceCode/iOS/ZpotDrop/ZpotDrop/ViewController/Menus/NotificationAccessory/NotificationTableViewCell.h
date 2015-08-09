//
//  NotificationTableViewCell.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"

typedef void(^notifiactionCellHandler)(id data, NOTIFICATION_ACTION action);

@interface NotificationTableViewCell : UITableViewCell <UIScrollViewDelegate>
{
    UIScrollView* _mScrollView;
    UIImageView* _avatarImage;
    UILabel* _username;
    UILabel* _content;
    UILabel* _time;
    UIButton* _location;
    UIButton* _add;
    id _data;
    
    notifiactionCellHandler _handler;
}

-(void)setupCellWithData:(NotificationModel*)data inSize:(CGSize)size andHandler:(notifiactionCellHandler)handler;
-(void)scrollBack;

@end
