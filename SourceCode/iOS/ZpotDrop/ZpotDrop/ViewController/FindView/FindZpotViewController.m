//
//  FindZpotViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FindZpotViewController.h"

@interface FindZpotViewController ()<MKMapViewDelegate>{
    UISearchBar* searchZpotBar;
    UICollectionView* usersCollectionView;
    NSMutableArray* usersSearchData;
    BOOL shoudMoveToUserLocation;
}

@end

@implementation FindZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    usersSearchData = [NSMutableArray array];
    shoudMoveToUserLocation = YES;
    
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
    
    /*======================Users Collection=======================*/
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    usersCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, btnScan.y - 60, frame.size.width, 60) collectionViewLayout:layout];
    //[usersCollectionView setDataSource:self];
    //[usersCollectionView setDelegate:self];
    //[usersCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self.view addSubview:usersCollectionView];

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

    if ([Utils instance].mapView.annotations.count == 0 && usersSearchData.count > 0) {
        //add
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeOpenLeftMenuNotification];
    [self removeOpenRightMenuNotification];
    [Utils instance].mapView.showsUserLocation = NO;
}

#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (shoudMoveToUserLocation) {
        shoudMoveToUserLocation = NO;
        CLLocationCoordinate2D startCoord = userLocation.coordinate;
        MKCoordinateRegion adjustedRegion = [[[Utils instance] mapView] regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 600, 600)];
        [[[Utils instance] mapView] setRegion:adjustedRegion animated:NO];
    }
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
@end
