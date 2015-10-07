//
//  RuleService.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/31/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "RuleService.h"

@implementation RuleService

+(RuleService*)shareRuleService
{
    static RuleService *shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

-(BOOL)checkEmailStringIsCorrect:(NSString *)emailString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}
@end
