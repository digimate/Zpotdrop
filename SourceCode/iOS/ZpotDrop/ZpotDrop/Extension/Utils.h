//
//  Utils.h
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
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

#define MAIN_COLOR @"b1cb89"

#define IS_DEBUG 1
#define DATE_FORMAT_MONTH_IN_LETTER @"MMM dd yyyy"

#define KEY_LOGIN_SUCCEED @"KEY_LOGIN_SUCCEED"

#define COLOR_DARK_GREEN [UIColor colorWithRed:(172/255.0) green:(199/255.0) blue:(132/255.0) alpha:1.0]
#define COLOR_SEPEARATE_LINE [UIColor colorWithRed:(250/255.0) green:(250/255.0) blue:(250/255.0) alpha:1.0]

typedef enum {
    NOTIFICATION_COMMING = 0,
    NOTIFICATION_FOLLOW,
    NOTIFICATION_COMMENT,
    NOTIFICATION_LIKE,
    NOTIFICATION_UNKNOWN
}NOTIFICATION_ACTION;

@interface Utils : NSObject
+ (Utils *) instance;
-(void)showProgressWithMessage:(NSString*)msg;
-(void)hideProgess;
-(MKMapView*)mapView;
@end
