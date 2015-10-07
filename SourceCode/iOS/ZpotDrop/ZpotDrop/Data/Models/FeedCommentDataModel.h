//
//  FeedCommentDataModel.h
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

#define STATUS_SENDING @"Sending"
#define STATUS_SENT @"Sent" // sender sent successful but receiver not receive
#define STATUS_DELIVER @"Deliver" // sender sent successful and receiver received
#define STATUS_ERROR @"Error"

#define TYPE_NOTIFY @"notify"
#define TYPE_COMMENT @"comment"

@interface FeedCommentDataModel : BaseDataModel

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * feed_id;

@end
