//
//  PostZpotViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "PostZpotViewController.h"
#import "Utils.h"

@interface PostZpotViewController (){
    UIScrollView* _scrollViewContent;
}

@end

@implementation PostZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"post".localized.uppercaseString;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
 
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    _scrollViewContent = [[UIScrollView alloc]initWithFrame:frame];
    [self.view addSubview:_scrollViewContent];
    
    UIView* zpotTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 44)];
    [_scrollViewContent addSubview:zpotTitleView];
    [zpotTitleView addBorderWithFrame:CGRectMake(0, zpotTitleView.height - 1.0, zpotTitleView.width, 1) color:COLOR_SEPEARATE_LINE];

    UITextField* zpotTitleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, zpotTitleView.frame.size.width - 75, zpotTitleView.height)];
    zpotTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    zpotTitleTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    zpotTitleTextField.textColor = [UIColor blackColor];
    zpotTitleTextField.placeholder = @"place_holder_zpot_drop_post".localized;
    [zpotTitleTextField setBorderStyle:UITextBorderStyleNone];
    [zpotTitleView addSubview:zpotTitleTextField];
    
    UIButton* btnPostZpot = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPostZpot.backgroundColor = COLOR_DARK_GREEN;
    btnPostZpot.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [btnPostZpot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPostZpot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnPostZpot setFrame:CGRectMake(zpotTitleView.frame.size.width-60, 0, 60, zpotTitleView.height)];
    [btnPostZpot setTitle:@"post".localized.uppercaseString forState:UIControlStateNormal];
    [zpotTitleView addSubview:btnPostZpot];
    
    UISearchBar* searchLocationBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, zpotTitleView.y + zpotTitleView.height, self.view.width, 40)];
    searchLocationBar.backgroundColor = [UIColor clearColor];
    searchLocationBar.barTintColor = [UIColor clearColor];
    searchLocationBar.backgroundImage = [[UIImage alloc]init];
    [searchLocationBar addBorderWithFrame:CGRectMake(0, searchLocationBar.height - 1.0, searchLocationBar.width, 1) color:COLOR_SEPEARATE_LINE];
    searchLocationBar.placeholder = @"place_holder_search_location".localized;
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName: [UIColor colorWithRed:219 green:219 blue:219],
                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14],
                                            };
    
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchLocationBar.placeholder
                                                                                attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    [_scrollViewContent addSubview:searchLocationBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[Utils instance].mapView.superview isEqual:self.view]) {
        [[Utils instance].mapView removeFromSuperview];
        [[Utils instance].mapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
        [self.view addSubview:[Utils instance].mapView];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
