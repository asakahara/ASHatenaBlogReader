//
//  ASBlogManager.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASBlogManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ASKissXMLDocumentResponseSerializer.h"
#import "ASBlogModel.h"
#import "DDXMLElement+Dictionary.h"
#import "ASBlogEntity.h"
#import "ASBlogAPIClient.h"

@interface ASBlogManager()

@property (nonatomic, strong) ASBlogAPIClient *blogAPIClient;
@property (nonatomic) NSMutableArray *blogs;

@end

@implementation ASBlogManager

+ (instancetype)sharedManager
{
    static ASBlogManager *_sharedManager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ASBlogManager alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.blogAPIClient = [ASBlogAPIClient sharedClient];
        self.blogs = [NSMutableArray array];
    }
    
    return self;
}

- (void)loadAllBlogs
{
    // DBからブログ情報を取得する
    NSArray *blogEntities = [ASBlogEntity findAllSortedBy:@"pubDate" ascending:NO];
    // DBにデータがある場合、配列に追加してKVOによる通知を行う
    if (blogEntities.count > 0) {
        [[self mutableArrayValueForKey:@"blogs"]
         replaceObjectsInRange:NSMakeRange(0, self.blogs.count) withObjectsFromArray:blogEntities];
    }
}

- (void)reloadBlogsWithBlock:(void (^)(NSError *error))block
{
    __weak typeof(self) weakSelf = self;
    
    // サーバからブログ情報を取得する
    [self loadBlogsWithCompletion:^(NSArray *blogs, NSError *error) {
        // サーバからブログ情報を取得できた場合、DB登録処理を開始する
        if (blogs.count > 0) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                // DBのブログ情報を全て削除する
                [ASBlogEntity truncateAllInContext:localContext];
        
                // サーバから取得した取得したブログ情報をDBに登録する
                [blogs enumerateObjectsUsingBlock:^(ASBlogModel *blogModel, NSUInteger idx, BOOL *stop) {
                    // ブログエンティティを生成する
                    [MTLManagedObjectAdapter managedObjectFromModel:blogModel
                                               insertingIntoContext:localContext error:nil];
                }];
                
            } completion:^(BOOL success, NSError *error) {
                if (success) {
                    // 保存したブログ情報をDBから取得する
                    NSArray *blogEntities = [ASBlogEntity findAllSortedBy:@"pubDate" ascending:NO];
                    
                    // 取得したブログ情報を配列に追加してKVOによる通知を行う
                    [[weakSelf mutableArrayValueForKey:@"blogs"]
                     replaceObjectsInRange:NSMakeRange(0, weakSelf.blogs.count) withObjectsFromArray:blogEntities];
                }
                
                if (block) block(error);
            }];
        } else {
            if (block) block(error);
        }
    }];
}


- (void)loadBlogsWithCompletion:(void (^)(NSArray *results, NSError *error))block
{
    __weak typeof(self) weakSelf = self;
    
    [self.blogAPIClient getBlogsWithCompletion:^(NSDictionary *results, NSError *error) {
        
        NSArray *blogs = nil;
        if (results && [results isKindOfClass:[NSDictionary class]]) {
            NSArray *blogsJSON = results[@"rss"][@"channel"][@"item"];
            
            if ([blogsJSON isKindOfClass:[NSArray class]]) {
                blogs = [weakSelf parseBlogs:blogsJSON];
            }
        }
        
        if (block) block(blogs, error);
    }];
}

- (NSArray *)parseBlogs:(NSArray *)blogs
{
    NSMutableArray *mutableBlogs = [NSMutableArray array];
    
    [blogs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ASBlogModel *blog = [MTLJSONAdapter modelOfClass:ASBlogModel.class fromJSONDictionary:obj error:nil];
        [mutableBlogs addObject:blog];
    }];
    
    return [mutableBlogs copy];
}

@end
