//
//  ASHTTPStubUtil.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/08.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import "ASHTTPStubUtil.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@implementation ASHTTPStubUtil

+ (void)setupResponseXML:(NSString *)fileName statusCode:(int)statusCode
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(fileName, nil)
                                                statusCode:statusCode headers:@{@"Content-Type":@"application/rss+xml"}];
    }];
}

+ (void)setupResponseWithFile:(NSString *)fileName statusCode:(int)statusCode
                 contentTypes:(NSDictionary *)contentTypes
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(fileName, nil)
                                                statusCode:statusCode headers:contentTypes];
    }];
}

+ (void)setupResponseWithData:(NSData *)data statusCode:(int)statusCode
                 contentTypes:(NSDictionary *)contentTypes
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:data statusCode:statusCode headers:contentTypes];
    }];
}

+ (void)removeAll
{
    [OHHTTPStubs removeAllStubs];
}

@end
