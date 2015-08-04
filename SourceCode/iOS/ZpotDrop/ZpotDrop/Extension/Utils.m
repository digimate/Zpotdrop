//
//  Utils.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (Utils *) instance {
    static Utils *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Utils alloc] init];
    });
    return _sharedInstance;
}
@end
