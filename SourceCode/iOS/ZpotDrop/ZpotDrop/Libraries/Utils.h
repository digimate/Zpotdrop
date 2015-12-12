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
#import "FacebookService.h"
#import "ZDConstant.h"

#define degreesToRadians(x) ((x) * M_PI / 180.0)
#define MAIN_COLOR @"b1cb89"

#define IS_DEBUG 0
#define DATE_FORMAT_MONTH_IN_LETTER @"MMM dd yyyy"

#define KEY_LOGIN_SUCCEED @"KEY_LOGIN_SUCCEED"
#define KEY_OPEN_LEFT_MENU @"KEY_OPEN_LEFT_MENU"
#define KEY_OPEN_RIGHT_MENU @"KEY_OPEN_RIGHT_MENU"

#define COLOR_DARK_GREEN [UIColor colorWithRed:(172/255.0) green:(199/255.0) blue:(132/255.0) alpha:1.0]
#define COLOR_SEPEARATE_LINE [UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1.0]

#define NOTIFICATION_COMMING  @"1"
#define NOTIFICATION_FOLLOW  @"2"
#define NOTIFICATION_COMMENT  @"3"
#define NOTIFICATION_LIKE  @"4"
#define NOTIFICATION_FB_Friend  @"5"

@interface Utils : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    void (^imageCompletion)(UIImage* image);
}
+ (Utils *) instance;
-(void)showProgressWithMessage:(NSString*)msg;
-(void)hideProgess;
-(MKMapView*)mapView;
-(CLLocationManager*)locationManager;
- (void)addMapViewToView:(UIView *)view;
-(BOOL)isGPS;
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg yesTitle:(NSString*)okStr noTitle:(NSString*)noStr handler:(UIAlertViewHandler)handler;
-(void)clearMapViewBeforeUsing;
-(void)showUserProfile:(id)userDataModel fromViewController:(UIViewController*)viewController;
-(void)showImagePickerWithCompletion:(void(^)(UIImage* image))completion fromViewController:(UIViewController*)controller isCrop:(BOOL)isDrop isCamera:(BOOL)isCamera;
-(NSString*)convertDateToRecent:(NSDate*)date;
-(NSString*)convertDateToAgo:(NSDate*)date;
-(NSString*)distanceBetweenCoor:(CLLocationCoordinate2D)c1 andCoor:(CLLocationCoordinate2D)c2;
-(NSString*)distanceWithMoveTimeBetweenCoor:(CLLocationCoordinate2D)c1 andCoor:(CLLocationCoordinate2D)c2;
-(void)convertLikeIDsToInfo:(NSArray*)likes completion:(void(^)(NSString* txt,NSArray * rangeArray))completion;
-(void)convertCommingIDsToInfo:(NSArray*)likes completion:(void(^)(NSString* txt,NSArray * rangeArray))completion;
-(NSString*)convertBirthdayToAge:(NSDate*)birthday;
- (void)showPostFromViewController:(UIViewController *)viewController;

// Font
+ (CGSize)getStringBoundingSize:(NSString*)string forWidth:(CGFloat)width withFont:(UIFont*)font;
@end


//
@interface UIView (KalAdditions)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@end


//
@interface MKMapView (Additions)
- (CLLocationCoordinate2D)topLeft;
- (CLLocationCoordinate2D)bottomRight;
@end



@interface NSString (Attributed)
- (NSAttributedString *)attributedStringWithFont:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;
@end
