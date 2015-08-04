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
-(MKMapView *)mapView{
    static MKMapView *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[MKMapView alloc] init];
    });
    return _sharedInstance;
}
@end
