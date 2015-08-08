//
//  ScannedUserAnnoView.m
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ScannedUserAnnoView.h"

@implementation ScannedUserAnnoView

- (id)initWithAnnotation:(ScannedUserAnnotation*)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = [self frame];
        frame.size = CGSizeMake(30, 30);
        [self setFrame:frame];
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        //avatar
        UIImageView* avatar = (UIImageView*)[self viewWithTag:121];
        if (!avatar) {
            avatar = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height-4)];
            avatar.layer.cornerRadius = avatar.frame.size.width/2;
            avatar.layer.masksToBounds = YES;
            avatar.tag = 121;
            [self addSubview:avatar];
        }
        avatar.image = [UIImage imageNamed:@"avatar"];
    }
    return self;
}
-(void)setupUIWithAnnotation:(ScannedUserAnnotation *)annotation{
    UIImageView* avatar = (UIImageView*)[self viewWithTag:121];
    avatar.image = [UIImage imageNamed:@"avatar"];
}
@end
