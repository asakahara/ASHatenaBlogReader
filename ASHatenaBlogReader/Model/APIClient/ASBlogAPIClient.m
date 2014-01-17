//
//  ASBlogAPIClient.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/17.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import "ASBlogAPIClient.h"
#import "ASKissXMLDocumentResponseSerializer.h"
#import "DDXMLElement+Dictionary.h"
#import "DDXMLDocument.h"

@implementation ASBlogAPIClient

static NSString * const kASBlogAPIBaseURLString = @"http://blog.hatena.ne.jp/";

+ (instancetype)sharedClient
{
    static ASBlogAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/rss+xml",
                                                };
        _sharedClient = [[ASBlogAPIClient alloc]
                         initWithBaseURL:[NSURL URLWithString:kASBlogAPIBaseURLString]
                         sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}

- (void)getBlogsWithCompletion:(void (^)(NSDictionary *results, NSError *error))block
{
    self.responseSerializer = [ASKissXMLDocumentResponseSerializer serializer];
    [self GET:@"/-/hotentry/rss"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {

          NSDictionary *results = nil;
          if ([responseObject isKindOfClass:[DDXMLDocument class]]) {
              results = [((DDXMLDocument *)responseObject).rootElement convertDictionary];
          }
          
          if (block) block(results, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (block) block(nil, error);
      }];
}

@end
