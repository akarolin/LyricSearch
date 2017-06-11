//
//  LyricSearchUITests.m
//  LyricSearchUITests
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LyricSearchUITests : XCTestCase

@end

@implementation LyricSearchUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTuneSearch {
    
    NSString *testArtist = @"Tom Waits";
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *enterSearchWordsSearchField = app.tables[@"Empty list"].searchFields[@"Enter search words"];
    [enterSearchWordsSearchField tap];
    [enterSearchWordsSearchField typeText:testArtist];
    [app.buttons[@"Search"] tap];

    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == YES"];
    int timeOutWait = 5;

    XCUIElement *cell = [[app.tables childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0];
    XCUIElement *test = cell.staticTexts[testArtist];
    [self expectationForPredicate:exists evaluatedWithObject:test handler:nil];
    [self waitForExpectationsWithTimeout:timeOutWait handler:nil];
    XCTAssertTrue([test.label isEqualToString:testArtist]);

}

- (void)testLyricsGet {
    
    NSString *testArtist = @"Tom Waits";
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *enterSearchWordsSearchField = app.tables[@"Empty list"].searchFields[@"Enter search words"];
    [enterSearchWordsSearchField tap];
    [enterSearchWordsSearchField typeText:testArtist];
    [app.buttons[@"Search"] tap];

    NSPredicate *exists = [NSPredicate predicateWithFormat:@"exists == YES"];
    int timeOutWait = 5;
    
    XCUIElement *cell = [[app.tables childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:0];
    XCUIElement *test = cell.staticTexts[testArtist];
    [self expectationForPredicate:exists evaluatedWithObject:test handler:nil];
    [self waitForExpectationsWithTimeout:timeOutWait handler:nil];
    XCTAssertTrue([test.label isEqualToString:testArtist]);
    
    [cell tap];
    
    NSString *testLyrics = @"Well, I hope that I don't fall in love with you 'Cause falling in love just makes me blue Well, the music plays and you display your heart for me to see I had a beer and now I hear you ca[...]";
    
    test = app.staticTexts[testLyrics];
    XCTAssertTrue([test.label isEqualToString:testLyrics]);

   
}

@end
