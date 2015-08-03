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
    
    _screenShot = [[UIView alloc]initWithFrame:CGRectMake(_menuContentView.frame.size.width, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height)];
    [_menuScrollBackground addSubview:_screenShot];
    
    _blurMask = [[UIView alloc]initWithFrame:_screenShot.frame];
    [_blurMask setBackgroundColor:[UIColor redColor]];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenuTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [_blurMask addGestureRecognizer:tap];
    
    [_menuScrollBackground addSubview:_blurMask];
    [_menuScrollBackground setContentOffset:CGPointMake(_menuContentView.frame.size.width, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeMenuTap:(id)sender
{
    [_menuScrollBackground setContentOffset:CGPointMake(_menuContentView.frame.size.width, 0) animated:YES];
}

-(void)openMenu
{
    _menuOpening = !_menuOpening;
    if (_menuOpening)
    {
        UIView* tmp = [self screenshot];
        [tmp setCenter:_screenShot.center];
        [_menuScrollBackground addSubview:tmp];
        [_screenShot removeFromSuperview];
        _screenShot = tmp;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.view bringSubviewToFront:_menuScrollBackground];
        [_menuScrollBackground bringSubviewToFront:_blurMask];
        [_menuScrollBackground setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.view sendSubviewToBack:_menuScrollBackground];
    }
}

- (UIView *) screenshot {
    
    return [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
}

-(BOOL)prefersStatusBarHidden
{
    return _menuOpening;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f", (1 - (scrollView.contentOffset.x/scrollView.frame.size.width)));
    [_blurMask setBackgroundColor:[UIColor colorWithWhite:0.f alpha:(.7 - (scrollView.contentOffset.x/scrollView.frame.size.width))]];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        [self openMenu];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        [self openMenu];
    }
}

@end
