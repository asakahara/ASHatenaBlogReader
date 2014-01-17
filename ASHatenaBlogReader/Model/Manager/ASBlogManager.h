//
//  ASBlogManager.h
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASBlogManager : NSObject

@property (nonatomic, readonly) NSMutableArray *blogs;

+ (instancetype)sharedManager;

- (void)loadAllBlogs;
- (void)reloadBlogsWithBlock:(void (^)(NSError *error))block;

@end
