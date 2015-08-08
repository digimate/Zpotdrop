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
@synthesize lblName = _lblName;
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    _lblName.textColor = COLOR_DARK_GREEN;
    _lblName.text = _lblMessage.text = _lblTime.text = nil;
    _lblName.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    _lblMessage.text = @"Happy birthday Alex!!! Happy birthday Alex!!!";
    _lblTime.text = @"3 min ago";
    _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    _lblName.text = @"Sonny Truong";
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{

    FeedCommentCell* cell = [FeedCommentCell instance];
    cell.lblName.text = @"Happy birthday Alex!!! Happy birthday Alex!!!";
    CGSize s = [cell.lblName sizeThatFits:CGSizeMake(cell.lblName.width, MAXFLOAT)];
    return 57 + (s.height - cell.lblName.height);
}

+(id)instance{
    static FeedCommentCell *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    });
    return _sharedInstance;
}
@end
