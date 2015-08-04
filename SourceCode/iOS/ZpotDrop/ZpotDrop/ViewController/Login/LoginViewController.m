//
//  LoginViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(didShow:) name:UIKeyboardWillShowNotification object:nil];
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

-(void)setupLayout
{
    [self.navigationController setNavigationBarHidden:YES];
    
    _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [_mScrollView setBackgroundColor:[UIColor whiteColor]];
    [_mScrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [self.view addSubview:_mScrollView];
    
    _signup = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signup setFrame:CGRectMake(0, _mScrollView.frame.size.height - 30 - 15, self.view.frame.size.width/2, 15)];
    [_signup setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_signup.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:12.f]];
    [_signup setTitle:@"Not yet on zpotdrop?" forState:UIControlStateNormal];
    [_signup setTitleColor:[UIColor colorWithHexString:@"d9d9d9"] forState:UIControlStateNormal];
    [_signup addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_signup];
    
    _forgot = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgot setFrame:CGRectMake(self.view.frame.size.width/2, _signup.frame.origin.y, self.view.frame.size.width/2, 15)];
    [_forgot setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_forgot.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:12.f]];
    [_forgot setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [_forgot setTitleColor:[UIColor colorWithHexString:@"d9d9d9"] forState:UIControlStateNormal];
    [_forgot addTarget:self action:@selector(forgot:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_forgot];
    
    _continue = [UIButton buttonWithType:UIButtonTypeCustom];
    [_continue setFrame:CGRectMake(0, _signup.frame.origin.y - 35 - 60, _mScrollView.frame.size.width, 60)];
    [_continue setTitle:@"Continue" forState:UIControlStateNormal];
    [_continue.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_continue setTitleColor:[UIColor colorWithHexString:@"b2cc8a"] forState:UIControlStateNormal];
    [_continue addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_continue];
    
    _password = [[UITextField alloc]initWithFrame:CGRectMake(30, _continue.frame.origin.y - 40, _mScrollView.frame.size.width - 60, 40)];
    [_password setSecureTextEntry:YES];
    [_password setPlaceholder:@"Password"];
    [_password setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_password setTextAlignment:NSTextAlignmentCenter];
    [_password setDelegate:self];
    [_mScrollView addSubview:_password];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, _password.frame.size.height - 1, _password.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_password addSubview:line];
    
    _email = [[UITextField alloc]initWithFrame:CGRectMake(_password.frame.origin.x, _password.frame.origin.y - _password.frame.size.height, _password.frame.size.width, _password.frame.size.height)];
    [_email setPlaceholder:@"Email or phone number"];
    [_email setTextAlignment:NSTextAlignmentCenter];
    [_email setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_email setDelegate:self];
    [_mScrollView addSubview:_email];
    
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _email.frame.size.height - 1, _email.frame.size.width, 1)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_email addSubview:line1];
    
    _name = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"name.png"]];
    CGRect nameFrame = _name.frame;
    nameFrame.origin.y = _email.frame.origin.y - 50 - nameFrame.size.height;
    nameFrame.origin.x = _mScrollView.frame.size.width/2 - nameFrame.size.width/2;
    [_name setFrame:nameFrame];
    [_mScrollView addSubview:_name];
    
    _welcome = [[UILabel alloc]initWithFrame:CGRectMake(0, _name.frame.origin.y - 60, _mScrollView.frame.size.width, 60)];
    [_welcome setFont:[UIFont fontWithName:@"PTSans-Regular" size:35.f]];
    [_welcome setTextColor:[UIColor blackColor]];
    [_welcome setText:@"Welcome to"];
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
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 100) animated:YES];
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
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Forgot password ?" message:@"Please enter your email" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    [[alertView textFieldAtIndex:0] setPlaceholder:@"example@example.com"];
    [alertView showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            if (![_rule checkEmailStringIsCorrect:[[alertView textFieldAtIndex:0] text]])
            {
                [[[UIAlertView alloc]initWithTitle:@"We're sorry" message:@"Your email is not correct format" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            }
            [_api forgotPasswordWithData:@{@"email": [[alertView textFieldAtIndex:0] text]} :^(id data, NSString *error) {
                if (error)
                    [[[UIAlertView alloc]initWithTitle:@"We're sorry" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }];
        }
    }];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)login:(id)sender
{
    [_api loginWithData:@{@"email":_email.text, @"password":_password.text} :^(id data, NSString *error) {
        if (error)
        {
            [[[UIAlertView alloc]initWithTitle:@"We're sorry" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
