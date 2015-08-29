//
//  NotificationModel.m
//  ZpotDrop
//
//  Created by Son Truong on 8/26/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "NotificationModel.h"
#import "AccountModel.h"

@implementation NotificationModel

@dynamic type;
@dynamic comment;
@dynamic receiver_id;
@dynamic sender_id;
@dynamic feed_id;
@dynamic time;

-(void)awakeFromInsert{
    [super awakeFromInsert];
    self.type = @"";
    self.comment = @"";
    self.receiver_id = @"";
    self.sender_id = @"";
    self.feed_id = @"";
    self.time = [NSDate date];
}

+(NotificationModel *)lastestNotification{
    NSArray* lastestNotify = [NotificationModel fetchObjectsWithPredicate:[NSPredicate predicateWithFormat:@"receiver_id == %@ AND sender_id != %@",[AccountModel currentAccountModel].user_id,[AccountModel currentAccountModel].user_id] sorts:@[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]]];
    if (lastestNotify.count > 0) {
        return [lastestNotify firstObject];
    }
    return nil;
}
@end
