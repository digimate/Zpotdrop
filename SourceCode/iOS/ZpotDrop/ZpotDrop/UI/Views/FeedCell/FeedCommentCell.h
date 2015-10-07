//
//  FeedCommentCell.h
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "SCSkypeActivityIndicatorView.h"

@interface FeedCommentCell : BaseTableViewCell{
    IBOutlet UIImageView* _imgvAvatar;
    IBOutlet UILabel* _lblName;
    IBOutlet UILabel* _lblMessage;
    IBOutlet UILabel* _lblTime;
    IBOutlet UIView* _viewSending;
    IBOutlet SCSkypeActivityIndicatorView* _indicatorView;
    IBOutlet UIButton * _btnRetry;
    IBOutlet UIButton * _btnDelete;
}
@property(nonatomic, readonly)UILabel * lblName;
@property(nonatomic, copy)void(^onDeleteComment)();
@end
