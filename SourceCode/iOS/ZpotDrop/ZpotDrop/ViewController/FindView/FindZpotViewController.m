//
//  FindZpotViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FindZpotViewController.h"

@interface FindZpotViewController (){
    UISearchBar* searchZpotBar;
}

@end

@implementation FindZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"find".localized.uppercaseString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    /*======================View Search Zpot=======================*/
    searchZpotBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    searchZpotBar.backgroundColor = [UIColor clearColor];
    searchZpotBar.barTintColor = [UIColor clearColor];
    searchZpotBar.backgroundImage = [[UIImage alloc]init];
    searchZpotBar.placeholder = @"place_holder_search_zpot".localized;
    [searchZpotBar setImage:[UIImage imageNamed:@"ic_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchZpotBar addBorderWithFrame:CGRectMake(0, searchZpotBar.height - 1.0, searchZpotBar.width, 1) color:COLOR_SEPEARATE_LINE];
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName: [UIColor colorWithRed:219 green:219 blue:219],
                                            NSFontAttributeName: [UIFont fontWithName:@"PTSans-Regular" size:14],
                                            };
    
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchZpotBar.placeholder
                                                                                attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
    [self.view addSubview:searchZpotBar];
    
    /*======================View Scan=======================*/
    UIButton* btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScan.frame = CGRectMake(0, frame.size.height - 44, frame.size.width, 44);
    btnScan.backgroundColor = COLOR_DARK_GREEN;
    [btnScan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnScan setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnScan.titleLabel setFont:[UIFont fontWithName:@"PTSans-Bold" size:20]];
    [self.view addSubview:btnScan];
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
