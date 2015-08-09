//
//  UserProfileCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UserProfileCell.h"
#import "Utils.h"

@implementation UserProfileCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    imgvAvatar.layer.cornerRadius = imgvAvatar.width/2;
    imgvAvatar.layer.masksToBounds = YES;
    lblDOB.text = [NSString stringWithFormat:@"%@:",@"dob".localized];
    lblEmail.text = [NSString stringWithFormat:@"%@:",@"email".localized];
    lblFirstName.text = [NSString stringWithFormat:@"%@:",@"first_name".localized];
    lblHomeTown.text = [NSString stringWithFormat:@"%@:",@"hometown".localized];
    lblLastName.text = [NSString stringWithFormat:@"%@:",@"last_name".localized];
    lblPhone.text = [NSString stringWithFormat:@"%@:",@"phone".localized];
    
    tfFirstName.text = tfLastName.text = tfHomeTown.text = tfPhone.text = tfEmail.text = tfDOB.text = nil;
    tfFirstName.returnKeyType = tfLastName.returnKeyType = tfHomeTown.returnKeyType = tfEmail.returnKeyType = tfDOB.returnKeyType = UIReturnKeyNext;
    tfPhone.returnKeyType = UIReturnKeyDone;
    
    tfFirstName.delegate = tfLastName.delegate = tfHomeTown.delegate = tfPhone.delegate = tfEmail.delegate = tfDOB.delegate = self;
    datePicker = [[UIDatePicker alloc]init];
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
    tfDOB.inputView = datePicker;
    [btnEditPicture addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];
}

-(void)changeAvatar{
    [[Utils instance]showImagePickerWithCompletion:^(UIImage *image) {
        imgvAvatar.image = image;
    } fromViewController:self.handler isCrop:YES isCamera:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 277;
}
-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    imgvAvatar.image = [UIImage imageNamed:@"avatar"];
}
-(void)datePickerChanged{
    NSDate* selectedDate = datePicker.date;
    tfDOB.text = [selectedDate stringWithFormat:@"dd/MM/yyyy"];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == tfFirstName) {
        [tfLastName becomeFirstResponder];
    }else if (textField == tfLastName){
        [tfHomeTown becomeFirstResponder];
    }else if (textField == tfHomeTown){
        [tfDOB becomeFirstResponder];
    }else if (textField == tfDOB){
        [tfEmail becomeFirstResponder];
    }else if (textField == tfEmail){
        [tfPhone becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}
@end
