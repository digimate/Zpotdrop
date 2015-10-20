//
//  PostAddFriendsViewController.h
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/19/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@class PostAddFriendsViewController;



@protocol PostAddFriendsViewControllerDelegate <NSObject>
- (void)postAddFriendsViewController:(PostAddFriendsViewController *)vc didSelectFriends:(NSArray *)users;
@end



@interface PostAddFriendsViewController : BaseViewController
@property (nonatomic, weak) id<PostAddFriendsViewControllerDelegate> delegate;
@end
