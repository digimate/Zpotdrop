//
//  BaseTableViewCell.h
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataModel.h"
@interface BaseTableViewCell : UITableViewCell
@property(nonatomic,retain)BaseDataModel* dataModel;
-(void)setupCellWithData:(BaseDataModel*)data andOptions:(NSDictionary*)param;
@end
