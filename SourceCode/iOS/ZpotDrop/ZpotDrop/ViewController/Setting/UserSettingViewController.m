//
//  UserSettingViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UserSettingViewController.h"
#import "Utils.h"
#import "BaseTableViewCell.h"
#import "UserProfileCell.h"
#import "SettingDisclosureViewCell.h"
#import "SettingSwitchCell.h"
#import "ChangePasswordViewController.h"
#import "UserDataModel.h"
#import "APIService.h"
#import "LeftMenuViewController.h"
#import "RightNotificationViewController.h"
#import "LocationDataModel.h"

@interface UserSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    UITableView* settingTableView;
    UserProfileCell* userProfile;
    BOOL enableAllZpot;
    BOOL privateProfile;
    UserDataModel* userData;
}

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"setting".localized.uppercaseString;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    userData = (UserDataModel*)[UserDataModel fetchObjectWithID:[AccountModel currentAccountModel].user_id];
    privateProfile = [userData.privateProfile boolValue];
    enableAllZpot = [userData.enableAllZpot boolValue];
    
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    settingTableView.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242];
    [settingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserProfileCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserProfileCell class])];
    [settingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingDisclosureViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SettingDisclosureViewCell class])];
    [settingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingSwitchCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SettingSwitchCell class])];
    settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    settingTableView.dataSource = self;
    settingTableView.delegate = self;
    [self.view addSubview:settingTableView];
    
    UIButton* btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    btnSave.frame = CGRectMake(0, 0, self.view.width, 44);
    btnSave.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    [btnSave setTitle:@"save".localized forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor colorWithRed:133 green:133 blue:133] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnSave.backgroundColor = [UIColor whiteColor];
    
    UIButton* btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogout.frame = CGRectMake(0, 45, self.view.width, 44);
    btnLogout.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    [btnLogout setTitle:@"logout".localized forState:UIControlStateNormal];
    [btnLogout setTitleColor:[UIColor colorWithRed:133 green:133 blue:133] forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnLogout.backgroundColor = [UIColor whiteColor];
    
    UIView* viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 89)];
    [viewFooter addSubview:btnLogout];
    [viewFooter addSubview:btnSave];
    [viewFooter addBorderWithFrame:CGRectMake(0, 44, viewFooter.width, 1.0) color:COLOR_SEPEARATE_LINE];
    
    settingTableView.tableFooterView = viewFooter;
}

-(void)logout:(UIButton*)sender{
    [[Utils instance]showAlertWithTitle:@"confirm".localized message:@"confirm_logout".localized yesTitle:@"yes".localized noTitle:@"no".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
            if ([title isEqualToString:@"yes".localized]) {
                [[Utils instance]showProgressWithMessage:nil];
                [[APIService shareAPIService]logoutWithCompletion:^(BOOL successful, NSString *error) {
                    [[Utils instance]hideProgess];
                    if (successful) {
                        [AccountModel currentAccountModel].access_token = @"";
                        [[LeftMenuViewController instance].view removeFromSuperview];
                        [[LeftMenuViewController instance]removeFromParentViewController];
                        [[RightNotificationViewController instance].view removeFromSuperview];
                        [[RightNotificationViewController instance]removeFromParentViewController];
                        NSArray * array = [LocationDataModel fetchObjectsWithPredicate:nil sorts:nil];
                        for (BaseDataModel* model in array) {
                            [model deleteFromDB];
                        }
                        array = [FeedDataModel fetchObjectsWithPredicate:nil sorts:nil];
                        for (BaseDataModel* model in array) {
                            [model deleteFromDB];
                        }
                        array = [FeedCommentDataModel fetchObjectsWithPredicate:nil sorts:nil];
                        for (BaseDataModel* model in array) {
                            [model deleteFromDB];
                        }
                        array = [UserDataModel fetchObjectsWithPredicate:nil sorts:nil];
                        for (BaseDataModel* model in array) {
                            [model deleteFromDB];
                        }
                        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                    }else{
                        [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        }];
                    }
                }];
            }
        }
    }];
}

-(void)saveInfo{
    [[Utils instance]showAlertWithTitle:@"confirm".localized message:@"confirm_save_info".localized yesTitle:@"yes".localized noTitle:@"no".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
            if ([title isEqualToString:@"yes".localized]) {
                [self updateUserInfoToServer];
            }
        }
    }];
}

