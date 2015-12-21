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
#import "TableViewDataHandler.h"
#import "LoadingView.h"

@interface FeedSelectedViewCell : BaseTableViewCell<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIImageView* _imgvAvatar;
    IBOutlet UILabel* _lblName;
    IBOutlet UILabel* _lblZpotTitle;
    IBOutlet UILabel* _lblZpotAddress;
    IBOutlet UILabel* _lblZpotInfo;
    IBOutlet UIView* _viewForMap;
    IBOutlet UITableView* _tableViewComments;
    IBOutlet UIButton* _btnComming;
    IBOutlet UIButton* _btnLike;
    IBOutlet UIButton* _btnComment;
    IBOutlet UILabel* _lblZpotTime;
    IBOutlet UILabel* _lblSpotDistance;
    IBOutlet UIView* _viewButtons;
    IBOutlet NSLayoutConstraint* _lblNumberLikesWidth;
    IBOutlet NSLayoutConstraint* _lblNumberCommentsWidth;
    IBOutlet UILabel* _lblNumberLikes;
    IBOutlet UILabel* _lblNumberComments;
    UILabel* _lblLikeInfo;
    UILabel* _lblCommingInfo;
    NSMutableArray* _commentsData;
    TableViewDataHandler* tableDataHandler;
    LoadingView* loadingView;
    BOOL canLoadOldComments;
}
-(void)addComment:(BaseDataModel*)data;
@property(nonatomic, copy)void(^onShowComment)();

@end
