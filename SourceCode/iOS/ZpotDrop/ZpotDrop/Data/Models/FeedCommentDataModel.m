//
//  FeedCommentDataModel.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedCommentDataModel.h"


@implementation FeedCommentDataModel

@dynamic type;
@dynamic message;
@dynamic time;
@dynamic user_id;
@dynamic status;
@dynamic feed_id;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.type = @"";
    self.message = @"";
    self.time = [NSDate date];
    self.user_id = @"";
    self.status = @"";
    self.feed_id = @"";
}
@end
