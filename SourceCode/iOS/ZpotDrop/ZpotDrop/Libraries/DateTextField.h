//
//  DateTextField.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/31/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateTextField : UITextField
{
    NSString* _displayFormat;
    NSDate* _pickerDate;
}

- (void)setDate:(NSDate *)date format:(NSString *)format;
- (void)setDate:(NSDate *)date;
- (void)setFormat:(NSString *)format;
-(NSDate*)getDate;
-(NSString*)getDateStringWithFormat:(NSString*)format;
@end
