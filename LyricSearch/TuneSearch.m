//
//  TuneSearch.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/9/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "TuneSearch.h"
#import "WebService.h"
#import "NSString+CondenseSpaces.h"
#import "SongData.h"
#import "StringConstants.h"


@interface TuneSearch() <WebServiceDelegate>

@property (nonatomic, strong) NSString *urlStub;
@property (nonatomic, strong) WebService *webService;
@end


@implementation TuneSearch

- (id)init {
    if (self = [super init]) {
        _urlStub = @"https://itunes.apple.com/search?entity=song&term="; //tom+waits
        _webService = [[WebService alloc] init];
        _webService.delegate = self;
    }
    return self;
}

- (void)getSongsUsingSearchTerms:(NSString *)searchTerms {
    NSString *searchString = [searchTerms condenseSpaces];
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url =[NSString stringWithFormat:@"%@%@", self.urlStub, searchString];
    
    [self.webService getWebDataByURL:url];
}

// webservice delegate
- (void)webServiceResponse:(NSDictionary *)dataObject withError:(NSString *)errorMessage {
 
    NSMutableArray *songList = [[NSMutableArray alloc] initWithCapacity:[dataObject count]];
    SongData *songData = [[SongData alloc] init];
    _testExpectation = nil;
    
    if (dataObject == nil) {
        _testExpectation = NoDataFound;

        songData.trackTitle = NoDataFound;
        [songList addObject:songData];

    } else {
        _testExpectation = DataFound;

        for(NSDictionary *item in dataObject[@"results"]) {
            
            songData.artist = [item objectForKey:@"artistName"];
            songData.trackTitle = [item objectForKey:@"trackName"];
            songData.albumTitle = [item objectForKey:@"collectionName"];
            songData.albumImageURL = [item objectForKey:@"artworkUrl60"];
            [songList addObject:songData];
        }
        
        if ([songList count] == 0) {
            _testExpectation = NoDataFound;

            songData.trackTitle = NoDataFound;
            [songList addObject:songData];
        }
    }
    
    self.songList = songList;
}

@end
