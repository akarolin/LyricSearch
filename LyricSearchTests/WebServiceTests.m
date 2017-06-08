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

- (void)testFailedJSON {
    [self.webService getWebData:@"http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json"];
    XCTAssertTrue(self.webService.jsonObject == nil);
    
    [NSThread sleepForTimeInterval:2];
    NSLog(@"Done Sleeping");
    XCTAssertTrue(self.webService.jsonObject == nil);
    XCTAssertTrue([self.webService.errorMsg hasPrefix:JSONError]);
}

- (void)testBadURL {
    [self.webService getWebData:@"https://itunes.apple.com/search?term=tom+waits&entity=xyz"];
    XCTAssertTrue(self.webService.jsonObject == nil);
    
    [NSThread sleepForTimeInterval:2];
    NSLog(@"Done Sleeping");
    
    XCTAssertTrue(self.webService.jsonObject == nil);
    XCTAssertTrue([self.webService.errorMsg hasPrefix:HTTPError]);
}

//10.0.0.0
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
