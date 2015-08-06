//
//  PostZpotViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "PostZpotViewController.h"
#import "Utils.h"

@interface PostZpotViewController ()<UITableViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate>{
    UIScrollView* _scrollViewContent;
    UITextField* zpotTitleTextField;
    UISearchBar* searchLocationBar;
}

@end

@implementation PostZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"post".localized.uppercaseString;
    // Do any additional setup after loading the view.
}

-(instancetype)init{
    self = [super init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    _scrollViewContent = [[UIScrollView alloc]initWithFrame:frame];
    [self.view addSubview:_scrollViewContent];
    /*======================View Input Location's Title=======================*/
    UIView* zpotTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 44)];
    [_scrollViewContent addSubview:zpotTitleView];
    [zpotTitleView addBorderWithFrame:CGRectMake(0, zpotTitleView.height - 1.0, zpotTitleView.width, 1) color:COLOR_SEPEARATE_LINE];
    
    zpotTitleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, zpotTitleView.frame.size.width - 75, zpotTitleView.height)];
    zpotTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    zpotTitleTextField.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
    zpotTitleTextField.textColor = [UIColor blackColor];
    zpotTitleTextField.placeholder = @"place_holder_zpot_drop_post".localized;
    [zpotTitleTextField setBorderStyle:UITextBorderStyleNone];
    zpotTitleTextField.delegate = self;
    zpotTitleTextField.returnKeyType = UIReturnKeyDone;
    [zpotTitleView addSubview:zpotTitleTextField];
    
    UIButton* btnPostZpot = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPostZpot.backgroundColor = COLOR_DARK_GREEN;
    btnPostZpot.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    [btnPostZpot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPostZpot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnPostZpot setFrame:CGRectMake(zpotTitleView.frame.size.width-60, 0, 60, zpotTitleView.height)];
    [btnPostZpot setTitle:@"post".localized.uppercaseString forState:UIControlStateNormal];
    [zpotTitleView addSubview:btnPostZpot];
    /*======================View Search Location=======================*/
    searchLocationBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, zpotTitleView.y + zpotTitleView.height, self.view.width, 40)];
    searchLocationBar.backgroundColor = [UIColor clearColor];
    searchLocationBar.barTintColor = [UIColor clearColor];
    searchLocationBar.backgroundImage = [[UIImage alloc]init];
    [searchLocationBar addBorderWithFrame:CGRectMake(0, searchLocationBar.height - 1.0, searchLocationBar.width, 1) color:COLOR_SEPEARATE_LINE];
    searchLocationBar.placeholder = @"place_holder_search_location".localized;
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName: [UIColor colorWithRed:219 green:219 blue:219],
                                            NSFontAttributeName: [UIFont fontWithName:@"PTSans-Regular" size:14],
                                            };
    
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchLocationBar.placeholder
                                                                                attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
    [_scrollViewContent addSubview:searchLocationBar];
    /*======================Locations Result Table=======================*/
    UITableView* tableViewLocation = [[UITableView alloc]initWithFrame:CGRectMake(0, searchLocationBar.y + searchLocationBar.height, self.view.width, _scrollViewContent.height - searchLocationBar.y - searchLocationBar.height) style:UITableViewStylePlain];
    tableViewLocation.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewLocation.dataSource = self;
    [_scrollViewContent addSubview:tableViewLocation];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboardIfNeed)];
    tapGesture.numberOfTapsRequired = 1;
    [_scrollViewContent addGestureRecognizer:tapGesture];
    
    return self;
}

-(void)closeKeyboardIfNeed{
    if (zpotTitleTextField.isFirstResponder) {
        [zpotTitleTextField resignFirstResponder];
    }else if (searchLocationBar.isFirstResponder){
        [searchLocationBar resignFirstResponder];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerKeyboardNotification];
    [self registerOpenLeftMenuNotification];
    [self registerOpenRightMenuNotification];
    if (![[Utils instance].mapView.superview isEqual:self.view]) {
        [[Utils instance].mapView removeFromSuperview];
        [[Utils instance].mapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
        [[[Utils instance] mapView] removeAnnotations:[[Utils instance] mapView].annotations];
        [_scrollViewContent addSubview:[Utils instance].mapView];
        [Utils instance].mapView.userInteractionEnabled = NO;
    }
    if ([[Utils instance] isGPS] == NO) {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }else{
        [[Utils instance].locationManager startUpdatingLocation];
        [[Utils instance].locationManager setDelegate:self];
        [[Utils instance].mapView setShowsUserLocation:YES];
        [[Utils instance].mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[Utils instance].locationManager stopUpdatingLocation];
    [[Utils instance].locationManager setDelegate:nil];
    [self removeKeyboardNotification];
    [self removeOpenLeftMenuNotification];
    [self removeOpenRightMenuNotification];
    [[Utils instance].mapView setShowsUserLocation:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)appBecomeActive{
    //force MKMapView to update Location whether GSP is turn on
    [[Utils instance].locationManager startUpdatingLocation];
    [[Utils instance].mapView setShowsUserLocation:YES];
}

-(void)leftMenuOpened{
    [self closeKeyboardIfNeed];
}
-(void)rightMenuOpened{
    [self closeKeyboardIfNeed];
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
        cell.detailTextLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:12];
        cell.textLabel.font =   [UIFont fontWithName:@"PTSans-Bold" size:16];
    };
    
    cell.textLabel.text = @"Text Title";
    cell.detailTextLabel.text = @"Text Subtitle";
    [cell addBorderWithFrame:CGRectMake(10, 44-1,tableView.frame.size.width -10, 1) color:COLOR_SEPEARATE_LINE];
    
    return cell;
}

#pragma mark - UIKeyboard
-(void)keyboardShow:(CGRect)frame{
    CGRect rect;
    if (zpotTitleTextField.isFirstResponder) {
        rect =zpotTitleTextField.superview.frame;
    }else{
        rect = searchLocationBar.frame;
    }
    if (_scrollViewContent.height - rect.origin.y - rect.size.height < frame.size.height) {
        [_scrollViewContent setContentOffset:CGPointMake(0, frame.size.height -(_scrollViewContent.height - rect.origin.y - rect.size.height) )];
    }
}
-(void)keyboardHide:(CGRect)frame{
    [_scrollViewContent setContentOffset:CGPointZero];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
