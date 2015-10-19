//
//  FeedDataModel.h
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface FeedDataModel : BaseDataModel

@property (nonatomic, retain) NSString * like_userIds;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * location_id;
@property (nonatomic, retain) NSNumber * like_count;
@property (nonatomic, retain) NSNumber * comment_count;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * comming_userIds;
@property (nonatomic, retain) NSString * with_userIds;
@end
