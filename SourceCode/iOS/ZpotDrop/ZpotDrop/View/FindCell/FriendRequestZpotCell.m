//
//  FriendRequestZpotCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FriendRequestZpotCell.h"
#import "Utils.h"

@implementation FriendRequestZpotCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    imgvAvatar.layer.cornerRadius = imgvAvatar.width/2;
    imgvAvatar.layer.masksToBounds = YES;
    btnRequestZpot.backgroundColor = COLOR_DARK_GREEN;
    btnRequestZpot.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    [btnRequestZpot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRequestZpot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnRequestZpot setTitle:@"request_zpot".localized forState:UIControlStateNormal];
    lblName.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    lblName.textColor = [UIColor colorWithRed:188 green:188 blue:188];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 50;
}
-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    lblName.text = @"Sonny Truong";
    imgvAvatar.image = [UIImage imageNamed:@"avatar"];
}
@end