-(void)updateUserInfoToServer{
    if ([[[userProfile firstName] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_first_name".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
        return;
    }
    
    if ([[[userProfile firstName] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_last_name".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
        return;
    }
    
    if ([userProfile email].length > 0 &&  ![_rule checkEmailStringIsCorrect:[userProfile email]])
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_email_format".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[userProfile firstName] forKey:@"firstName"];
    [params setObject:[userProfile lastName] forKey:@"lastName"];
    [params setObject:[userProfile email] forKey:@"email"];
    [params setObject:[userProfile hometown] forKey:@"hometown"];
    [params setObject:[userProfile birthday] forKey:@"dob"];
    [params setObject:[userProfile phoneNumber] forKey:@"phoneNumber"];
    [params setObject:[NSNumber numberWithBool:enableAllZpot] forKey:@"enableAllZpot"];
    [params setObject:[NSNumber numberWithBool:privateProfile] forKey:@"privateProfile"];
    [[Utils instance]showProgressWithMessage:@""];
    [self closeKeyboard];
    [[APIService shareAPIService]updateUserInfoToServerWithID:userData.mid params:params completion:^(BOOL success, NSString *error) {
        [[Utils instance]hideProgess];
        if (success) {
            
        }else{
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error.localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }
    }];
}

-(void)leftMenuOpened{
    [self closeKeyboard];
}
-(void)rightMenuOpened{
    [self closeKeyboard];
}
-(void)closeKeyboard{
    [settingTableView endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerOpenLeftMenuNotification];
    [self registerOpenRightMenuNotification];
    [self registerKeyboardNotification];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOpenLeftMenuNotification];
    [self removeOpenRightMenuNotification];
    [self removeKeyboardNotification];
}
-(void)keyboardShow:(CGRect)frame{
    [UIView animateWithDuration:0.3 animations:^{
        settingTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height  - frame.size.height);
    }];
}
-(void)keyboardHide:(CGRect)frame{
    [UIView animateWithDuration:0.3 animations:^{
        settingTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height );
    }];
}
#pragma mark - UITableViewDatasource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return [SettingDisclosureViewCell cellHeightWithData:nil];
        }
        return [UserProfileCell cellHeightWithData:nil];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return [SettingSwitchCell ceilHeigthWithParams:@{@"title":@"private_profile".localized}];
        }
        return [SettingSwitchCell ceilHeigthWithParams:@{@"title":@"enable_all_zpot".localized,@"subtitle":@"enable_all_zpot_usage".localized}];
    }else if (indexPath.section == 2){
        return [SettingDisclosureViewCell cellHeightWithData:nil];
    }
    return 0;
}
-(NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            return NSStringFromClass([SettingDisclosureViewCell class]);
        }
        return NSStringFromClass([UserProfileCell class]);
    }else if (indexPath.section == 1){
        return NSStringFromClass([SettingSwitchCell class]);
    }else if (indexPath.section == 2){
        return NSStringFromClass([SettingDisclosureViewCell class]);
    }
    return NSStringFromClass([UserProfileCell class]);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];
    cell.handler = self;
    [cell removeBorder];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSDictionary* dict = nil;
    if (indexPath.section == 0) {
        if ( indexPath.row == 0) {
            userProfile = (UserProfileCell*)cell;
        }else{
            dict = @{@"title":@"change_password".localized};
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            dict = @{@"title":@"private_profile".localized,@"switch":[NSNumber numberWithBool:privateProfile]};
            [(SettingSwitchCell*)cell setOnSwitchChanged:^(BOOL flag) {
                privateProfile = flag;
            }];
        
        }else{
            dict = @{@"title":@"enable_all_zpot".localized,@"switch":[NSNumber numberWithBool:enableAllZpot],@"subtitle":@"enable_all_zpot_usage".localized};
            [cell addBorderWithFrame:CGRectMake(0, 0, cell.width, 1.0) color:COLOR_SEPEARATE_LINE];
            [(SettingSwitchCell*)cell setOnSwitchChanged:^(BOOL flag) {
                enableAllZpot = flag;
            }];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            dict = @{@"title":@"terms_of_use".localized};
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            dict = @{@"title":@"privacy_policy".localized};
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell addBorderWithFrame:CGRectMake(0, 0, cell.width, 1.0) color:COLOR_SEPEARATE_LINE];
        }
    }
    [cell setupCellWithData:[AccountModel currentAccountModel] andOptions:dict];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section != 2) {
        return nil;
    }
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            ChangePasswordViewController* vc = [[ChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self closeKeyboard];
}
@end
