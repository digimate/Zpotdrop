//
//  FindZpotViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FindZpotViewController.h"
#import "ScannedUserCell.h"
#import "ScannedUserAnnoView.h"
#import "ZpotAnnotationView.h"
#import "FriendRequestZpotCell.h"
#import "MyAnnotation.h"
@interface FindZpotViewController ()<MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    UISearchBar* searchZpotBar;
    UICollectionView* usersCollectionView;
    BOOL shoudMoveToUserLocation;
    NSMutableArray* scannedUsersData;
    id selectedScannedUser;
    UITableView* friendsSearchTableView;
    NSMutableArray* searchUsersData;
    UIButton* btnHere;
    UIButton* btnThere;
}

@end

@implementation FindZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scannedUsersData = [NSMutableArray array];
    searchUsersData = [NSMutableArray array];
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
    searchZpotBar.enablesReturnKeyAutomatically = NO;
    searchZpotBar.delegate = self;
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
    [btnScan setTitle:@"scan".localized forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(scanArea:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];
    
    /*======================Here There=======================*/
    btnHere = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHere.frame = CGRectMake(0, btnScan.y - 44, self.view.frame.size.width/2, 44);
    [btnHere addTopBorderWithHeight:1.0 andColor:COLOR_SEPEARATE_LINE];
    [btnHere setTitle:@"Here" forState:UIControlStateNormal];
    [btnHere setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    [btnHere setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnHere addRightBorderWithWidth:1.0 andColor:COLOR_SEPEARATE_LINE];
    [btnHere addTarget:self action:@selector(changeHereThere:) forControlEvents:UIControlEventTouchUpInside];
    btnHere.selected = YES;
    [self.view addSubview:btnHere];
    
    btnThere = [UIButton buttonWithType:UIButtonTypeCustom];
    btnThere.frame = CGRectMake(btnHere.x + btnHere.width, btnHere.y, btnHere.width, btnHere.height);
    [btnThere addTopBorderWithHeight:1.0 andColor:COLOR_SEPEARATE_LINE];
    [btnThere setTitle:@"There" forState:UIControlStateNormal];
    [btnThere setTitleColor:COLOR_DARK_GREEN forState:UIControlStateSelected];
    [btnThere setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnThere addTarget:self action:@selector(changeHereThere:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnThere];
    
    /*======================Users Collection=======================*/
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    usersCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, btnHere.y - 60, frame.size.width, 60) collectionViewLayout:layout];
    [usersCollectionView setBackgroundColor:[UIColor whiteColor]];
    [usersCollectionView setDataSource:self];
    [usersCollectionView setDelegate:self];
    [usersCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ScannedUserCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ScannedUserCell class])];
    [self.view addSubview:usersCollectionView];
    
    /*======================Friends Search Result=======================*/
    friendsSearchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchZpotBar.height, self.view.width, self.view.height - 64 - searchZpotBar.height) style:UITableViewStylePlain];
    friendsSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [friendsSearchTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendRequestZpotCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FriendRequestZpotCell class])];
    friendsSearchTableView.dataSource = self;
    friendsSearchTableView.delegate = self;
    friendsSearchTableView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
}

-(void)changeHereThere:(UIButton*)sender{
    if (!sender.isSelected) {
        sender.selected = YES;
        if (sender == btnHere) {
            btnThere.selected = NO;
        }else{
            btnHere.selected = NO;
        }
        [self updateMapView];
    }
}

-(void)updateMapView{
    [Utils instance].mapView.delegate = self;
    if (btnHere.isSelected) {
        [Utils instance].mapView.showsUserLocation = YES;
        [[Utils instance].mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        [Utils instance].mapView.scrollEnabled = NO;
        [Utils instance].mapView.zoomEnabled = NO;
        [[Utils instance].mapView removeOverlays:[Utils instance].mapView.overlays];
    }else{
        btnHere.selected = NO;
        [Utils instance].mapView.showsUserLocation = YES;
        [[Utils instance].mapView setUserTrackingMode:MKUserTrackingModeNone];
        [Utils instance].mapView.scrollEnabled = YES;
        [Utils instance].mapView.zoomEnabled = YES;
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:[Utils instance].mapView.centerCoordinate radius:500];
        [[Utils instance].mapView addOverlay:circle];
    }
}

-(void)moveToCurrentLocation{
    if ([[Utils instance]isGPS]) {
        [[Utils instance].locationManager startUpdatingLocation];
    }else{
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
}

-(void)leftMenuOpened{
    [self closeKeyboard];
}

-(void)rightMenuOpened{
    [self closeKeyboard];
}

-(void)closeKeyboard{
    [searchZpotBar resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerOpenLeftMenuNotification];
    [self registerOpenRightMenuNotification];
    if ([Utils instance].mapView.superview == nil || ![[Utils instance].mapView.superview isEqual:self.view]) {
        [[Utils instance] clearMapViewBeforeUsing];
        [Utils instance].mapView.delegate = self;
        [self.view addSubview:[Utils instance].mapView];
        [self.view sendSubviewToBack:[Utils instance].mapView];
    }
    [Utils instance].locationManager.delegate = self;

    [self updateMapView];
    
    [self addAnnotationScannedUsers];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOpenLeftMenuNotification];
    [self removeOpenRightMenuNotification];
    [Utils instance].locationManager.delegate = nil;
}

