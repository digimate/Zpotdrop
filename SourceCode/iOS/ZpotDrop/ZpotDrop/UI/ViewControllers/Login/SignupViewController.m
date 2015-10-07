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
    [self setupLayout];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(didShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

-(void)closeKeyboard{
    [currentTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)didShow:(id)sender
{
    NSDictionary* keyboardInfo = [sender userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [_mScrollView setContentSize:CGSizeMake(0, keyboardFrameBeginRect.size.height + _mScrollView.frame.size.height)];
}

-(IBAction)didHide:(id)sender
{
    [_mScrollView setContentSize:CGSizeMake(0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.view.frame;
    _mScrollView = [[UIScrollView alloc]initWithFrame:frame];
    [_mScrollView setBackgroundColor:[UIColor whiteColor]];
    [_mScrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [self.view addSubview:_mScrollView];
    
    _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon.png"]];
    [_icon setCenter:CGPointMake(_mScrollView.frame.size.width/2, 90 + _icon.frame.size.height/2)];
    [_mScrollView addSubview:_icon];
    
    _email = [[UITextField alloc]initWithFrame:CGRectMake(30, _icon.frame.origin.y + _icon.frame.size.height + 50, _mScrollView.frame.size.width - 60, 40)];
    [_email setPlaceholder:@"Email"];
    [_email setTextAlignment:NSTextAlignmentCenter];
    [_email setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_email setDelegate:self];
    [_mScrollView addSubview:_email];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, _email.frame.size.height - 1, _email.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_email addSubview:line];
    
    _password = [[UITextField alloc]initWithFrame:CGRectMake(_email.frame.origin.x, _email.frame.origin.y + _email.frame.size.height, _mScrollView.frame.size.width - 60, 40)];
    [_password setSecureTextEntry:YES];
    [_password setPlaceholder:@"password".localized];
    [_password setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_password setTextAlignment:NSTextAlignmentCenter];
    [_password setDelegate:self];
    [_mScrollView addSubview:_password];
    
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _password.frame.size.height - 1, _password.frame.size.width, 1)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_password addSubview:line1];
    
    _confirm = [[UITextField alloc]initWithFrame:CGRectMake(_password.frame.origin.x, _password.frame.origin.y + _password.frame.size.height, _mScrollView.frame.size.width - 60, 40)];
    [_confirm setSecureTextEntry:YES];
    [_confirm setPlaceholder:@"confirm_password".localized];
    [_confirm setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_confirm setTextAlignment:NSTextAlignmentCenter];
    [_confirm setDelegate:self];
    [_mScrollView addSubview:_confirm];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _password.frame.size.height - 1, _password.frame.size.width, 1)];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_confirm addSubview:line2];
    
    _continue = [UIButton buttonWithType:UIButtonTypeCustom];
    [_continue setFrame:CGRectMake(0, _confirm.frame.origin.y + _confirm.frame.size.height, _mScrollView.frame.size.width, 60)];
    [_continue setTitle:@"continue".localized forState:UIControlStateNormal];
    [_continue.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_continue setTitleColor:[UIColor colorWithHexString:@"b2cc8a"] forState:UIControlStateNormal];
    [_continue addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_continue];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 100) animated:YES];
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
