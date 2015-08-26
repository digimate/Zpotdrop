//
//  NotificationModel.h
//  ZpotDrop
//
//  Created by Son Truong on 8/26/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface NotificationModel : BaseDataModel

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * receiver_id;
@property (nonatomic, retain) NSString * sender_id;
@property (nonatomic, retain) NSString * feed_id;
@property (nonatomic, retain) NSDate * time;

@end
