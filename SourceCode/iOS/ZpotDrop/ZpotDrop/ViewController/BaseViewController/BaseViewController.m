//
//  BaseViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _api = [APIService shareAPIService];
    _rule = [RuleService shareRuleService];
    
    //====================== LEFT MENU =========================
    _menuScrollBackground = [[UIScrollView alloc]initWithFrame:self.navigationController.view.frame];
    [_menuScrollBackground setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
    [_menuScrollBackground setDelegate:self];
    [_menuScrollBackground setShowsHorizontalScrollIndicator:NO];
    [_menuScrollBackground setPagingEnabled:YES];
    
    [self.navigationController.view addSubview:_menuScrollBackground];
    [self.navigationController.view sendSubviewToBack:_menuScrollBackground];
    
    _menuContentView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width - 40, self.view.frame.size.height) style:UITableViewStylePlain];
    [_menuScrollBackground addSubview:_menuContentView];
    
    [_menuScrollBackground setContentSize:CGSizeMake(self.navigationController.view.frame.size.width + _menuContentView.frame.size.width, 0)];
    
    _menuScreenShot = [[UIView alloc]initWithFrame:CGRectMake(_menuContentView.frame.size.width, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    [_menuScrollBackground addSubview:_menuScreenShot];
    
    _menuBlurMask = [[UIView alloc]initWithFrame:_menuScreenShot.frame];
    [_menuBlurMask setBackgroundColor:[UIColor redColor]];
    
    UITapGestureRecognizer* menuTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenuTap:)];
    [menuTap setNumberOfTapsRequired:1];
    [menuTap setNumberOfTouchesRequired:1];
    [_menuBlurMask addGestureRecognizer:menuTap];
    
    [_menuScrollBackground addSubview:_menuBlurMask];
    [_menuScrollBackground setContentOffset:CGPointMake(_menuContentView.frame.size.width, 0)];
    
    
    //====================== RIGHT NOTIFICATION =========================
    _notificationScrollBackground = [[UIScrollView alloc]initWithFrame:self.navigationController.view.frame];
    [_notificationScrollBackground setBackgroundColor:[UIColor colorWithHexString:@"000000"]];
    [_notificationScrollBackground setDelegate:self];
    [_notificationScrollBackground setShowsHorizontalScrollIndicator:NO];
    [_notificationScrollBackground setPagingEnabled:YES];
    
    [self.navigationController.view addSubview:_notificationScrollBackground];
    [self.navigationController.view sendSubviewToBack:_notificationScrollBackground];
    
    _notificationScreenShot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    [_notificationScrollBackground addSubview:_notificationScreenShot];
    
    _notificationBlurMask = [[UIView alloc]initWithFrame:_notificationScreenShot.frame];
    [_notificationBlurMask setBackgroundColor:[UIColor redColor]];
    
    UITapGestureRecognizer* notificationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeNotificationTap:)];
    [notificationTap setNumberOfTapsRequired:1];
    [notificationTap setNumberOfTouchesRequired:1];
    [_notificationBlurMask addGestureRecognizer:notificationTap];
    
    [_notificationScrollBackground addSubview:_notificationBlurMask];
    
    _notificationContentView = [[UITableView alloc]initWithFrame:CGRectMake(_notificationScreenShot.frame.size.width, 0, self.navigationController.view.frame.size.width - 40, self.view.frame.size.height) style:UITableViewStylePlain];
    [_notificationScrollBackground addSubview:_notificationContentView];
    
    [_notificationScrollBackground setContentSize:CGSizeMake(self.navigationController.view.frame.size.width + _notificationScrollBackground.frame.size.width, 0)];
    
    [_notificationScrollBackground setContentOffset:CGPointMake(_notificationContentView.frame.size.width, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeMenuTap:(id)sender
{
    [_menuScrollBackground setContentOffset:CGPointMake(_menuContentView.frame.size.width, 0) animated:YES];
}

-(IBAction)closeNotificationTap:(id)sender
{
    [_notificationScrollBackground setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)openMenu
{
    _menuOpening = !_menuOpening;
    if (_menuOpening)
    {
        UIView* tmp = [self screenshot];
        [tmp setCenter:_menuScreenShot.center];
        [_menuScrollBackground addSubview:tmp];
        [_menuScreenShot removeFromSuperview];
        _menuScreenShot = tmp;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.view bringSubviewToFront:_menuScrollBackground];
        [_menuScrollBackground bringSubviewToFront:_menuBlurMask];
        [_menuScrollBackground setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.view sendSubviewToBack:_menuScrollBackground];
    }
}

-(void)openNotification
{
    _notificationOpening = !_notificationOpening;
    if (_notificationOpening)
    {
        UIView* tmp = [self screenshot];
        [tmp setCenter:_notificationScreenShot.center];
        [_notificationScrollBackground addSubview:tmp];
        [_notificationScreenShot removeFromSuperview];
        _notificationScreenShot = tmp;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.view bringSubviewToFront:_notificationScrollBackground];
        [_notificationScrollBackground bringSubviewToFront:_notificationBlurMask];
        [_notificationScrollBackground setContentOffset:CGPointMake(_notificationContentView.frame.size.width, 0) animated:YES];
    }
    else
    {
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.view sendSubviewToBack:_notificationScrollBackground];
    }
}

- (UIView *) screenshot {
    
    return [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
}

-(BOOL)prefersStatusBarHidden
{
    return (_menuOpening | _notificationOpening);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_menuScrollBackground == scrollView)
    {
        [_menuBlurMask setBackgroundColor:[UIColor colorWithWhite:0.f alpha:(.7 - (scrollView.contentOffset.x/scrollView.frame.size.width))]];
    }
    else if (_notificationScrollBackground == scrollView)
    {
        [_notificationBlurMask setBackgroundColor:[UIColor colorWithWhite:0.f alpha:(scrollView.contentOffset.x/scrollView.frame.size.width)]];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0 && scrollView == _menuScrollBackground)
    {
        [self openMenu];
    }
    else if (scrollView.contentOffset.x == 0 && scrollView == _notificationScrollBackground)
    {
        [self openNotification];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0 && scrollView == _menuScrollBackground)
    {
        [self openMenu];
    }
    else if (scrollView.contentOffset.x == 0 && scrollView == _notificationScrollBackground)
    {
        [self openNotification];
    }
}

@end
