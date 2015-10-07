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
    [_mScrollView setContentSize:CGSizeMake(0,keyboardFrameBeginRect.size.height + _continue.y + _continue.height + 10)];

}

-(IBAction)didHide:(id)sender
{
    [_mScrollView setContentSize:CGSizeMake(0, _continue.y + _continue.height + 10)];
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
    
    UILabel* lblForget = [[UILabel alloc]initWithFrame:CGRectMake(10, _icon.frame.origin.y + _icon.frame.size.height + 40, _mScrollView.width - 20, 20)];
    lblForget.font = [UIFont fontWithName:@"PTSans-Bold" size:18];
    lblForget.textAlignment = NSTextAlignmentCenter;
    lblForget.textColor = [UIColor colorWithHexString:@"c9c9c9"];
    lblForget.text = @"forget_pass".localized;
    [_mScrollView addSubview:lblForget];
    
    _email = [[UITextField alloc]initWithFrame:CGRectMake(30, lblForget.frame.origin.y + lblForget.frame.size.height + 20, _mScrollView.frame.size.width - 60, 40)];
    [_email setPlaceholder:@"Email"];
    [_email setTextAlignment:NSTextAlignmentCenter];
    [_email setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_email setDelegate:self];
    [_mScrollView addSubview:_email];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, _email.frame.size.height - 1, _email.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_email addSubview:line];
    
    _continue = [UIButton buttonWithType:UIButtonTypeCustom];
    [_continue setFrame:CGRectMake(0, _email.frame.origin.y + _email.frame.size.height, _mScrollView.frame.size.width, 60)];
    [_continue setTitle:@"send".localized forState:UIControlStateNormal];
    [_continue.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_continue setTitleColor:[UIColor colorWithHexString:@"b2cc8a"] forState:UIControlStateNormal];
    [_continue addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_continue];
    
    [_mScrollView setContentSize:CGSizeMake(0, _continue.y + _continue.height + 10)];
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
