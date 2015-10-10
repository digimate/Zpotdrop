//
//  LoginViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController (){
    UITextField* currentTextField;
}

@end

@implementation LoginViewController


#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Private

- (void)closeKeyboard{
    [currentTextField resignFirstResponder];
}


#pragma mark - IBAction

- (IBAction)loginWithFacebook{
    [[Utils instance]showProgressWithMessage:nil];
    [[FacebookService instance]login:^(BOOL result, NSString *error) {
        if (result) {
            NSString* facebookID = [FBSDKProfile currentProfile].userID;
            [[APIService shareAPIService] loginUserWithFID:facebookID :^(id data, NSString *error) {
                [[Utils instance]hideProgess];
                if (error)
                {
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        
                    }];
                }else{
                    //login success
                    [[NSNotificationCenter defaultCenter]postNotificationName:KEY_LOGIN_SUCCEED object:nil];
                }
            }];
        }else if ([error isEqualToString:@"user_cancel"]){
            [[Utils instance]hideProgess];
            [[FacebookService instance]logout];
        }else if ([error isEqualToString:@"missing_permission"]){
            [[Utils instance]hideProgess];
            [[FacebookService instance]logout];
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"permission_missing".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }else{
            [[Utils instance]hideProgess];
            [[FacebookService instance]logout];
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
    }];
}


- (IBAction)signup:(id)sender
{
    SignupViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)forgot:(id)sender
{
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"forget_password".localized message:@"notice_input_email".localized delegate:nil cancelButtonTitle:@"cancel".localized otherButtonTitles:@"send".localized, nil];
//    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
//    [[alertView textFieldAtIndex:0] setPlaceholder:@"example@example.com"];
//    [alertView showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1)
//        {
//            if (![_rule checkEmailStringIsCorrect:[[alertView textFieldAtIndex:0] text]])
//            {
//                [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_email_format".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                    
//                }];
//                return;
//            }
//            [_api forgotPasswordWithData:@{@"email": [[alertView textFieldAtIndex:0] text]} :^(id data, NSString *error) {
//                if (error)
//                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                    }];
//            }];
//        }
//    }];
    ForgetPasswordViewController* vc = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)login:(id)sender
{
    [self closeKeyboard];
    if (IS_DEBUG) {
        //login success
        [[NSNotificationCenter defaultCenter]postNotificationName:KEY_LOGIN_SUCCEED object:nil];
    }else{
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
        
        [[Utils instance]showProgressWithMessage:nil];
        [_api loginWithData:@{@"email":_email.text, @"password":_password.text} :^(id data, NSString *error) {
            [[Utils instance]hideProgess];
            if (error)
            {
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
            }else{
                //login success
                [[NSNotificationCenter defaultCenter]postNotificationName:KEY_LOGIN_SUCCEED object:nil];
            }
        }];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _email) {
        [_password becomeFirstResponder];
    }else if (textField == _password){
        [_password resignFirstResponder];
    }
    return YES;
}

@end
