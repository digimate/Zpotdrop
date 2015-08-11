//
//  CreateLocationCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/11/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "CreateLocationCell.h"
#import "Utils.h"

@implementation CreateLocationCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    lblTitle.text = @"create_location".localized;
    lblAddress.text = @"location_address".localized;
    lblName.text = @"location_name".localized;
    tfAddress.text = tfName.text = nil;
    tfAddress.delegate = tfName.delegate = self;
    tfName.returnKeyType = tfAddress.returnKeyType = UIReturnKeyDone;
    [btnCreate setTitleColor:COLOR_DARK_GREEN forState:UIControlStateNormal];
    [btnCreate setTitleColor:lblAddress.textColor forState:UIControlStateHighlighted];
    [btnCreate setTitle:@"create_location".localized forState:UIControlStateNormal];
    [btnCreate addTarget:self action:@selector(createLocation) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createLocation{
    self.onCreateLocationPressed([tfName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],[tfAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAddress:(NSString *)address{
    tfAddress.text = address;
}

-(NSString *)address{
    return tfAddress.text;
}

-(NSString *)name{
    return tfName.text;
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 185;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
