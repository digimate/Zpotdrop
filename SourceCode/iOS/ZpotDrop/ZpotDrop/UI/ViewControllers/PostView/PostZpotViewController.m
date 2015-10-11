//
//  PostZpotViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "PostZpotViewController.h"
#import "Utils.h"
#import "CreateLocationCell.h"
#import "LocationDataModel.h"
#import "LeftMenuViewController.h"
#import "FeedZpotViewController.h"
#import "UIColor+HexColors.h"

@interface PostZpotViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate>{
    UIScrollView* _scrollViewContent;
    UITextField* zpotTitleTextField;
    UISearchBar* searchLocationBar;
    NSMutableArray* searchLocationResults;
    UITableView* tableViewLocation;
    id currentSelectedLocation;
    CreateLocationCell* createLocationCell;
}

@end

@implementation PostZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"post".localized.uppercaseString;
    [self setupUI];
}


- (void)setupUI {
    btnAddText.layer.borderWidth    = 0.5;
    btnAddText.layer.borderColor    = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    
    btnAddFriends.layer.borderWidth = 0.5;
    btnAddFriends.layer.borderColor = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
    
    btnAddImage.layer.borderWidth   = 0.5;
    btnAddImage.layer.borderColor   = [UIColor colorWithHexString:@"e9e9e9"].CGColor;
}

//-(instancetype)init{
//    self = [super init];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//    
//    searchLocationResults = [NSMutableArray array];
//    CGRect frame = [UIScreen mainScreen].bounds;
//    frame.size.height -= 64;
//    _scrollViewContent = [[UIScrollView alloc]initWithFrame:frame];
//    [self.view addSubview:_scrollViewContent];
//    /*======================View Input Location's Title=======================*/
//    UIView* zpotTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 44)];
//    [_scrollViewContent addSubview:zpotTitleView];
//    [zpotTitleView addBorderWithFrame:CGRectMake(0, zpotTitleView.height - 1.0, zpotTitleView.width, 1) color:COLOR_SEPEARATE_LINE];
//    
//    zpotTitleTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, zpotTitleView.frame.size.width - 75, zpotTitleView.height)];
//    zpotTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    zpotTitleTextField.font = [UIFont fontWithName:@"PTSans-Regular" size:16];
//    zpotTitleTextField.textColor = [UIColor blackColor];
//    zpotTitleTextField.placeholder = @"place_holder_zpot_drop_post".localized;
//    [zpotTitleTextField setBorderStyle:UITextBorderStyleNone];
//    zpotTitleTextField.delegate = self;
//    zpotTitleTextField.returnKeyType = UIReturnKeyDone;
//    [zpotTitleView addSubview:zpotTitleTextField];
//    
//    UIButton* btnPostZpot = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnPostZpot.backgroundColor = COLOR_DARK_GREEN;
//    btnPostZpot.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
//    [btnPostZpot setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnPostZpot setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [btnPostZpot setFrame:CGRectMake(zpotTitleView.frame.size.width-60, 0, 60, zpotTitleView.height)];
//    [btnPostZpot setTitle:@"post".localized.uppercaseString forState:UIControlStateNormal];
//    [btnPostZpot addTarget:self action:@selector(postNewZpot:) forControlEvents:UIControlEventTouchUpInside];
//    [zpotTitleView addSubview:btnPostZpot];
//    /*======================View Search Location=======================*/
//    searchLocationBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, zpotTitleView.y + zpotTitleView.height, self.view.width, 40)];
//    searchLocationBar.delegate = self;
//    searchLocationBar.enablesReturnKeyAutomatically = NO;
//    searchLocationBar.backgroundColor = [UIColor clearColor];
//    searchLocationBar.barTintColor = [UIColor clearColor];
//    searchLocationBar.backgroundImage = [[UIImage alloc]init];
//    [searchLocationBar setImage:[UIImage imageNamed:@"location_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [searchLocationBar addBorderWithFrame:CGRectMake(0, searchLocationBar.height - 1.0, searchLocationBar.width, 1) color:COLOR_SEPEARATE_LINE];
//    searchLocationBar.placeholder = @"place_holder_search_location".localized;
//    NSDictionary *placeholderAttributes = @{
//                                            NSForegroundColorAttributeName: [UIColor colorWithRed:219 green:219 blue:219],
//                                            NSFontAttributeName: [UIFont fontWithName:@"PTSans-Regular" size:14],
//                                            };
//    
//    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchLocationBar.placeholder
//                                                                                attributes:placeholderAttributes];
//    
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
//    [_scrollViewContent addSubview:searchLocationBar];
//    /*======================Locations Result Table=======================*/
//    tableViewLocation = [[UITableView alloc]initWithFrame:CGRectMake(0, searchLocationBar.y + searchLocationBar.height, self.view.width, _scrollViewContent.height - searchLocationBar.y - searchLocationBar.height) style:UITableViewStylePlain];
//    tableViewLocation.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [tableViewLocation registerNib:[UINib nibWithNibName:NSStringFromClass([CreateLocationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CreateLocationCell class])];
//    tableViewLocation.dataSource = self;
//    tableViewLocation.delegate = self;
//    [_scrollViewContent addSubview:tableViewLocation];
//    [_scrollViewContent setClipsToBounds:YES];
//    //    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboardIfNeed)];
//    //    tapGesture.numberOfTapsRequired = 1;
//    //    [_scrollViewContent addGestureRecognizer:tapGesture];
//    
//    return self;
//}

