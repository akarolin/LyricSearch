//
//  TuneSearchData.h
//  LyricSearch
//
//  Created by Andy Karolin on 6/9/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TuneSearchDelegate <NSObject>
- (void)dataLoaded;
@end

@interface TuneSearchData : NSObject

@property (nonatomic, strong) NSArray *songList;
@property (nonatomic, strong) NSString *testExpectation;
@property (nonatomic, strong) id<TuneSearchDelegate> delegate;

- (void)getSongsUsingSearchTerms:(NSString *)searchTerms;

@end
