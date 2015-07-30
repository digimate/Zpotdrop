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
    UIScrollView* _mScrollView;
    UIImageView* _icon;
    
    UITextField* _firstName;
    UITextField* _lastName;
    DateTextField* _dob;
    UIButton* _male;
    UIButton* _female;
    
    UIButton* _complete;
    BOOL _gender; //YES: male, NO: female
    NSDate* _dobData;
}

@property (nonatomic, retain) NSMutableDictionary* data;

@end
