//
//  FeedSelectedViewCell.h
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import <MapKit/MapKit.h>

@interface FeedSelectedViewCell : BaseTableViewCell<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIImageView* _imgvAvatar;
    IBOutlet UILabel* _lblName;
    IBOutlet UILabel* _lblZpotTitle;
    IBOutlet UILabel* _lblZpotAddress;
    IBOutlet UILabel* _lblZpotInfo;
    IBOutlet UIView* _viewForMap;
    IBOutlet UITableView* _tableViewComments;
    IBOutlet UIButton* _btnComming;
}

@end
