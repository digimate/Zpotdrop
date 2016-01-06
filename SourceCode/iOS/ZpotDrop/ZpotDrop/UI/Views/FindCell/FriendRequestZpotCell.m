//
//  FriendRequestZpotCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FriendRequestZpotCell.h"
#import "Utils.h"
#import "UserDataModel.h"
#import "APIService.h"

@implementation FriendRequestZpotCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    imgvAvatar.layer.cornerRadius = imgvAvatar.width/2;
    imgvAvatar.layer.masksToBounds = YES;
    btnRequestZpot.backgroundColor = COLOR_DARK_GREEN;
    btnRequestZpot.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    [btnRequestZpot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRequestZpot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnRequestZpot setTitle:@"request_zpot".localized forState:UIControlStateNormal];
    [btnRequestZpot addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    lblName.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    lblName.textColor = [UIColor colorWithRed:188 green:188 blue:188];
    lblName.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 50;
}
-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if ([data isKindOfClass:[UserDataModel class]]) {
        self.dataModel = data;
        UserDataModel* user = (UserDataModel*)data;
        imgvAvatar.image = [UIImage imageNamed:@"avatar"];
        [user updateObjectForUse:^{
            lblName.text = user.name;
            if (user.avatar.length > 0) {
                imgvAvatar.image = [user.avatar stringToUIImage];
            }
        }];
        
    }
    
}

-(void)sendRequest:(UIButton*)sender{
    if ([self.dataModel isKindOfClass:[UserDataModel class]]) {
       UserDataModel* user = (UserDataModel*)self.dataModel;
        sender.enabled = NO;
        [[APIService shareAPIService]requestLocationOfUserID:user.mid completion:^(BOOL successful, NSString *error) {
            sender.enabled = YES;
            if (error) {
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            } else {
                NSString *zpotMessage = [NSString stringWithFormat:@"You have been requested zpot to %@", user.name];
                [[Utils instance]showAlertWithTitle:nil message:zpotMessage yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }
        }];
    }
}
@end
