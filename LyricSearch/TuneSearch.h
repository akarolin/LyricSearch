//
//  TuneSearch
//  LyricSearch
//
//  Created by Andy Karolin on 6/9/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuneSearch : NSObject

@property (nonatomic, strong) NSArray *songList;
@property (nonatomic, strong) NSString *testExpectation;

- (void)getSongsUsingSearchTerms:(NSString *)searchTerms;

@end
