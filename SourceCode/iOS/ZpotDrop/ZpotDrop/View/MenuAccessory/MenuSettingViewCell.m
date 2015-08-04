//
//  MenuSettingViewCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "MenuSettingViewCell.h"
#import "Utils.h"

@implementation MenuSettingViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _lblTitle.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
    _lblTitle.textColor = [UIColor colorWithRed:184 green:184 blue:184];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight{
    return 44;
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if (param != nil && [param objectForKey:@"title"] != nil) {
        _lblTitle.text = [param objectForKey:@"title"];
    }
}
@end
