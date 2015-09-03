//
//  ChangePasswordViewCell.h
//  ZpotDrop
//
//  Created by Son Truong on 8/10/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface ChangePasswordViewCell : BaseTableViewCell<UITextFieldDelegate>{
    IBOutlet UILabel* lblChangePass;
    IBOutlet UILabel* lblPassword;
    IBOutlet UILabel* lblNewPassword;
    IBOutlet UILabel* lblNewPasswordConfirm;
    IBOutlet UITextField* tfPassword;
    IBOutlet UITextField* tfNewPassword;
    IBOutlet UITextField* tfNewPasswordConfirm;
    
}
@property(nonatomic,readonly)UITextField * oldPassword;
@property(nonatomic,readonly)UITextField * confirmPassword;
@property(nonatomic,readonly)UITextField * curPasswordTf;
@end
