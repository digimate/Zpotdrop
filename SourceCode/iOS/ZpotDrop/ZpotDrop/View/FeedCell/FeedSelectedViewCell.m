//
//  FeedSelectedViewCell.m
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedSelectedViewCell.h"
#import "Utils.h"
#import "FeedCommentCell.h"
#import "FeedCommentNotifyCell.h"
#import "UserDataModel.h"
#import "LocationDataModel.h"
#import "APIService.h"

@implementation FeedSelectedViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _viewButtons.width = self.width;
    [_viewButtons addBorderWithFrame:CGRectMake(0, 0, _viewButtons.width, 1.0) color:COLOR_SEPEARATE_LINE];
    [_btnComment addBorderWithFrame:CGRectMake(0, 0, 1.0, _btnComment.height) color:COLOR_SEPEARATE_LINE];
    [_btnComming addBorderWithFrame:CGRectMake(0, 0, 1.0, _btnComment.height) color:COLOR_SEPEARATE_LINE];
    [_btnLike setTitle:@"like".localized forState:UIControlStateNormal];
    [_btnLike setTitle:@"liked".localized forState:UIControlStateSelected];
    [_btnLike setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    
    [_btnComment setTitle:@"comment".localized forState:UIControlStateNormal];
    [_btnComment setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    
    [_btnComming setTitle:@"comming".localized forState:UIControlStateNormal];
    [_btnComming setTitle:@"comminged".localized forState:UIControlStateSelected];
    [_btnComming setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [_lblZpotTitle setWidth:(_lblZpotTitle.width + (self.width - 320))];
    [_viewForMap setWidth:self.width];
    [_tableViewComments setWidth:self.width];
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    _lblName.textColor = COLOR_DARK_GREEN;
    _lblZpotInfo.backgroundColor = [COLOR_DARK_GREEN colorWithAlphaComponent:0.5];
    _lblName.text = _lblZpotAddress.text = _lblZpotInfo.text = _lblZpotTitle.text = nil;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]init];
    tapGesture.numberOfTapsRequired = 1;
    [_viewForMap addGestureRecognizer:tapGesture];
    
    _commentsData = [NSMutableArray array];
    [_tableViewComments registerNib:[UINib nibWithNibName:NSStringFromClass([FeedCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedCommentCell class])];
    [_tableViewComments registerNib:[UINib nibWithNibName:NSStringFromClass([FeedCommentNotifyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedCommentNotifyCell class])];
    _tableViewComments.delegate = self;
    _tableViewComments.dataSource = self;
    
    tableDataHandler = [[TableViewDataHandler alloc]init];
    tableDataHandler.addOnTop = NO;
    loadingView = [[LoadingView alloc]init];
    
    [_btnComming addTarget:self action:@selector(sendCommingNotify:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLike addTarget:self action:@selector(likeFeed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if ([data isKindOfClass:[FeedDataModel class]]) {
        FeedDataModel* feedData = (FeedDataModel*)data;
        self.dataModel = data;
        self.dataModel.dataDelegate = self;
        if (feedData.user_id != nil && feedData.user_id.length > 0) {
            UserDataModel* poster = (UserDataModel*)[UserDataModel fetchObjectWithID:feedData.user_id];
            [poster updateObjectForUse:^{
                _lblName.text = poster.name;
            }];
        }
        if (feedData.location_id != nil && feedData.location_id.length > 0) {
            LocationDataModel* location = (LocationDataModel*)[LocationDataModel fetchObjectWithID:feedData.location_id];
            [location updateObjectForUse:^{
                _lblZpotAddress.text = [NSString stringWithFormat:@"%@-%@",location.name,location.address];
            }];
        }
        _lblZpotTitle.text = feedData.title;
        if ([Utils instance].isGPS) {
            NSString* distance = [[Utils instance] distanceWithMoveTimeBetweenCoor:CLLocationCoordinate2DMake([feedData.latitude doubleValue], [feedData.longitude doubleValue]) andCoor:[Utils instance].locationManager.location.coordinate];
            _lblZpotInfo.text = distance;
        }
        _imgvAvatar.image = [UIImage imageNamed:@"avatar"];

        _btnComming.enabled = ![feedData.user_id isEqualToString:[AccountModel currentAccountModel].user_id];
        
        _lblZpotTitle.text = feedData.title;
        _lblZpotTime.text = [[Utils instance]convertDateToRecent:feedData.time];
        if ([Utils instance].isGPS) {
            _lblSpotDistance.text = [[Utils instance] distanceBetweenCoor:CLLocationCoordinate2DMake([feedData.latitude doubleValue], [feedData.longitude doubleValue]) andCoor:[Utils instance].locationManager.location.coordinate];
            
        }

        
        [[Utils instance] clearMapViewBeforeUsing];
        [[[Utils instance]mapView] setFrame:_viewForMap.bounds];
        [_viewForMap addSubview:[[Utils instance] mapView]];
        [_viewForMap sendSubviewToBack:[[Utils instance] mapView]];
        [[Utils instance] mapView].userInteractionEnabled = YES;
        [[Utils instance] mapView].scrollEnabled = NO;
        [[Utils instance] mapView].zoomEnabled = YES;
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(10.784693, 106.684585);
        MKCoordinateRegion adjustedRegion = [[[Utils instance] mapView] regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 400, 400)];
        [[[Utils instance] mapView] removeAnnotations:[[Utils instance] mapView].annotations];
        [[[Utils instance] mapView] setRegion:adjustedRegion animated:NO];
        [[Utils instance] mapView].delegate = self;
        //add annotation
        ZpotAnnotation *annotationPoint = [[ZpotAnnotation alloc] init];
        [annotationPoint setCoordinate:startCoord];
        [annotationPoint setTitle:_lblZpotTitle.text];
        [[[Utils instance] mapView] addAnnotation:annotationPoint];
        
        [_commentsData removeAllObjects];
        [tableDataHandler handleData:_commentsData ofTableView:_tableViewComments];
        [_tableViewComments reloadData];
        
        //headerView
        _tableViewComments.tableHeaderView = nil;
        UIView* viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableViewComments.width, 28)];
        UILabel* lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(10, 0,viewHeader.width-10, viewHeader.height-2)];
        lblHeader.textColor = [COLOR_DARK_GREEN colorWithAlphaComponent:0.7];
        lblHeader.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
        lblHeader.text = nil;
        [viewHeader addSubview:lblHeader];
        _lblLikeInfo = lblHeader;
        _tableViewComments.tableHeaderView = viewHeader;
        NSArray* arrayLikeUserID;
        if (feedData.like_userIds.length > 0) {
            arrayLikeUserID = [feedData.like_userIds componentsSeparatedByString:@","];
        }else{
            arrayLikeUserID = @[];
        }
        [[Utils instance]convertLikeIDsToInfo:arrayLikeUserID completion:^(NSString *txt) {
            _lblLikeInfo.text = txt;
        }];
        [self loadComments];
        _btnLike.selected = ([feedData.like_userIds rangeOfString:[AccountModel currentAccountModel].user_id].location != NSNotFound);
        _btnComming.selected = ([feedData.comming_userIds rangeOfString:[AccountModel currentAccountModel].user_id].location != NSNotFound);
        
        //setup comment number
        NSString* commentString;
        if ([feedData.comment_count integerValue] > 1) {
            commentString = [NSString stringWithFormat:@"%@ %@",feedData.comment_count.description,@"comments".localized];
        }else{
            commentString = [NSString stringWithFormat:@"%@ %@",feedData.comment_count.description,@"comment".localized];
        }
        NSMutableAttributedString* commentAttString = [[NSMutableAttributedString alloc]initWithString:commentString];
        [commentAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, feedData.comment_count.description.length)];
        _lblNumberComments.attributedText = commentAttString;
        
        //setup like number
        NSString* likeString;
        if ([feedData.like_count integerValue] > 1) {
            likeString = [NSString stringWithFormat:@"%@ %@",feedData.like_count.description,@"likes".localized];
        }else{
            likeString = [NSString stringWithFormat:@"%@ %@",feedData.like_count.description,@"like".localized];
        }
        NSMutableAttributedString* likeAttString = [[NSMutableAttributedString alloc]initWithString:likeString];
        [likeAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, feedData.like_count.description.length)];
        _lblNumberLikes.attributedText = likeAttString;
        
        CGSize s = [_lblNumberComments sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberComments.height)];
        _lblNumberCommentsWidth.constant = ceilf(s.width);
        
        s = [_lblNumberLikes sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberLikes.height)];
        _lblNumberLikesWidth.constant = ceilf(s.width);
    }
}

