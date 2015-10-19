//
//  AddLocationViewController.m
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/18/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "AddLocationViewController.h"
#import "APIService.h"
#import "Utils.h"

@interface AddLocationViewController () <UITextFieldDelegate>
@end

@implementation AddLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButton];
    [self updateUI];
    [self fetchAddressForCurrentLocation];
    
    [self.btnAddLocationInputAccessory removeFromSuperview];
    self.tfLocationName.inputAccessoryView = self.btnAddLocationInputAccessory;
    self.tfLocationAddress.inputAccessoryView = self.btnAddLocationInputAccessory;
}

#pragma mark - Accessors
- (void)setLocationName:(NSString *)locationName {
    _locationName = locationName;
    self.tfLocationName.text = locationName;
}

#pragma mark - IBAction

- (IBAction)didTouchAddLocation:(id)sender {
    if (!CLLocationCoordinate2DIsValid([Utils instance].locationManager.location.coordinate)) {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
    else if (self.tfLocationName.text.length == 0) {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_empty_location_name".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }else if (self.tfLocationAddress.text.length == 0 ){
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_empty_location_address".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }else{
        //create location
        [[Utils instance]showProgressWithMessage:nil];
        [[APIService shareAPIService]createLocationWithCoordinate:[Utils instance].mapView.userLocation.coordinate params:[NSMutableDictionary dictionaryWithDictionary:@{@"name":self.tfLocationName.text,@"address":self.tfLocationAddress.text}] completion:^(id data, NSString *error) {
            [[Utils instance]hideProgess];
            if (data == nil) {
                [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                }];
            } else {
                [self goBack:nil];
            }
        }];
    }
}


#pragma mark - Private

- (void)updateUI {
    self.tfLocationName.text = self.locationName;
}

- (void)fetchAddressForCurrentLocation {
    CLLocationCoordinate2D coor = [Utils instance].locationManager.location.coordinate;
    [[APIService shareAPIService]addressFromLocationCoordinate:coor completion:^(NSString *address) {
        self.tfLocationAddress.text = address;
    }];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.btnAddLocation.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.btnAddLocation.hidden = NO;
}

@end
