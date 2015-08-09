//
//  NotificationModel.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseDataModel.h"
#import <Parse/Parse.h>
#import "Utils.h"

@interface NotificationModel : NSObject

@property (nonatomic, retain) NSNumber* notificationType;
@property (nonatomic, retain) NSString* notificationContent;
@property (nonatomic, retain) NSDate* time;
//@property (nonatomic, retain) PFRelation* user;

@end
