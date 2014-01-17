//
//  ASBlogManagerTests.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/05.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASBlogManager.h"
#import "ASBlogModel.h"
#import "ASBlogEntity.h"
#import "ASDateUtil.h"
// Test support
#import "ASHTTPStubUtil.h"
#import "TRVSMonitor.h"
#define EXP_SHORTHAND
#import "Expecta.h"

@interface ASBlogManager (Private)
- (void)loadBlogsWithCompletion:(void (^)(NSArray *results, NSError *error))block;
@end

@interface ASBlogManagerTests : XCTestCase

@end

@implementation ASBlogManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    [ASBlogEntity truncateAll];
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    //[MagicalRecord cleanUp];
    [super tearDown];
}

- (void)testLoadBlogsWithCompletionSuccess
{
    // テストデータの設定
    [ASHTTPStubUtil setupResponseXML:@"BlogList.txt" statusCode:200];
    
    ASBlogManager *manager = [ASBlogManager sharedManager];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *testResult = nil;
    
    [manager loadBlogsWithCompletion:^(NSArray *results, NSError *error) {
        
        testResult = results;
        // ブロックの処理が完了したらシグナルを送る
        [monitor signal];
    }];
    
    // シグナルを受け取るまで待機する
    [monitor wait];
    
    // テスト実行
    expect(testResult).to.haveCountOf(2);
    
    ASBlogModel *blog1 = testResult[0];
    expect(blog1.title).to.equal(@"タイトル1");
    expect(blog1.body).to.equal(@"本文test1");
    expect(blog1.creator).to.equal(@"user1");
    expect(blog1.webURL).to.equal(@"http://www.mocology.com/test1");
    expect(blog1.blogImageURL).to.equal(@"http://www.mocology.com/test1/test1.jpg");
    expect(blog1.pubDate).to.equal([ASDateUtil parseDate:@"Sat, 04 Jan 2014 23:37:19 +0900"]);
    
    ASBlogModel *blog2 = testResult[1];
    expect(blog2.title).to.equal(@"タイトル2");
    expect(blog2.body).to.equal(@"本文test2");
    expect(blog2.creator).to.equal(@"user2");
    expect(blog2.webURL).to.equal(@"http://www.mocology.com/test2");
    expect(blog2.blogImageURL).to.equal(@"http://www.mocology.com/test2/test2.jpg");
    expect(blog2.pubDate).to.equal([ASDateUtil parseDate:@"Sat, 04 Jan 2014 18:38:43 +0900"]);
    
    // テストデータの廃棄
    [ASHTTPStubUtil removeAll];
}

- (void)testLoadBlogsWithCompletionFailFileNotFound
{
    // テストデータの設定(ステータスコードを404にする)
    [ASHTTPStubUtil setupResponseXML:@"BlogList.txt" statusCode:404];
    
    ASBlogManager *manager = [ASBlogManager sharedManager];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *testResult = nil;
    __block NSError *testError = nil;
     
    [manager loadBlogsWithCompletion:^(NSArray *results, NSError *error) {
        
        testResult = results;
        testError = error;
        // ブロックの処理が完了したらシグナルを送る
        [monitor signal];
    }];
    
    // シグナルを受け取るまで待機する
    [monitor wait];
    
    // テスト実行
    // エラーのためデータが返ってこないことを期待する
    expect(testResult).to.beNil();
    // エラー情報が含まれることを期待する
    expect(testError).notTo.beNil();
    
    // テストデータの廃棄
    [ASHTTPStubUtil removeAll];
}

- (void)testLoadBlogsWithCompletionFailParseXML
{
    // テストデータの設定
    [ASHTTPStubUtil setupResponseXML:@"BlogListFail.txt" statusCode:200];
    
    ASBlogManager *manager = [ASBlogManager sharedManager];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSArray *testResult = nil;
    __block NSError *testError = nil;
    
    [manager loadBlogsWithCompletion:^(NSArray *results, NSError *error) {
        
        testResult = results;
        testError = error;
        // ブロックの処理が完了したらシグナルを送る
        [monitor signal];
    }];
    // シグナルを受け取るまで待機する
    [monitor wait];
    
    // テスト実行
    expect(testResult).to.beNil();
    expect(testError).notTo.beNil();
    
    // テストデータの廃棄
    [ASHTTPStubUtil removeAll];
}


