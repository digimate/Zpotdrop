//
//  PostZpotViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "PostZpotViewController.h"
#import "Utils.h"

@interface PostZpotViewController ()<UITableViewDataSource>{
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
    
    UITableView* tableViewLocation = [[UITableView alloc]initWithFrame:CGRectMake(0, searchLocationBar.y + searchLocationBar.height, self.view.width, _scrollViewContent.height - searchLocationBar.y - searchLocationBar.height) style:UITableViewStylePlain];
    tableViewLocation.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewLocation.dataSource = self;
    [_scrollViewContent addSubview:tableViewLocation];
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

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* str = @"cellLocation";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:159 green:159 blue:159];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        cell.textLabel.font =   [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    };
    
    cell.textLabel.text = @"Text Title";
    cell.detailTextLabel.text = @"Text Subtitle";
    [cell addBorderWithFrame:CGRectMake(10, 44-1,tableView.frame.size.width -10, 1) color:COLOR_SEPEARATE_LINE];
    
    return cell;
}
@end
