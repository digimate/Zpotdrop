//
//  MenuFeatureTableViewCell.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/2/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "MenuFeatureTableViewCell.h"
#import "Utils.h"

@implementation MenuFeatureTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    _lblTitle.font = [UIFont fontWithName:@"PTSans" size:18];
    UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_indicator"]];
    self.accessoryView = checkmark;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if (param != nil && [param objectForKey:@"icon"] != nil) {
        _imgvIcon.image = [UIImage imageNamed:[param objectForKey:@"icon"]];
    }
    if (param != nil && [param objectForKey:@"title"] != nil) {
        _lblTitle.text = [param objectForKey:@"title"];
    }
    
    if (param != nil && [param objectForKey:@"selected"] != nil && [[param objectForKey:@"selected"] boolValue] == YES) {
        _lblTitle.textColor = COLOR_DARK_GREEN;
    }else{
        _lblTitle.textColor = [UIColor blackColor];
    }
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 44;
}
@end