- (void)testReloadBlogsWithBlockSuccess
{
    // テストデータの設定
    [ASHTTPStubUtil setupResponseXML:@"BlogList.txt" statusCode:200];
    
    ASBlogManager *manager = [ASBlogManager sharedManager];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    [manager reloadBlogsWithBlock:^(NSError *error) {
        
        // ブロックの処理が完了したらシグナルを送る
        [monitor signal];
    }];
    
    // シグナルを受け取るまで待機する
    [monitor wait];
    
    NSArray *testResult = manager.blogs;
    
    // テスト実行
    expect(testResult).to.haveCountOf(2);
    
    ASBlogEntity *blog1 = testResult[0];
    expect(blog1.title).to.equal(@"タイトル1");
    expect(blog1.body).to.equal(@"本文test1");
    expect(blog1.userID).to.equal(@"user1");
    expect(blog1.webURL).to.equal(@"http://www.mocology.com/test1");
    expect(blog1.blogImageURL).to.equal(@"http://www.mocology.com/test1/test1.jpg");
    expect(blog1.pubDate).to.equal([ASDateUtil parseDate:@"Sat, 04 Jan 2014 23:37:19 +0900"]);
    
    ASBlogEntity *blog2 = testResult[1];
    expect(blog2.title).to.equal(@"タイトル2");
    expect(blog2.body).to.equal(@"本文test2");
    expect(blog2.userID).to.equal(@"user2");
    expect(blog2.webURL).to.equal(@"http://www.mocology.com/test2");
    expect(blog2.blogImageURL).to.equal(@"http://www.mocology.com/test2/test2.jpg");
    expect(blog2.pubDate).to.equal([ASDateUtil parseDate:@"Sat, 04 Jan 2014 18:38:43 +0900"]);
    
    // テストデータの廃棄
    [ASHTTPStubUtil removeAll];
}

- (void)testReloadBlogsWithBlockFailNotFound
{
    // テストデータの設定(ステータスコードを404にする)
    [ASHTTPStubUtil setupResponseXML:@"BlogList.txt" statusCode:404];
    
    ASBlogManager *manager = [ASBlogManager sharedManager];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSError *testError = nil;
    
    [manager reloadBlogsWithBlock:^(NSError *error) {
        
        testError = error;
        
        // ブロックの処理が完了したらシグナルを送る
        [monitor signal];
    }];
    
    // シグナルを受け取るまで待機する
    [monitor wait];
    
    // テスト実行
    // エラー情報が含まれることを期待する
    expect(testError).notTo.beNil();
    
    // テストデータの廃棄
    [ASHTTPStubUtil removeAll];
}

- (void)testReloadBlogsWithBlockFailParseXML
{
    // テストデータの設定
    [ASHTTPStubUtil setupResponseXML:@"BlogListFail.txt" statusCode:200];
    
    ASBlogManager *manager = [ASBlogManager sharedManager];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSError *testError = nil;
    
    [manager reloadBlogsWithBlock:^(NSError *error) {

        testError = error;
        
        // ブロックの処理が完了したらシグナルを送る
        [monitor signal];
    }];
    
    // シグナルを受け取るまで待機する
    [monitor wait];
    
    // テスト実行
    expect(testError).notTo.beNil();
    
    // テストデータの廃棄
    [ASHTTPStubUtil removeAll];
}

- (void)testLoadAllBlogs
{
    ASBlogManager *manager = [ASBlogManager sharedManager];
    
    ASBlogEntity *blogEntity1 = [ASBlogEntity createEntity];
    blogEntity1.title = @"blogTitle1";
    blogEntity1.body = @"blogBody1";
    blogEntity1.pubDate = [ASDateUtil parseDate:@"Sat, 04 Jan 2014 23:37:19 +0900"];
    
    ASBlogEntity *blogEntity2 = [ASBlogEntity createEntity];
    blogEntity2.title = @"blogTitle2";
    blogEntity2.body = @"blogBody2";
    blogEntity1.pubDate = [ASDateUtil parseDate:@"Sat, 04 Jan 2014 18:38:43 +0900"];
    
    [manager loadAllBlogs];
    
    // テスト実行
    expect(manager.blogs).to.haveCountOf(2);
    
    ASBlogEntity *blog1 = manager.blogs[0];
    expect(blog1.title).to.equal(@"blogTitle1");
    expect(blog1.body).to.equal(@"blogBody1");
}

@end
