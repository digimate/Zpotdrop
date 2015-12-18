//
//  FeedCommentCell.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedCommentCell.h"
#import "Utils.h"
#import "UserDataModel.h"

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
    [_btnDelete addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRetry setTitle:@"retry".localized forState:UIControlStateNormal];
    [_btnRetry addTarget:self action:@selector(retryComment:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *imgTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgvAvatarDidTouch:)];
    [_imgvAvatar addGestureRecognizer:imgTapper];
    
    UITapGestureRecognizer *nameTapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblNameDidTouch:)];
    [_lblName addGestureRecognizer:nameTapper];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)deleteComment:(UIButton*)sender{
    if (self.onDeleteComment) {
        self.onDeleteComment();
    }
}

-(void)retryComment:(UIButton*)sender{
    FeedCommentDataModel* feedData = (FeedCommentDataModel*)self.dataModel;
    if (feedData != nil) {
        feedData.status = STATUS_SENDING;
        [self updateUIForDataModel:nil options:@{@"status":@""}];
    }
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if ([data isKindOfClass:[FeedCommentDataModel class]]) {
        FeedCommentDataModel* feedComment = (FeedCommentDataModel*)data;
        self.dataModel = data;
        data.dataDelegate = self;
        _lblMessage.text = feedComment.message;
        _lblTime.text = [[Utils instance]convertDateToRecent:feedComment.time];
        _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
        UserDataModel* poster = (UserDataModel*)[UserDataModel fetchObjectWithID:feedComment.user_id];
        [poster updateObjectForUse:^{
            _lblName.text = poster.name;
            if (poster.avatar.length > 0) {
                _imgvAvatar.image = [poster.avatar stringToUIImage];
            }
        }];
        
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
    if (data != nil && [data isKindOfClass:[FeedCommentDataModel class]]) {
        FeedCommentCell* cell = [FeedCommentCell instance];
        cell.lblName.text = [(FeedCommentDataModel*)data message];
        CGSize s = [cell.lblName sizeThatFits:CGSizeMake(cell.lblName.width, MAXFLOAT)];
        return 57 + (s.height - cell.lblName.height);
    }
    return 0;
    
}

+(id)instance{
    static FeedCommentCell *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    });
    return _sharedInstance;
}

#pragma mark - Event Handlers

- (IBAction)imgvAvatarDidTouch:(id)sender {
    FeedCommentDataModel* feedComment = (FeedCommentDataModel*)self.dataModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AvatarDidTouchNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:feedComment.user_id forKey:@"UserId"]];
}

- (IBAction)lblNameDidTouch:(id)sender {
    FeedCommentDataModel* feedComment = (FeedCommentDataModel*)self.dataModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NameDidTouchNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:feedComment.user_id forKey:@"UserId"]];
}

@end
