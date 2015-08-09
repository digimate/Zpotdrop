//
//  FriendRequestZpotCell.h
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface FriendRequestZpotCell : BaseTableViewCell{
    IBOutlet UIImageView* imgvAvatar;
    IBOutlet UILabel* lblName;
    IBOutlet UIButton* btnRequestZpot;
}

@end
