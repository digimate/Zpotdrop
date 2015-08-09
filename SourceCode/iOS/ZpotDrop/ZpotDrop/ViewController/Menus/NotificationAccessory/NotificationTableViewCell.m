//
//  NotificationTableViewCell.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "UIView+Circle.h"


@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(NotificationModel*)data inSize:(CGSize)size andHandler:(notifiactionCellHandler)handler
{
    _handler = handler;
    if (!_mScrollView)
    {
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [_mScrollView setBackgroundColor:[UIColor clearColor]];
        [_mScrollView setShowsHorizontalScrollIndicator:NO];
        [_mScrollView setPagingEnabled:YES];
        [self addSubview:_mScrollView];
        
        UIView* _background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [_background setBackgroundColor:[UIColor whiteColor]];
        [_mScrollView addSubview:_background];
        
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(11, 7, size.height - 14, size.height - 14)];
        [_avatarImage circleWithBorderWidth:0 andColor:nil];
        [_avatarImage setImage:[UIImage imageNamed:@"avatar"]];
        [_background addSubview:_avatarImage];
        
        _username = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 7, _avatarImage.frame.origin.y, size.width - (_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 7), _avatarImage.frame.size.height/2)];
        [_username setFont:[UIFont fontWithName:@"PTSans-Bold" size:15.f]];
        [_username setTextColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_username setText:@"User name here"];
        [_background addSubview:_username];
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(_username.frame.origin.x, _username.frame.size.height + _username.frame.origin.y, size.width - _username.frame.origin.x, _avatarImage.frame.size.height/2)];
        [_content setTextColor:[UIColor blackColor]];
        [_content setFont:[UIFont fontWithName:@"PTSans-Regular" size:13.f]];
        [_content setText:@"notification content should display here"];
        [_background addSubview:_content];
        
        _location = [UIButton buttonWithType:UIButtonTypeCustom];
        [_location setFrame:CGRectMake(size.width - 60, 0, 60, size.height)];
        [_location setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_location setImage:[UIImage imageNamed:@"notification_location.png"] forState:UIControlStateNormal];
        [self addSubview:_location];
        
        _time = [[UILabel alloc]initWithFrame:CGRectMake(size.width - 60, _username.frame.origin.y, 60, _username.frame.size.height)];
        [_time setTextColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_time setText:@"1 min ago"];
        [_time setFont:[UIFont fontWithName:@"PTSans-Regular" size:11.f]];
        [_background addSubview:_time];
        
        _add = [UIButton buttonWithType:UIButtonTypeCustom];
        [_add setFrame:CGRectMake(size.width - 10 - _avatarImage.frame.size.width, _avatarImage.frame.origin.y, _avatarImage.frame.size.width, _avatarImage.frame.size.height)];
        [_add circleWithBorderWidth:0 andColor:nil];
        [_add setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_add setImage:[UIImage imageNamed:@"notification_add.png"] forState:UIControlStateNormal];
        [_mScrollView addSubview:_add];
        [self sendSubviewToBack:_location];
    }
    
    if (data.notificationType.intValue == NOTIFICATION_FOLLOW)
    {
        [_time setHidden:YES];
        [_add setHidden:NO];
        [_mScrollView setContentSize:CGSizeMake(0,0)];
    }
    else
    {
        [_time setHidden:NO];
        [_add setHidden:YES];
        [_mScrollView setContentSize:CGSizeMake(size.width + _location.frame.size.width,0)];
    }
    
    [_content setText:data.notificationContent];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        [self bringSubviewToFront:_location];
    }
    else
    {
        [self sendSubviewToBack:_location];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        [self bringSubviewToFront:_location];
    }
}

-(void)scrollBack
{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
@end
