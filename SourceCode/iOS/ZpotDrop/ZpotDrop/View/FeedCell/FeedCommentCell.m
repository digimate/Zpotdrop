//
//  FeedCommentCell.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedCommentCell.h"
#import "Utils.h"

@implementation FeedCommentCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    _lblName.textColor = COLOR_DARK_GREEN;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{

}

+(CGFloat)cellHeight{
    return 0;
}
@end
