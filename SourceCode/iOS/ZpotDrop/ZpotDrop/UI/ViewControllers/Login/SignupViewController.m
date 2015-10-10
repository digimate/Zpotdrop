//
//  SignupViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "SignupViewController.h"
#import "CompleteSignupViewController.h"

@interface SignupViewController (){
    UITextField* currentTextField;
}

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)closeKeyboard{
    [self.view endEditing:YES];
}

- (IBAction)next:(id)sender
{
    [self closeKeyboard];
    if (![_rule checkEmailStringIsCorrect:_email.text])
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_email_format".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [_email setText:@""];
            [_email becomeFirstResponder];
        }];
        return;
    }
    if ([_password.text length] < 3)
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_password_length".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [_password setText:@""];
            [_password becomeFirstResponder];
        }];
        return;
    }
    
    if (![_confirm.text isEqualToString:_password.text])
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_passwords_not_match".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [_confirm setText:@""];
            [_confirm becomeFirstResponder];
        }];
        return;
    }
    [[Utils instance] showProgressWithMessage:nil];
    [[APIService shareAPIService] checkIsExistUsername:_email.text completion:^(BOOL isExist) {
        [[Utils instance]hideProgess];
        if (isExist) {
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_exist_email".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }else{
            CompleteSignupViewController* vc = [[CompleteSignupViewController alloc]init];
            vc.data = [NSMutableDictionary dictionaryWithObjects:@[_email.text, _password.text] forKeys:@[@"email", @"password"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
  
}
@end