-(void)updateUIForDataModel:(BaseDataModel *)model options:(NSDictionary*)params{
    if (self.dataModel) {
        FeedDataModel* feedData = (FeedDataModel*)self.dataModel;
        NSArray* arrayLikeUserID;
        if (feedData.like_userIds.length > 0) {
            arrayLikeUserID = [feedData.like_userIds componentsSeparatedByString:@","];
        }else{
            arrayLikeUserID = @[];
        }
        [[Utils instance]convertLikeIDsToInfo:arrayLikeUserID completion:^(NSString *txt) {
            _lblLikeInfo.text = txt;
        }];
        _btnLike.selected = ([feedData.like_userIds rangeOfString:[AccountModel currentAccountModel].user_id].location != NSNotFound);
        _btnComming.selected = ([feedData.comming_userIds rangeOfString:[AccountModel currentAccountModel].user_id].location != NSNotFound);
        
        //setup comment number
        NSString* commentString;
        if ([feedData.comment_count integerValue] > 1) {
            commentString = [NSString stringWithFormat:@"%@ %@",feedData.comment_count.description,@"comments".localized];
        }else{
            commentString = [NSString stringWithFormat:@"%@ %@",feedData.comment_count.description,@"comment".localized];
        }
        NSMutableAttributedString* commentAttString = [[NSMutableAttributedString alloc]initWithString:commentString];
        [commentAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, feedData.comment_count.description.length)];
        _lblNumberComments.attributedText = commentAttString;
        
        //setup like number
        NSString* likeString;
        if ([feedData.like_count integerValue] > 1) {
            likeString = [NSString stringWithFormat:@"%@ %@",feedData.like_count.description,@"likes".localized];
        }else{
            likeString = [NSString stringWithFormat:@"%@ %@",feedData.like_count.description,@"like".localized];
        }
        NSMutableAttributedString* likeAttString = [[NSMutableAttributedString alloc]initWithString:likeString];
        [likeAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, feedData.like_count.description.length)];
        _lblNumberLikes.attributedText = likeAttString;
        
        CGSize s = [_lblNumberComments sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberComments.height)];
        _lblNumberCommentsWidth.constant = ceilf(s.width);
        
        s = [_lblNumberLikes sizeThatFits:CGSizeMake(MAXFLOAT, _lblNumberLikes.height)];
        _lblNumberLikesWidth.constant = ceilf(s.width);
    }
    
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 472;
}

