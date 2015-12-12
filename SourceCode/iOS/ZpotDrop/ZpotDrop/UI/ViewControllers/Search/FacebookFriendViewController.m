//
//  FacebookFriendViewController.m
//  ZpotDrop
//
//  Created by ME on 8/31/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FacebookFriendViewController.h"
#import "ContactCell.h"
#import <Parse/Parse.h>
#import "Utils.h"
#import "LoadingView.h"
#import "FacebookService.h"

@interface FacebookFriendViewController ()<UISearchBarDelegate>{
    UISearchBar* _searchZpotBar;
    UITableView* _mTableView;
    NSMutableArray* _searchResult;
    NSMutableArray* _facebookFriends;
    LoadingView* loadingView;
    UIView* loginFacebookView;
}

@end

@implementation FacebookFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButton];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
    _searchResult = [NSMutableArray array];
    _facebookFriends = [NSMutableArray array];
    self.title = @"search".localized.uppercaseString;
    _searchZpotBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y, self.view.width, 40)];
    _searchZpotBar.backgroundColor = [UIColor clearColor];
    _searchZpotBar.barTintColor = [UIColor clearColor];
    _searchZpotBar.backgroundImage = [[UIImage alloc]init];
    _searchZpotBar.returnKeyType = UIReturnKeyDone;
    _searchZpotBar.enablesReturnKeyAutomatically = NO;
    _searchZpotBar.delegate = self;
    _searchZpotBar.placeholder = @"search_for_people".localized;
    [_searchZpotBar setImage:[UIImage imageNamed:@"ic_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchZpotBar addBorderWithFrame:CGRectMake(0, _searchZpotBar.height - 1.0, _searchZpotBar.width, 1) color:COLOR_SEPEARATE_LINE];
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName: [UIColor colorWithRed:219 green:219 blue:219],
                                            NSFontAttributeName: [UIFont fontWithName:@"PTSans-Regular" size:14],
                                            };
    
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:_searchZpotBar.placeholder
                                                                                attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
    [self.view addSubview:_searchZpotBar];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchZpotBar.y + _searchZpotBar.height, self.view.frame.size.width, self.view.frame.size.height - (_searchZpotBar.y + _searchZpotBar.height)) style:UITableViewStylePlain];
    [_mTableView setDelegate:self];
    [_mTableView setDataSource:self];
    [_mTableView registerClass:[ContactCell class] forCellReuseIdentifier:@"contactCell"];
    [_mTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mTableView];
    
    loadingView  = [[LoadingView alloc]init];
    
    if ([[FacebookService instance] isLoggedIn]) {
        [self getFacebookFriend];
    }else{
        loginFacebookView = [[UIView alloc]initWithFrame:_mTableView.frame];
        loginFacebookView.backgroundColor = [UIColor whiteColor];
        UIButton* btnLoginFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLoginFacebook setFrame:CGRectMake(0, 0, 222, 44)];
        [btnLoginFacebook setImage:[UIImage imageNamed:@"ic_facebook_login@2x"] forState:UIControlStateNormal];
        [btnLoginFacebook addTarget:self action:@selector(loginFacebook) forControlEvents:UIControlEventTouchUpInside];
        btnLoginFacebook.center = CGPointMake(loginFacebookView.width/2, loginFacebookView.height/2 + btnLoginFacebook.height/2);
        [loginFacebookView addSubview:btnLoginFacebook];
        
        UILabel* lblFacebook = [[UILabel alloc]initWithFrame:CGRectMake(btnLoginFacebook.x, btnLoginFacebook.y - 50, btnLoginFacebook.width, 40)];
        lblFacebook.numberOfLines = 0;
        [lblFacebook setTextAlignment:NSTextAlignmentCenter];
        lblFacebook.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
        lblFacebook.textColor = [UIColor lightGrayColor];
        lblFacebook.text = @"find_facebook_friend_title".localized;
        [loginFacebookView addSubview:lblFacebook];
        [self.view addSubview:loginFacebookView];
    }
}

-(void)getFacebookFriend{
    [loadingView showViewInView:_mTableView];
    [[FacebookService instance]getFriends:^(NSArray *friends, NSInteger total) {
        [_facebookFriends removeAllObjects];
        __block int count = friends.count;
        for (NSDictionary* dict in friends) {
            NSString* facebookID = dict[@"id"];
            [[APIService shareAPIService]updateUserModelWithFacebookID:facebookID completion:^(UserDataModel *userModel) {
                count--;
                if (userModel) {
                    [_facebookFriends addObject:userModel];
                }
                if (count == 0) {
                    [loadingView hideView];
                    [_searchResult addObjectsFromArray:_facebookFriends];
                    [_mTableView reloadData];
                }
            }];
        }
        if (count == 0) {
            [loadingView hideView];
        }
    }];
}

-(void)loginFacebook{
    [[Utils instance]showProgressWithMessage:nil];
    [[FacebookService instance]login:^(BOOL result, NSString *error) {
        [[Utils instance]hideProgess];
        if (result) {
            [[FacebookService instance]requestInfoForMe:^{
                if ([FBSDKProfile currentProfile]) {
                    PFUser* user = [PFUser currentUser];
                    user[@"facebook_id"] = [FBSDKProfile currentProfile].userID;
                    UserDataModel* currentUser = (UserDataModel*)[UserDataModel fetchObjectWithID:[AccountModel currentAccountModel].user_id];
                    currentUser.facebook_id = [FBSDKProfile currentProfile].userID;
                }
            }];
            [loginFacebookView removeFromSuperview];
            [self getFacebookFriend];
        }else{
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
    }];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
        NSArray* result = [_facebookFriends filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"username contains[c] %@ OR first_name contains[c] %@ OR last_name contains[c] %@",searchBar.text,searchBar.text,searchBar.text]];
        [_searchResult removeAllObjects];
        [_searchResult addObjectsFromArray:result];
        [_mTableView reloadData];
    }else{
        [_searchResult removeAllObjects];
        [_searchResult addObjectsFromArray:_facebookFriends];
        [_mTableView reloadData];
    }
    [searchBar resignFirstResponder];
}

#pragma mark - UITablViewDatasource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchResult count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ContactCell cellHeightWithData:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    UserDataModel* user = [_searchResult objectAtIndex:indexPath.row];
    cell.dataModel.dataDelegate = nil;
    cell.dataModel = nil;
    user.dataDelegate = cell;
    [cell setupCellWithData:user andOptions:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
