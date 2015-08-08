//
//  Utils.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (Utils *) instance {
    static Utils *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Utils alloc] init];
        [_sharedInstance setup];
    });
    return _sharedInstance;
}

-(void)setup{
    [SVProgressHUD setForegroundColor:COLOR_DARK_GREEN];
    [SVProgressHUD setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0.8]];
}

-(void)showProgressWithMessage:(NSString*)msg{
    [SVProgressHUD showWithStatus:msg maskType:SVProgressHUDMaskTypeGradient];
}

-(void)hideProgess{
    [SVProgressHUD dismiss];
}

-(void)clearMapViewBeforeUsing{
    [[self mapView] removeFromSuperview];
    [[self mapView] removeAnnotations:[[Utils instance] mapView].annotations];
    [self mapView].userInteractionEnabled = YES;
    [self mapView].showsUserLocation = NO;
    [self mapView].zoomEnabled = YES;
    [self mapView].scrollEnabled = YES;
    [self mapView].delegate = nil;
}
-(MKMapView *)mapView{
    static MKMapView *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[MKMapView alloc] init];
    });
    return _sharedInstance;
}

-(BOOL)isGPS{
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return NO;
    }
    [self locationManager];
    return YES;
}

-(CLLocationManager*)locationManager{
    static CLLocationManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[CLLocationManager alloc] init];
        if ([_sharedInstance respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_sharedInstance requestWhenInUseAuthorization];
        }
        _sharedInstance.desiredAccuracy = kCLLocationAccuracyBest;
        _sharedInstance.distanceFilter = 5;
    });
    return _sharedInstance;
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg yesTitle:(NSString*)okStr noTitle:(NSString*)noStr handler:(UIAlertViewHandler)handler{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:noStr otherButtonTitles:okStr,nil];
    [alertView showWithHandler:handler];
}
@end
