//
//  ZpotAnnotationView.m
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ZpotAnnotationView.h"

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
        UIImageView* avatarView = [[UIImageView alloc]initWithFrame:CGRectMake([blipImage size].width/4 - 1, [blipImage size].width/4 - 1, [blipImage size].width/2 + 2, [blipImage size].width/2 + 2)];
        avatarView.layer.cornerRadius = avatarView.frame.size.width/2;
        avatarView.layer.masksToBounds = YES;
        avatarView.image = [UIImage imageNamed:@"avatar"];
        [self addSubview:avatarView];
        [self sendSubviewToBack:avatarView];
    }
    return self;
}

@end
