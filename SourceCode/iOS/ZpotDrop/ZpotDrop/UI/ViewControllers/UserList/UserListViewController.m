//
//  UserListViewController.m
//  ZpotDrop
//
//  Created by Vu Tiet on 12/25/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "UserListViewController.h"
#import "UserListCell.h"

@interface UserListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *userListTableView;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.userListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserListCell class])];
    self.userListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self createBackButton];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.userListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate & UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userIds.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDataModel* model = (UserDataModel*)[UserDataModel fetchObjectWithID:self.userIds[indexPath.row]];
    NSString* identifier = [self cellIdentiferForIndexPath:indexPath];
    UserListCell* cell = (UserListCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setupCellWithData:model andOptions:nil];
    return cell;
}

-(NSString*)cellIdentiferForIndexPath:(NSIndexPath*)indexPath{
    return NSStringFromClass([UserListCell class]);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row >= API_PAGE_SIZE-3 && _feedData.count >= API_PAGE_SIZE && canLoadMore) {
//        canLoadMore = NO;
//        [self loadMoreFeeds];
//    }
//}

@end
