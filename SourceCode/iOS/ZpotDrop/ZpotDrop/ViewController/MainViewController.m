//
//  MainViewController.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "MainViewController.h"
#import "PostZpotViewController.h"
#import "AppDelegate.h"
#import "FeedZpotViewController.h"
#import "FindZpotViewController.h"
#import "UserProfileViewController.h"
#import "UserSettingViewController.h"

@interface MainViewController ()<LeftMenuDelegate,rightNotificationDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    self.navigationController.navigationBar.fixedHeightWhenStatusBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 30, 30)];
    [menuButton setImage:[UIImage imageNamed:@"item_menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* menuItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    UIButton* notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton setFrame:CGRectMake(0, 0, 30, 30)];
    [notificationButton setImage:[UIImage imageNamed:@"item_notification.png"] forState:UIControlStateNormal];
    [notificationButton addTarget:self action:@selector(notificationPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* notificationItem = [[UIBarButtonItem alloc]initWithCustomView:notificationButton];
    self.navigationItem.rightBarButtonItem = notificationItem;

    //====================== LEFT MENU =========================
    _leftMenuViewController = [[LeftMenuViewController alloc]init];
    _leftMenuViewController.delegate = self;
    _leftMenuViewController.view.frame = [UIScreen mainScreen].bounds;
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] addSubview:_leftMenuViewController.view];
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] sendSubviewToBack:_leftMenuViewController.view];
    
    UIView* menuBackground = [[UIView alloc]initWithFrame:_leftMenuViewController.view.bounds];
    menuBackground.backgroundColor = [UIColor clearColor];
    [_leftMenuViewController.view addSubview:menuBackground];
    [_leftMenuViewController.view sendSubviewToBack:menuBackground];
    UITapGestureRecognizer* menuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openMenu)];
    menuTap.cancelsTouchesInView = NO;
    [menuTap setNumberOfTapsRequired:1];
    [menuTap setNumberOfTouchesRequired:1];
    [menuBackground addGestureRecognizer:menuTap];

    //====================== RIGHT NOTIFICATION =========================
    _rightMenuViewController = [[RightNotificationViewController alloc]init];
    _rightMenuViewController.delegate = self;
    _rightMenuViewController.view.frame = [UIScreen mainScreen].bounds;
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] addSubview:_rightMenuViewController.view];
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] sendSubviewToBack:_rightMenuViewController.view];
    UIView* notificationBackground = [[UIView alloc]initWithFrame:_rightMenuViewController.view.bounds];
    notificationBackground.backgroundColor = [UIColor clearColor];
    [_rightMenuViewController.view addSubview:notificationBackground];
    [_rightMenuViewController.view sendSubviewToBack:notificationBackground];
    UITapGestureRecognizer* notificationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openNotification)];
    notificationTap.cancelsTouchesInView = NO;
    [notificationTap setNumberOfTapsRequired:1];
    [notificationTap setNumberOfTouchesRequired:1];
    [notificationBackground addGestureRecognizer:notificationTap];
    
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] addGestureRecognizer:swipeLeftGesture];

    ///add PostZpot as Intital View of MainView
    [self showPostView];
}

-(void)viewDidAppear:(BOOL)animated{
    if (_leftMenuViewController.parentViewController == nil) {
        [self.navigationController addChildViewController:_leftMenuViewController];
    }
}

-(void)showPostView{
    [self.navigationController popToRootViewControllerAnimated:NO];
    PostZpotViewController* postViewController = [[PostZpotViewController alloc]init];
    [self.navigationController pushViewController:postViewController animated:NO];
    postViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    postViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}

-(void)showFeedView{
    [self.navigationController popToRootViewControllerAnimated:NO];
    FeedZpotViewController* postViewController = [[FeedZpotViewController alloc]init];
    [self.navigationController pushViewController:postViewController animated:NO];
    postViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    postViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}

-(void)showFindView{
    [self.navigationController popToRootViewControllerAnimated:NO];
    FindZpotViewController* postViewController = [[FindZpotViewController alloc]init];
    [self.navigationController pushViewController:postViewController animated:NO];
    postViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    postViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}

-(void)showSettingView{
    [self.navigationController popToRootViewControllerAnimated:NO];
    UserSettingViewController* postViewController = [[UserSettingViewController alloc]init];
    [self.navigationController pushViewController:postViewController animated:NO];
    postViewController.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem;
    postViewController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}

-(void)handleSwipeLeft{
    [self openNotification];
}

-(void)handleSwipeRight{
    [self openMenu];
}

-(void)openMenu
{
    if (_notificationOpening) {
        return;
    }
    _menuOpening = !_menuOpening;
    if (_menuOpening)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:KEY_OPEN_LEFT_MENU object:nil];
        [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] bringSubviewToFront:_leftMenuViewController.view];
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [_leftMenuViewController viewWillAppear:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _leftMenuViewController.tableView.frame;
            frame.origin.x = 0;
            _leftMenuViewController.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            _leftMenuViewController.tableView.frame = frame;
        }];
    }
    else
    {
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        [_leftMenuViewController viewWillDisappear:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _leftMenuViewController.tableView.frame;
            frame.origin.x = -frame.size.width;
            _leftMenuViewController.view.backgroundColor = [UIColor clearColor];
            _leftMenuViewController.tableView.frame = frame;
        } completion:^(BOOL finished) {
            [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] sendSubviewToBack:_leftMenuViewController.view];
        }];
    }
}

-(void)openNotification
{
    if (_menuOpening) {
        return;
    }
    _notificationOpening = !_notificationOpening;
    if (_notificationOpening)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:KEY_OPEN_RIGHT_MENU object:nil];
        [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] bringSubviewToFront:_rightMenuViewController.view];
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [_rightMenuViewController viewWillAppear:YES];

        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _rightMenuViewController.tableView.frame;
            frame.origin.x = 40;
            _rightMenuViewController.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            _rightMenuViewController.tableView.frame = frame;
        }];
    }
    else
    {
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        [_rightMenuViewController viewWillDisappear:YES];

        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _rightMenuViewController.tableView.frame;
            frame.origin.x = frame.size.width;
            _rightMenuViewController.view.backgroundColor = [UIColor clearColor];
            _rightMenuViewController.tableView.frame = frame;
        }completion:^(BOOL finished) {
            [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] sendSubviewToBack:_rightMenuViewController.view];
        }];
    }
}

- (UIView *) screenshot {
    
    return [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
}

- (IBAction)menuPressed:(id)sender {
    [self openMenu];
}

-(IBAction)notificationPressed:(id)sender
{
    [self openNotification];
}


#pragma mark - Left & Right MenuDelegate
-(void)leftmenuChangeViewToClass:(NSString *)clsString{
    if ([clsString isEqualToString:NSStringFromClass([PostZpotViewController class])]) {
        [self showPostView];
    }else if ([clsString isEqualToString:NSStringFromClass([FeedZpotViewController class])]){
        [self showFeedView];
    }else if ([clsString isEqualToString:NSStringFromClass([FindZpotViewController class])]){
        [self showFindView];
    }else if ([clsString isEqualToString:NSStringFromClass([UserSettingViewController class])]){
        [self showSettingView];
    }
    [self openMenu];
}

-(void)closeLeftMenu
{
    [self openMenu];
}

-(void)closeRightNotification
{
    [self openNotification];
}

-(void)didPressedOnNotificationWithAction:(NOTIFICATION_ACTION)command andData:(id)data{
    
}

@end
