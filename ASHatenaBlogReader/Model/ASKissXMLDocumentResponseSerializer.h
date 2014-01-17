//
//  ASKissXMLResponseSerializer.h
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/08.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@interface ASKissXMLDocumentResponseSerializer : AFHTTPResponseSerializer

@property (nonatomic, assign) NSUInteger options;

+ (instancetype)serializerWithXMLDocumentOptions:(NSUInteger)mask;

@end
