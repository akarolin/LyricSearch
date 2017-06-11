//
//  LyricSearchTests.m
//  LyricSearchTests
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+CondenseSpaces.h"
#import "TuneSearchData.h"
#import "LyricsData.h"
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
    // test all cases
    NSString *testString1 = @"   This     is      a        test    ";
    NSString *testString2 = @"This     is      a        test    ";
    NSString *testString3 = @"   This     is      a        test";
    NSString *testString4 = @"This     is      a        test";
    NSString *testString5 = @"This is a test";
    NSString *finalString = @"This is a test";
    
    NSString *newString = [testString1 condenseSpaces];
    XCTAssertTrue([newString isEqualToString:finalString]);

    newString = [testString2 condenseSpaces];
    XCTAssertTrue([newString isEqualToString:finalString]);
    
    newString = [testString3 condenseSpaces];
    XCTAssertTrue([newString isEqualToString:finalString]);
    
    newString = [testString4 condenseSpaces];
    XCTAssertTrue([newString isEqualToString:finalString]);
    
    newString = [testString5 condenseSpaces];
    XCTAssertTrue([newString isEqualToString:finalString]);
    
}

- (void)testSuccessfulTuneSearch {

    XCTestExpectation *expectation = [self expectationWithDescription:@"server responded"];

    TuneSearchData *tuneSearchData = [[TuneSearchData alloc] init];
    [tuneSearchData getSongsUsingSearchTerms:@"tom waits" updatedSongList:^(NSArray *songList) {
        [expectation fulfill];
        XCTAssertNotNil(songList, @"Expected object");
        XCTAssertTrue([songList count] > 0);
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testUnsuccessfulTuneSearch {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"server responded"];
    
    TuneSearchData *tuneSearchData = [[TuneSearchData alloc] init];
    [tuneSearchData getSongsUsingSearchTerms:@"sgyhrk"  updatedSongList:^(NSArray *songList){
        [expectation fulfill];
        XCTAssertNotNil(songList, @"Expected object");
        XCTAssertTrue([songList count] == 0);
        
    }];

    [self waitForExpectationsWithTimeout:2 handler:nil];

}

- (void)testSuccessfulLyricsGet {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"server responded"];
    
    LyricsData *lyricsData = [[LyricsData alloc] init];
    [lyricsData getLyrics:@"Tom Waits" andSongTitle:@"new coat of paint" getLyrics:^(NSString *lyrics) {
        [expectation fulfill];
        XCTAssertFalse([lyrics isEqualToString:@"Not found"]);
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)testUnsuccessfulLyricsGet {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"server responded"];
    
    LyricsData *lyricsData = [[LyricsData alloc] init];
    [lyricsData getLyrics:@"Tom Waits" andSongTitle:@"nshjhohog" getLyrics:^(NSString *lyrics) {
        [expectation fulfill];
        XCTAssertTrue([lyrics isEqualToString:@"Not found"]);
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}


@end
