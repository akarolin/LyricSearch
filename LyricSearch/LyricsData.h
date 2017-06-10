//
//  LyricsData.h
//  LyricSearch
//
//  Created by Andy Karolin on 6/10/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SongData.h"

@protocol LyricsDataDelegate <NSObject>
- (void)dataLoaded;
@end

@interface LyricsData : NSObject

@property (nonatomic, strong) NSString *lyrics;
@property (nonatomic, strong) id<LyricsDataDelegate> delegate;

- (void)getLyrics:(NSString *)artist andSongTitle:(NSString *)songTitle;

@end
