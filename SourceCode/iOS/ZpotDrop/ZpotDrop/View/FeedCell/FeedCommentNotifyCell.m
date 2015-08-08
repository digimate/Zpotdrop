//
//  FeedCommentNotifyCell.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedCommentNotifyCell.h"
#import "Utils.h"
@implementation FeedCommentNotifyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _lblTitle.text = _lblTime.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    NSString* str = [NSString stringWithFormat:@"%@ %@",@"Cody Huynh",@"is_comming".localized];
    NSDictionary* dict = @{NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:16] ,
                            NSForegroundColorAttributeName : [UIColor colorWithRed:129 green:129 blue:129]};
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:148 green:148 blue:148]}];
    [attStr addAttributes:dict range:NSMakeRange(0, @"Cody Huynh".length)];
    _lblTitle.attributedText = attStr;
    
    _lblTime.text = @"5 min ago";
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 26;
}
@end
