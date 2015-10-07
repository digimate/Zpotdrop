//
//  FeedCommentNotifyCell.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedCommentNotifyCell.h"
#import "Utils.h"
#import "FeedCommentDataModel.h"
#import "UserDataModel.h"

@implementation FeedCommentNotifyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _lblTitle.text = _lblTime.text = nil;
    NSString* str = [NSString stringWithFormat:@"%@ %@",@"friend".localized,@"is_comming".localized];
    _lblTitle.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if (data) {
        self.dataModel = data;
        FeedCommentDataModel* commentModel = (FeedCommentDataModel*)data;
        [commentModel updateObjectForUse:^{
            UserDataModel* userModel = (UserDataModel*)[UserDataModel fetchObjectWithID:commentModel.user_id];
            [userModel updateObjectForUse:^{
                NSString* str = [NSString stringWithFormat:@"%@ %@",userModel.name,@"is_comming".localized];
                NSDictionary* dict = @{NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:16] ,
                                       NSForegroundColorAttributeName : [UIColor colorWithRed:129 green:129 blue:129]};
                NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:148 green:148 blue:148]}];
                [attStr addAttributes:dict range:NSMakeRange(0, userModel.name.length)];
                _lblTitle.attributedText = attStr;
            }];
            _lblTime.text = [[Utils instance]convertDateToRecent:commentModel.time];
        }];
    }
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 26;
}
@end
