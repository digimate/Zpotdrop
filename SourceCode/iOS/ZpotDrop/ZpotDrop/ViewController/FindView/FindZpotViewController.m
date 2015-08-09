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

@interface FindZpotViewController ()<MKMapViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UISearchBar* searchZpotBar;
    UICollectionView* usersCollectionView;
    BOOL shoudMoveToUserLocation;
    NSMutableArray* scannedUsersData;
    id selectedScannedUser;
    UITableView* friendsSearchTableView;
}

@end

@implementation FindZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scannedUsersData = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4"]];
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
    searchZpotBar.returnKeyType = UIReturnKeyDone;
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
    [self.view addSubview:btnScan];
    
    /*======================Users Collection=======================*/
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    usersCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, btnScan.y - 60, frame.size.width, 60) collectionViewLayout:layout];
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
        [Utils instance].mapView.frame = CGRectMake(0, searchZpotBar.height, [UIScreen mainScreen].bounds.size.width, usersCollectionView.y - searchZpotBar.height);
        [Utils instance].mapView.delegate = self;
        [self.view addSubview:[Utils instance].mapView];
    }
    [Utils instance].mapView.showsUserLocation = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOpenLeftMenuNotification];
    [self removeOpenRightMenuNotification];
    [Utils instance].mapView.showsUserLocation = NO;
}

#define ARC4RANDOM_MAX      0x100000000
-(void)addAnnotationScannedUsers{
    if ([Utils instance].mapView.annotations.count <= 1 && scannedUsersData.count > 0) {
        //add
        NSMutableArray* annotationArray = [NSMutableArray array];
        for (int i = 0; i < scannedUsersData.count; i++) {
            id data = [scannedUsersData objectAtIndex:i];
            //val is a double between 0 and 1
            double xOffset = ((double)arc4random() / ARC4RANDOM_MAX);
            double yOffset = ((double)arc4random() / ARC4RANDOM_MAX);
            
            CLLocationCoordinate2D randomCoordinate = [Utils instance].mapView.userLocation.coordinate;
            randomCoordinate.latitude += (xOffset/200.0);
            randomCoordinate.longitude += (yOffset/200.0);
            if ([data isEqual:selectedScannedUser]) {
                ZpotAnnotation* annotation = [[ZpotAnnotation alloc]init];
                annotation.coordinate = randomCoordinate;
                [annotationArray addObject:annotation];
            }else{
                ScannedUserAnnotation* annotation = [[ScannedUserAnnotation alloc]init];
                annotation.coordinate = randomCoordinate;
                [annotationArray addObject:annotation];
            }
            
        }
        [[Utils instance].mapView addAnnotations:annotationArray];
    }
}
#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (shoudMoveToUserLocation) {
        shoudMoveToUserLocation = NO;
        CLLocationCoordinate2D startCoord = userLocation.coordinate;
        MKCoordinateRegion adjustedRegion = [[[Utils instance] mapView] regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 600, 600)];
        [[[Utils instance] mapView] setRegion:adjustedRegion animated:NO];
    }
    [self performSelector:@selector(addAnnotationScannedUsers) withObject:nil afterDelay:3.0];
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
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [mapView deselectAnnotation:view.annotation animated:NO];
    if ([view isKindOfClass:[ZpotAnnotationView class]]) {
        [[Utils instance]showUserProfile:nil fromViewController:self];
    }
}
#pragma mark - UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return scannedUsersData.count;
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
    id data = [scannedUsersData objectAtIndex:indexPath.row];
    ScannedUserCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ScannedUserCell class]) forIndexPath:indexPath];
    [cell setSize:CGSizeMake(60, 60)];
    if ([data isEqual:selectedScannedUser]) {
        [cell setupCellWithData:nil andOptions:@{@"isSelected":[NSNumber numberWithBool:YES]}];
    }else{
        [cell setupCellWithData:nil andOptions:@{@"isSelected":[NSNumber numberWithBool:NO]}];
    }
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
    [[Utils instance].mapView removeAnnotations:[Utils instance].mapView.annotations];
    [self addAnnotationScannedUsers];
}
#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchZpotBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length == 0) {
        [friendsSearchTableView removeFromSuperview];
    }else{
        if (!friendsSearchTableView.superview) {
            [self.view addSubview:friendsSearchTableView];
        }
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FriendRequestZpotCell cellHeightWithData:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendRequestZpotCell class]) forIndexPath:indexPath];
    [cell setupCellWithData:nil andOptions:nil];
    return cell;
}
@end
