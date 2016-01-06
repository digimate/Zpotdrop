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
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "FeedCommentViewController.h"

@interface RightNotificationViewController (){
    int countNew;
    BOOL canLoadMore;
}

@end

@implementation RightNotificationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizesSubviews = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    //======================UITableView=========================//
    canLoadMore = YES;
    int spacing = 40;
    countNew = 0;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(spacing, 0, self.view.frame.size.width - spacing, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[NotificationTableViewCell class] forCellReuseIdentifier:@"notificationCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableviewcell"];
    [self.view addSubview:_tableView];
    
    _refresh = [[UIRefreshControl alloc]init];
    [_refresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refresh];
    
    UISwipeGestureRecognizer* closeSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction:)];
    [closeSwipe setNumberOfTouchesRequired:1];
    [closeSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:closeSwipe];
    
    _notificationData = [NSMutableArray array];
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getNewNotification) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    countNew = 0;
    [self updateRightButton];
    [self getLocalNotification];
}

-(void)updateRightButton{
    if (self.parentViewController) {
        MainViewController* mainVC = (MainViewController*)self.parentViewController;
        [[mainVC.navigationItem.rightBarButtonItem.customView viewWithTag:69] setHidden:(countNew == 0)];
    }
}

-(void)getNewNotification{
    NotificationModel* lastestModel = [NotificationModel lastestNotification];
    if (lastestModel) {
        [[APIService shareAPIService]getNotificationFromServerForUser:[AccountModel currentAccountModel].user_id lastestNotifcation:lastestModel completion:^(NSArray *returnArray, NSString *error) {
            countNew += returnArray.count;
            [self updateRightButton];
        }];
    }else{
        [[APIService shareAPIService]getNotificationFromServerForUser:[AccountModel currentAccountModel].user_id completion:^(NSArray *returnArray, NSString *error) {
             countNew += returnArray.count;
            [self updateRightButton];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupData{
    [self getLocalNotification];
}

-(IBAction)closeAction:(id)sender
{
    [_delegate closeRightNotification];
}

-(IBAction)refreshAction:(id)sender
{
    [self getNotificationFromServer];
}

-(void)getLocalNotification{
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    NSArray* notifications = [NotificationModel fetchObjectsWithPredicate:[NSPredicate predicateWithFormat:@"receiver_id == %@ AND sender_id != %@",[AccountModel currentAccountModel].user_id,[AccountModel currentAccountModel].user_id] sorts:@[sort]];
    if (notifications.count == 0) {
        [self getNotificationFromServer];
    }else{
        [_notificationData removeAllObjects];
        [_notificationData addObjectsFromArray:notifications];
        [_tableView reloadData];
    }
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
    NotificationModel* oldNotify = [_notificationData lastObject];
    NSArray* array = [NotificationModel fetchObjectsWithPredicate:[NSPredicate predicateWithFormat:@"receiver_id == %@ AND time < %@",[AccountModel currentAccountModel].user_id,oldNotify.time] sorts:@[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]]];
    if (array.count > 0) {
        canLoadMore = YES;
        [_notificationData addObjectsFromArray:array];
        [_tableView reloadData];
    }else{
        [[APIService shareAPIService]getNotificationFromServerForUser:[AccountModel currentAccountModel].user_id oldestNotifcation:oldNotify completion:^(NSArray *returnArray, NSString *error) {
            if (returnArray.count == API_PAGE_SIZE) {
                canLoadMore = YES;
            }
            [_notificationData addObjectsFromArray:returnArray];
            [_tableView reloadData];
        }];
    }
}
-(void)showCommentView:(FeedDataModel*)feedModel{
    FeedCommentViewController* commentVC = [[FeedCommentViewController alloc]init];
    commentVC.feedData = feedModel;
    [self.navigationController pushViewController:commentVC animated:YES];
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
    cell.dataModel = nil;
    model.dataDelegate = cell;
    [cell setupCellWithData:model andOptions:nil];
    cell.onShowPost = ^(NotificationModel*model){
        FeedDataModel* feed = (FeedDataModel*)[FeedDataModel fetchObjectWithID:model.feed_id];
        [feed updateObjectForUse:^{
            [self.delegate closeRightNotification];
            [self showCommentView:feed];
        }];
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
    cell.onShareLocation = ^(NotificationModel *model) {
        // Push notification back
        [[APIService shareAPIService] notifyLocationToUserID:model.sender_id completion:^(BOOL successful, NSString *error) {
            if (error) {
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            } else {
                [[Utils instance]showAlertWithTitle:nil message:@"You have been shared your location!" yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }
            
        }];
    };
    cell.onShowLocation = ^(NotificationModel *model) {
        [self.delegate showFindViewFromNotification];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (canLoadMore && _notificationData.count >= API_PAGE_SIZE && indexPath.row == (_notificationData.count - 2)) {
        canLoadMore = NO;
        [self getMoreNotifcation];
    }
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