-(void)likeFeed:(UIButton*)sender{
    if (self.dataModel) {
        FeedDataModel* feedData = (FeedDataModel*)self.dataModel;
        sender.enabled = NO;
        if (sender.isSelected) {
            [[APIService shareAPIService] unlikeFeedWithID:feedData.mid completion:^(BOOL successful, NSString *error) {
                sender.enabled = YES;
                if (!successful) {
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }else{
                    sender.selected = NO;
                }
            }];
        }else{
            [[APIService shareAPIService] likeFeedWithID:feedData.mid completion:^(BOOL successful, NSString *error) {
                sender.enabled = YES;
                if (!successful) {
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }else{
                    sender.selected = YES;
                }
            }];
        }
        
    }
}

-(void)sendCommingNotify:(UIButton*)sender{
    if (self.dataModel != nil) {
        sender.enabled = NO;
        FeedDataModel* feedData = (FeedDataModel*)self.dataModel;
        if (sender.isSelected) {
            //send uncomming
            [[APIService shareAPIService]sendUnCommingNotifyForFeedID:feedData.mid completion:^(BOOL isSuccess, NSString *error) {
                sender.enabled = YES;
                if (isSuccess) {
                    _btnComming.selected = NO;
                    NSArray* deleteArray = [FeedCommentDataModel fetchObjectsWithPredicate:[NSPredicate predicateWithFormat:@"feed_id = %@ AND user_id = %@ AND type = %@",feedData.mid,[AccountModel currentAccountModel].user_id,TYPE_NOTIFY] sorts:nil];
                    [tableDataHandler removeData:deleteArray];
                }else{
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
            }];
            
        }else{
            //send comming
            [[APIService shareAPIService]sendCommingNotifyForFeedID:feedData.mid completion:^(BOOL isSuccess, NSString *error) {
                sender.enabled = YES;
                if (isSuccess) {
                    _btnComming.selected = YES;
                    FeedCommentDataModel* comment = (FeedCommentDataModel*)[FeedCommentDataModel fetchObjectWithID:[[NSDate date] string]];
                    comment.message = @"";
                    comment.feed_id = feedData.mid;
                    comment.user_id = [AccountModel currentAccountModel].user_id;
                    comment.status = STATUS_DELIVER;
                    comment.type = TYPE_NOTIFY;
                    comment.time = [NSDate date];
                    if (![_commentsData containsObject:comment]) {
                        [tableDataHandler insertData:comment];
                    }
                }else{
                    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    }];
                }
            }];
        }
    }
}

