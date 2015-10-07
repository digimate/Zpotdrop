//
//  UIView+Circle.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UIView+Circle.h"

@implementation UIView (Circle)

-(void)circleWithBorderWidth:(float)width andColor:(UIColor*)color
{
    [self.layer setCornerRadius:self.frame.size.width/2];
    if (width > 0)
    {
        [self.layer setBorderWidth:width];
        [self.layer setBorderColor:color.CGColor];
    }
    [self.layer setMasksToBounds:YES];
}

@end
