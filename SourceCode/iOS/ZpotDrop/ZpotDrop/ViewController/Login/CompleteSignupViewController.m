//
//  CompleteSignupViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "CompleteSignupViewController.h"

@interface CompleteSignupViewController ()

@end

@implementation CompleteSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

-(void)setupLayout
{
    [self.navigationController setNavigationBarHidden:YES];
    
    _mScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [_mScrollView setBackgroundColor:[UIColor whiteColor]];
    [_mScrollView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [self.view addSubview:_mScrollView];
    
    _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon.png"]];
    [_icon setCenter:CGPointMake(_mScrollView.frame.size.width/2, 90 + _icon.frame.size.height/2)];
    [_mScrollView addSubview:_icon];
    
    _firstName = [[UITextField alloc]initWithFrame:CGRectMake(30, _icon.frame.origin.y + _icon.frame.size.height + 50, _mScrollView.frame.size.width - 60, 40)];
    [_firstName setPlaceholder:@"First name"];
    [_firstName setTextAlignment:NSTextAlignmentCenter];
    [_firstName setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_firstName setDelegate:self];
    [_mScrollView addSubview:_firstName];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, _firstName.frame.size.height - 1, _firstName.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_firstName addSubview:line];
    
    _lastName = [[UITextField alloc]initWithFrame:CGRectMake(_firstName.frame.origin.x, _firstName.frame.origin.y + _firstName.frame.size.height, _mScrollView.frame.size.width - 60, 40)];
    [_lastName setPlaceholder:@"Last name"];
    [_lastName setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_lastName setTextAlignment:NSTextAlignmentCenter];
    [_lastName setDelegate:self];
    [_mScrollView addSubview:_lastName];
    
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _lastName.frame.size.height - 1, _lastName.frame.size.width, 1)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_lastName addSubview:line1];
    
    _dob = [[UITextField alloc]initWithFrame:CGRectMake(_lastName.frame.origin.x, _lastName.frame.origin.y + _lastName.frame.size.height, _mScrollView.frame.size.width - 60, 40)];
    [_dob setPlaceholder:@"Date of birth"];
    [_dob setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_dob setTextAlignment:NSTextAlignmentCenter];
    [_dob setDelegate:self];
    [_mScrollView addSubview:_dob];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _dob.frame.size.height - 1, _dob.frame.size.width, 1)];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_dob addSubview:line2];
    
    _male = [UIButton buttonWithType:UIButtonTypeCustom];
    [_male setFrame:CGRectMake(_dob.frame.origin.x, _dob.frame.origin.y + _dob.frame.size.height + 20, _dob.frame.size.width/2, 27)];
    [_male setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
    [_male setTitle:@"Male" forState:UIControlStateNormal];
    [_male setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_male.layer setBorderColor:[UIColor colorWithHexString:@"c9c9c9"].CGColor];
    [_male addTarget:self action:@selector(malePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_male.layer setBorderWidth:1.f];
    [_mScrollView addSubview:_male];
    
    _female = [UIButton buttonWithType:UIButtonTypeCustom];
    [_female setFrame:CGRectMake(_male.frame.origin.x + _male.frame.size.width, _male.frame.origin.y, _dob.frame.size.width/2, 27)];
    [_female setBackgroundColor:[UIColor whiteColor]];
    [_female setTitle:@"Female" forState:UIControlStateNormal];
    [_female.layer setBorderColor:[UIColor colorWithHexString:@"c9c9c9"].CGColor];
    [_female addTarget:self action:@selector(femalePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_female.layer setBorderWidth:1.f];
    [_female setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:UIControlStateNormal];
    [_mScrollView addSubview:_female];
    
    
    _complete = [UIButton buttonWithType:UIButtonTypeCustom];
    [_complete setFrame:CGRectMake(0, _male.frame.origin.y + _male.frame.size.height, _mScrollView.frame.size.width, 60)];
    [_complete setTitle:@"Continue" forState:UIControlStateNormal];
    [_complete.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_complete setTitleColor:[UIColor colorWithHexString:@"b2cc8a"] forState:UIControlStateNormal];
    [_mScrollView addSubview:_complete];
}

-(IBAction)malePressed:(id)sender
{
    [_male setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
    [_male setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_female setBackgroundColor:[UIColor whiteColor]];
    [_female setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:UIControlStateNormal];
}

-(IBAction)femalePressed:(id)sender
{
    [_female setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
    [_female setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_male setBackgroundColor:[UIColor whiteColor]];
    [_male setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 100) animated:YES];
}

@end
