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
@synthesize onFollowUser,onShowPost,onUnFollowUser;
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

-(void)showPost{
    if (self.onShowPost) {
        self.onShowPost((NotificationModel*)self.dataModel);
    }
}

-(void)followUser:(UIButton*)sender{
    if (sender.isSelected) {
        if (self.onUnFollowUser) {
            self.onUnFollowUser((NotificationModel*)self.dataModel);
        }
    }else{
        if (self.onFollowUser) {
            self.onFollowUser((NotificationModel*)self.dataModel);
        }
    }
}

-(void)updateUIForDataModel:(BaseDataModel *)model options:(NSDictionary *)params{
    [self setupCellWithData:model andOptions:params];
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, [NotificationTableViewCell cellHeightWithData:nil])];
        [_mScrollView setShowsHorizontalScrollIndicator:NO];
        [_mScrollView setPagingEnabled:YES];
        [self addSubview:_mScrollView];
    }
    _mScrollView.delegate = self;
    [_mScrollView setBackgroundColor:[UIColor clearColor]];
    for (UIView* sub in _mScrollView.subviews) {
        [sub removeFromSuperview];
    }
    self.dataModel = data;
    NotificationModel* notifModel = (NotificationModel*)data;
    
    CGSize size = _mScrollView.frame.size;
    
    if (!viewButtons) {
        viewButtons = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [viewButtons setBackgroundColor:[UIColor clearColor]];
        [self addSubview:viewButtons];
    }
    for (UIView* sub in viewButtons.subviews) {
        [sub removeFromSuperview];
    }
    [self sendSubviewToBack:viewButtons];

    
    UIView* _background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [_background setBackgroundColor:[UIColor whiteColor]];
    [_mScrollView addSubview:_background];
    UserDataModel* sender = (UserDataModel*)[UserDataModel fetchObjectWithID:notifModel.sender_id];
    [sender updateObjectForUse:^{
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(11, 7, size.height - 14, size.height - 14)];
        [_avatarImage setImage:[UIImage imageNamed:@"avatar"]];
        [_avatarImage circleWithBorderWidth:0 andColor:nil];
        if (sender.avatar.length > 0) {
            _avatarImage.image = [sender.avatar stringToUIImage];
        }
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
        CGFloat buttonWidth = 0;
        if ([notifModel.type isEqualToString:NOTIFICATION_COMMING]) {
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_comming_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
            
            UIButton* btnComming = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnComming setBackgroundColor:COLOR_DARK_GREEN];
            [btnComming setFrame:CGRectMake(0, 0, size.height, size.height)];
            [btnComming setImage:[UIImage imageNamed:@"ic_location_white"] forState:UIControlStateNormal];
            [btnComming addTarget:self action:@selector(showPost) forControlEvents:UIControlEventTouchUpInside];
            [viewButtons addSubview:btnComming];
            buttonWidth = size.height;
        }else if ([notifModel.type isEqualToString:NOTIFICATION_COMMENT]){
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_comment_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
            
            UIButton* btnComming = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnComming setBackgroundColor:COLOR_DARK_GREEN];
            [btnComming setFrame:CGRectMake(0, 0, size.height, size.height)];
            [btnComming setImage:[UIImage imageNamed:@"ic_location_white"] forState:UIControlStateNormal];
            [btnComming addTarget:self action:@selector(showPost) forControlEvents:UIControlEventTouchUpInside];
            [viewButtons addSubview:btnComming];
            buttonWidth = size.height;
        }else if ([notifModel.type isEqualToString:NOTIFICATION_LIKE]){
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_like_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
            
            UIButton* btnComming = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnComming setBackgroundColor:COLOR_DARK_GREEN];
            [btnComming setFrame:CGRectMake(0, 0, size.height, size.height)];
            [btnComming setImage:[UIImage imageNamed:@"ic_location_white"] forState:UIControlStateNormal];
            [btnComming addTarget:self action:@selector(showPost) forControlEvents:UIControlEventTouchUpInside];
            [viewButtons addSubview:btnComming];
            buttonWidth = size.height;
        }else if ([notifModel.type isEqualToString:NOTIFICATION_FOLLOW]){
            //update user follow me
            NSMutableArray* array = [NSMutableArray arrayWithArray:[[AccountModel currentAccountModel].follower_ids componentsSeparatedByString:@","]];
            if (![array containsObject:sender.mid]) {
                [array addObject:sender.mid];
                [AccountModel currentAccountModel].follower_ids = [array componentsJoinedByString:@","];
            }
            
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_follow_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : COLOR_DARK_GREEN,
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
            
            UIButton* btnFollow = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnFollow setFrame:CGRectMake(0, 7, (size.height- 14), (size.height- 14))];
            [btnFollow setImage:[UIImage imageNamed:@"ic_add_friend"] forState:UIControlStateNormal];
            [btnFollow setImage:[UIImage imageNamed:@"ic_friended"] forState:UIControlStateSelected];
            [btnFollow addTarget:self action:@selector(followUser:) forControlEvents:UIControlEventTouchUpInside];
            [viewButtons addSubview:btnFollow];
            buttonWidth = size.height;
            //check whether me follow this user
            array = [NSMutableArray arrayWithArray:[[AccountModel currentAccountModel].following_ids componentsSeparatedByString:@","]];
            if ([array containsObject:sender.mid]) {
                btnFollow.selected = YES;
            }else{
                btnFollow.selected = NO;
            }
        }else if ([notifModel.type isEqualToString:NOTIFICATION_FB_Friend]){
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_facebook_format".localized,name,date]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
        } else if ([notifModel.type isEqualToString:NOTIFICATION_REQUEST_LOCATION]) {
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_request_location_format".localized,name]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
        } else if ([notifModel.type isEqualToString:NOTIFICATION_SHARE_LOCATION]) {
            attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"notification_share_location_format".localized,name]];
            NSDictionary* dictName = @{NSForegroundColorAttributeName : [UIColor blackColor],
                                       NSFontAttributeName : [UIFont fontWithName:@"PTSans-Bold" size:14]};
            NSRange rangeName = [attStr.string rangeOfString:name];
            NSRange rangeDate = [attStr.string rangeOfString:date];
            [attStr addAttributes:dictDate range:rangeDate];
            [attStr addAttributes:dictName range:rangeName];
        }
        
        CGRect frame = viewButtons.frame;
        frame.size.width = buttonWidth;
        frame.origin.x = size.width - frame.size.width;
        viewButtons.frame = frame;
        
        [_content setAttributedText:attStr];
        [_background addSubview:_content];
        
        [_mScrollView setContentSize:CGSizeMake(size.width + buttonWidth,0)];
        [self addBorderWithFrame:CGRectMake(_content.x, size.height - 1, size.width - _content.x, 1.0) color:COLOR_SEPEARATE_LINE];
    }];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        [self bringSubviewToFront:viewButtons];
    }
    else
    {
        [self sendSubviewToBack:viewButtons];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        [self bringSubviewToFront:viewButtons];
    }else
    {
        [self sendSubviewToBack:viewButtons];
    }
}

-(void)scrollBack
{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}
@end
