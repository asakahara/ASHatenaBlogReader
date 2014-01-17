//
//  ASBlogAPIClientTests.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/17.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASBlogAPIClient.h"
// Test support
#import "ASHTTPStubUtil.h"
#import "TRVSMonitor.h"
#define EXP_SHORTHAND
#import "Expecta.h"

@interface ASBlogAPIClientTests : XCTestCase

@end

@implementation ASBlogAPIClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testLoadBlogsWithCompletionSuccess
{
    // テストデータの設定
    [ASHTTPStubUtil setupResponseXML:@"BlogList.txt" statusCode:200];
    
    ASBlogAPIClient *apiClient = [ASBlogAPIClient sharedClient];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSDictionary *testResult = nil;
    
    [apiClient getBlogsWithCompletion:^(NSDictionary *results, NSError *error) {
        
        testResult = results;
        // ブロックの処理が完了したらシグナルを送る
        [monitor signal];
    }];
    
    // シグナルを受け取るまで待機する
    [monitor wait];
    
    NSArray *results = testResult[@"rss"][@"channel"][@"item"];
    // テスト実行
    expect(results).to.haveCountOf(2);
    
    NSDictionary *blog1 = results[0];
    expect(blog1[@"title"]).to.equal(@"タイトル1");
    expect(blog1[@"description"]).to.equal(@"本文test1");
    expect(blog1[@"dc:creator"]).to.equal(@"user1");
    expect(blog1[@"link"]).to.equal(@"http://www.mocology.com/test1");
    expect(blog1[@"media:content"][@"url"]).to.equal(@"http://www.mocology.com/test1/test1.jpg");
    expect(blog1[@"pubDate"]).to.equal(@"Sat, 04 Jan 2014 23:37:19 +0900");
    
    NSDictionary *blog2 = results[1];
    expect(blog2[@"title"]).to.equal(@"タイトル2");
    expect(blog2[@"description"]).to.equal(@"本文test2");
    expect(blog2[@"dc:creator"]).to.equal(@"user2");
    expect(blog2[@"link"]).to.equal(@"http://www.mocology.com/test2");
    expect(blog2[@"media:content"][@"url"]).to.equal(@"http://www.mocology.com/test2/test2.jpg");
    expect(blog2[@"pubDate"]).to.equal(@"Sat, 04 Jan 2014 18:38:43 +0900");
    
    // テストデータの廃棄
    [ASHTTPStubUtil removeAll];
}

- (void)testLoadBlogsWithCompletionFailFileNotFound
{
    // テストデータの設定(ステータスコードを404にする)
    [ASHTTPStubUtil setupResponseXML:@"BlogList.txt" statusCode:404];
    
    ASBlogAPIClient *apiClient = [ASBlogAPIClient sharedClient];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSDictionary *testResult = nil;
    __block NSError *testError = nil;
    
    [apiClient getBlogsWithCompletion:^(NSDictionary *results, NSError *error) {
        
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
    
    ASBlogAPIClient *apiClient = [ASBlogAPIClient sharedClient];
    
    // Monitorの生成
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    
    __block NSDictionary *testResult = nil;
    __block NSError *testError = nil;
    
    [apiClient getBlogsWithCompletion:^(NSDictionary *results, NSError *error) {
        
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

@end
