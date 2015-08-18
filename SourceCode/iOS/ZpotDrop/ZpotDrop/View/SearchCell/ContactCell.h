//
//  ContactCell.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"

typedef void(^followHandler)(BOOL setFollow);

@interface ContactCell : UITableViewCell
{
    UIImageView* _avatar;
    UILabel* _username;
    UIButton* _folow;
    followHandler _handler;
    BOOL _isFollowing;
}

-(void)setupCellWithData:(UserDataModel*)data inSize:(CGSize)size;
-(void)setFollow:(BOOL)follow withHandler:(followHandler)handler;

@end
