//
//  BookmarksTests.m
//  BookmarksTests
//
//  Created by 高田 明史 on 2014/05/04.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ATJSONParser.h"

@interface BookmarksTests : XCTestCase

@end

@implementation BookmarksTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParseExample1Json
{
    NSString *anExampleFilepath = @"/Users/aki/Cocoa/Bookmarks/BookmarksTests/Examples/example-1.json";
    ATJSONParser *aParser = [ATJSONParser parserWithString:[NSString stringWithContentsOfFile:anExampleFilepath encoding:NSUTF8StringEncoding error:NULL]];
    id anObject = [aParser parse];
    XCTAssertNotNil(anObject, @"");
    XCTAssertTrue([(NSDictionary *)anObject count] > 0, @"");
}

- (void)testParseExample2Json
{
    NSString *anExampleFilepath = @"/Users/aki/Cocoa/Bookmarks/BookmarksTests/Examples/example-2.json";
    ATJSONParser *aParser = [ATJSONParser parserWithString:[NSString stringWithContentsOfFile:anExampleFilepath encoding:NSUTF8StringEncoding error:NULL]];
    id anObject = [aParser parse];
    XCTAssertNotNil(anObject, @"");
    XCTAssertTrue([(NSArray *)anObject count] > 0, @"");
}

@end
