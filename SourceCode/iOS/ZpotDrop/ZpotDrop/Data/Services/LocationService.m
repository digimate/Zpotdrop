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
    __block NSMutableArray *parseLocations = [[NSMutableArray alloc] init];
    __block NSMutableArray *googleLocations = [[NSMutableArray alloc] init];
    __block NSError *parseError = nil;
    __block NSError *googleError = nil;
    dispatch_group_t serviceGroup = dispatch_group_create();
    
    // Get locations from Parse
    dispatch_group_enter(serviceGroup);
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
            [parseLocations addObject:model];
        }
        parseError = [error copy];
        dispatch_group_leave(serviceGroup);
    }];
    
    // Get from Google Map API
    dispatch_group_enter(serviceGroup);
    GMSPlacesClient *_placesClient = [GMSPlacesClient sharedClient];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            googleError = [error copy];
            dispatch_group_leave(serviceGroup);
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
//            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
//            NSLog(@"Current Place address %@", place.formattedAddress);
//            NSLog(@"Current Place attributions %@", place.attributions);
//            NSLog(@"Current PlaceID %@", place.placeID);
            
            LocationDataModel* model = (LocationDataModel*)[LocationDataModel fetchObjectWithID:[NSString stringWithFormat:@"%f,%f",place.coordinate.latitude,place.coordinate.longitude]];
            model.name = place.name;
            model.address = place.formattedAddress;
            model.latitude = [NSNumber numberWithDouble:place.coordinate.latitude];
            model.longitude = [NSNumber numberWithDouble:place.coordinate.longitude];
            [googleLocations addObject:model];
        }
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        // Should combine 2 results and return responses
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NONE %@.mid == mid", parseLocations];
        NSArray *results = [googleLocations filteredArrayUsingPredicate:predicate];
        [parseLocations addObjectsFromArray:results];
//        NSLog(@"parseLocations: %@", parseLocations);
//        NSLog(@"googleLocations: %@", googleLocations);
        
        completion(parseLocations, parseError.description);
    });
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
