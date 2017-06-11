//
//  LyricsData.h
//  LyricSearch
//
//  Created by Andy Karolin on 6/10/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SongData.h"

@interface LyricsData : NSObject

- (void)getLyrics:(NSString *)artist andSongTitle:(NSString *)songTitle;
- (void)getLyrics:(NSString *)artist andSongTitle:(NSString *)songTitle getLyrics:(void (^)(NSString *lyrics))returnLyrics;

@end
