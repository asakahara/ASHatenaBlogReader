//
//  ASDateUtils.h
//  ASTwitterClient
//
//  Created by sakahara on 2013/10/05.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASDateUtil : NSObject

+ (NSDate *)parseDate:(NSString *)dateString;

+ (NSString *)formatDate:(NSDate *)date formatString:(NSString *)formatString;

@end
