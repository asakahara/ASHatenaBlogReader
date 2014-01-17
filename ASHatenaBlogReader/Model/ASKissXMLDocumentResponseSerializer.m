//
//  ASKissXMLResponseSerializer.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/08.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import "ASKissXMLDocumentResponseSerializer.h"
#import "DDXMLDocument.h"

extern NSString * const AFNetworkingErrorDomain;

@implementation ASKissXMLDocumentResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithXMLDocumentOptions:0];
}

+ (instancetype)serializerWithXMLDocumentOptions:(NSUInteger)mask {
    ASKissXMLDocumentResponseSerializer *serializer = [[self alloc] init];
    serializer.options = mask;
    
    return serializer;
}


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:
                                   @"application/xml", @"text/xml", @"application/rss+xml", nil];
    
    return self;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if ([(NSError *)(*error) code] == NSURLErrorCannotDecodeContentData) {
            return nil;
        }
    }
    
    return [[DDXMLDocument alloc] initWithData:data options:self.options error:error];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    self.options = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(options))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.options forKey:NSStringFromSelector(@selector(options))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    ASKissXMLDocumentResponseSerializer *serializer = [[[self class] allocWithZone:zone] init];
    serializer.options = self.options;
    
    return serializer;
}


@end
