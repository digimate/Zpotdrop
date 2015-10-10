//
//  CompleteSignupViewController.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/30/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"
#import "DateTextField.h"

@interface CompleteSignupViewController : BaseViewController <UITextFieldDelegate>
{
    IBOutlet UITextField* _firstName;
    IBOutlet UITextField* _lastName;
    IBOutlet UITextField* _phoneNumber;
    IBOutlet DateTextField* _dob;
    IBOutlet UISlider* _genderSlider;
    
    IBOutlet UIButton *_male;
    IBOutlet UIButton *_female;
    
    UIButton* _complete;
    BOOL _gender; //YES: male, NO: female
    NSDate* _dobData;
}

@property (nonatomic, retain) NSMutableDictionary* data;

@end
