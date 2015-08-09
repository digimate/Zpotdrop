//
//  listModeCell.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FOLLOWER,
    FOLLOWING
}CONTACT_MODE;

typedef void(^contactHandler)(CONTACT_MODE mode);
@interface listModeCell : UITableViewCell
{
    UIButton* _btFollower;
    UIButton* _btFollowing;
    contactHandler _handler;
}

-(void)setupCellWithMode:(CONTACT_MODE)mode inSize:(CGSize)size AndHandler:(contactHandler)handler;

@end
