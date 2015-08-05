//
//  FeedSelectedViewCell.m
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedSelectedViewCell.h"
#import "Utils.h"

@implementation FeedSelectedViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [_lblZpotName setWidth:(_lblZpotName.width + (self.width - 320))];
    [_viewForMap setWidth:self.width];
    [_tableViewComments setWidth:self.width];
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    _lblName.textColor = _btnComming.backgroundColor =  COLOR_DARK_GREEN;
    _lblZpotInfo.backgroundColor = [COLOR_DARK_GREEN colorWithAlphaComponent:0.5];
    _lblName.text = _lblZpotAddress.text = _lblZpotInfo.text = _lblZpotName.text = nil;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    _lblName.text = @"Alex Stone";
    _lblZpotAddress.text = @"Villandry - StJames's";
    _lblZpotName.text = @"Brunch with mom.";
    [_btnComming setTitle:@"comming".localized forState:UIControlStateNormal];
    _lblZpotInfo.text = [NSString stringWithFormat:@"zpot_distance_format".localized,@"234 m",@"3 min",@"1 min"];
}

+(CGFloat)cellHeight{
    return 390;
}
@end
