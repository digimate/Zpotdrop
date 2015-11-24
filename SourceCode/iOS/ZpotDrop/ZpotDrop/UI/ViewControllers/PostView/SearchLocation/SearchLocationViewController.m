//
//  SearchLocationViewController.m
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/18/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "LocationService.h"
#import "Utils.h"
#import "AddLocationViewController.h"
@import GoogleMaps;


@interface LocationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbLocationName;
@property (strong, nonatomic) IBOutlet UILabel *lbLocationAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imvSeparator;
@property (strong, nonatomic) LocationDataModel *location;
@end
@implementation LocationCell
- (void)setLocation:(LocationDataModel *)location {
    _location = location;
    self.lbLocationName.text     = location.name;
    self.lbLocationAddress.text  = location.address;
}

- (void)setSuggestedPlaces:(GMSAutocompletePrediction *)place {
    NSString *placeString = [place.attributedFullText string];
    NSRange firstRange = [placeString rangeOfString:@","];
    self.lbLocationName.text = [placeString substringWithRange:NSMakeRange(0, firstRange.location)];
    self.lbLocationAddress.text = [placeString substringFromIndex:self.lbLocationName.text.length+firstRange.length];
}

@end



//

@interface SearchLocationViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *tfSearchName;
@property (strong, nonatomic) IBOutlet UIButton *btnAddLocation;
@property (strong, nonatomic) NSArray *arrLocation;
@property (assign, nonatomic) NSInteger selectedIndex;
@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackButton];
    
    self.selectedIndex = NSNotFound;
    self.tblLocation.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - Override

- (void)goBack:(id)sender {
    if (self.selectedIndex != NSNotFound) {
        [[Utils instance]showProgressWithMessage:nil];
        GMSAutocompletePrediction *selectedPlace = self.arrLocation[self.selectedIndex];
        GMSPlacesClient *placesClient = [GMSPlacesClient sharedClient];
        [placesClient lookUpPlaceID:selectedPlace.placeID callback:^(GMSPlace *result, NSError *error) {
            if (error) {
                NSLog(@"selectedIndex has error %@", error.localizedDescription);
                [[Utils instance]hideProgess];
            } else {
                
                //create location
                [[APIService shareAPIService]createLocationWithCoordinate:result.coordinate params:[NSMutableDictionary dictionaryWithDictionary:@{@"name":result.name, @"address":result.formattedAddress}] completion:^(id data, NSString *error) {
                    [[Utils instance]hideProgess];
                    if (data == nil) {
                        [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        }];
                    } else {
                        [self.delegate searchLocationViewController:self didSelectLocation:(LocationDataModel *)data];
                    }
                }];

                
//                LocationDataModel *selectedLocation = self.arrLocation[self.selectedIndex];
//                if (selectedLocation) {
//                    [self.delegate searchLocationViewController:self didSelectLocation:selectedLocation];
//                }
            }
            [super goBack:sender];
        }];
    }

}


#pragma mark - IBAction

- (IBAction)didTouchAddLocation:(id)sender {
    AddLocationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddLocationViewController"];
    vc.locationName = self.tfSearchName.text;
    vc.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -

- (void)updateTitleOfAddLocationWithText:(NSString *)text {
    NSString *title = [NSString stringWithFormat:@"+   Add %@", text];
    [self.btnAddLocation setTitle:title forState:UIControlStateNormal];
}


- (void)searchLocationWithText:(NSString *)text {
    if (text.length == 0) {
        [self clearLocationList];
        return;
    }
    
    LocationService *service = [LocationService new];
    
    [service getPlacesWithKeyword:text completion:^(NSArray *data, NSString *error){
        if (self.tfSearchName.text.length == 0) {
            [self clearLocationList];
            return;
        }
        self.arrLocation = data;
        self.selectedIndex = NSNotFound;
        [self.tblLocation reloadData];
    }];
    
//    [service searchLocationWithName:text completion:^(NSArray *data, NSString *error) {
//        if (self.tfSearchName.text.length == 0) {
//            [self clearLocationList];
//            return;
//        }
//        self.arrLocation = data;
//        self.selectedIndex = NSNotFound;
//        [self.tblLocation reloadData];
//    }];
}

- (void)clearLocationList {
    self.arrLocation = nil;
    self.selectedIndex = NSNotFound;
    [self.tblLocation reloadData];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLocation.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    cell.imvSeparator.hidden = YES;//indexPath.row == 0;
    if (indexPath.row == self.selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
//    cell.location = self.arrLocation[indexPath.row];
    [cell setSuggestedPlaces:self.arrLocation[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = indexPath.row;
//    [tableView reloadData];
    [self goBack:nil];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateTitleOfAddLocationWithText:text];
    [self searchLocationWithText:text];
    return YES;
}

- (IBAction)searchTextFieldDidChangeValue:(id)sender {
    
}

@end
