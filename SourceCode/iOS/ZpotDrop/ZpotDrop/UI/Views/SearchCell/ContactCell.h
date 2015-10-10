//
//  ContactCell.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"
#import "BaseTableViewCell.h"

@interface ContactCell : BaseTableViewCell
{
    UIImageView* _avatar;
    UILabel* _username;
    UIButton* _folow;
    BOOL _isFollowing;
}

@end