//
//  LocationService.m
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/17/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "LocationService.h"
#import <Parse/Parse.h>
#import "LocationDataModel.h"
#import "Utils.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation LocationService
- (void)searchLocationWithinCoord:(CLLocationCoordinate2D)topLeft
                            coor2:(CLLocationCoordinate2D)botRight
                       completion:(void(^)(NSArray * data,NSString* error))completion
{
    PFQuery* query = [PFQuery queryWithClassName:@"Location" predicate:[NSPredicate predicateWithFormat:@"%@ <= latitude AND latitude <= %@ AND %@ <= longitude AND longitude <= %@", [NSNumber numberWithDouble:botRight.latitude],[NSNumber numberWithDouble:topLeft.latitude],[NSNumber numberWithDouble:topLeft.longitude],[NSNumber numberWithDouble:botRight.longitude]]];
    [query setLimit:API_PAGE_SIZE];
    [query findObjectsInBackgroundWithBlock:^(NSArray * data,NSError* error){
        NSMutableArray *arrLocation = [NSMutableArray array];
        for (PFObject* location in data) {
            LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:location.objectId];
            model.name = location[@"name"];
            model.address = location[@"address"];
            model.latitude = location[@"latitude"];
            model.longitude = location[@"longitude"];
            [arrLocation addObject:model];
        }
        completion(arrLocation, error.description);
    }];
}


- (void)searchLocationWithName:(NSString*)name
                   withinCoord:(CLLocationCoordinate2D)topLeft
                         coor2:(CLLocationCoordinate2D)botRight
                    completion:(void(^)(NSArray * data,NSString* error))completion
{
    PFQuery* query = [PFQuery queryWithClassName:@"Location" predicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH %@ AND %@ <= latitude AND latitude <= %@ AND %@ <= longitude AND longitude <= %@",name,[NSNumber numberWithDouble:botRight.latitude],[NSNumber numberWithDouble:topLeft.latitude],[NSNumber numberWithDouble:topLeft.longitude],[NSNumber numberWithDouble:botRight.longitude]]];
    [query setLimit:API_PAGE_SIZE];
    [query findObjectsInBackgroundWithBlock:^(NSArray * data, NSError* error){
        NSMutableArray *arrLocation = [NSMutableArray array];
        for (PFObject* location in data) {
            LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:location.objectId];
            model.name = location[@"name"];
            model.address = location[@"address"];
            model.latitude = location[@"latitude"];
            model.longitude = location[@"longitude"];
            [arrLocation addObject:model];
        }
        completion(arrLocation, error.description);
    }];
}


- (void)searchLocationAroundLocation:(CLLocation *)location
                          completion:(void(^)(NSArray * data,NSString* error))completion
{
    CLLocationCoordinate2D center       = location.coordinate;
    CLLocationCoordinate2D topLeft      = CLLocationCoordinate2DMake(center.latitude + 0.01, center.longitude - 0.01);
    CLLocationCoordinate2D bottomRight  = CLLocationCoordinate2DMake(center.latitude - 0.01, center.longitude + 0.01);
    [self searchLocationWithinCoord:topLeft coor2:bottomRight completion:completion];
}


- (void)searchLocationAroundLocation:(CLLocation *)location
                            withName:(NSString *)name
                          completion:(void(^)(NSArray * data,NSString* error))completion
{
    CLLocationCoordinate2D center       = location.coordinate;
    CLLocationCoordinate2D topLeft      = CLLocationCoordinate2DMake(center.latitude + 0.01, center.longitude - 0.01);
    CLLocationCoordinate2D bottomRight  = CLLocationCoordinate2DMake(center.latitude - 0.01, center.longitude + 0.01);
    [self searchLocationWithName:name withinCoord:topLeft coor2:bottomRight completion:completion];
    
}


- (void)searchLocationWithName:(NSString *)name
                    completion:(void(^)(NSArray * data,NSString* error))completion
{
    PFQuery* query = [PFQuery queryWithClassName:@"Location" predicate:[NSPredicate predicateWithFormat:@"name BEGINSWITH %@",name]];
    [query setLimit:API_PAGE_SIZE];
    [query findObjectsInBackgroundWithBlock:^(NSArray * data, NSError* error){
        NSMutableArray *arrLocation = [NSMutableArray array];
        for (PFObject* location in data) {
            LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:location.objectId];
            model.name = location[@"name"];
            model.address = location[@"address"];
            model.latitude = location[@"latitude"];
            model.longitude = location[@"longitude"];
            [arrLocation addObject:model];
        }
        completion(arrLocation, error.description);
    }];
}

- (void)getPlacesWithKeyword:(NSString *)keyword completion:(void(^)(NSArray * data, NSString *error))completion {

    MKMapView* mapView = [[Utils instance] mapView];
    CLLocationCoordinate2D topLeft = [mapView topLeft];
    CLLocationCoordinate2D botRight = [mapView bottomRight];
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:topLeft
                                                                       coordinate:botRight];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
    
    GMSPlacesClient *_placesClient = [GMSPlacesClient sharedClient];
    [_placesClient autocompleteQuery:keyword
                              bounds:bounds
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                completion(results, error.localizedDescription);
//                                if (error != nil) {
//                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
//                                    return;
//                                }
//                                
//                                for (GMSAutocompletePrediction* result in results) {
//                                    NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
//                                }
                            }];
}

@end
