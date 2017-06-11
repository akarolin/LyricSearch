//
//  TuneSearchData.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/9/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "TuneSearchData.h"
#import "WebService.h"
#import "NSString+CondenseSpaces.h"
#import "SongData.h"


@interface TuneSearchData()

@property (nonatomic, strong) NSString *urlStub;
@property (nonatomic, strong) WebService *webService;

@end


@implementation TuneSearchData

- (id)init {
    if (self = [super init]) {
        _urlStub = @"https://itunes.apple.com/search?entity=song&term="; //tom+waits
        _webService = [[WebService alloc] init];
    }
    return self;
}

- (void)getSongsUsingSearchTerms:(NSString *)searchTerms updatedSongList:(void (^)(NSArray *songList))updateSongList {
    NSString *searchString = [searchTerms condenseSpaces];
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url =[NSString stringWithFormat:@"%@%@", self.urlStub, searchString];
    
    [self.webService getWebDataByURL:url completionHandler:^(NSDictionary *dataObject, NSString *errorMessage) {

        NSMutableArray *songList = nil;
        
        if (dataObject == nil) {
            
        } else {
            songList = [[NSMutableArray alloc] initWithCapacity:[dataObject count]];
            
            for(NSDictionary *item in dataObject[@"results"]) {
                
                SongData *songData = [[SongData alloc] init];
                songData.artist = [item objectForKey:@"artistName"];
                songData.songTitle = [item objectForKey:@"trackName"];
                songData.albumTitle = [item objectForKey:@"collectionName"];
                songData.albumImageURL = [item objectForKey:@"artworkUrl60"];
                [songList addObject:songData];
            }
            
        }
       updateSongList(songList);
    }];
}


@end
