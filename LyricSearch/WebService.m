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


    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"%@", json);
    }];
    
    [dataTask resume];
//    NSURLSessionDataTask *dataTask = session
//                                      dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
//                                              
//                                              if (error != nil) {
//                                                  NSString *errorMessage = error.localizedDescription;
//                                                  [self errorResponse:data response:response error:errorMessage];
//                                              } else {
//                                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//                                                  if (httpResponse.statusCode == 200) {
//                                                      [self successfulResponse:data response:response];
//                                                  } else {
//                                                      // needs to be modified for more descriptive error message
//                                                      NSString *errorMessage = [NSString stringWithFormat:@"Http Error Code: %ld",(long)httpResponse.statusCode];
//                                                      [self errorResponse:data response:response error:errorMessage];
//                                                  }
//                                              }
//                                          });
//                                      }];

}

@end
