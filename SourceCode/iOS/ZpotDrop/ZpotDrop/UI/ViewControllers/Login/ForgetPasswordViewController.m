//
//  ForgetPasswordViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>{
    UITextField* currentTextField;
}

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)closeKeyboard{
    [self.view endEditing:YES];
}

-(IBAction)next:(id)sender
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
    [[Utils instance] showProgressWithMessage:nil];
    //send forget password
    [_api forgotPasswordWithData:@{@"email": _email.text} :^(id data, NSString *error) {
        [[Utils instance]hideProgess];
        if (error){
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

@end
