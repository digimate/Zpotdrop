//
//  RightNotificationViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "RightNotificationViewController.h"
#import "NotificationTableViewCell.h"

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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(spacing - self.view.frame.size.width, 0, self.view.frame.size.width - spacing, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[NotificationTableViewCell class] forCellReuseIdentifier:@"notificationCell"];
    [self.view addSubview:_tableView];
    
    _refresh = [[UIRefreshControl alloc]init];
    [_refresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refresh];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return header;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    [cell setupCellWithData:nil inSize:CGSizeMake(tableView.frame.size.width, 50.f) andHandler:^(id data, NOTIFICATION_ACTION action) {
        
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end