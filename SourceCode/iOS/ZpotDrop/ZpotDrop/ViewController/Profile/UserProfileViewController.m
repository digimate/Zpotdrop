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
@synthesize userModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"profile".localized.uppercaseString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    userZpotsData = [NSMutableArray array];
    /*=============Profile header=========*/
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 233)];
    [self.view addSubview:viewHeader];

    [[Utils instance] clearMapViewBeforeUsing];
    [[Utils instance].mapView setFrame:viewHeader.bounds];
    [[Utils instance].mapView setShowsUserLocation:YES];
    [viewHeader addSubview:[Utils instance].mapView];
    
    UIView* blurView = [[UIView alloc]initWithFrame:viewHeader.bounds];
    blurView.backgroundColor = [COLOR_DARK_GREEN colorWithAlphaComponent:0.8];
    [viewHeader addSubview:blurView];
    
    UIView* viewAvatar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 98, 98)];
    viewAvatar.layer.cornerRadius = viewAvatar.width/2;
    viewAvatar.layer.masksToBounds = YES;
    viewAvatar.backgroundColor = [UIColor colorWithRed:212 green:223 blue:192];
    viewAvatar.center = CGPointMake(viewHeader.width/2, viewHeader.height/2);
    [viewHeader addSubview:viewAvatar];
    
    UIImageView* imgvAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    imgvAvatar.layer.cornerRadius = imgvAvatar.width/2;
    imgvAvatar.layer.masksToBounds = YES;
    imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    imgvAvatar.center = CGPointMake(viewHeader.width/2, viewHeader.height/2);
    [viewHeader addSubview:imgvAvatar];
    
    UILabel* lblName = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.view.width - 40, 22)];
    lblName.font = [UIFont fontWithName:@"PTSans-Bold" size:20];
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.textColor = [UIColor whiteColor];
    [viewHeader addSubview:lblName];
    
    UIButton* btnHometown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHometown.userInteractionEnabled = NO;
    [[btnHometown titleLabel]setFont:[UIFont fontWithName:@"PTSans-Regular" size:14]];
    [btnHometown setFrame:CGRectMake(20, 35, viewHeader.width - 40, 16)];
    [btnHometown setImage:[UIImage imageNamed:@"ic_location_white"] forState:UIControlStateNormal];
    [viewHeader addSubview:btnHometown];
    
    UIButton* btnFollow = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFollow setFrame:CGRectMake(0, 0, 34, 34)];
    [btnFollow setCenter:CGPointMake(imgvAvatar.center.x + 25, imgvAvatar.centerY + imgvAvatar.height/2)];
    [btnFollow setImage:[UIImage imageNamed:@"ic_add_friend"] forState:UIControlStateNormal];
    [btnFollow setImage:[UIImage imageNamed:@"ic_friended"] forState:UIControlStateSelected];
    [btnFollow addTarget:self action:@selector(followUser:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnFollow];
    
    UIButton* btnRequestLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRequestLocation setFrame:CGRectMake(0, 0, 34, 34)];
    [btnRequestLocation setCenter:CGPointMake(imgvAvatar.center.x - 25, imgvAvatar.centerY + imgvAvatar.height/2)];
    [btnRequestLocation setImage:[UIImage imageNamed:@"ic_request_spot"] forState:UIControlStateNormal];
    [btnRequestLocation addTarget:self action:@selector(requestLocation:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnRequestLocation];

    [[APIService shareAPIService]checkFriendWithUserID:userModel.mid completion:^(BOOL isFriend, NSString *error) {
        if (error == nil) {
            btnRequestLocation.selected = isFriend;
        }
    }];
    
    [userModel updateObjectForUse:^{
        lblName.text = userModel.name;
        [btnHometown setTitle:[NSString stringWithFormat:@"%@,%@",userModel.hometown,[[Utils instance]convertBirthdayToAge:userModel.birthday]] forState:UIControlStateNormal];
    }];
    
    /*=============User's ZPot=========*/
    userZpotsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, viewHeader.height, self.view.width, self.view.height - 64 - viewHeader.height) style:UITableViewStylePlain];
    userZpotsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [userZpotsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedNormalViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedNormalViewCell class])];
    userZpotsTableView.dataSource = self;
    userZpotsTableView.delegate = self;
    [self.view addSubview:userZpotsTableView];
    [self getFeedsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)followUser:(UIButton*)sender{
    [[Utils instance]showProgressWithMessage:@""];
    if (sender.isSelected) {
        [[APIService shareAPIService]setUnFollowWithUser:userModel.username completion:^(BOOL successful, NSArray *result) {
            [[Utils instance]hideProgess];
            if (successful) {
                sender.selected = NO;
            }
        }];
    }else{
        [[APIService shareAPIService]setFolowWithUser:userModel.username completion:^(BOOL successful, NSArray *result) {
            [[Utils instance]hideProgess];
            if (successful) {
                sender.selected = YES;
            }
        }];
    }
    
}

-(void)requestLocation:(UIButton*)sender{
    [[Utils instance]showProgressWithMessage:@""];
    [[APIService shareAPIService]requestLocationOfUserID:userModel.mid completion:^(BOOL successful, NSString *error) {
        [[Utils instance]hideProgess];
        if (error) {
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
    }];
}

-(void)loadFeedsFromLocal:(void(^)(NSMutableArray* returnArray))completion{
    NSMutableArray* returnArray = [NSMutableArray array];
    NSSortDescriptor* sortByTime = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"user_id == %@",userModel.mid];
    [returnArray addObjectsFromArray:[FeedDataModel fetchObjectsWithPredicate:predicate sorts:@[sortByTime]]];
    completion(returnArray);
}

-(void)getFeedsFromServer{
    [[Utils instance]showProgressWithMessage:nil];
    [[APIService shareAPIService]getFeedsFromServerForUserID:userModel.mid completion:^(NSMutableArray *returnArray, NSString *error) {
        [[Utils instance]hideProgess];
        if (error) {
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }else{
            [self loadFeedsFromLocal:^(NSMutableArray *returnArray) {
                [userZpotsData addObjectsFromArray:returnArray];
                [userZpotsTableView reloadData];
            }];
        }
    }];
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
    id data = [userZpotsData objectAtIndex:indexPath.row];
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    [cell addBorderWithFrame:CGRectMake(10, height - 1.0, cell.width-20, 1.0) color:COLOR_SEPEARATE_LINE];
    [cell setupCellWithData:data andOptions:nil];
    return cell;
}

-(NSString*)cellIdentiferForIndexPath:(NSIndexPath*)indexPath{
    return NSStringFromClass([FeedNormalViewCell class]);
}

@end