-(void)scanArea:(UIButton*)sender{
    if ([[Utils instance] isGPS]) {
        MKMapView* mapView = [[Utils instance] mapView];
        CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapView.visibleMapRect.origin);
        CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(mapView.visibleMapRect.origin.x + mapView.visibleMapRect.size.width, mapView.visibleMapRect.origin.y + mapView.visibleMapRect.size.height));
        [[Utils instance]showProgressWithMessage:nil];
        [[APIService shareAPIService] scanAreaForUserID:[AccountModel currentAccountModel].user_id topLeftCoord:topLeft botRightCoord:botRight completion:^(NSArray *data, NSString *error) {
            [[Utils instance]hideProgess];
            if (error) {
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            }else{
                [scannedUsersData removeAllObjects];
                [scannedUsersData addObjectsFromArray:data];
                [self addAnnotationScannedUsers];
                [usersCollectionView reloadData];
            }
            
        }];
    }else{
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
}

-(void)searchFriendWithName:(NSString*)name{
    [[Utils instance]showProgressWithMessage:nil];
    [[APIService shareAPIService]searchFriendWithName:name completion:^(NSMutableArray *returnArray, NSString *error) {
        [[Utils instance]hideProgess];
        if (error) {
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        }else{
            [searchUsersData removeAllObjects];
            [searchUsersData addObjectsFromArray:returnArray];
            [friendsSearchTableView reloadData];
        }
    }];
}

-(void)filterFriendWithName:(NSString*)name{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(first_name contains[c] %@ OR last_name contains[c] %@) AND mid != %@",name,name,[AccountModel currentAccountModel].user_id];
    NSArray* userArray = [UserDataModel fetchObjectsWithPredicate:predicate sorts:nil];
    [searchUsersData removeAllObjects];
    [searchUsersData addObjectsFromArray:userArray];
    [friendsSearchTableView reloadData];
}

#define ARC4RANDOM_MAX      0x100000000
-(void)addAnnotationScannedUsers{
    [[Utils instance].mapView removeAnnotations:[Utils instance].mapView.annotations];
    //add
    NSMutableArray* annotationArray = [NSMutableArray array];
    for (int i = 0; i < scannedUsersData.count; i++) {
        FeedDataModel* data = [scannedUsersData objectAtIndex:i];
        //val is a double between 0 and 1
//            double xOffset = ((double)arc4random() / ARC4RANDOM_MAX);
//            double yOffset = ((double)arc4random() / ARC4RANDOM_MAX);
//            
//            CLLocationCoordinate2D randomCoordinate = [Utils instance].mapView.userLocation.coordinate;
//            randomCoordinate.latitude += (xOffset/200.0);
//            randomCoordinate.longitude += (yOffset/200.0);
        CLLocationCoordinate2D randomCoordinate = CLLocationCoordinate2DMake([data.latitude doubleValue], [data.longitude doubleValue]);
        if ([data isEqual:selectedScannedUser]) {
            ZpotAnnotation* annotation = [[ZpotAnnotation alloc]init];
            annotation.coordinate = randomCoordinate;
            annotation.ownerID = data.user_id;
            annotation.mid = data.mid;
            [annotationArray addObject:annotation];
        }else{
            ScannedUserAnnotation* annotation = [[ScannedUserAnnotation alloc]init];
            annotation.coordinate = randomCoordinate;
            annotation.ownerID = data.user_id;
            annotation.mid = data.mid;
            [annotationArray addObject:annotation];
        }
        
    }
    [[Utils instance].mapView addAnnotations:annotationArray];
}
#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (shoudMoveToUserLocation) {
        shoudMoveToUserLocation = NO;
        CLLocationCoordinate2D startCoord = userLocation.coordinate;
        MKCoordinateRegion adjustedRegion = [[[Utils instance] mapView] regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 600, 600)];
        [[[Utils instance] mapView] setRegion:adjustedRegion animated:NO];
    }
    //[self performSelector:@selector(addAnnotationScannedUsers) withObject:nil afterDelay:3.0];
}
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [self changeUserLocationColor];
}

