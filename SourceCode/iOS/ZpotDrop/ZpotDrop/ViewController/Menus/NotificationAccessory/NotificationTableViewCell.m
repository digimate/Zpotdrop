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

-(void)setupCellWithData:(id)data inSize:(CGSize)size andHandler:(notifiactionCellHandler)handler
{
    _handler = handler;
    if (!_mScrollView)
    {
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [_mScrollView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_mScrollView];
        
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(11, 7, size.height - 14, size.height - 14)];
        [_avatarImage circleWithBorderWidth:0 andColor:nil];
        [_mScrollView addSubview:_avatarImage];
        
        _username = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 7, _avatarImage.frame.origin.y, size.width - (_avatarImage.frame.size.width + _avatarImage.frame.origin.x + 7), _avatarImage.frame.size.height/2)];
        [_username setFont:[UIFont fontWithName:@"" size:15.f]];
        [_username setTextColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_mScrollView addSubview:_username];
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(_username.frame.origin.x, _username.frame.size.height + _username.frame.origin.y, size.width - _username.frame.origin.x, _avatarImage.frame.size.height/2)];
        [_content setTextColor:[UIColor blackColor]];
        [_content setFont:[UIFont fontWithName:@"" size:13.f]];
        [_mScrollView addSubview:_content];
        
        _location = [UIButton buttonWithType:UIButtonTypeCustom];
        [_location setFrame:CGRectMake(size.width - 60, 0, 60, size.height)];
        [_location setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_location setImage:[UIImage imageNamed:@"notification_location.png"] forState:UIControlStateNormal];
        
        _time = [[UILabel alloc]initWithFrame:CGRectMake(size.width - 60, _username.frame.origin.y, 60, _username.frame.size.height)];
        [_time setTextColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_time setText:@"1 min ago"];
        [_time setFont:[UIFont fontWithName:@"" size:11.f]];
        [_mScrollView addSubview:_time];
        
        _add = [UIButton buttonWithType:UIButtonTypeCustom];
        [_add setFrame:CGRectMake(size.width - 10 - _avatarImage.frame.size.width, _avatarImage.frame.origin.y, _avatarImage.frame.size.width, _avatarImage.frame.size.height)];
        [_add circleWithBorderWidth:0 andColor:nil];
        [_add setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_add setImage:[UIImage imageNamed:@"notification_add.png"] forState:UIControlStateNormal];
        [_mScrollView addSubview:_add];
        
        [self addSubview:_location];
    }
    
    
}

-(void)scrollBack
{
    
}
@end
