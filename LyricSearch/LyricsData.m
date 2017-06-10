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


@interface LyricsData() <WebServiceDelegate>

@property (nonatomic, strong) WebService *webService;

@end

@implementation LyricsData

- (id)init {
    if (self = [super init]) {

        _webService = [[WebService alloc] init];
        _webService.delegate = self;
    }
    return self;
}

- (void)getLyrics:(NSString *)artist andSongTitle:(NSString *)songTitle {

    // http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"getsong" forKey:@"func"];
    [parameters setObject:artist forKey:@"artist"];
    [parameters setObject:songTitle forKey:@"song"];
    [parameters setObject:@"json" forKey:@"fmt"];
    
    NSString *url = [self.webService createCompleteURLString:@"lyrics.wikia.com/api.php" withParameters:parameters andHTTPS:NO];
    
    [self.webService getWebDataByURL:url];
}

// webservice delegate
- (void)webServiceResponse:(NSDictionary *)dataObject withError:(NSString *)errorMessage {
 
    self.lyrics = @"";

    if (dataObject != nil) {
        self.lyrics = [dataObject objectForKey:@"lyrics"];
    }
    
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
