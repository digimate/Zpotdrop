//
//  MenuProfileTableViewCell.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/2/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"

@interface MenuProfileTableViewCell : UITableViewCell

-(void)setupCellWithData:(UserDataModel*)data inSize:(CGSize)size;

@end
