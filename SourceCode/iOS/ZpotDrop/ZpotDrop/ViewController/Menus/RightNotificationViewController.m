//
//  RightNotificationViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "RightNotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "NotificationModel.h"

@interface RightNotificationViewController ()

@end

@implementation RightNotificationViewController

-(void)setupData{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizesSubviews = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    //======================UITableView=========================//
    int spacing = 40;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(spacing, 0, self.view.frame.size.width - spacing, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[NotificationTableViewCell class] forCellReuseIdentifier:@"notificationCell"];
    [self.view addSubview:_tableView];
    
    _refresh = [[UIRefreshControl alloc]init];
    [_refresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refresh];
    
    UISwipeGestureRecognizer* closeSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction:)];
    [closeSwipe setNumberOfTouchesRequired:1];
    [closeSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:closeSwipe];
    
    _notificationData = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeAction:(id)sender
{
    [_delegate closeRightNotification];
}

-(IBAction)refreshAction:(id)sender
{
    [self getNotificationFromServer];
}

-(void)getNotificationFromServer{
    [[APIService shareAPIService]getNotificationFromServerForUser:[AccountModel currentAccountModel].user_id completion:^(NSArray *returnArray, NSString *error) {
        [_refresh endRefreshing];
        [_notificationData removeAllObjects];
        [_notificationData addObjectsFromArray:returnArray];
        [_tableView reloadData];
    }];
}

-(void)getMoreNotifcation{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_notificationData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationModel* model = [_notificationData objectAtIndex:indexPath.row];
    return [NotificationTableViewCell cellHeightWithData:model];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50.f)];
    [header setText:@"NOTIFICATION"];
    [header setTextColor:[UIColor colorWithHexString:MAIN_COLOR]];
    [header setFont:[UIFont fontWithName:@"" size:20.f]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setBackgroundColor:[UIColor whiteColor]];
    return header;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationModel* model = [_notificationData objectAtIndex:indexPath.row];
    NotificationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    cell.dataModel.dataDelegate = nil;
    model.dataDelegate = cell;
    [cell setupCellWithData:model andOptions:nil];
    cell.onShowPost = ^(NotificationModel*model){
        
    };
    cell.onFollowUser = ^(NotificationModel*model){
        
        [[APIService shareAPIService]setFollowWithUser:model.sender_id completion:^(BOOL successful, NSString *error) {
            // call for update UI after change Data
            [model.dataDelegate updateUIForDataModel:model options:nil];
        }];
    };
    cell.onUnFollowUser = ^(NotificationModel*model){
        [[APIService shareAPIService]setUnFollowWithUser:model.sender_id completion:^(BOOL successful, NSString *error) {
            // call for update UI after change Data
            [model.dataDelegate updateUIForDataModel:model options:nil];
        }];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate didPressedOnNotificationWithData:[_notificationData objectAtIndex:indexPath.row]];
}

+ (RightNotificationViewController *) instance {
    static RightNotificationViewController *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[RightNotificationViewController alloc] init];
    });
    return _sharedInstance;
}
@end
