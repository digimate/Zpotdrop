//
//  ChangePasswordViewCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/10/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ChangePasswordViewCell.h"
#import "Utils.h"

@implementation ChangePasswordViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    lblChangePass.text = @"change_password".localized.capitalizedString;
    lblNewPassword.text = [NSString stringWithFormat:@"%@:",@"new_password".localized];

    lblNewPasswordConfirm.text = [NSString stringWithFormat:@"%@:",@"new_password_again".localized];

    lblPassword.text = [NSString stringWithFormat:@"%@:",@"password".localized];
    tfNewPassword.text = tfNewPasswordConfirm.text = tfPassword.text = nil;
    tfPassword.delegate = tfNewPasswordConfirm.delegate = tfNewPassword.delegate = self;
    tfNewPassword.returnKeyType = tfPassword.returnKeyType = UIReturnKeyNext;
    tfNewPasswordConfirm.returnKeyType = UIReturnKeyDone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 185;
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == tfPassword) {
        [tfNewPassword becomeFirstResponder];
    }else if (textField == tfNewPassword) {
        [tfNewPasswordConfirm becomeFirstResponder];
    }else{
        [tfNewPasswordConfirm resignFirstResponder];
    }
    return YES;
}
@end
