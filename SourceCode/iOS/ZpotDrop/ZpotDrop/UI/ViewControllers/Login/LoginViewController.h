//
//  LoginViewController.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate>
{
    UIScrollView* _mScrollView;
    UIImageView* _icon;
    UILabel* _welcome;
    UIImageView* _name;
    UITextField* _email;
    UITextField* _password;
    UIButton* _continue;
    UIButton* _signup;
    UIButton* _forgot;
}
@end
