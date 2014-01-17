//
//  ASHTTPStubUtil.h
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/08.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASHTTPStubUtil : NSObject

+ (void)setupResponseWithFile:(NSString *)fileName statusCode:(int)statusCode
                 contentTypes:(NSDictionary *)contentTypes;

+ (void)setupResponseWithData:(NSData *)data statusCode:(int)statusCode
                 contentTypes:(NSDictionary *)contentTypes;

+ (void)setupResponseXML:(NSString *)fileName statusCode:(int)statusCode;

+ (void)removeAll;

@end
