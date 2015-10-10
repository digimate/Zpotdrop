//
//  SignupViewController.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@interface SignupViewController : BaseViewController <UITextFieldDelegate>
{
//    UIScrollView* _mScrollView;
//    UIImageView* _icon;
    
    IBOutlet UITextField* _email;
    IBOutlet UITextField* _password;
    IBOutlet UITextField* _confirm;
//    UIButton* _continue;
}
@end
