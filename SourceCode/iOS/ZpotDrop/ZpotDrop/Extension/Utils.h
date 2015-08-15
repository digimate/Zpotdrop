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
#import "TableViewDataHandler.h"
#import "AccountModel.h"
#import "ZpotAnnotation.h"
#import "ZpotAnnotationView.h"
#import "FeedCommentDataModel.h"
#import "FeedDataModel.h"
#import "UINavigationController+Block.h"

#define MAIN_COLOR @"b1cb89"

#define IS_DEBUG 0
#define DATE_FORMAT_MONTH_IN_LETTER @"MMM dd yyyy"
#define API_PAGE 20

#define KEY_LOGIN_SUCCEED @"KEY_LOGIN_SUCCEED"
#define KEY_OPEN_LEFT_MENU @"KEY_OPEN_LEFT_MENU"
#define KEY_OPEN_RIGHT_MENU @"KEY_OPEN_RIGHT_MENU"

#define COLOR_DARK_GREEN [UIColor colorWithRed:(172/255.0) green:(199/255.0) blue:(132/255.0) alpha:1.0]
#define COLOR_SEPEARATE_LINE [UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1.0]

typedef enum {
    NOTIFICATION_COMMING = 0,
    NOTIFICATION_FOLLOW,
    NOTIFICATION_COMMENT,
    NOTIFICATION_LIKE,
    NOTIFICATION_UNKNOWN
}NOTIFICATION_ACTION;

@interface Utils : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    void (^imageCompletion)(UIImage* image);
}
+ (Utils *) instance;
-(void)showProgressWithMessage:(NSString*)msg;
-(void)hideProgess;
-(MKMapView*)mapView;
-(CLLocationManager*)locationManager;
-(BOOL)isGPS;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg yesTitle:(NSString*)okStr noTitle:(NSString*)noStr handler:(UIAlertViewHandler)handler;
-(void)clearMapViewBeforeUsing;
-(void)showUserProfile:(id)userDataModel fromViewController:(UIViewController*)viewController;
-(void)showImagePickerWithCompletion:(void(^)(UIImage* image))completion fromViewController:(UIViewController*)controller isCrop:(BOOL)isDrop isCamera:(BOOL)isCamera;
-(NSString*)convertDateToRecent:(NSDate*)date;
-(NSString*)distanceBetweenCoor:(CLLocationCoordinate2D)c1 andCoor:(CLLocationCoordinate2D)c2;
-(NSString*)distanceWithMoveTimeBetweenCoor:(CLLocationCoordinate2D)c1 andCoor:(CLLocationCoordinate2D)c2;
-(void)convertLikeIDsToInfo:(NSArray*)likes completion:(void(^)(NSString* txt))completion;
@end
