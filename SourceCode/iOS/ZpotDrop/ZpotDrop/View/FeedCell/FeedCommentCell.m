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
    [_btnDelete setTitle:@"delete".localized forState:UIControlStateNormal];
    [_btnRetry setTitle:@"retry".localized forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if ([data isKindOfClass:[FeedCommentDataModel class]]) {
        FeedCommentDataModel* feedComment = (FeedCommentDataModel*)data;
        self.dataModel = data;
        data.dataDelegate = self;
        _lblMessage.text = @"Happy birthday Alex!!! Happy birthday Alex!!!";
        _lblTime.text = @"3 min ago";
        _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
        _lblName.text = @"Sonny Truong";
        
        if ([feedComment.status isEqualToString:STATUS_SENDING]) {
            [_indicatorView setBubbleColor:COLOR_DARK_GREEN];
            [_indicatorView setNumberOfBubbles:4];
            [_indicatorView setBubbleSize:CGSizeMake(8, 8)];
            [_indicatorView startAnimating];
            _btnRetry.hidden = _btnDelete.hidden = YES;
            _viewSending.hidden = NO;
            _indicatorView.hidden = NO;
        }else if([feedComment.status isEqualToString:STATUS_ERROR]){
            _btnRetry.hidden = _btnDelete.hidden = NO;
            _viewSending.hidden = NO;
            _indicatorView.hidden = YES;
            [_indicatorView stopAnimating];
        }else{
            _btnRetry.hidden = _btnDelete.hidden = YES;
            _viewSending.hidden = YES;
            _indicatorView.hidden = YES;
            [_indicatorView stopAnimating];
        }
        
    }
}

-(void)updateUIForDataModel:(BaseDataModel *)model options:(NSDictionary *)params{
    if (params != nil && [[params allKeys] containsObject:@"status"]) {
        FeedCommentDataModel* feedComment = (FeedCommentDataModel*)self.dataModel;
        if ([feedComment.status isEqualToString:STATUS_SENDING]) {
            [_indicatorView setBubbleColor:COLOR_DARK_GREEN];
            [_indicatorView setNumberOfBubbles:4];
            [_indicatorView setBubbleSize:CGSizeMake(8, 8)];
            [_indicatorView startAnimating];
            _btnRetry.hidden = _btnDelete.hidden = YES;
            _viewSending.hidden = NO;
            _indicatorView.hidden = NO;
        }else if([feedComment.status isEqualToString:STATUS_ERROR]){
            _btnRetry.hidden = _btnDelete.hidden = NO;
            _viewSending.hidden = NO;
            _indicatorView.hidden = YES;
            [_indicatorView stopAnimating];
        }else{
            _btnRetry.hidden = _btnDelete.hidden = YES;
            _viewSending.hidden = YES;
            _indicatorView.hidden = YES;
            [_indicatorView stopAnimating];
        }
    }
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
