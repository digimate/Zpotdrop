//
//  ChangePasswordViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/10/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordViewCell.h"

@interface ChangePasswordViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* settingTableView;
    ChangePasswordViewCell* currentCell;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"setting".localized.uppercaseString;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    settingTableView.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242];
    [settingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChangePasswordViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ChangePasswordViewCell class])];
    settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    settingTableView.dataSource = self;
    settingTableView.delegate = self;
    [self.view addSubview:settingTableView];
    
    UIButton* btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(0, 0, self.view.width, 44);
    btnSave.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    [btnSave setTitle:@"save".localized forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor colorWithRed:133 green:133 blue:133] forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btnSave.backgroundColor = [UIColor whiteColor];
    [btnSave addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    settingTableView.tableFooterView = btnSave;

}

-(void)changePassword{
    if ([currentCell.oldPassword.text length] < 3)
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_password_length".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [currentCell.oldPassword setText:@""];
            [currentCell.oldPassword becomeFirstResponder];
        }];
        return;
    }
    if ([currentCell.curPasswordTf.text length] < 3)
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_password_length".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [currentCell.curPasswordTf setText:@""];
            [currentCell.curPasswordTf becomeFirstResponder];
        }];
        return;
    }
    
    if (![currentCell.confirmPassword.text isEqualToString:currentCell.curPasswordTf.text])
    {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_passwords_not_match".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [currentCell.confirmPassword setText:@""];
            [currentCell.confirmPassword becomeFirstResponder];
        }];
        return;
    }
//    if (![currentCell.oldPassword.text isEqualToString:[PFUser currentUser].password])
//    {
//        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_password_not_right".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            [currentCell.oldPassword setText:@""];
//            [currentCell.oldPassword becomeFirstResponder];
//        }];
//        return;
//    }
    [[Utils instance]showProgressWithMessage:nil];
    [PFUser currentUser].password = currentCell.curPasswordTf.text;
    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL successful,NSError* error){
        if (error) {
            [[Utils instance]hideProgess];
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error.localizedDescription yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }else{
            [[APIService shareAPIService]loginWithData:@{@"email":[PFUser currentUser].email, @"password":currentCell.curPasswordTf.text } :^(id data, NSString *error) {
                [[Utils instance]hideProgess];
                [self.navigationController popViewControllerAnimated:YES];
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChangePasswordViewCell cellHeightWithData:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangePasswordViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChangePasswordViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellWithData:nil andOptions:nil];
    currentCell = cell;
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
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section != 2) {
        return nil;
    }
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242];
    return view;
}
@end
