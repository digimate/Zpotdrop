//
//  UserProfileCell.h
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface UserProfileCell : BaseTableViewCell<UITextFieldDelegate>{
    IBOutlet UILabel* lblFirstName;
    IBOutlet UILabel* lblLastName;
    IBOutlet UILabel* lblHomeTown;
    IBOutlet UILabel* lblDOB;
    IBOutlet UILabel* lblEmail;
    IBOutlet UILabel* lblPhone;
    IBOutlet UITextField* tfFirstName;
    IBOutlet UITextField* tfLastName;
    IBOutlet UITextField* tfEmail;
    IBOutlet UITextField* tfPhone;
    IBOutlet UITextField* tfDOB;
    IBOutlet UITextField* tfHomeTown;
    IBOutlet UIButton * btnEditPicture;
    IBOutlet UIImageView* imgvAvatar;
    UIDatePicker* datePicker;
}

@end
