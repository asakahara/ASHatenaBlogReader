//
//  ASDateUtils.m
//  ASTwitterClient
//
//  Created by sakahara on 2013/10/05.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASDateUtil.h"

@implementation ASDateUtil

+ (NSDate *)parseDate:(NSString *)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    // Mon, 30 Dec 2013 10:46:49 +0900
    [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return [df dateFromString:dateString];
}

+ (NSString *)formatDate:(NSDate *)date formatString:(NSString *)formatString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:formatString];
    return [df stringFromDate:date];
}

@end
