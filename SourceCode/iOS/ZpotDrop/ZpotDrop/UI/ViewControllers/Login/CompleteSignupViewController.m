//
//  CompleteSignupViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "CompleteSignupViewController.h"

@interface CompleteSignupViewController (){
    UITextField* currentTextField;
}

@end

@implementation CompleteSignupViewController

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

-(IBAction)didShow:(id)sender
{
    NSDictionary* keyboardInfo = [sender userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    [_mScrollView setContentSize:CGSizeMake(0, keyboardFrameBeginRect.size.height + _complete.y + _complete.height + 20)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)didHide:(id)sender
{
    [_mScrollView setContentSize:CGSizeMake(0, _complete.y + _complete.height + 20)];
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    
    _firstName = [[UITextField alloc]initWithFrame:CGRectMake(30, _icon.frame.origin.y + _icon.frame.size.height + 50, _mScrollView.frame.size.width - 60, 40)];
    [_firstName setPlaceholder:@"first_name".localized];
    [_firstName setTextAlignment:NSTextAlignmentCenter];
    [_firstName setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_firstName setDelegate:self];
    [_mScrollView addSubview:_firstName];
    
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, _firstName.frame.size.height - 1, _firstName.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_firstName addSubview:line];
    
    _lastName = [[UITextField alloc]initWithFrame:CGRectMake(_firstName.frame.origin.x, _firstName.frame.origin.y + _firstName.frame.size.height, _mScrollView.frame.size.width - 60, 40)];
    [_lastName setPlaceholder:@"last_name".localized];
    [_lastName setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_lastName setTextAlignment:NSTextAlignmentCenter];
    [_lastName setDelegate:self];
    [_mScrollView addSubview:_lastName];
    
    UILabel* line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _lastName.frame.size.height - 1, _lastName.frame.size.width, 1)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_lastName addSubview:line1];
    
    _phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(_lastName.frame.origin.x, _lastName.frame.origin.y + _lastName.frame.size.height, _mScrollView.frame.size.width - 60, 40)];
    [_phoneNumber setPlaceholder:@"phone_number".localized];
    [_phoneNumber setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_phoneNumber setTextAlignment:NSTextAlignmentCenter];
    [_phoneNumber setDelegate:self];
    [_mScrollView addSubview:_phoneNumber];
    
    UILabel* line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, _phoneNumber.frame.size.height - 1, _phoneNumber.frame.size.width, 1)];
    [line3 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNumber addSubview:line3];
    
    _dob = [[DateTextField alloc]initWithFrame:CGRectMake(_phoneNumber.frame.origin.x, _phoneNumber.frame.origin.y + _phoneNumber.frame.size.height, _mScrollView.frame.size.width - 60, 40) date:[NSDate date] andDisplayFormat:DATE_FORMAT_MONTH_IN_LETTER];
    [_dob setPlaceholder:@"birthday".localized];
    [_dob setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_dob setTextAlignment:NSTextAlignmentCenter];
    [_dob setDelegate:self];
    [_mScrollView addSubview:_dob];
    
    UILabel* line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _dob.frame.size.height - 1, _dob.frame.size.width, 1)];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [_dob addSubview:line2];
    
    UILabel* lblMale = [[UILabel alloc]initWithFrame:CGRectMake(_dob.x + 20, _dob.y + _dob.height + 10, 40, 20)];
    lblMale.font = [UIFont fontWithName:@"PTSans-Regular" size:18];
    lblMale.textColor = COLOR_DARK_GREEN;
    lblMale.text = @"male".localized;
    [_mScrollView addSubview:lblMale];
    
    UILabel* lblFemale = [[UILabel alloc]initWithFrame:CGRectMake(_dob.x , _dob.y + _dob.height + 10, _dob.width, 20)];
    lblFemale.textAlignment = NSTextAlignmentRight;
    lblFemale.font = [UIFont fontWithName:@"PTSans-Regular" size:18];
    lblFemale.textColor = COLOR_DARK_GREEN;
    lblFemale.text = @"female".localized;
    [_mScrollView addSubview:lblFemale];
    
