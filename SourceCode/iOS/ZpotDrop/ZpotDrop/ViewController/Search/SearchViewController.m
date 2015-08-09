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

@interface SearchViewController() <UISearchBarDelegate>
{
    UISearchBar* _searchZpotBar;
    UITableView* _mTableView;
    CONTACT_MODE _mode;
}
@end

@implementation SearchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchZpotBar.frame.size.height + _searchZpotBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - (_searchZpotBar.frame.size.height + _searchZpotBar.frame.origin.y)) style:UITableViewStylePlain];
    [_mTableView setDelegate:self];
    [_mTableView setDataSource:self];
    [_mTableView registerClass:[ContactCell class] forCellReuseIdentifier:@"contactCell"];
    [_mTableView registerClass:[friendCell class] forCellReuseIdentifier:@"friendCell"];
    [_mTableView registerClass:[listModeCell class] forCellReuseIdentifier:@"listCell"];
    [_mTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mTableView];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - UITablViewDatasource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2)
    {
        return 50.f;
    }
    return 35.f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2)
    {
        ContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
        [cell setupCellWithData:nil inSize:CGSizeMake(tableView.frame.size.width, 50)];
        [cell setFollow:(indexPath.row%2)];
        return cell;
    }
    if (indexPath.row == 0)
    {
        friendCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
        [cell faceBookCell];
    }
    if (indexPath.row == 1)
    {
        friendCell* cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
        [cell contactCell];
    }
    listModeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    [cell setupCellWithMode:_mode inSize:CGSizeMake(tableView.frame.size.width, 35.f) AndHandler:^(CONTACT_MODE mode) {
        _mode = mode;
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
