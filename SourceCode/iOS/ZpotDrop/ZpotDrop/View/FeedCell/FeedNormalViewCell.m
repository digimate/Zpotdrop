//
//  FeedNormalViewCell.m
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedNormalViewCell.h"
#import "Utils.h"

@implementation FeedNormalViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self setWidth:[UIScreen mainScreen].bounds.size.width];
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    _lblName.textColor = _lblNumberComments.textColor = _lblNumberLikes.textColor = COLOR_DARK_GREEN;
    _lblName.text = nil;
    _lblNumberComments.text = nil;
    _lblNumberLikes.text = nil;
    _lblSpotDistance.text = nil;
    _lblZpotAddress.text = nil;
    _lblZpotTitle.text = nil;
    _lblZpotTime.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    _lblName.text = @"Alex Stone";
    _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    _lblZpotAddress.text = @"Villandry - StJames's";
    _lblZpotTitle.text = @"Brunch with mom.";
    _lblZpotTime.text = @"10 min ago";
    _lblSpotDistance.text = @"234 m";
    _lblNumberComments.text = @"0";
    _lblNumberLikes.text = @"3";
    
    CGSize s = [_lblNumberComments sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberComments.height)];
    _lblNumberCommentsWidth.constant = ceilf(s.width);
    
    s = [_lblNumberLikes sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberLikes.height)];
    _lblNumberLikesWidth.constant = ceilf(s.width);
    
    if ([_lblNumberLikes.text isEqualToString:@"0"]) {
        _lblNumberLikes.hidden = YES;
        _lblNumberLikesWidth.constant = 0;
    }else{
        _lblNumberLikes.hidden = NO;
    }
    _btnLike.selected = !_lblNumberLikes.hidden;
    
    if ([_lblNumberComments.text isEqualToString:@"0"]) {
        _lblNumberComments.hidden = YES;
        _lblNumberCommentsWidth.constant = 0;
    }else{
        _lblNumberComments.hidden = NO;
    }
    _btnComment.selected = !_lblNumberComments.hidden;
}

+(CGFloat)cellHeight{
    return 80;
}
@end
