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
#import "StringConstants.h"


@interface TuneSearchData() <WebServiceDelegate>

@property (nonatomic, strong) NSString *urlStub;
@property (nonatomic, strong) WebService *webService;

@end


@implementation TuneSearchData

- (id)init {
    if (self = [super init]) {
        _urlStub = @"https://itunes.apple.com/search?entity=song&term="; //tom+waits
        _webService = [[WebService alloc] init];
        _webService.delegate = self;
    }
    return self;
}

- (void)getSongsUsingSearchTerms:(NSString *)searchTerms{
    NSString *searchString = [searchTerms condenseSpaces];
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url =[NSString stringWithFormat:@"%@%@", self.urlStub, searchString];
    
    [self.webService getWebDataByURL:url];
}

// webservice delegate
- (void)webServiceResponse:(NSDictionary *)dataObject withError:(NSString *)errorMessage {
 
    NSMutableArray *songList = [[NSMutableArray alloc] initWithCapacity:[dataObject count]];
    _testExpectation = nil;
    
    if (dataObject == nil) {
        _testExpectation = NoDataFound;

    } else {

        for(NSDictionary *item in dataObject[@"results"]) {
            
            SongData *songData = [[SongData alloc] init];
            songData.artist = [item objectForKey:@"artistName"];
            songData.songTitle = [item objectForKey:@"trackName"];
            songData.albumTitle = [item objectForKey:@"collectionName"];
            songData.albumImageURL = [item objectForKey:@"artworkUrl60"];
            [songList addObject:songData];
        }
        
        _testExpectation = [songList count] == 0 ? NoDataFound : DataFound;
    }
    
    self.songList = songList;
    [self dataLoaded];
}

- (void)dataLoaded {
    if ([self.delegate respondsToSelector:@selector(dataLoaded)]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.delegate dataLoaded];
        });
    }
}

@end
