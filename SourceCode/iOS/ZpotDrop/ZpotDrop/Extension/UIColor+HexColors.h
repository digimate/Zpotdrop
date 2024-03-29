//
//  UIColor+HexColors.h
//  KiwiHarness
//
//  Created by Tim Duckett on 07/09/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColors)

+(UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha;
+(UIColor *)colorWithHexString:(NSString *)hexString;
+(NSString *)hexValuesFromUIColor:(UIColor *)color;

+(UIColor *)colorWithRed:(int)red green:(int)green blue:(int)blue;
@end
