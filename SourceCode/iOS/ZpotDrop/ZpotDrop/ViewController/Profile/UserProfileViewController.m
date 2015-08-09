//
//  UserProfileViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UserProfileViewController.h"
#import "FeedNormalViewCell.h"

@interface UserProfileViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView* viewHeader;
    UITableView* userZpotsTableView;
    NSMutableArray* userZpotsData;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"profile".localized.uppercaseString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    userZpotsData = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3"]];
    /*=============Profile header=========*/
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 233)];
    [self.view addSubview:viewHeader];

    UIImageView* imgvAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 100, 100)];
    imgvAvatar.layer.cornerRadius = imgvAvatar.width/2;
    imgvAvatar.layer.masksToBounds = YES;
    imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    [viewHeader addSubview:imgvAvatar];
 
    UILabel* lblName = [[UILabel alloc]initWithFrame:CGRectMake(140, 20, self.view.width - 160, 20)];
    lblName.font = [UIFont fontWithName:@"PTSans-Bold" size:18];
    lblName.textColor = [UIColor colorWithRed:163 green:163 blue:163];
    lblName.text = @"Sonny Truong";
    [viewHeader addSubview:lblName];
    
    UILabel* lblAddress = [[UILabel alloc]initWithFrame:CGRectMake(lblName.x, lblName.y + lblName.height + 4, lblName.width, 16)];
    lblAddress.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    lblAddress.textColor = [UIColor colorWithRed:212 green:212 blue:212];
    lblAddress.text = @"Stockholm";
    [viewHeader addSubview:lblAddress];
    
    UILabel* lblAge = [[UILabel alloc]initWithFrame:CGRectMake(lblName.x, lblAddress.y + lblAddress.height + 2, lblName.width, 16)];
    lblAge.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    lblAge.textColor = [UIColor colorWithRed:212 green:212 blue:212];
    lblAge.text = @"25 years";
    [viewHeader addSubview:lblAge];
    
    UILabel* lblTitlePlaces = [[UILabel alloc]initWithFrame:CGRectMake(lblName.x, lblAge.y + lblAge.height + 6, lblName.width, 17)];
    lblTitlePlaces.font = [UIFont fontWithName:@"PTSans-Regular" size:15];
    lblTitlePlaces.textColor = lblName.textColor;
    lblTitlePlaces.text = @"Top 3 places";
    [viewHeader addSubview:lblTitlePlaces];
    
    UILabel* lblPlaces = [[UILabel alloc]initWithFrame:CGRectMake(lblName.x, lblTitlePlaces.y + lblTitlePlaces.height + 2, lblName.width, 50)];
    lblPlaces.numberOfLines = 0;
    lblPlaces.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    lblPlaces.textColor = [UIColor colorWithRed:212 green:212 blue:212];
    lblPlaces.text = @"Taverna Brillo\nTMS Building\nBetexco Tower";
    [viewHeader addSubview:lblPlaces];
    
    UIView* viewStatics = [[UIView alloc]initWithFrame:CGRectMake(0, lblPlaces.y + lblPlaces.height+ 20, self.view.width, 60)];
    viewStatics.backgroundColor =COLOR_DARK_GREEN;
    [viewHeader addSubview:viewStatics];
    
    UILabel* lblFollowerTitle = [[UILabel alloc]initWithFrame:CGRectMake(viewStatics.width/2 - 40, viewStatics.height/2, 80, 20)];
    lblFollowerTitle.textAlignment = NSTextAlignmentCenter;
    lblFollowerTitle.font = [UIFont fontWithName:@"PTSans-Regular" size:12];
    lblFollowerTitle.textColor = [UIColor whiteColor];
    lblFollowerTitle.text = @"followers".localized.uppercaseString;
    [viewStatics addSubview:lblFollowerTitle];
    
    UILabel* lblFollowingTitle = [[UILabel alloc]initWithFrame:CGRectMake(lblFollowerTitle.x + lblFollowerTitle.width + 2, viewStatics.height/2, lblFollowerTitle.width, lblFollowerTitle.height)];
    lblFollowingTitle.textAlignment = NSTextAlignmentCenter;
    lblFollowingTitle.font = [UIFont fontWithName:@"PTSans-Regular" size:12];
    lblFollowingTitle.textColor = [UIColor whiteColor];
    lblFollowingTitle.text = @"following".localized.uppercaseString;
    [viewStatics addSubview:lblFollowingTitle];
    
    UILabel* lblDropTitle = [[UILabel alloc]initWithFrame:CGRectMake(lblFollowerTitle.x -2 - lblFollowerTitle.width, viewStatics.height/2, lblFollowerTitle.width, lblFollowerTitle.height)];
    lblDropTitle.font = [UIFont fontWithName:@"PTSans-Regular" size:12];
    lblDropTitle.textColor = [UIColor whiteColor];
    lblDropTitle.text = @"drops".localized.uppercaseString;
    lblDropTitle.textAlignment = NSTextAlignmentCenter;
    [viewStatics addSubview:lblDropTitle];
    
    UILabel* lblNumberFollower = [[UILabel alloc]initWithFrame:CGRectMake(lblFollowerTitle.x, lblFollowerTitle.y - 24, lblFollowerTitle.width, 24)];
    lblNumberFollower.font = [UIFont fontWithName:@"PTSans-Bold" size:20];
    lblNumberFollower.textColor = [UIColor whiteColor];
    lblNumberFollower.textAlignment = NSTextAlignmentCenter;
    lblNumberFollower.text = @"120";
    [viewStatics addSubview:lblNumberFollower];
    
    UILabel* lblNumberFollowing = [[UILabel alloc]initWithFrame:CGRectMake(lblFollowingTitle.x, lblFollowingTitle.y - lblNumberFollower.height, lblFollowingTitle.width, lblNumberFollower.height)];
    lblNumberFollowing.font = [UIFont fontWithName:@"PTSans-Bold" size:20];
    lblNumberFollowing.textColor = [UIColor whiteColor];
    lblNumberFollowing.textAlignment = NSTextAlignmentCenter;
    lblNumberFollowing.text = @"103";
    [viewStatics addSubview:lblNumberFollowing];
    
    UILabel* lblNumberDrop = [[UILabel alloc]initWithFrame:CGRectMake(lblDropTitle.x, lblDropTitle.y - lblNumberFollower.height, lblDropTitle.width, lblNumberFollower.height)];
    lblNumberDrop.font = [UIFont fontWithName:@"PTSans-Bold" size:20];
    lblNumberDrop.textColor = [UIColor whiteColor];
    lblNumberDrop.textAlignment = NSTextAlignmentCenter;
    lblNumberDrop.text = @"10";
    [viewStatics addSubview:lblNumberDrop];
    
    /*=============User's ZPot=========*/
    userZpotsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, viewHeader.height, self.view.width, self.view.height - 64 - viewHeader.height) style:UITableViewStylePlain];
    userZpotsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [userZpotsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedNormalViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedNormalViewCell class])];
    userZpotsTableView.dataSource = self;
    userZpotsTableView.delegate = self;
    [self.view addSubview:userZpotsTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return userZpotsData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id data = [userZpotsData objectAtIndex:indexPath.row];
    return [FeedNormalViewCell cellHeightWithData:data];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier = [self cellIdentiferForIndexPath:indexPath];
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    [cell addBorderWithFrame:CGRectMake(10, height - 1.0, cell.width-20, 1.0) color:COLOR_SEPEARATE_LINE];
    [cell setupCellWithData:nil andOptions:nil];
    return cell;
}

-(NSString*)cellIdentiferForIndexPath:(NSIndexPath*)indexPath{
    return NSStringFromClass([FeedNormalViewCell class]);
}

@end
