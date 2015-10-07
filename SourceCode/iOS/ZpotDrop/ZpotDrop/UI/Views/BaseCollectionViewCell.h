//
//  BaseCollectionViewCell.h
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataModel.h"
@interface BaseCollectionViewCell : UICollectionViewCell
-(void)setupCellWithData:(BaseDataModel*)data andOptions:(NSDictionary*)param;
@end
