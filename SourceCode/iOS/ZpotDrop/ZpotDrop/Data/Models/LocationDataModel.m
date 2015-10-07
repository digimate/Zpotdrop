//
//  LocationDataModel.m
//  ZpotDrop
//
//  Created by Son Truong on 8/11/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "LocationDataModel.h"
#import "APIService.h"

@implementation LocationDataModel

@dynamic name;
@dynamic address;
@dynamic latitude;
@dynamic longitude;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.name = @"";
    self.address = @"";
    self.latitude = @(0);
    self.longitude = @(0);
}

-(void)updateObjectForUse:(void(^)())completion{
    if (self.address == nil || self.address.length == 0) {
        [[APIService shareAPIService] updateLocationModelWithID:self.mid completion:^{
            completion();
        }];
    }else{
        completion();
    }
}
@end
