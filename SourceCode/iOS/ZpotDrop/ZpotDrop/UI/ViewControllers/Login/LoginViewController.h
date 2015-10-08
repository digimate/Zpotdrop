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
    IBOutlet UITextField* _email;
    IBOutlet UITextField* _password;
}
@end
