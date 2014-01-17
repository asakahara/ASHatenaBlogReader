//
//  ASBlogAPIClient.h
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/17.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ASBlogAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (void)getBlogsWithCompletion:(void (^)(NSDictionary *results, NSError *error))block;

@end
