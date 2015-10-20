//
//  LocationService.h
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/17/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ZDConstant.h"

@interface LocationService : NSObject
- (void)searchLocationWithinCoord:(CLLocationCoordinate2D)topLeft
                            coor2:(CLLocationCoordinate2D)botRight
                       completion:(void(^)(NSArray * data,NSString* error))completion;
- (void)searchLocationWithName:(NSString*)name
                   withinCoord:(CLLocationCoordinate2D)topLeft
                         coor2:(CLLocationCoordinate2D)botRight
                    completion:(void(^)(NSArray * data,NSString* error))completion;
- (void)searchLocationAroundLocation:(CLLocation *)location
                          completion:(void(^)(NSArray * data,NSString* error))completion;
- (void)searchLocationAroundLocation:(CLLocation *)location
                            withName:(NSString *)name
                          completion:(void(^)(NSArray * data,NSString* error))completion;
- (void)searchLocationWithName:(NSString *)name
                    completion:(void(^)(NSArray * data,NSString* error))completion;
@end
