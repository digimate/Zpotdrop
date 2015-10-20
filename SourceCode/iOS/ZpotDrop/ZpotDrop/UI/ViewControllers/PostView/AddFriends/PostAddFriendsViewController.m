//
//  PostAddFriendsViewController.m
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/19/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "PostAddFriendsViewController.h"
#import "UserService.h"
#import "AccountModel.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NSString+Ext.h"
#import "UserDataModel.h"

@interface PostAddFriendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imvAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) UserDataModel *user;
@end
@implementation PostAddFriendCell
- (void)setUser:(UserDataModel *)user {
    _user = user;
    if (user.avatar.length > 0) {
        self.imvAvatar.image = [user.avatar stringToUIImage];
    } else {
        self.imvAvatar.image = [UIImage imageNamed:@"avatar"];
    }
    self.lbName.text = user.name;
}
@end


//
@interface PostAddFriendsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *tfSearchFriend;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblFriend;
@property (strong, nonatomic) NSArray *arrFriends;
@property (strong, nonatomic) NSArray *arrFilteredFriends;
@property (strong, nonatomic) NSMutableArray *arrSelectedFriends;
@end

@implementation PostAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButton];
    [self fetchFriendList];
}


#pragma mark -

- (void)fetchFriendList {
    UserService *service = [UserService new];
    [service getFolloweeOfUserId:[AccountModel currentAccountModel].user_id completion:^(NSArray *users, NSError *error) {
        self.arrFriends = [users copy];
        self.arrFilteredFriends = [users copy];
        self.arrSelectedFriends = [NSMutableArray array];
        [self.tblFriend reloadData];
    }];
}

- (void)filterFriendListWithText:(NSString *)text {
    NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (trimmedText.length == 0) {
        self.arrFilteredFriends = [self.arrFriends copy];
        [self.tblFriend reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"first_name CONTAINS %@ OR last_name CONTAINS %@", trimmedText, trimmedText];
    self.arrFilteredFriends = [self.arrFriends filteredArrayUsingPredicate:predicate];
    [self.tblFriend reloadData];
}

- (void)selectDeselectUser:(UserDataModel *)user {
    if ([self.arrSelectedFriends containsObject:user]) {
        [self.arrSelectedFriends removeObject:user];
    } else {
        [self.arrSelectedFriends addObject:user];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self filterFriendListWithText:text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrFilteredFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostAddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostAddFriendCell"];
    UserDataModel *user = self.arrFilteredFriends[indexPath.row];
    cell.user = user;
    if ([self.arrSelectedFriends containsObject:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectDeselectUser:self.arrFilteredFriends[indexPath.row]];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
