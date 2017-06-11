//
//  WebServiceTests.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebService.h"
#import "StringConstants.h"

@interface WebServiceTests : XCTestCase
@property (nonatomic, strong) WebService *webService;

@end

@implementation WebServiceTests

- (void)setUp {
    [super setUp];
    self.webService = [[WebService alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateURL {
    NSString *baseURL = @"lyrics.wikia.com";
    NSString *test = @"https://lyrics.wikia.com";
    NSString *url = [self.webService createCompleteURLString:baseURL withParameters:nil andHTTPS:YES];
    
    XCTAssertTrue([url isEqualToString:test], "@First CreateURL test fail");

    baseURL = @"lyrics.wikia.com/api.php";
    test = @"http://lyrics.wikia.com/api.php?func=getSong&artist=Tom%20Waits";
    NSString *test2 = @"http://lyrics.wikia.com/api.php?artist=Tom%20Waits&func=getSong";
    NSDictionary *parameters = @{@"func" : @"getSong", @"artist" : @"Tom Waits"};
    url = [self.webService createCompleteURLString:baseURL withParameters:parameters andHTTPS:NO];
    
    // no order guarantee with dictionary, need to check both permutations
    XCTAssertTrue([url isEqualToString:test] || [url isEqualToString:test2], "@Second CreateURL test fail");
}

- (void)testSuccessfulJSON {
    NSString *jsonString = @"{ \"content\": {\"1\":\"a\",\"2\":\"b\" } }";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *testObject = [self.webService getResponseObjectFromData:jsonData withError:&error];
    XCTAssertNotNil(testObject, @"JSON object should not have failed");
}

- (void)testSuccessfulJS {
    NSString *jsString = @"{ content = {\"1\":\"a\",\"2\":\"b\" } }";
    NSData *jsData = [jsString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *testObject = [self.webService getResponseObjectFromData:jsData withError:&error];
    XCTAssertNotNil(testObject, @"JS object should not have failed");
}

- (void)testUnsuccessfulJSON {
    NSString *jsonString = @"{ \"content\": {\"1\":\"a\",\"2\":\"b\"  }";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *testObject = [self.webService getResponseObjectFromData:jsonData withError:&error];
    XCTAssertNil(testObject, @"JSON object should have failed");
}

- (void)testUnsuccessfulJS {
    NSString *jsString = @"{ content = {\"1\":\"a\",\"2\":\"b\"  }";
    jsString = @"function multiply(value1, value2) { return value1 * value2 ";
    NSData *jsData = [jsString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *testObject = [self.webService getResponseObjectFromData:jsData withError:&error];
    XCTAssertNil(testObject, @"JS object should have failed");
}

- (void)testSuccessfulJSONCall {
    
    [self successfulCallExpected:@"https://itunes.apple.com/search?term=tom+waits"];
}

- (void)testSuccessfulJSObjectCall {
    
    [self successfulCallExpected:@"http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json"];
}

- (void)successfulCallExpected:(NSString *)url {
    XCTestExpectation *expectation = [self expectationWithDescription:@"server responded"];

    [self.webService getWebDataByURL:url completionHandler:^(NSDictionary *object, NSString *errorMessage){
        [expectation fulfill];
        XCTAssertNotNil(object, @"Data object expected");
        XCTAssertNil(errorMessage, @"No error expected: %@", errorMessage);
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}


- (void)testFailedJSONCall {
    
    [self failedCallExpected:@"https://www.google.com" expectingPrefix:JSONError ];
}

- (void)testBadURL {
    
    [self failedCallExpected:@"https://itunes.apple.com/search?term=tom+waits&entity=xyz" expectingPrefix:HTTPError];
}

- (void)failedCallExpected:(NSString *)url  expectingPrefix:(NSString *)testPrefix {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"server responded"];

    [self.webService getWebDataByURL:url completionHandler:^(NSDictionary *object, NSString *errorMessage) {
        [expectation fulfill];
        XCTAssertNil(object ,@"No data object expected");
        XCTAssertTrue([errorMessage hasPrefix:testPrefix]);
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}


@end
