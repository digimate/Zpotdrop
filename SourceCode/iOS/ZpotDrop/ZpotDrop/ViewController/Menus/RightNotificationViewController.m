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
    for(int i = 0; i < 50 ; ++i)
    {
        NotificationModel* model = [[NotificationModel alloc]init];
        model.time = [NSDate date];
        model.notificationType = [NSNumber numberWithInt:(i%4)];
        switch (i%4) {
            case NOTIFICATION_COMMENT:
                model.notificationContent = @"comment on your Zpotdrop: <<Have fun!>>";
                break;
            case NOTIFICATION_COMMING:
                model.notificationContent = @"is comming to your zpotdrop";
                break;
            case NOTIFICATION_FOLLOW:
                model.notificationContent = @"Started following you";
                break;
            default:
                model.notificationContent = @"Liked your Zpotdrop";
                break;
        }
        [_notificationData addObject:model];
    }
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
    return 50.f;
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
    NotificationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    [cell setupCellWithData:_notificationData[indexPath.row] inSize:CGSizeMake(tableView.frame.size.width, 50.f) andHandler:^(id data, NOTIFICATION_ACTION action) {
        
    }];
    [cell scrollBack];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate didPressedOnNotificationWithAction:NOTIFICATION_LIKE andData:nil];
}

@end
