//
//  Utils.h
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "NSString+Ext.h"
#import "UIColor+HexColors.h"
#import "UIImageView+Ext.h"
#import "DateTextField.h"
#import "UIAlertView+Blocks.h"
#import "NSDate+Helper.h"
#import "UIView+Borders.h"
#import "UIView+Frame.h"
#import "SVProgressHUD.h"

#import "AccountModel.h"

#define IS_DEBUG 1
#define DATE_FORMAT_MONTH_IN_LETTER @"MMM dd yyyy"

#define KEY_LOGIN_SUCCEED @"KEY_LOGIN_SUCCEED"
#define KEY_OPEN_LEFT_MENU @"KEY_OPEN_LEFT_MENU"
#define KEY_OPEN_RIGHT_MENU @"KEY_OPEN_RIGHT_MENU"

#define COLOR_DARK_GREEN [UIColor colorWithRed:(172/255.0) green:(199/255.0) blue:(132/255.0) alpha:1.0]
#define COLOR_SEPEARATE_LINE [UIColor colorWithRed:(250/255.0) green:(250/255.0) blue:(250/255.0) alpha:1.0]

@interface Utils : NSObject
+ (Utils *) instance;
-(void)showProgressWithMessage:(NSString*)msg;
-(void)hideProgess;
-(MKMapView*)mapView;
-(BOOL)isGPS;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg yesTitle:(NSString*)okStr noTitle:(NSString*)noStr handler:(UIAlertViewHandler)handler;
@end
