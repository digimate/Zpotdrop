//
//  MenuProfileTableViewCell.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/2/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"
#import "BaseTableViewCell.h"
@interface MenuProfileTableViewCell : BaseTableViewCell{
    IBOutlet UIImageView* _imgvAvatar;
    IBOutlet UILabel* _lblName;
}
@end
