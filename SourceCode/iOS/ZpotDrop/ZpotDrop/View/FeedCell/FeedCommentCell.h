//
//  FeedCommentCell.h
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface FeedCommentCell : BaseTableViewCell{
    IBOutlet UIImageView* _imgvAvatar;
    IBOutlet UILabel* _lblName;
    IBOutlet UILabel* _lblMessage;
    IBOutlet UILabel* _lblTime;
}

@end
