//
//  LocationDataModel.m
//  ZpotDrop
//
//  Created by Son Truong on 8/11/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "LocationDataModel.h"

@implementation LocationDataModel

@dynamic name;
@dynamic address;
@dynamic latitude;
@dynamic longitude;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.name = @"";
    self.address = @"";
}
@end
