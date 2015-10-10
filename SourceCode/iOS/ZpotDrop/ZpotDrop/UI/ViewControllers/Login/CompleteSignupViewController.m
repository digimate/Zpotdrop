//
//  CompleteSignupViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "CompleteSignupViewController.h"

@interface CompleteSignupViewController (){
}

@end

@implementation CompleteSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayout];
}

-(void)closeKeyboard{
    [self.view endEditing:YES];
}


-(void)setupLayout
{
    [_genderSlider setThumbImage:[UIImage imageNamed:@"gender_thumb"] forState:UIControlStateNormal];
    [_genderSlider setThumbImage:[UIImage imageNamed:@"gender_thumb"] forState:UIControlStateHighlighted];
    [_genderSlider setThumbImage:[UIImage imageNamed:@"gender_thumb"] forState:UIControlStateSelected];
    [_dob setFormat:DATE_FORMAT_MONTH_IN_LETTER];
}

- (IBAction)genderValueChanged{
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

@end
