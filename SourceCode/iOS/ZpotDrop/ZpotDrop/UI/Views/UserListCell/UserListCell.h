//
//  UserListCell.h
//  ZpotDrop
//
//  Created by Vu Tiet on 12/25/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface UserListCell : BaseTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end
