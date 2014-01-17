//
//  ASBlog.h
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface ASBlogModel : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *body;

@property (nonatomic, strong) NSString *creator;

@property (nonatomic, strong) NSString *blogImageURL;

@property (nonatomic, strong) NSString *webURL;

@property (nonatomic, strong) NSDate *pubDate;

@end
