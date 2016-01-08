//
//  SearchViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "SearchViewController.h"
#import "ContactCell.h"
#import "friendCell.h"
#import "listModeCell.h"
#import <Parse/Parse.h>
#import "FacebookFriendViewController.h"
#import "ContactFriendViewController.h"

@interface SearchViewController() <UISearchBarDelegate>
{
    UISearchBar* _searchZpotBar;
    UITableView* _mTableView;
    NSMutableArray* _searchResult;
    NSMutableArray* _follower;
    NSMutableArray* _following;
}
@end

@implementation SearchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _follower = [NSMutableArray array];
    _following = [NSMutableArray array];
    _searchResult = [NSMutableArray array];
    self.title = @"search".localized.uppercaseString;
    _searchZpotBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y, self.view.width, 40)];
    _searchZpotBar.backgroundColor = [UIColor clearColor];
    _searchZpotBar.barTintColor = [UIColor clearColor];
    _searchZpotBar.backgroundImage = [[UIImage alloc]init];
    _searchZpotBar.returnKeyType = UIReturnKeyDone;
    _searchZpotBar.enablesReturnKeyAutomatically = NO;
    _searchZpotBar.delegate = self;
    _searchZpotBar.placeholder = @"search_for_people".localized;
    [_searchZpotBar setShowsCancelButton:YES];
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
    
    UIView* buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, _searchZpotBar.y+ _searchZpotBar.height, self.view.width, 80)];
    buttonsView.backgroundColor = COLOR_SEPEARATE_LINE;
    [self.view addSubview:buttonsView];
    
    UIButton* btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFacebook setBackgroundColor:[UIColor whiteColor]];
    [btnFacebook setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [btnFacebook setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnFacebook setFrame:CGRectMake(0, 4, buttonsView.width, 35)];
    [[btnFacebook titleLabel]setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
    [btnFacebook setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnFacebook setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnFacebook setImage:[UIImage imageNamed:@"ic_facebook2"] forState:UIControlStateNormal];
    [btnFacebook setTitle:@"find_fb_friend".localized forState:UIControlStateNormal];
    [btnFacebook setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnFacebook addTarget:self action:@selector(showFacebookFriends) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:btnFacebook];
    
    UIButton* btnContacts = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnContacts setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnContacts setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [btnContacts setBackgroundColor:[UIColor whiteColor]];
    [btnContacts setFrame:CGRectMake(0, 41, buttonsView.width, 35)];
    [[btnContacts titleLabel]setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
    [btnContacts setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnContacts setImage:[UIImage imageNamed:@"ic_contact2"] forState:UIControlStateNormal];
    [btnContacts setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnContacts setTitle:@"find_from_contacts".localized forState:UIControlStateNormal];
    [btnContacts addTarget:self action:@selector(showContactFriends) forControlEvents:UIControlEventTouchUpInside];
    [btnContacts setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [buttonsView addSubview:btnContacts];
    
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, buttonsView.y + buttonsView.height, self.view.frame.size.width, self.view.frame.size.height - (buttonsView.y + buttonsView.height)) style:UITableViewStylePlain];
    [_mTableView setDelegate:self];
    [_mTableView setDataSource:self];
    [_mTableView registerClass:[ContactCell class] forCellReuseIdentifier:@"contactCell"];
    [_mTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mTableView];
    
    
    NSArray* array = [[AccountModel currentAccountModel].follower_ids componentsSeparatedByString:@","];
    for (NSString* userID in array) {
        if (userID.length > 1) {
            UserDataModel* user = (UserDataModel*)[UserDataModel fetchObjectWithID:userID];
            [_follower addObject:user];
        }
    }
    array = [[AccountModel currentAccountModel].following_ids componentsSeparatedByString:@","];
    for (NSString* userID in array) {
        if (userID.length > 1) {
            UserDataModel* user = (UserDataModel*)[UserDataModel fetchObjectWithID:userID];
            [_following addObject:user];
        }
    }
    [_searchResult addObjectsFromArray:_follower];
    [_searchResult addObjectsFromArray:_following];
}

-(void)showContactFriends{
    ContactFriendViewController* facebookVC = [[ContactFriendViewController alloc]init];
    [self.navigationController pushViewController:facebookVC animated:YES];
}

-(void)showFacebookFriends{
    FacebookFriendViewController* facebookVC = [[FacebookFriendViewController alloc]init];
    [self.navigationController pushViewController:facebookVC animated:YES];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
        [_api searchUserWithData:searchBar.text completion:^(BOOL successful, NSArray *result) {
            [_searchResult removeAllObjects];
            [_searchResult addObjectsFromArray:result];
            [_mTableView reloadData];
        }];
    }else{
        [_searchResult removeAllObjects];
        [_searchResult addObjectsFromArray:_follower];
        [_searchResult addObjectsFromArray:_following];
        [_mTableView reloadData];
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
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
    UserDataModel* user = [_searchResult objectAtIndex:indexPath.row];
    [[Utils instance]showUserProfile:user fromViewController:self];
}
@end
