//
//  TuneSearchData.h
//  LyricSearch
//
//  Created by Andy Karolin on 6/9/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuneSearchData : NSObject

- (void)getSongsUsingSearchTerms:(NSString *)searchTerms updatedSongList:(void (^)(NSArray *songList))updateSongList;

@end
