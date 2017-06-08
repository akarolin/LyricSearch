//
//  WebService.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "WebService.h"

@implementation WebService

- (void) getWebData:(NSString *)urlString {
//    self.jsonObject = nil;
//    self.errorMsg = nil;

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSError *jsonError = nil;
            self.jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (self.jsonObject == nil) {
                self.errorMsg = (jsonError == nil) ? @"Not a JSON Object"
                                                   : [NSString stringWithFormat:@"%@ - %@", jsonError.localizedDescription, jsonError.localizedFailureReason];
            }
        } else {
            self.errorMsg = [NSString stringWithFormat:@"%@ - %@", error.localizedDescription, error.localizedFailureReason];
        }
    }];
    
    [dataTask resume];
}

@end
