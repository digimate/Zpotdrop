//
//  MenuProfileTableViewCell.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/2/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "MenuProfileTableViewCell.h"
#import "Utils.h"

@implementation MenuProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.frame.size.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    
    [_lblName setText:@""];
    [_lblName setFont:[UIFont fontWithName:@"PTSans-Bold" size:18]];
    _lblName.textColor = COLOR_DARK_GREEN;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel*)data andOptions:(NSDictionary*)param
{
    [_lblName setText:@"SONNY TRUONG"];
    _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
}

+(CGFloat)cellHeight{
    return 150;
}

@end
