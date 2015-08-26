//
//  NotificationTableViewCell.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "UIView+Circle.h"
#import "Utils.h"
#import "UserDataModel.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 50;
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, [NotificationTableViewCell cellHeightWithData:nil])];
        [_mScrollView setShowsHorizontalScrollIndicator:NO];
        [_mScrollView setPagingEnabled:YES];
        [self addSubview:_mScrollView];
    }
    [_mScrollView setBackgroundColor:[UIColor clearColor]];
    for (UIView* sub in _mScrollView.subviews) {
        [sub removeFromSuperview];
    }
    self.dataModel = data;
    NotificationModel* notifModel = (NotificationModel*)data;
    
    CGSize size = _mScrollView.frame.size;
    
    viewButtons = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [viewButtons setBackgroundColor:[UIColor whiteColor]];
    [_mScrollView addSubview:viewButtons];
    
    UIView* _background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_background setBackgroundColor:[UIColor whiteColor]];
    [_mScrollView addSubview:_background];
    
    UserDataModel* sender = (UserDataModel*)[UserDataModel fetchObjectWithID:notifModel.sender_id];
    [sender updateObjectForUse:^{
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(11, 7, size.height - 14, size.height - 14)];
        [_avatarImage circleWithBorderWidth:0 andColor:nil];
        [_avatarImage setImage:[UIImage imageNamed:@"avatar"]];
        [_background addSubview:_avatarImage];
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 5, _avatarImage.frame.origin.y, size.width - (_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 10), size.height - 14)];
        _content.numberOfLines = 2;
        [_content setTextColor:[UIColor blackColor]];
        [_content setFont:[UIFont fontWithName:@"PTSans-Regular" size:14.f]];
        
        NSString* name = [sender name];
        NSString* date = [[Utils instance]convertDateToAgo:notifModel.time];
        NSDictionary* dictDate = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                   NSFontAttributeName : [UIFont fontWithName:@"PTSans-Regular" size:8]};
        NSMutableAttributedString* attStr;
        if ([notifModel.type isEqualToString:NOTIFICATION_COMMING]) {
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_comming_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
            
            
        }else if ([notifModel.type isEqualToString:NOTIFICATION_COMMENT]){
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_comment_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
        }else if ([notifModel.type isEqualToString:NOTIFICATION_LIKE]){
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_like_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
        }else if ([notifModel.type isEqualToString:NOTIFICATION_FOLLOW]){
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_follow_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
        }else if ([notifModel.type isEqualToString:NOTIFICATION_FB_Friend]){
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_facebook_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
        }
        
        [_content setAttributedText:attStr];
        [_background addSubview:_content];
        
        [_mScrollView setContentSize:CGSizeMake(size.width,0)];
        [self addBorderWithFrame:CGRectMake(_content.x, size.height - 1, size.width - _content.x, 1.0) color:COLOR_SEPEARATE_LINE];
    }];
    
}


-(void)setupCellWithData:(NotificationModel*)data inSize:(CGSize)size
{
    
//    if (!_mScrollView)
//    {
//        _username = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 7, _avatarImage.frame.origin.y, size.width - (_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 7), _avatarImage.frame.size.height/2)];
//        [_username setFont:[UIFont fontWithName:@"PTSans-Bold" size:15.f]];
//        [_username setText:@"User name here"];
//        [_background addSubview:_username];
//        
//        _content = [[UILabel alloc]initWithFrame:CGRectMake(_username.frame.origin.x, _username.frame.size.height + _username.frame.origin.y, size.width - _username.frame.origin.x, _avatarImage.frame.size.height/2)];
//        [_content setTextColor:[UIColor blackColor]];
//        [_content setFont:[UIFont fontWithName:@"PTSans-Regular" size:13.f]];
//        [_content setText:@"notification content should display here"];
//        [_background addSubview:_content];
        
//        _location = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_location setFrame:CGRectMake(size.width - 60, 0, 60, size.height)];
//        //[_location setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
//        [_location setImage:[UIImage imageNamed:@"notification_location.png"] forState:UIControlStateNormal];
//        [self addSubview:_location];
        
//        _time = [[UILabel alloc]initWithFrame:CGRectMake(size.width - 60, _username.frame.origin.y, 60, _username.frame.size.height)];
//        //[_time setTextColor:[UIColor colorWithHexString:MAIN_COLOR]];
//        [_time setText:@"1 min ago"];
//        [_time setFont:[UIFont fontWithName:@"PTSans-Regular" size:11.f]];
//        [_background addSubview:_time];
        
//        _add = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_add setFrame:CGRectMake(size.width - 10 - _avatarImage.frame.size.width, _avatarImage.frame.origin.y, _avatarImage.frame.size.width, _avatarImage.frame.size.height)];
//        [_add circleWithBorderWidth:0 andColor:nil];
//        //[_add setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
//        [_add setImage:[UIImage imageNamed:@"notification_add.png"] forState:UIControlStateNormal];
//        [_mScrollView addSubview:_add];
//        [self sendSubviewToBack:_location];
//    }
    
//    if (data.notificationType.intValue == NOTIFICATION_FOLLOW)
//    {
//        [_time setHidden:YES];
//        [_add setHidden:NO];
//        [_mScrollView setContentSize:CGSizeMake(0,0)];
//    }
//    else
//    {
//        [_time setHidden:NO];
//        [_add setHidden:YES];
//        [_mScrollView setContentSize:CGSizeMake(size.width + _location.frame.size.width,0)];
//    }
//    
//    [_content setText:data.notificationContent];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        //[self bringSubviewToFront:_location];
    }
    else
    {
        //[self sendSubviewToBack:_location];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
       // [self bringSubviewToFront:_location];
    }
}

-(void)scrollBack
{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
@end
