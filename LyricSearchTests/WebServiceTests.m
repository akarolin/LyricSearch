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

@interface WebServiceTests : XCTestCase<WebServiceDelegate>
@property (nonatomic, strong) WebService *webService;
@property (nonatomic, strong) XCTestExpectation *serverRespondExpectation;
@property (nonatomic, strong) NSDictionary *objectFromWebServiceDelegate;
@property (nonatomic, strong) NSString *errorMessageFromWebServiceDelegate;

@end

@implementation WebServiceTests

- (void)setUp {
    [super setUp];
    self.webService = [[WebService alloc] init];
    self.webService.delegate = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)webServiceResponse:(NSDictionary *)dataObject withError:(NSString *)errorMessage {
    self.objectFromWebServiceDelegate = dataObject;
    self.errorMessageFromWebServiceDelegate = errorMessage;
    [self.serverRespondExpectation fulfill];
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
    [self.webService getWebDataByURL:@"https://itunes.apple.com/search?term=tom+waits"];
    
    self.serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertNotNil(self.objectFromWebServiceDelegate, @"Data object expected");
        XCTAssertNil(self.errorMessageFromWebServiceDelegate, @"No error expected: %@", self.errorMessageFromWebServiceDelegate);
    }];
    
}

- (void)testSuccessfulJSObjectCall {
    
    // this returns a javascript ojbect
    [self.webService getWebDataByURL:@"http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json"];
    
    self.serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertNotNil(self.objectFromWebServiceDelegate,@"Data object expected");
        XCTAssertNil(self.errorMessageFromWebServiceDelegate, @"No error expected: %@", self.errorMessageFromWebServiceDelegate);
    }];
    
}

- (void)testFailedJSON {
    [self.webService getWebDataByURL:@"https://www.google.com"];
    
    self.serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertNil(self.objectFromWebServiceDelegate,@"Data object expected");
        XCTAssertTrue([self.errorMessageFromWebServiceDelegate hasPrefix:JSONError]);
    }];
}

- (void)testBadURL {
    [self.webService getWebDataByURL:@"https://itunes.apple.com/search?term=tom+waits&entity=xyz"];
    
    self.serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertNil(self.objectFromWebServiceDelegate,@"Data object expected");
        XCTAssertTrue([self.errorMessageFromWebServiceDelegate hasPrefix:HTTPError]);
    }];
    
}

//10.0.0.0
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
