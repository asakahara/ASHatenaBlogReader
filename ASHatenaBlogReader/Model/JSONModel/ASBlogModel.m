//
//  ASBlog.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASBlogModel.h"
#import "ASDateUtil.h"

@implementation ASBlogModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"body": @"description",
             @"creator": @"dc:creator",
             @"blogImageURL": @"media:content.url",
             @"webURL": @"link",
             };
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
             @"creator": @"userID",
             };
}

+ (NSValueTransformer *)pubDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [ASDateUtil parseDate:str];
    } reverseBlock:^(NSDate *date) {
        return [ASDateUtil formatDate:date formatString:@"MM/dd"];
    }];
}

+ (NSString *)managedObjectEntityName {
    return @"Blog";
}

@end
