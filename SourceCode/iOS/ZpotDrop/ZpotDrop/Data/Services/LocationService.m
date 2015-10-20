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
@end
