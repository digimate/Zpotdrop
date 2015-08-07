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

@implementation FeedSelectedViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [_lblZpotTitle setWidth:(_lblZpotTitle.width + (self.width - 320))];
    [_viewForMap setWidth:self.width];
    [_tableViewComments setWidth:self.width];
    _imgvAvatar.layer.cornerRadius = _imgvAvatar.width/2;
    _imgvAvatar.layer.masksToBounds = YES;
    _lblName.textColor = _btnComming.backgroundColor =  COLOR_DARK_GREEN;
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
    
    insertHandler = [[TableViewInsertDataHandler alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    _lblName.text = @"Alex Stone";
    _lblZpotAddress.text = @"Villandry - StJames's";
    _lblZpotTitle.text = @"Brunch with mom.";
    [_btnComming setTitle:@"comming".localized forState:UIControlStateNormal];
    _lblZpotInfo.text = [NSString stringWithFormat:@"zpot_distance_format".localized,@"234 m",@"3 min",@"1 min"];
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
    [_commentsData addObjectsFromArray:@[@"2",@"1",@"1"]];
    [insertHandler handleInsertData:_commentsData ofTableView:_tableViewComments];
    [_tableViewComments reloadData];
    
    //headerView
    _tableViewComments.tableHeaderView = nil;
    UIView* viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableViewComments.width, 28)];
    UILabel* lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(10, 0,viewHeader.width-10, viewHeader.height-2)];
    lblHeader.textColor = [COLOR_DARK_GREEN colorWithAlphaComponent:0.7];
    lblHeader.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    lblHeader.text = @"You, Alex and 5 others like this";
    [viewHeader addSubview:lblHeader];
    _tableViewComments.tableHeaderView = viewHeader;
}

+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 390;
}
-(void)addComment:(BaseDataModel*)data{
    [insertHandler insertData:@"2"];
    [self performSelector:@selector(scrollToTop) withObject:nil afterDelay:0.3];
}
-(void)scrollToTop{
    [_tableViewComments setContentOffset:CGPointZero];
}
#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
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
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath]];
    [cell setupCellWithData:data andOptions:nil];
    return cell;
}
-(NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    id data = [_commentsData objectAtIndex:indexPath.row];
    if ([data isEqualToString:@"1"]) {
        return NSStringFromClass([FeedCommentNotifyCell class]);
    }
    return NSStringFromClass([FeedCommentCell class]);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id data = [_commentsData objectAtIndex:indexPath.row];
    if ([data isEqualToString:@"1"]) {
        return [FeedCommentNotifyCell cellHeightWithData:data];
    }
    return [FeedCommentCell cellHeightWithData:data];
}

@end
