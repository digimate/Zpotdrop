//
//  UIImageView+Ext.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UIImageView+Ext.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (Ext)
-(void)setImageURL:(NSString *)urlString withHolderImage:(UIImage *)holder{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:holder];
}
@end
