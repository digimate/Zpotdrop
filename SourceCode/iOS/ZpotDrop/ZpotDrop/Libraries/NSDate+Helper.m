//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009–2012, ZETETIC LLC
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the ZETETIC LLC nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

static NSCalendar *_calendar = nil;
static NSDateFormatter *_displayFormatter = nil;

+ (void)initializeStatics {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
#if __has_feature(objc_arc)
                _calendar = [NSCalendar currentCalendar];
#else
                _calendar = [[NSCalendar currentCalendar] retain];
#endif
            }
            if (_displayFormatter == nil) {
                _displayFormatter = [[NSDateFormatter alloc] init];
            }
        }
    });
}

+ (NSCalendar *)sharedCalendar {
    [self initializeStatics];
    return _calendar;
}

+ (NSDateFormatter *)sharedDateFormatter {
    [self initializeStatics];
    return _displayFormatter;
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[self class] sharedDateFormatter];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
	return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (long int)utcTimeStamp{
    return lround(floor([self timeIntervalSince1970]));
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [self sharedDateFormatter];
	[formatter setDateFormat:format];
	NSDate *date = [formatter dateFromString:string];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSDate *)add:(NSInteger)hour intoDate:(NSDate*)date
{
    NSTimeInterval secondsCalFromHours = hour * 60 * 60;
    return [date dateByAddingTimeInterval:secondsCalFromHours];
}

- (NSString*)activeString
{
    NSInteger time = ABS([self timeIntervalSinceDate:[NSDate date]]);
    if (time < 60)
    {
        return [NSString stringWithFormat:@"Active %ld secs ago",(long)time];
    }
    if (time < 3600)
    {
        return [NSString stringWithFormat:@"Active %ld mins ago",(long)(time/60)];
    }
    if (time < 86400)
    {
        return [NSString stringWithFormat:@"Active %ld hrs ago",(long)(time/3600)];
    }
    return [NSString stringWithFormat:@"Active %ld days ago",(long)(time/86400)];
}

- (NSString *)stringWithFormat:(NSString *)format {
	[[self class] initializeStatics];
	[[[self class] sharedDateFormatter] setDateFormat:format];
	NSString *timestamp_str = [[[self class] sharedDateFormatter] stringFromDate:self];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	[[[self class] sharedDateFormatter] setDateStyle:dateStyle];
	[[[self class] sharedDateFormatter] setTimeStyle:timeStyle];
	NSString *outputString = [[[self class] sharedDateFormatter] stringFromDate:self];
	return outputString;
}

+ (NSString *)dateFormatString {
	return kNSDateHelperFormatSQLDate;
}

+ (NSString *)timeFormatString {
	return kNSDateHelperFormatSQLTime;
}

+ (NSString *)timestampFormatString {
	return kNSDateHelperFormatSQLDateWithTime;
}

// preserving for compatibility
+ (NSString *)dbFormatString {
	return [NSDate timestampFormatString];
}

- (BOOL)isSameDayAsDate:(NSDate*)otherDate {
    
    // From progrmr's answer...
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:otherDate];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
