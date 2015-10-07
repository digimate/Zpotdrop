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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(didShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(IBAction)didShow:(id)sender
{
    NSDictionary* keyboardInfo = [sender userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [_mScrollView setContentSize:CGSizeMake(0,keyboardFrameBeginRect.size.height + _signup.y + _signup.height + 10)];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(IBAction)didHide:(id)sender
{
    [_mScrollView setContentSize:CGSizeMake(0, _signup.y + _signup.height + 10)];
    [_mScrollView setContentSize:CGSizeMake(0, 0)];
}

-(void)setupLayout
{
    [self.navigationController setNavigationBarHidden:YES];
    
    _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [_mScrollView setBackgroundColor:[UIColor whiteColor]];
    [_mScrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [self.view addSubview:_mScrollView];
    
    _signup = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signup setFrame:CGRectMake(0, _mScrollView.frame.size.height - 30, self.view.frame.size.width/2, 15)];
    [_signup setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_signup.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:12.f]];
    [_signup setTitle:@"no_zpotdrop_account".localized forState:UIControlStateNormal];
    [_signup setTitleColor:[UIColor colorWithHexString:@"d9d9d9"] forState:UIControlStateNormal];
    [_signup addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_signup];
    
    _forgot = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgot setFrame:CGRectMake(self.view.frame.size.width/2, _signup.frame.origin.y, self.view.frame.size.width/2, 15)];
    [_forgot setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_forgot.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:12.f]];
    [_forgot setTitle:@"forget_password".localized forState:UIControlStateNormal];
    [_forgot setTitleColor:[UIColor colorWithHexString:@"d9d9d9"] forState:UIControlStateNormal];
    [_forgot addTarget:self action:@selector(forgot:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_forgot];
    
    _continue = [UIButton buttonWithType:UIButtonTypeCustom];
    [_continue setFrame:CGRectMake(0, _signup.frame.origin.y - 35 - 100, _mScrollView.frame.size.width, 60)];
    [_continue setTitle:@"continue".localized forState:UIControlStateNormal];
    [_continue.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_continue setTitleColor:[UIColor colorWithHexString:@"b2cc8a"] forState:UIControlStateNormal];
    [_continue addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_continue];
    
    _password = [[UITextField alloc]initWithFrame:CGRectMake(30, _continue.frame.origin.y - 40, _mScrollView.frame.size.width - 60, 40)];
    [_password setSecureTextEntry:YES];
    [_password setPlaceholder:@"password".localized];
    [_password setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_password setTextAlignment:NSTextAlignmentCenter];
    [_password setDelegate:self];
    [_password setReturnKeyType:UIReturnKeyDone];
    [_mScrollView addSubview:_password];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, _password.frame.size.height - 1, _password.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_password addSubview:line];
    
    _email = [[UITextField alloc]initWithFrame:CGRectMake(_password.frame.origin.x, _password.frame.origin.y - _password.frame.size.height, _password.frame.size.width, _password.frame.size.height)];
    [_email setPlaceholder:@"place_holder_username".localized];
    [_email setTextAlignment:NSTextAlignmentCenter];
    [_email setKeyboardType:UIKeyboardTypeEmailAddress];
    [_email setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_email setDelegate:self];
    [_email setReturnKeyType:UIReturnKeyNext];
    [_email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_mScrollView addSubview:_email];
    
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _email.frame.size.height - 1, _email.frame.size.width, 1)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_email addSubview:line1];
    
    _name = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"name.png"]];
    CGRect nameFrame = _name.frame;
    nameFrame.origin.y = _email.frame.origin.y - 30 - nameFrame.size.height;
    nameFrame.origin.x = _mScrollView.frame.size.width/2 - nameFrame.size.width/2;
    [_name setFrame:nameFrame];
    [_mScrollView addSubview:_name];
    
    _welcome = [[UILabel alloc]initWithFrame:CGRectMake(0, _name.frame.origin.y - 40, _mScrollView.frame.size.width, 60)];
    [_welcome setFont:[UIFont fontWithName:@"PTSans-Regular" size:35.f]];
    [_welcome setTextColor:[UIColor blackColor]];
    [_welcome setText:@"welcome".localized];
    [_welcome setTextAlignment:NSTextAlignmentCenter];
    [_mScrollView addSubview:_welcome];
    
    _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon.png"]];
    float delta = 0;
    if (_mScrollView.frame.size.height < 500)
    {
        delta = 20;
    }
    [_icon setCenter:CGPointMake(_mScrollView.frame.size.width/2, 90*_mScrollView.frame.size.height/1136.f + _icon.frame.size.height/2 - delta)];
    [_mScrollView addSubview:_icon];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(_email.x, _continue.y + _continue.height + 10, _email.frame.size.width, 1)];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_mScrollView addSubview:line2];
    
    UILabel* lblOr = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 16)];
    lblOr.backgroundColor = [UIColor whiteColor];
    lblOr.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    lblOr.textColor = line2.backgroundColor;
    lblOr.textAlignment = NSTextAlignmentCenter;
    lblOr.text = @"or".localized.uppercaseString;
    lblOr.center = CGPointMake(line2.width/2, line2.height/2);
    [line2 addSubview:lblOr];
    
    UIButton* btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFacebook.frame = CGRectMake(_continue.x, line2.y + line2.height + 10, _continue.width, 20);
    [btnFacebook setImage:[UIImage imageNamed:@"ic_facebook2"] forState:UIControlStateNormal];
    [[btnFacebook titleLabel]setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
    [btnFacebook setTitle:@"login_facebook".localized forState:UIControlStateNormal];
    [btnFacebook setTitleColor:line2.backgroundColor forState:UIControlStateNormal];
    [btnFacebook setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnFacebook setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
    [btnFacebook addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:btnFacebook];
    
    
    [_mScrollView setContentSize:CGSizeMake(0, _signup.y + _signup.height + 10)];
}

-(void)loginWithFacebook{
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

-(void)closeKeyboard{
    [currentTextField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 100) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _email) {
        [_password becomeFirstResponder];
    }else if (textField == _password){
        [_password resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signup:(id)sender
{
    SignupViewController* vc = [[SignupViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)forgot:(id)sender
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

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)login:(id)sender
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
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
