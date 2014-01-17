//
//  ASStringUtilTests.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/04.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASDateUtil.h"

@interface ASSDateUtilTests : XCTestCase

@end

@implementation ASSDateUtilTests

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

- (void)testParseDateSuccess
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps.year = 2013;
    comps.month = 12;
    comps.day = 30;
    comps.hour = 10;
    comps.minute = 45;
    comps.second = 50;
    
    NSDate *date = [calendar dateFromComponents:comps];
    NSDate *testTargetDate = [ASDateUtil parseDate:@"Mon, 30 Dec 2013 10:45:50 +0900"];
    XCTAssertEqual(testTargetDate.timeIntervalSinceReferenceDate, date.timeIntervalSinceReferenceDate);
}

- (void)testParseDateFail
{
    NSDate *testTargetDate = [ASDateUtil parseDate:@"Mon, 30 D 2013 10:45:50 +0900"];
    XCTAssertNil(testTargetDate);
}

- (void)testFormatDateSuccess
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps.year = 2013;
    comps.month = 12;
    comps.day = 30;
    comps.hour = 10;
    comps.minute = 45;
    comps.second = 50;
    
    NSDate *targetDate = [calendar dateFromComponents:comps];
    
    NSString *targetDateString = [ASDateUtil formatDate:targetDate formatString:@"yyyy/MM/dd HH:mm:ss"];
    XCTAssertTrue([targetDateString isEqualToString:@"2013/12/30 10:45:50"]);
}

@end
