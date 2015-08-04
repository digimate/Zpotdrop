//
//  NSString+Ext.m
//  ZpotDrop
//
//  Created by Son Truong on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "NSString+Ext.h"

@implementation NSString(Ext)
-(NSString *)localized{
    return NSLocalizedString(self, nil);
}
@end
