//
//  Utils.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "Utils.h"
#import "UserProfileViewController.h"
#import "UserDataModel.h"

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
#pragma mark - ProgressView
-(void)showProgressWithMessage:(NSString*)msg{
    [SVProgressHUD showWithStatus:msg maskType:SVProgressHUDMaskTypeGradient];
}

-(void)hideProgess{
    [SVProgressHUD dismiss];
}

#pragma mark - MapView

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

#pragma mark - Translate Views

-(void)showUserProfile:(id)userDataModel fromViewController:(UIViewController *)viewController{
    if (viewController.navigationController) {
        UserProfileViewController* userProfileVC = [[UserProfileViewController alloc]init];
        [viewController.navigationController pushViewController:userProfileVC animated:YES];
    }
}

#pragma mark - Converter
-(NSString*)convertDateToRecent:(NSDate*)date{
    double deltaSeconds = [[NSDate date] timeIntervalSinceDate:date];
    if (deltaSeconds < 1) {
        return @"just_now".localized;
    }else if (deltaSeconds < 60) {
        return [NSString stringWithFormat:@"format_second_ago".localized,deltaSeconds];
    }else if (deltaSeconds < 60*60) {
        return [NSString stringWithFormat:@"format_min_ago".localized,(deltaSeconds/60)];
    }else if (deltaSeconds < 60*60*24) {
        return [NSString stringWithFormat:@"format_hour_ago".localized,(deltaSeconds/(60*60))];
    }else if (deltaSeconds < 60*60*24*2) {
        return @"yesterday".localized;
    }else{
        return [date stringWithFormat:kNSDateHelperFormatDateDisplay];
    }
}

-(NSString*)distanceBetweenCoor:(CLLocationCoordinate2D)c1 andCoor:(CLLocationCoordinate2D)c2{
    CLLocation* l1  = [[CLLocation alloc]initWithLatitude:c1.latitude longitude:c1.longitude];
    CLLocation* l2  = [[CLLocation alloc]initWithLatitude:c2.latitude longitude:c2.longitude];
    double distanceInMet = [l1 distanceFromLocation:l2];
    if (distanceInMet == 0) {
        distanceInMet = 1;
    }
    if (distanceInMet < 1000) {
        return [NSString stringWithFormat:@"%0.0lf m",distanceInMet];
    }else{
        return [NSString stringWithFormat:@"%0.1lf km",distanceInMet/1000.0];
    }
}

-(NSString*)distanceWithMoveTimeBetweenCoor:(CLLocationCoordinate2D)c1 andCoor:(CLLocationCoordinate2D)c2{
    CLLocation* l1  = [[CLLocation alloc]initWithLatitude:c1.latitude longitude:c1.longitude];
    CLLocation* l2  = [[CLLocation alloc]initWithLatitude:c2.latitude longitude:c2.longitude];
    double distanceInMet = [l1 distanceFromLocation:l2];
    if (distanceInMet == 0) {
        distanceInMet = 1;
    }
    int walkTimeInMin = (distanceInMet * 60)/5000;
    if (walkTimeInMin == 0) {
        walkTimeInMin = 1;
    }
    int carTimeInMin = (distanceInMet * 60)/40000;
    if (carTimeInMin == 0) {
        carTimeInMin = 1;
    }
    if (distanceInMet < 1000) {
        NSString* distance = [NSString stringWithFormat:@"%0.0lf m",distanceInMet];
        
        return [NSString stringWithFormat:@"zpot_distance_format".localized,distance,[NSString stringWithFormat:@"%d %@",walkTimeInMin,@"min".localized],[NSString stringWithFormat:@"%d %@",carTimeInMin,@"min".localized]];
    }else{
        NSString* distance = [NSString stringWithFormat:@"%0.1lf km",distanceInMet/1000.0];
        NSString* walkTimeStr;
        if (walkTimeInMin <= 60) {
            walkTimeStr = [NSString stringWithFormat:@"%d %@",walkTimeInMin,@"min".localized];
        }else{
            walkTimeStr = [NSString stringWithFormat:@"%d %@",(walkTimeInMin/60),@"hour".localized];
        }
        
        NSString* carTimeStr;
        if (carTimeInMin <= 60) {
            carTimeStr = [NSString stringWithFormat:@"%d %@",carTimeInMin,@"min".localized];
        }else{
            carTimeStr = [NSString stringWithFormat:@"%d %@",(carTimeInMin/60),@"hour".localized];
        }
        return [NSString stringWithFormat:@"zpot_distance_format".localized,distance,walkTimeStr,carTimeStr];
    }
}

-(void)convertLikeIDsToInfo:(NSArray*)likes completion:(void(^)(NSString* txt))completion{
    __block NSMutableArray* muLikes = [NSMutableArray arrayWithArray:likes];
    __block NSString* returnString = @"";
    
    void(^voidBlock)() = ^{
        if (muLikes.count > 0) {
            NSString* user_id = [muLikes firstObject];
            [muLikes removeObjectAtIndex:0];
            UserDataModel* user = (UserDataModel*) [UserDataModel fetchObjectWithID:user_id];
            [user updateObjectForUse:^{
                if (muLikes.count > 0) {
                    returnString = [NSString stringWithFormat:@"%@, %@ %@",returnString,user.name,@"and".localized.lowercaseString];
                    if (muLikes.count == 1) {
                        //3 users
                        NSString* user_id = [muLikes firstObject];
                        UserDataModel* user = (UserDataModel*) [UserDataModel fetchObjectWithID:user_id];
                        [user updateObjectForUse:^{
                            returnString = [NSString stringWithFormat:@"%@ %@ %@",returnString,user.name,@"like_this".localized];
                            completion(returnString);
                        }];
                    }else{
                        //> 3 users
                        returnString = [NSString stringWithFormat:@"%@ %d %@ %@",returnString,(int)muLikes.count,@"other".localized.lowercaseString,@"like_this".localized];
                        completion(returnString);
                    }
                }else{
                    //2 users
                    returnString = [NSString stringWithFormat:@"%@ %@ %@ %@",returnString,@"and".localized.lowercaseString,user.name,@"like_this".localized];
                    completion(returnString);
                    
                }
            }];
        }else{
            //1 user
            completion([NSString stringWithFormat:@"%@ %@",returnString,@"like_this".localized]);
        }
    };
    
    if ([muLikes containsObject:[AccountModel currentAccountModel].user_id]) {
        returnString = @"you".localized;
        [muLikes removeObject:[AccountModel currentAccountModel].user_id];
        voidBlock();
    }else if (muLikes.count>0){
        NSString* user_id = [muLikes firstObject];
        [muLikes removeObjectAtIndex:0];
        UserDataModel* user = (UserDataModel*) [UserDataModel fetchObjectWithID:user_id];
        [user updateObjectForUse:^{
            returnString = user.name;
            voidBlock();
        }];
    }else{
        completion(@"be_first_one_like_this".localized);
    }
}

#pragma mark - UIImagePicker
-(void)showImagePickerWithCompletion:(void(^)(UIImage* image))completion fromViewController:(UIViewController*)controller isCrop:(BOOL)isDrop isCamera:(BOOL)isCamera{
    imageCompletion = completion;
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = isDrop;
    if (isCamera) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    imagePicker.delegate = self;
    [controller presentViewController:imagePicker animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        imageCompletion(nil);
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image ;
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        imageCompletion(image);
    }];
}
@end
