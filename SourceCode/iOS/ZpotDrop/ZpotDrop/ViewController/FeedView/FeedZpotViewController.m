//
//  FeedZpotViewController.m
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedZpotViewController.h"

@interface FeedZpotViewController (){
    UITableView* _feedTableView;
    UIView* _commentPostView;
}

@end

@implementation FeedZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"feed".localized.uppercaseString;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _feedTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _feedTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_feedTableView];
    
    _commentPostView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [_commentPostView addTopBorderWithHeight:1.0 andColor:COLOR_SEPEARATE_LINE];
    _commentPostView.translatesAutoresizingMaskIntoConstraints = NO;
    _commentPostView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_commentPostView];
    
    /*============Layout with Constraints============*/
    NSDictionary* dictItems = NSDictionaryOfVariableBindings(_feedTableView,_commentPostView);
    NSArray* commentPostW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentPostView]|" options:0 metrics:nil views:dictItems];
    NSArray* feedTableW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_feedTableView]|" options:0 metrics:nil views:dictItems];
    NSArray* combineH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_feedTableView]-0-[_commentPostView(40)]-0-|" options:0 metrics:nil views:dictItems];
    [self.view addConstraints:commentPostW];
    [self.view addConstraints:feedTableW];
    [self.view addConstraints:combineH];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
