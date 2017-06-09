//
//  LyricSearchTests.m
//  LyricSearchTests
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+CondenseSpaces.h"
#import "TuneSearch.h"
#import "StringConstants.h"

@interface LyricSearchTests : XCTestCase

@end

@implementation LyricSearchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCondenseSpaces {
    NSString *testString = @"   This     is      a        test    ";
    NSString *finalString = @"This is a test";
    
    NSString *newString = [testString condenseSpaces];
    XCTAssertTrue([newString isEqualToString:finalString]);
    
}

- (void)testSuccessfulTuneSearch {

    TuneSearch *tuneSearch = [[TuneSearch alloc] init];
    [tuneSearch getSongsUsingSearchTerms:@"tom waits"];
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"testExpectation != nil"];
    [self expectationForPredicate:exists evaluatedWithObject:tuneSearch handler:nil];
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertTrue([tuneSearch.testExpectation isEqualToString:DataFound]);
    }];
    
}

- (void)testUnsuccessfulTuneSearch {
    
    TuneSearch *tuneSearch = [[TuneSearch alloc] init];
    [tuneSearch getSongsUsingSearchTerms:@"sgyhrk"];
    
    NSPredicate *exists = [NSPredicate predicateWithFormat:@"testExpectation != nil"];
    [self expectationForPredicate:exists evaluatedWithObject:tuneSearch handler:nil];
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error,@"Server Timeout Error: %@", error.localizedDescription);
        XCTAssertTrue([tuneSearch.testExpectation isEqualToString:NoDataFound]);
    }];
    
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
