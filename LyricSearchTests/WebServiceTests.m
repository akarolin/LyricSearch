//
//  WebServiceTests.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebService.h"

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

- (void)testURLcall {
    [self.webService getWebData:@"https://itunes.apple.com/search?term=tom+waits"];
    XCTAssertTrue(self.webService.jsonObject == nil);

    [NSThread sleepForTimeInterval:2];
    NSLog(@"Done Sleeping");

    XCTAssertTrue(self.webService.jsonObject != nil);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