-(void)postNewZpot:(UIButton*)sender{
    if (![Utils instance].mapView.userLocationVisible ||  !CLLocationCoordinate2DIsValid([Utils instance].mapView.userLocation.coordinate)) {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
    else if ([zpotTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_empty_zpot_title".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }else if (currentSelectedLocation == nil){
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_empty_zpot_location".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }else{
        //Post zpot
        [self closeKeyboardIfNeed];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"title":[zpotTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                                                                      @"location":[(LocationDataModel*)currentSelectedLocation mid]
                                                                                      }];
        NSInteger row = [searchLocationResults indexOfObject:currentSelectedLocation];
        currentSelectedLocation = nil;
        [tableViewLocation reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        zpotTitleTextField.text = nil;
        [[Utils instance]showProgressWithMessage:nil];
        [[APIService shareAPIService]postZpotWithCoordinate:[Utils instance].mapView.userLocation.coordinate params:params completion:^(id data, NSString *error) {
            [[Utils instance]hideProgess];
            if (data) {
                //                FeedDataModel* feedModel = (FeedDataModel*)data;
                //                ZpotAnnotation *annotationPoint = [[ZpotAnnotation alloc] init];
                //                [annotationPoint setCoordinate:CLLocationCoordinate2DMake([feedModel.latitude doubleValue], [feedModel.longitude doubleValue])];
                //                [annotationPoint setTitle:feedModel.title];
                //                [[[Utils instance] mapView] addAnnotation:annotationPoint];
                [[LeftMenuViewController instance]changeViewToClass:NSStringFromClass([FeedZpotViewController class])];
            }else{
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }
        }];
    }
}

-(void)closeKeyboardIfNeed{
    if (zpotTitleTextField.isFirstResponder) {
        [zpotTitleTextField resignFirstResponder];
    }else if (searchLocationBar.isFirstResponder){
        [searchLocationBar resignFirstResponder];
    }
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self registerKeyboardNotification];
//    [self registerOpenLeftMenuNotification];
//    [self registerOpenRightMenuNotification];
//    if ([Utils instance].mapView.superview == nil || ![[Utils instance].mapView.superview isEqual:self.view]) {
//        [[Utils instance] clearMapViewBeforeUsing];
//        [[Utils instance].mapView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
//        [_scrollViewContent addSubview:[Utils instance].mapView];
//        [Utils instance].mapView.userInteractionEnabled = NO;
//        [[Utils instance] mapView].delegate = self;
//    }
//    if ([[Utils instance] isGPS] == NO) {
//        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        }];
//    }else{
//        [[Utils instance].locationManager setDelegate:self];
//        [[Utils instance].locationManager startUpdatingLocation];
//        [[Utils instance].mapView setShowsUserLocation:YES];
//        [[Utils instance].mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    }
//    [self removeAppBecomActiveNotification];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[Utils instance].locationManager stopUpdatingLocation];
//    [[Utils instance].locationManager setDelegate:nil];
//    [self removeKeyboardNotification];
//    [self removeOpenLeftMenuNotification];
//    [self removeOpenRightMenuNotification];
//    [[Utils instance] mapView].delegate = nil;
//    [[Utils instance].mapView setShowsUserLocation:NO];
//    [self removeAppBecomActiveNotification];
//}

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

-(void)searchLocationInLocal:(NSString*)key{
    MKMapView* mapView = [[Utils instance] mapView];
    
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapView.visibleMapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(mapView.visibleMapRect.origin.x + mapView.visibleMapRect.size.width, mapView.visibleMapRect.origin.y + mapView.visibleMapRect.size.height));
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ AND %lf <= latitude AND latitude <= %lf AND %lf <= longitude AND longitude <= %lf",key,botRight.latitude,topLeft.latitude,topLeft.longitude,botRight.longitude];
    
    NSArray* locationModels = [LocationDataModel fetchObjectsWithPredicate:predicate sorts:nil];
    [searchLocationResults removeAllObjects];
    currentSelectedLocation = nil;
    [searchLocationResults addObjectsFromArray:locationModels];
    [tableViewLocation reloadData];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchLocationResults.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == searchLocationResults.count) {
        CreateLocationCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CreateLocationCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.onCreateLocationPressed = ^(NSString* name,NSString* address){
            if (![Utils instance].mapView.userLocationVisible ||  !CLLocationCoordinate2DIsValid([Utils instance].mapView.userLocation.coordinate)) {
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }
            else if (name.length == 0) {
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_empty_location_name".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }else if (address.length == 0 ){
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_empty_location_address".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }else{
                //create location
                [[Utils instance]showProgressWithMessage:nil];
                [[APIService shareAPIService]createLocationWithCoordinate:[Utils instance].mapView.userLocation.coordinate params:[NSMutableDictionary dictionaryWithDictionary:@{@"name":name,@"address":address}] completion:^(id data, NSString *error) {
                    [[Utils instance]hideProgess];
                    if (data == nil) {
                        [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        }];
                    }else{
                        [searchLocationResults insertObject:data atIndex:0];
                        [tableViewLocation insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                    }
                }];
            }
        };
        createLocationCell = cell;
        return cell;
    }else{
        LocationDataModel* data = [searchLocationResults objectAtIndex:indexPath.row];
        static NSString* str = @"cellLocation";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:159 green:159 blue:159];
            cell.detailTextLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:12];
            cell.textLabel.font =   [UIFont fontWithName:@"PTSans-Bold" size:16];
        };
        if (data == currentSelectedLocation) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = data.name;
        cell.detailTextLabel.text = data.address;
        [cell addBorderWithFrame:CGRectMake(10, 44-1,tableView.frame.size.width -20, 1) color:COLOR_SEPEARATE_LINE];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closeKeyboardIfNeed];
    if (indexPath.row < searchLocationResults.count) {
        id data = [searchLocationResults objectAtIndex:indexPath.row];
        if (data != currentSelectedLocation) {
            NSMutableArray* array = [NSMutableArray arrayWithObjects:indexPath, nil];
            if (currentSelectedLocation != nil) {
                NSInteger row = [searchLocationResults indexOfObject:currentSelectedLocation];
                [array addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            }
            currentSelectedLocation = data;
            [tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == searchLocationResults.count) {
        return 185;
    }
    return 44;
}

#pragma mark - UIKeyboard
-(void)keyboardShow:(CGRect)frame{
    CGRect rect;
    if (zpotTitleTextField.isFirstResponder) {
        rect = zpotTitleTextField.superview.frame;
    }else if(searchLocationBar.isFirstResponder){
        rect = searchLocationBar.frame;
    }else{
        rect = tableViewLocation.frame;
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
#pragma mark - CLLocationDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (createLocationCell && createLocationCell.address.length == 0) {
        CLLocation* loc = [locations lastObject];
        CLLocationCoordinate2D coor = [loc coordinate];
        [[Utils instance].mapView setCenterCoordinate:coor];
        [[APIService shareAPIService]addressFromLocationCoordinate:coor completion:^(NSString *address) {
            if (createLocationCell && address) {
                [createLocationCell setAddress:address];
            }
        }];
    }
    
}
#pragma mark - MKMapViewDelegate
-(void)changeUserLocationColor{
    MKAnnotationView* annotationView = [[Utils instance].mapView viewForAnnotation:[Utils instance].mapView .userLocation];
    if (annotationView) {
        annotationView.tintColor = COLOR_DARK_GREEN;
    }else{
        [self performSelector:@selector(changeUserLocationColor) withObject:nil afterDelay:0.3];
    }
}
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [self changeUserLocationColor];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *const kAnnotationIdentifier = @"ZpotMapAnnotation";
    ZpotAnnotationView *annotationView = (ZpotAnnotationView *)
    [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
    if (! annotationView) {
        annotationView = [[ZpotAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
    }
    [annotationView setAnnotation:annotation];
    
    return annotationView;
}

#pragma mark - UISearchbarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length > 0) {
        [self searchLocationInLocal:searchBar.text];
    }else{
        [searchLocationResults removeAllObjects];
        currentSelectedLocation = nil;
        [tableViewLocation reloadData];
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (searchBar.text.length > 0) {
        MKMapView* mapView = [[Utils instance] mapView];
        CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapView.visibleMapRect.origin);
        CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(mapView.visibleMapRect.origin.x + mapView.visibleMapRect.size.width, mapView.visibleMapRect.origin.y + mapView.visibleMapRect.size.height));
        
        [[Utils instance]showProgressWithMessage:nil];
        [[APIService shareAPIService]searchLocationWithName:searchBar.text withinCoord:topLeft coor2:botRight completion:^(NSArray *data, NSString *error) {
            [[Utils instance]hideProgess];
            [self searchLocationInLocal:searchBar.text];
        }];
    }
}
@end
