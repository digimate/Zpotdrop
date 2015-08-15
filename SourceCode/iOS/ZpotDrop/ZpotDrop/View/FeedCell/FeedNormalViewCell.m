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
    _btnLike.enabled = YES;
    _btnLike.userInteractionEnabled = YES;
    [_btnLike addTarget:self action:@selector(likeFeed:) forControlEvents:UIControlEventTouchUpInside];
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
                }
            }];
        }else{
            [[APIService shareAPIService] likeFeedWithID:feedData.mid completion:^(BOOL successful, NSString *error) {
                sender.enabled = YES;
                if (!successful) {
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
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
        _lblNumberComments.text = feedData.comment_count.description;
        _lblNumberLikes.text = feedData.like_count.description;
        
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
        _btnLike.selected = ([feedData.like_userIds rangeOfString:[AccountModel currentAccountModel].user_id].location != NSNotFound);
        
        if ([_lblNumberComments.text isEqualToString:@"0"]) {
            _lblNumberComments.hidden = YES;
            _lblNumberCommentsWidth.constant = 0;
        }else{
            _lblNumberComments.hidden = NO;
        }
        _btnComment.selected = !_lblNumberComments.hidden;

    }
}

-(void)updateUIForDataModel:(BaseDataModel *)model options:(NSDictionary*)params{
    [self setupCellWithData:model andOptions:params];
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 80;
}
@end
