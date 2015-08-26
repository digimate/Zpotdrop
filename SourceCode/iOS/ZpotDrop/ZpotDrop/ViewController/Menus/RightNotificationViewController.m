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
    NotificationModel* m1 = (NotificationModel*)[NotificationModel fetchObjectWithID:@"1"];
    m1.type = NOTIFICATION_COMMENT;
    m1.comment = @"Hey you";
    m1.sender_id = [AccountModel currentAccountModel].user_id;
    m1.receiver_id = [AccountModel currentAccountModel].user_id;
    m1.feed_id = @"HZRLmabJBZ";
    [_notificationData addObject:m1];
    
    NotificationModel* m2 = (NotificationModel*)[NotificationModel fetchObjectWithID:@"2"];
    m2.type = NOTIFICATION_COMMING;
    m2.comment = @"Hey you";
    m2.sender_id = [AccountModel currentAccountModel].user_id;
    m2.receiver_id = [AccountModel currentAccountModel].user_id;
    m2.feed_id = @"HZRLmabJBZ";
    [_notificationData addObject:m2];
    
    NotificationModel* m3 = (NotificationModel*)[NotificationModel fetchObjectWithID:@"3"];
    m3.type = NOTIFICATION_FB_Friend;
    m3.comment = @"Hey you";
    m3.sender_id = [AccountModel currentAccountModel].user_id;
    m3.receiver_id = [AccountModel currentAccountModel].user_id;
    m3.feed_id = @"HZRLmabJBZ";
    [_notificationData addObject:m3];
    
    NotificationModel* m4 = (NotificationModel*)[NotificationModel fetchObjectWithID:@"4"];
    m4.type = NOTIFICATION_FOLLOW;
    m4.comment = @"Hey you";
    m4.sender_id = [AccountModel currentAccountModel].user_id;
    m4.receiver_id = [AccountModel currentAccountModel].user_id;
    m4.feed_id = @"HZRLmabJBZ";
    [_notificationData addObject:m4];
    
    NotificationModel* m5 = (NotificationModel*)[NotificationModel fetchObjectWithID:@"5"];
    m5.type = NOTIFICATION_LIKE;
    m5.comment = @"Hey you";
    m5.sender_id = [AccountModel currentAccountModel].user_id;
    m5.receiver_id = [AccountModel currentAccountModel].user_id;
    m5.feed_id = @"HZRLmabJBZ";
    [_notificationData addObject:m5];
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
    [_refresh endRefreshing];
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
    [cell setupCellWithData:model andOptions:nil];
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
