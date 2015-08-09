//
//  SettingDisclosureViewCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "SettingDisclosureViewCell.h"

@implementation SettingDisclosureViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    lblTitle.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 35;
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if (param && [param objectForKey:@"title"]) {
        lblTitle.text = [param objectForKey:@"title"];
    }
}
@end
