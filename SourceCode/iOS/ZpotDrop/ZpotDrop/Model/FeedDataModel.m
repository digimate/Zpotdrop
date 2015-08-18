//
//  FeedDataModel.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedDataModel.h"


@implementation FeedDataModel

@dynamic like_userIds;
@dynamic user_id;
@dynamic latitude;
@dynamic longitude;
@dynamic time;
@dynamic location_id;
@dynamic like_count;
@dynamic comment_count;
@dynamic title;
@dynamic comming_userIds;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.like_userIds = @"";
    self.user_id = @"";
    self.latitude = @(0);
    self.longitude = @(0);
    self.time = [NSDate date];
    self.location_id = @"";
    self.like_count = @(0);
    self.comment_count = @(0);
    self.title = @"";
    self.comming_userIds = @"";
}

-(void)awakeFromFetch{
    if (self.comment_count == nil || [self.comment_count isKindOfClass:[NSNull class]]) {
        self.comment_count = @(0);
    }
    if (self.comming_userIds == nil) {
        self.comming_userIds = @"";
    }
}
@end
