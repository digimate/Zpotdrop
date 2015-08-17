//
//  FeedNormalViewCell.h
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface FeedNormalViewCell : BaseTableViewCell{
    IBOutlet UIImageView* _imgvAvatar;
    IBOutlet UILabel* _lblName;
    IBOutlet UILabel* _lblZpotAddress;
    IBOutlet UILabel* _lblZpotTitle;
    IBOutlet UILabel* _lblZpotTime;
    IBOutlet UILabel* _lblSpotDistance;
    IBOutlet UILabel* _lblNumberLikes;
    IBOutlet UILabel* _lblNumberComments;
    IBOutlet UIButton* _btnLike;
    IBOutlet UIButton* _btnComment;
    IBOutlet UIButton* _btnComming;
    IBOutlet UIView* _viewButtons;
    IBOutlet NSLayoutConstraint* _lblNumberLikesWidth;
    IBOutlet NSLayoutConstraint* _lblNumberCommentsWidth;
}

@end
