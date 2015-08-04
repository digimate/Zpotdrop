//
//  MainViewController.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    int spacing = 40;
    _menuBackground = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_menuBackground setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.view addSubview:_menuBackground];
    [self.navigationController.view sendSubviewToBack:_menuBackground];
    
    UITapGestureRecognizer* menuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openMenu)];
    [menuTap setNumberOfTapsRequired:1];
    [menuTap setNumberOfTouchesRequired:1];
    [_menuBackground addGestureRecognizer:menuTap];
    
    _menuContentView = [[LeftMenuViewController alloc]init];
    [_menuBackground addSubview:_menuContentView.view];
    _menuContentView.view.frame = CGRectMake(spacing - _menuBackground.frame.size.width, 0, _menuBackground.frame.size.width - spacing, _menuBackground.frame.size.height);

    //====================== RIGHT NOTIFICATION =========================
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    frame.size.height -= frame.origin.y;
    _notificationBackground = [[UIView alloc]initWithFrame:frame];
    [_notificationBackground setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.view addSubview:_notificationBackground];
    [self.navigationController.view sendSubviewToBack:_notificationBackground];
    
    _notificationContentView = [[UITableView alloc]initWithFrame:CGRectMake(_notificationBackground.frame.size.width, 0, _notificationBackground.frame.size.width - spacing, _notificationBackground.frame.size.height) style:UITableViewStylePlain];
    [_notificationBackground addSubview:_notificationContentView];

    UITapGestureRecognizer* notificationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openNotification)];
    [notificationTap setNumberOfTapsRequired:1];
    [notificationTap setNumberOfTouchesRequired:1];
    [_notificationBackground addGestureRecognizer:notificationTap];
    
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
}

-(void)viewDidAppear:(BOOL)animated{
    if (_menuContentView.parentViewController == nil) {
        [self.navigationController addChildViewController:_menuContentView];
    }
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
        [self.navigationController.view bringSubviewToFront:_menuBackground];
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _menuContentView.view.frame;
            frame.origin.x = 0;
            _menuBackground.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            _menuContentView.view.frame = frame;
        }];
    }
    else
    {
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _menuContentView.view.frame;
            frame.origin.x = -frame.size.width;
            _menuBackground.backgroundColor = [UIColor clearColor];
            _menuContentView.view.frame = frame;
        } completion:^(BOOL finished) {
            [self.navigationController.view sendSubviewToBack:_menuBackground];
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
        [self.navigationController.view bringSubviewToFront:_notificationBackground];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _notificationContentView.frame;
            frame.origin.x = _notificationBackground.frame.size.width - frame.size.width;
            _notificationBackground.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            _notificationContentView.frame = frame;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _notificationContentView.frame;
            frame.origin.x = _notificationBackground.frame.size.width;
            _notificationBackground.backgroundColor = [UIColor clearColor];
            _notificationContentView.frame = frame;
        }completion:^(BOOL finished) {
            [self.navigationController.view sendSubviewToBack:_notificationBackground];
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

@end
