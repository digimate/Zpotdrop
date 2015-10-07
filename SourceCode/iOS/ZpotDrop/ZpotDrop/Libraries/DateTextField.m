//
//  DateTextField.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/31/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "DateTextField.h"
#import "NSDate+Helper.h"

@implementation DateTextField

-(id)initWithFrame:(CGRect)frame date:(NSDate*)date andDisplayFormat:(NSString*)format
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _displayFormat = format;
        _pickerDate = date;
        
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
        [myToolbar setBarTintColor:[UIColor whiteColor]];
        [myToolbar setTranslucent:NO];
        
        UIBarButtonItem* _doneLabel = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
        
        [myToolbar setItems:@[_doneLabel]];
        
        UIDatePicker* _date = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        [_date setBackgroundColor:[UIColor blackColor]];
        
        [_date setValue:[UIColor whiteColor] forKey:@"textColor"];
        _date.datePickerMode = UIDatePickerModeDate;
        [_date addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        self.inputAccessoryView = myToolbar;
        self.inputView = _date;
        
        [self setText:[NSDate stringFromDate:_pickerDate withFormat:format]];
    }
    return self;
}

-(IBAction)dateChange:(UIDatePicker*)sender
{
    _pickerDate = sender.date;
    [self setText:[NSDate stringFromDate:_pickerDate withFormat:_displayFormat]];
}

-(IBAction)inputAccessoryViewDidFinish:(id)sender
{
    [self resignFirstResponder];
}

-(NSDate*)getDate
{
    return _pickerDate;
}

-(NSString*)getDateStringWithFormat:(NSString *)format
{
    if (format)
        return [NSDate stringFromDate:_pickerDate withFormat:format];
    return self.text;
}
@end
