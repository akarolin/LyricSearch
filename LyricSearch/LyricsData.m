//
//  LyricsData.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/10/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "LyricsData.h"
#import "WebService.h"
#import "NSString+CondenseSpaces.h"
#import "SongData.h"
#import "StringConstants.h"


@interface LyricsData()

@property (nonatomic, strong) WebService *webService;

@end

@implementation LyricsData

- (id)init {
    if (self = [super init]) {
        _webService = [[WebService alloc] init];
    }
    return self;
}

- (void)getLyrics:(NSString *)artist andSongTitle:(NSString *)songTitle {} // temporary
- (void)getLyrics:(NSString *)artist andSongTitle:(NSString *)songTitle getLyrics:(void (^)(NSString *lyrics))returnLyrics {

    // http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"getsong" forKey:@"func"];
    [parameters setObject:artist forKey:@"artist"];
    [parameters setObject:songTitle forKey:@"song"];
    [parameters setObject:@"json" forKey:@"fmt"];
    
    NSString *url = [self.webService createCompleteURLString:@"lyrics.wikia.com/api.php" withParameters:parameters andHTTPS:NO];
    
    [self.webService getWebDataByURL:url completionHandler:^(NSDictionary *dataObject, NSString *errorMessage) {
        NSString *lyrics = @"";

        if (dataObject != nil) {
            lyrics = [dataObject objectForKey:@"lyrics"];
        }
    
        returnLyrics(lyrics);
    }];
}

@end
