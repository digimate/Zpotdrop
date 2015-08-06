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

@interface FeedCommentDataModel : BaseDataModel

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * user_id;

@end
