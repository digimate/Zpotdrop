//
//  PostAddFriendsViewController.m
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/19/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "PostAddFriendsViewController.h"

@interface PostAddFriendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imvAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@end
@implementation PostAddFriendCell
@end


//
@interface PostAddFriendsViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tfSearchFriend;
@property (strong, nonatomic) NSArray *arrFriends;
@property (strong, nonatomic) NSArray *arrSelectedFriends;
@end

@implementation PostAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
