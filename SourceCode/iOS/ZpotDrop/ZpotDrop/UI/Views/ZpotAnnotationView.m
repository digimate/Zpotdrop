//
//  ZpotAnnotationView.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ZpotAnnotationView.h"
#import "Utils.h"
#import "UserDataModel.h"

@implementation ZpotAnnotationView

- (id)initWithAnnotation:(ZpotAnnotation*)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *blipImage = [UIImage imageNamed:@"ic_annotation"];
        CGRect frame = [self frame];
        frame.size = [blipImage size];
        [self setFrame:frame];
        [self setCenterOffset:CGPointMake(0.0, -[blipImage size].height/2)];
        [self setImage:blipImage];
        
        //avatar
        UIImageView* avatarView = (UIImageView*)[self viewWithTag:121];
        if (!avatarView) {
            avatarView = [[UIImageView alloc]initWithFrame:CGRectMake([blipImage size].width/4 - 1, [blipImage size].width/4 - 1, [blipImage size].width/2 + 2, [blipImage size].width/2 + 2)];
            avatarView.tag = 121;
            avatarView.layer.cornerRadius = avatarView.frame.size.width/2;
            avatarView.layer.masksToBounds = YES;
            [self addSubview:avatarView];
            [self sendSubviewToBack:avatarView];
        }
        
        avatarView.image = [UIImage imageNamed:@"avatar"];
        UserDataModel* poster = (UserDataModel*)[UserDataModel fetchObjectWithID:annotation.ownerID];
        [poster updateObjectForUse:^{
            if (poster.avatar.length > 0) {
                avatarView.image = [poster.avatar stringToUIImage];
            }
        }];
    }
    return self;
}
-(void)setupUIWithAnnotation:(ZpotAnnotation *)annotation{
    UIImageView* avatar = (UIImageView*)[self viewWithTag:121];
    UserDataModel* poster = (UserDataModel*)[UserDataModel fetchObjectWithID:annotation.ownerID];
    [poster updateObjectForUse:^{
        if (poster.avatar.length > 0) {
            avatar.image = [poster.avatar stringToUIImage];
        }
    }];
}
@end
