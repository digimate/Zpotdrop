//
//  UserListCell.m
//  ZpotDrop
//
//  Created by Vu Tiet on 12/25/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "UserListCell.h"
#import "UserDataModel.h"
#import "NSString+Ext.h"

@implementation UserListCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    // Initialization code
}


-(void)setupCellWithData:(BaseDataModel*)data andOptions:(NSDictionary*)param
{
    UserDataModel* user = (UserDataModel*)[UserDataModel fetchObjectWithID:data.mid];
    self.avatarImageView.image = [UIImage imageNamed:@"avatar"];
    [user updateObjectForUse:^{
        self.nameLabel.text = user.name;
        if (user.avatar.length > 0) {
            self.avatarImageView.image = [user.avatar stringToUIImage];
        }
    }];
}

@end