-(void)addComment:(BaseDataModel*)data{
    [tableDataHandler insertData:data];
    [self performSelector:@selector(scrollToTop) withObject:nil afterDelay:0.3];
}
-(void)scrollToTop{
    [_tableViewComments setContentOffset:CGPointZero];
}

-(void)removeComment:(BaseDataModel*)data{
    if (data != nil) {
        [tableDataHandler removeData:data];
    }
}

-(void)loadComments{
    FeedDataModel* feedModel = (FeedDataModel*)self.dataModel;
    if (feedModel) {
        [loadingView showViewInView:_tableViewComments];
        [[APIService shareAPIService]getCommentsFromServerForFeedID:feedModel.mid completion:^(NSMutableArray *returnData, NSString *error) {
            [loadingView hideView];
            [self loadCommentsFromLocal];
        }];
    }
}

-(void)loadCommentsFromLocal{
    FeedDataModel* feedModel = (FeedDataModel*)self.dataModel;
    if (feedModel) {
        NSSortDescriptor* sortByTime = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
        NSArray* comments = [FeedCommentDataModel fetchObjectsWithPredicate:[NSPredicate predicateWithFormat:@"feed_id = %@",feedModel.mid] sorts:@[sortByTime]];
        [_commentsData removeAllObjects];
        [_commentsData addObjectsFromArray:comments];
        [_tableViewComments reloadData];
    }
    
}
#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *const kAnnotationIdentifier = @"ZpotMapAnnotation";
    ZpotAnnotationView *annotationView = (ZpotAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
    if (! annotationView) {
        annotationView = [[ZpotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
    }
    [annotationView setAnnotation:annotation];
    
    return annotationView;
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentsData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id data = [_commentsData objectAtIndex:indexPath.row];
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];
    cell.dataModel.dataDelegate = nil;
    cell.dataModel = nil;
    [cell setupCellWithData:data andOptions:nil];
    if ([cell isKindOfClass:[FeedCommentCell class]]) {
        FeedSelectedViewCell* weak = weakObject(self);
        FeedCommentCell* weakCommentCell = weakObject(cell);
        [(FeedCommentCell*)cell setOnDeleteComment:^{
            [weak removeComment:weakCommentCell.dataModel];
        }];
    }
    return cell;
}
-(NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    FeedCommentDataModel* data = (FeedCommentDataModel*)[_commentsData objectAtIndex:indexPath.row];
    if ([data.type isEqualToString:TYPE_NOTIFY]) {
        return NSStringFromClass([FeedCommentNotifyCell class]);
    }
    return NSStringFromClass([FeedCommentCell class]);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedCommentDataModel* data = (FeedCommentDataModel*)[_commentsData objectAtIndex:indexPath.row];
    if ([data.type isEqualToString:TYPE_NOTIFY]) {
        return [FeedCommentNotifyCell cellHeightWithData:data];
    }
    return [FeedCommentCell cellHeightWithData:data];
}

@end
