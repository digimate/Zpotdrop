//
//  RuleService.h
//  ZpotDrop
//
//  Created by Nguyenh on 7/31/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuleService : NSObject

+(RuleService*)shareRuleService;

-(BOOL)checkEmailStringIsCorrect:(NSString*)emailString;

@end
