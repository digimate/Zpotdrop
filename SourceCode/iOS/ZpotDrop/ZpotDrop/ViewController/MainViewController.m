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

@interface MainViewController ()<LeftMenuDelegate>

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
    int spacing = 40;
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    frame.size.height -= frame.origin.y;
    _notificationBackground = [[UIView alloc]initWithFrame:frame];
    [_notificationBackground setBackgroundColor:[UIColor clearColor]];
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] addSubview:_notificationBackground];
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] sendSubviewToBack:_notificationBackground];
    
    _notificationContentView = [[UITableView alloc]initWithFrame:CGRectMake(_notificationBackground.frame.size.width, 0, _notificationBackground.frame.size.width - spacing, _notificationBackground.frame.size.height) style:UITableViewStylePlain];
    [_notificationBackground addSubview:_notificationContentView];

    UITapGestureRecognizer* notificationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openNotification)];
    [notificationTap setNumberOfTapsRequired:1];
    [notificationTap setNumberOfTouchesRequired:1];
    [_notificationBackground addGestureRecognizer:notificationTap];
    
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRight)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] addGestureRecognizer:swipeLeftGesture];
}

-(void)viewDidAppear:(BOOL)animated{
    if (_leftMenuViewController.parentViewController == nil) {
        [self.navigationController addChildViewController:_leftMenuViewController];
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
        [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] bringSubviewToFront:_notificationBackground];
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
            [[(AppDelegate*)[[UIApplication sharedApplication]delegate] window] sendSubviewToBack:_notificationBackground];
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

#pragma mark - LeftMenuDelegate
-(void)leftmenuChangeViewToClass:(NSString *)clsString{
    if ([clsString isEqualToString:NSStringFromClass([PostZpotViewController class])]) {
        
    }
}
@end