//    _male = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_male setFrame:CGRectMake(_dob.frame.origin.x, _dob.frame.origin.y + _dob.frame.size.height + 20, _dob.frame.size.width/2, 27)];
//    [_male setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
//    [_male setTitle:@"male".localized forState:UIControlStateNormal];
//    [_male setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_male.layer setBorderColor:[UIColor colorWithHexString:@"c9c9c9"].CGColor];
//    [_male addTarget:self action:@selector(malePressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_male.layer setBorderWidth:1.f];
//    [_mScrollView addSubview:_male];
//_gender = YES;
    
    _genderSlider = [[UISlider alloc]initWithFrame:CGRectMake(_dob.x + 20, _dob.frame.origin.y + _dob.frame.size.height + 20 + lblMale.height, _dob.width - 40, 20)];
    _genderSlider.maximumValue = 2;
    _genderSlider.minimumValue = 0;
    _genderSlider.value = 1;
    _genderSlider.maximumTrackTintColor = [UIColor whiteColor];
    _genderSlider.minimumTrackTintColor = [UIColor whiteColor];
    [_genderSlider addTarget:self action:@selector(genderValueChanged) forControlEvents:UIControlEventTouchUpInside];
    [_genderSlider setThumbImage:[[UIImage alloc]init] forState:UIControlStateNormal];
    _genderSlider.thumbTintColor = COLOR_DARK_GREEN;
    [_mScrollView addSubview:_genderSlider];
    
//    _female = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_female setFrame:CGRectMake(_male.frame.origin.x + _male.frame.size.width, _male.frame.origin.y, _dob.frame.size.width/2, 27)];
//    [_female setBackgroundColor:[UIColor whiteColor]];
//    [_female setTitle:@"female".localized forState:UIControlStateNormal];
//    [_female.layer setBorderColor:[UIColor colorWithHexString:@"c9c9c9"].CGColor];
//    [_female addTarget:self action:@selector(femalePressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_female.layer setBorderWidth:1.f];
//    [_female setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:UIControlStateNormal];
  //  [_mScrollView addSubview:_female];
    
    
    _complete = [UIButton buttonWithType:UIButtonTypeCustom];
    [_complete setFrame:CGRectMake(0, _genderSlider.frame.origin.y + _genderSlider.frame.size.height, _mScrollView.frame.size.width, 60)];
    [_complete setTitle:@"sign_up".localized forState:UIControlStateNormal];
    [_complete.titleLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:20.f]];
    [_complete setTitleColor:[UIColor colorWithHexString:@"b2cc8a"] forState:UIControlStateNormal];
    [_complete addTarget:self action:@selector(completePressed:) forControlEvents:UIControlEventTouchUpInside];
    [_mScrollView addSubview:_complete];
    
    [_mScrollView setContentSize:CGSizeMake(0, _complete.y + _complete.height + 20)];
}

-(void)genderValueChanged{
    _genderSlider.value = roundf(_genderSlider.value);
}

-(IBAction)completePressed:(id)sender
{
    [self closeKeyboard];
    if (IS_DEBUG) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KEY_LOGIN_SUCCEED object:nil];
    }else{
        if ([[_firstName.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
        {
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_first_name".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [_firstName becomeFirstResponder];
            }];
            return;
        }
        
        if ([[_lastName.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
        {
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_last_name".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [_lastName becomeFirstResponder];
            }];
            return;
        }
        
        [_data setObject:_firstName.text forKey:@"firstName"];
        [_data setObject:_lastName.text forKey:@"lastName"];
        [_data setObject:_dob.getDate forKey:@"dob"];
        [_data setObject:_phoneNumber.text forKey:@"phoneNumber"];
        [_data setObject:@"" forKey:@"facebook_id"];
        [_data setObject:@"" forKey:@"hometown"];
        [_data setObject:[NSNumber numberWithInt:_genderSlider.value] forKey:@"gender"];
        [[Utils instance]showProgressWithMessage:nil];
        [_api createAccountWithData:_data :^(id data, NSString *error) {
            [[Utils instance]hideProgess];
            if (data) {
                [[NSNotificationCenter defaultCenter]postNotificationName:KEY_LOGIN_SUCCEED object:nil];
            }else{
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];

            }
        }];
    }
}

-(IBAction)malePressed:(id)sender
{
    [_male setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
    [_male setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_female setBackgroundColor:[UIColor whiteColor]];
    [_female setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:UIControlStateNormal];
    _gender = YES;
}

-(IBAction)femalePressed:(id)sender
{
    [_female setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
    [_female setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_male setBackgroundColor:[UIColor whiteColor]];
    [_male setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:UIControlStateNormal];
    _gender = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y - 100) animated:YES];
}

@end