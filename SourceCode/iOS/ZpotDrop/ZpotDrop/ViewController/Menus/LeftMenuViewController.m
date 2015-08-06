//
//  LeftMenuViewController.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MenuProfileTableViewCell.h"
#import "MenuFeatureTableViewCell.h"
#import "MenuZpotAllTableViewCell.h"
#import "MenuSettingViewCell.h"
#import "BaseTableViewCell.h"
#import "CircleProgressView.h"
#import "PostZpotViewController.h"
#import "FeedZpotViewController.h"
#import "FindZpotViewController.h"

@interface LeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftMenuViewController
@synthesize tableView = _tableView;
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
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuProfileTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MenuProfileTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuFeatureTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MenuFeatureTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuZpotAllTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MenuZpotAllTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuSettingViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MenuSettingViewCell class])];
    
    // ZPOT ALL VIEW
    UIView* zpotdropAllView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 150)];
    zpotdropAllView.backgroundColor = [UIColor whiteColor];
    CircleProgressView* progressView = [[CircleProgressView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    progressView.backgroundColor = [UIColor clearColor];
    progressView.trackBackgroundColor = [UIColor colorWithRed:229 green:229 blue:229];
    progressView.trackFillColor = COLOR_DARK_GREEN;
    progressView.trackWidth = 4;
    progressView.center = CGPointMake(zpotdropAllView.width/2, zpotdropAllView.height/2 - 10);
    [zpotdropAllView addSubview:progressView];
    
    UIButton* zpotdropAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [zpotdropAllButton setFrame:CGRectMake(0, 0, 86, 86)];
    zpotdropAllButton.center = progressView.center;
    [[zpotdropAllButton titleLabel]setFont:[UIFont fontWithName:@"PTSans-Bold" size:12]];
    [zpotdropAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zpotdropAllButton setTitleColor:[UIColor colorWithRed:229 green:229 blue:229] forState:UIControlStateDisabled];
    [zpotdropAllButton setTitle:@"zpot_all".localized.uppercaseString forState:UIControlStateNormal];
    zpotdropAllButton.enabled = NO;
    zpotdropAllButton.layer.cornerRadius = zpotdropAllButton.width/2;
    [zpotdropAllView addSubview:zpotdropAllButton];
    
    UILabel* lblZpotAll = [[UILabel alloc]initWithFrame:CGRectMake(0, progressView.y + progressView.height, zpotdropAllView.width, 16)];
    lblZpotAll.textColor = COLOR_DARK_GREEN;
    lblZpotAll.textAlignment = NSTextAlignmentCenter;
    lblZpotAll.font = [UIFont fontWithName:@"PTSans-Regular" size:12];
    lblZpotAll.text = @"zpot_all_usage".localized;
    [zpotdropAllView addSubview:lblZpotAll];
    _tableView.tableFooterView = zpotdropAllView;
    currentSelectedRow = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self identifierForIndexPath:indexPath] forIndexPath:indexPath];
    [cell setWidth:tableView.width];
    NSDictionary* param = nil;
    CGRect borderRect = CGRectZero;
    if (indexPath.row == 0) {
         borderRect = CGRectMake(15, [MenuProfileTableViewCell cellHeightWithData:nil]-1.0, tableView.width - 15, 1.0);
        cell.userInteractionEnabled = NO;
    }else if (indexPath.row == 1) {
        param = @{@"title":@"post".localized.uppercaseString,@"icon":@"icon"};
        borderRect = CGRectMake(15, [MenuFeatureTableViewCell cellHeightWithData:nil]-1.0, tableView.width - 15, 1.0);
    }else if (indexPath.row == 2){
        param = @{@"title":@"feed".localized.uppercaseString,@"icon":@"ic_feed"};
         borderRect = CGRectMake(15, [MenuFeatureTableViewCell cellHeightWithData:nil]-1.0, tableView.width - 15, 1.0);
    }else if (indexPath.row == 3){
        param = @{@"title":@"find".localized.uppercaseString,@"icon":@"ic_find"};
         borderRect = CGRectMake(15, [MenuFeatureTableViewCell cellHeightWithData:nil]-1.0, tableView.width - 15, 1.0);
    }else if (indexPath.row == 4){
        param = @{@"title":@"search".localized.uppercaseString};
        borderRect = CGRectMake(15, [MenuFeatureTableViewCell cellHeightWithData:nil]-1.0, tableView.width - 15, 1.0);
    }else if (indexPath.row == 5){
        param = @{@"title":@"settings".localized.uppercaseString};
        borderRect = CGRectMake(15, [MenuFeatureTableViewCell cellHeightWithData:nil]-1.0, tableView.width - 15, 1.0);
    }
    [cell setupCellWithData:nil andOptions:param];
    if (!CGRectEqualToRect(borderRect, CGRectZero)) {
        [cell addBorderWithFrame:borderRect color:COLOR_SEPEARATE_LINE];
    }
    return cell;
}


-(NSString*)identifierForIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.row == 0) {
        return NSStringFromClass([MenuProfileTableViewCell class]);
    }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
        return NSStringFromClass([MenuFeatureTableViewCell class]);
    }else if (indexPath.row == 4 || indexPath.row == 5 ){
        return NSStringFromClass([MenuSettingViewCell class]);
    }
    return NSStringFromClass([MenuProfileTableViewCell class]);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return [MenuProfileTableViewCell cellHeightWithData:nil];
    }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
        return [MenuFeatureTableViewCell cellHeightWithData:nil];
    }else if (indexPath.row == 4 || indexPath.row == 5){
        return [MenuSettingViewCell cellHeightWithData:nil];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (currentSelectedRow != indexPath.row) {
        currentSelectedRow = indexPath.row;
        if (currentSelectedRow == 1) {
            [self.delegate leftmenuChangeViewToClass:NSStringFromClass([PostZpotViewController class])];
        }else if (currentSelectedRow == 2) {
            [self.delegate leftmenuChangeViewToClass:NSStringFromClass([FeedZpotViewController class])];
        }else if (currentSelectedRow == 3) {
            [self.delegate leftmenuChangeViewToClass:NSStringFromClass([FindZpotViewController class])];
        }
    }else{
        [self.delegate leftmenuChangeViewToClass:nil];
    }
}
@end
