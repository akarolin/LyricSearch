//
//  WebServiceTests.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebService.h"

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

- (void)testURLcall {
    [self.webService getWebData:@"https://itunes.apple.com/search?term=tom+waits"];

    self.serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertEqual(error,nil,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertNotEqual(self.objectFromWebServiceDelegate,nil,@"Data object expected");
        XCTAssertEqual(self.errorMessageFromWebServiceDelegate,nil, @"No error expected: %@", self.errorMessageFromWebServiceDelegate);
    }];

}

- (void)testFailedJSON {
    [self.webService getWebData:@"https://www.google.com"];
    
    self.serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertEqual(error,nil,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertEqual(self.objectFromWebServiceDelegate,nil,@"Data object expected");
        XCTAssertTrue([self.errorMessageFromWebServiceDelegate hasPrefix:JSONError]);
    }];
}

- (void)testBadURL {
    [self.webService getWebData:@"https://itunes.apple.com/search?term=tom+waits&entity=xyz"];
    
    self.serverRespondExpectation = [self expectationWithDescription:@"server responded"];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertEqual(error,nil,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertEqual(self.objectFromWebServiceDelegate,nil,@"Data object expected");
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