-(void)changeUserLocationColor{
    MKAnnotationView* annotationView = [[Utils instance].mapView viewForAnnotation:[Utils instance].mapView .userLocation];
    if (annotationView) {
        annotationView.tintColor = COLOR_DARK_GREEN;
    }else{
        [self performSelector:@selector(changeUserLocationColor) withObject:nil afterDelay:0.3];
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[ZpotAnnotation class]]) {
        ZpotAnnotationView* annoView = (ZpotAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([ZpotAnnotationView class])];
        if (!annoView) {
            annoView = [[ZpotAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([ZpotAnnotationView class])];
        }else{
            [annoView setupUIWithAnnotation:annotation];
        }
        return annoView;
    }else{
        ScannedUserAnnoView* annoView = (ScannedUserAnnoView*)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([ScannedUserAnnoView class])];
        if (!annoView) {
            annoView = [[ScannedUserAnnoView alloc]initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([ScannedUserAnnoView class])];
        }else{
            [annoView setupUIWithAnnotation:annotation];
        }
        return annoView;
    }
    
}
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self closeKeyboard];
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (btnThere.isSelected) {
        [mapView removeOverlays:mapView.overlays];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:[Utils instance].mapView.centerCoordinate radius:500];
        [mapView addOverlay:circle];
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [mapView deselectAnnotation:view.annotation animated:NO];
    if ([view isKindOfClass:[ZpotAnnotationView class]]) {
        ZpotAnnotation* anno = view.annotation;
        [[Utils instance]showUserProfile:[UserDataModel fetchObjectWithID:anno.ownerID] fromViewController:self];
    }
}
- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    circleView.fillColor = [COLOR_DARK_GREEN colorWithAlphaComponent:0.6];
    return circleView;
}
#pragma mark - UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = scannedUsersData.count;
    if (count == 0) {
        [Utils instance].mapView.frame = CGRectMake(0, searchZpotBar.height, [UIScreen mainScreen].bounds.size.width, usersCollectionView.y - searchZpotBar.height + usersCollectionView.height);
        collectionView.hidden = YES;
    }else{
        [Utils instance].mapView.frame = CGRectMake(0, searchZpotBar.height, [UIScreen mainScreen].bounds.size.width, usersCollectionView.y - searchZpotBar.height);
        collectionView.hidden = NO;
    }
    return count;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(usersCollectionView.height, usersCollectionView.height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedDataModel* data = [scannedUsersData objectAtIndex:indexPath.row];
    ScannedUserCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ScannedUserCell class]) forIndexPath:indexPath];
    [cell setSize:CGSizeMake(60, 60)];
    if ([data isEqual:selectedScannedUser]) {
        [cell setupCellWithData:data andOptions:@{@"isSelected":[NSNumber numberWithBool:YES]}];
    }else{
        [cell setupCellWithData:data andOptions:@{@"isSelected":[NSNumber numberWithBool:NO]}];
    }
    cell.onDeleteCell = ^(BaseDataModel* data){
        if ([scannedUsersData containsObject:data]) {
            id deletedAnno;
            NSInteger index = [scannedUsersData indexOfObject:data];
            for (id annotation in [Utils instance].mapView.annotations) {
                if ([annotation isKindOfClass:[MyAnnotation class]]) {
                    MyAnnotation* anno = (MyAnnotation*)annotation;
                    if ([anno.mid isEqualToString:data.mid]) {
                        deletedAnno = anno;
                        break;
                    }
                }
            }
            if (deletedAnno) {
                [[Utils instance].mapView removeAnnotation:deletedAnno];
            }
            [scannedUsersData removeObjectAtIndex:index];
            [usersCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        }
    };
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedScannedUser) {
        NSIndexPath * oldIndex = [NSIndexPath indexPathForItem:[scannedUsersData indexOfObject:selectedScannedUser] inSection:0];
        ScannedUserCell* oldCell = (ScannedUserCell*)[collectionView cellForItemAtIndexPath:oldIndex];
        [oldCell setSelectedUser:NO withAnimated:YES];
    }
    selectedScannedUser = [scannedUsersData objectAtIndex:indexPath.row];
    ScannedUserCell* newCell = (ScannedUserCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [newCell setSelectedUser:YES withAnimated:YES];
    
    //reload MapView
    [self addAnnotationScannedUsers];
}
#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchZpotBar resignFirstResponder];
    if (searchBar.text.length > 0) {
        [self searchFriendWithName:searchBar.text];
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length == 0) {
        [friendsSearchTableView removeFromSuperview];
    }else{
        if (!friendsSearchTableView.superview) {
            [self.view addSubview:friendsSearchTableView];
        }
        [self filterFriendWithName:searchBar.text];
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchUsersData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FriendRequestZpotCell cellHeightWithData:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDataModel* user = [searchUsersData objectAtIndex:indexPath.row];
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendRequestZpotCell class]) forIndexPath:indexPath];
    [cell setupCellWithData:user andOptions:nil];
    return cell;
}
#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations.count > 0) {
        CLLocation* loc = [locations lastObject];
        [[Utils instance].mapView setCenterCoordinate:loc.coordinate];
    }
    [manager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [[Utils instance]showAlertWithTitle:@"error_title".localized message:error.description yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    }];
    [manager stopUpdatingLocation];
}
@end
