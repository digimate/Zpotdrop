//
//  FeedNormalViewCell.m
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedNormalViewCell.h"
#import "Utils.h"
#import "UserDataModel.h"
#import "LocationDataModel.h"
#import "APIService.h"

@implementation FeedNormalViewCell
@synthesize btnComment = _btnComment;
@synthesize btnComming = _btnComming;
@synthesize btnLike = _btnLike;
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _viewButtons.width = self.width;
    [_viewButtons addBorderWithFrame:CGRectMake(0, 0, _viewButtons.width, 1.0) color:COLOR_SEPEARATE_LINE];
    [_btnComment addBorderWithFrame:CGRectMake(0, 0, 1.0, _btnComment.height) color:COLOR_SEPEARATE_LINE];
    [_btnComming addBorderWithFrame:CGRectMake(0, 0, 1.0, _btnComment.height) color:COLOR_SEPEARATE_LINE];
    [_btnLike setTitle:@"like".localized forState:UIControlStateNormal];
    [_btnLike setTitle:@"liked".localized forState:UIControlStateSelected];
    [_btnLike setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    
    [_btnComment setTitle:@"comment".localized forState:UIControlStateNormal];
    [_btnComment setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    [_btnComment addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnComming setTitle:@"comming".localized forState:UIControlStateNormal];
    [_btnComming setTitle:@"comminged".localized forState:UIControlStateSelected];
    [_btnComming setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    [_btnComming addTarget:self action:@selector(sendCommingNotify:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self setWidth:[UIScreen mainScreen].bounds.size.width];
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    _lblName.textColor = COLOR_DARK_GREEN;
    _lblName.text = nil;
    _lblNumberComments.text = nil;
    _lblNumberLikes.text = nil;
    _lblSpotDistance.text = nil;
    _lblZpotAddress.text = nil;
    _lblZpotTitle.text = nil;
    _lblZpotTime.text = nil;
    _btnLike.enabled = YES;
    _btnLike.userInteractionEnabled = YES;
    [_btnLike addTarget:self action:@selector(likeFeed:) forControlEvents:UIControlEventTouchUpInside];
    [self addBorderWithFrame:CGRectMake(0, [FeedNormalViewCell cellHeightWithData:nil]-5.0, self.width, 5.0) color:[UIColor colorWithRed:242 green:242 blue:242]];
}

-(void)showCommentView{
    self.onShowComment();
}

-(void)sendCommingNotify:(UIButton*)sender{
    if (self.dataModel != nil) {
        sender.enabled = NO;
        FeedDataModel* feedData = (FeedDataModel*)self.dataModel;
        if (sender.isSelected) {
            //send uncomming
            [[APIService shareAPIService]sendUnCommingNotifyForFeedID:feedData.mid completion:^(BOOL isSuccess, NSString *error) {
                sender.enabled = YES;
                if (isSuccess) {
                    _btnComming.selected = NO;
                    NSArray* deleteArray = [FeedCommentDataModel fetchObjectsWithPredicate:[NSPredicate predicateWithFormat:@"feed_id = %@ AND user_id = %@ AND type = %@",feedData.mid,[AccountModel currentAccountModel].user_id,TYPE_NOTIFY] sorts:nil];
                    for (BaseDataModel* model in deleteArray) {
                        [model deleteFromDB];
                    }
                }else{
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
            }];
        
        }else{
            //send comming
            [[APIService shareAPIService]sendCommingNotifyForFeedID:feedData.mid completion:^(BOOL isSuccess, NSString *error) {
                sender.enabled = YES;
                if (isSuccess) {
                    _btnComming.selected = YES;
                    FeedCommentDataModel* comment = (FeedCommentDataModel*)[FeedCommentDataModel fetchObjectWithID:[[NSDate date] string]];
                    comment.message = @"";
                    comment.feed_id = feedData.mid;
                    comment.user_id = [AccountModel currentAccountModel].user_id;
                    comment.status = STATUS_DELIVER;
                    comment.type = TYPE_NOTIFY;
                    comment.time = [NSDate date];
                }else{
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
            }];
        }
    }
}

-(void)likeFeed:(UIButton*)sender{
    if (self.dataModel) {
        FeedDataModel* feedData = (FeedDataModel*)self.dataModel;
        sender.enabled = NO;
        if (sender.isSelected) {
            [[APIService shareAPIService] unlikeFeedWithID:feedData.mid completion:^(BOOL successful, NSString *error) {
                sender.enabled = YES;
                if (!successful) {
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }else{
                    sender.selected = NO;
                }
            }];
        }else{
            [[APIService shareAPIService] likeFeedWithID:feedData.mid completion:^(BOOL successful, NSString *error) {
                sender.enabled = YES;
                if (!successful) {
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }else{
                    sender.selected = YES;
                }
            }];
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if ([data isKindOfClass:[FeedDataModel class]]) {
        FeedDataModel* feedData = (FeedDataModel*)data;
        self.dataModel = data;
        self.dataModel.dataDelegate = self;
        if (feedData.user_id != nil && feedData.user_id.length > 0) {
            UserDataModel* poster = (UserDataModel*)[UserDataModel fetchObjectWithID:feedData.user_id];
            [poster updateObjectForUse:^{
                _lblName.text = poster.name;
            }];
        }
        if (feedData.location_id != nil && feedData.location_id.length > 0) {
            LocationDataModel* location = (LocationDataModel*)[LocationDataModel fetchObjectWithID:feedData.location_id];
            [location updateObjectForUse:^{
                _lblZpotAddress.text = [NSString stringWithFormat:@"%@-%@",location.name,location.address];
            }];
        }
        _lblZpotTitle.text = feedData.title;
        _lblZpotTime.text = [[Utils instance]convertDateToRecent:feedData.time];
        if ([Utils instance].isGPS) {
            _lblSpotDistance.text = [[Utils instance] distanceBetweenCoor:CLLocationCoordinate2DMake([feedData.latitude doubleValue], [feedData.longitude doubleValue]) andCoor:[Utils instance].locationManager.location.coordinate];

        }
        _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
        //setup comment number
        NSString* commentString;
        if ([feedData.comment_count integerValue] > 1) {
            commentString = [NSString stringWithFormat:@"%@ %@",feedData.comment_count.description,@"comments".localized];
        }else{
            commentString = [NSString stringWithFormat:@"%@ %@",feedData.comment_count.description,@"comment".localized];
        }
        NSMutableAttributedString* commentAttString = [[NSMutableAttributedString alloc]initWithString:commentString];
        [commentAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, feedData.comment_count.description.length)];
        _lblNumberComments.attributedText = commentAttString;
        
        //setup like number
        NSString* likeString;
        if ([feedData.like_count integerValue] > 1) {
            likeString = [NSString stringWithFormat:@"%@ %@",feedData.like_count.description,@"likes".localized];
        }else{
            likeString = [NSString stringWithFormat:@"%@ %@",feedData.like_count.description,@"like".localized];
        }
        NSMutableAttributedString* likeAttString = [[NSMutableAttributedString alloc]initWithString:likeString];
        [likeAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, feedData.like_count.description.length)];
        _lblNumberLikes.attributedText = likeAttString;
        
        CGSize s = [_lblNumberComments sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberComments.height)];
        _lblNumberCommentsWidth.constant = ceilf(s.width);
        
        s = [_lblNumberLikes sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberLikes.height)];
        _lblNumberLikesWidth.constant = ceilf(s.width);
        
        _btnLike.selected = ([feedData.like_userIds rangeOfString:[AccountModel currentAccountModel].user_id].location != NSNotFound);
        _btnComming.selected = ([feedData.comming_userIds rangeOfString:[AccountModel currentAccountModel].user_id].location != NSNotFound);
        _btnComming.enabled = ![feedData.user_id isEqualToString:[AccountModel currentAccountModel].user_id];
    }
}

-(void)updateUIForDataModel:(BaseDataModel *)model options:(NSDictionary*)params{
    [self setupCellWithData:model andOptions:params];
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 141;
}
@end
