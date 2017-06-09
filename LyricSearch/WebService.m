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
        
        if (error != nil) { // general error
            NSMutableString *errorMessage = [[NSMutableString alloc] initWithFormat:@"%@: ",ResponseError];
            [errorMessage appendString:error.localizedDescription];
            if (error.localizedFailureReason != nil && error.localizedFailureReason.length > 0)
                [errorMessage appendFormat:@"\n%@",error.localizedFailureReason ];
            [self webServiceResponse:nil withError:errorMessage];
            
        } else {
            
            // test for valid HTTP response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode != 200) {
                NSString *errorMessage = [NSString stringWithFormat:@"%@: %ld: %@", HTTPError, httpResponse.statusCode,
                                                                [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                [self webServiceResponse:nil withError:errorMessage];
            } else { // Valid reponse attempt to get object
                
                NSError *jsonError = nil;
                NSDictionary *dataObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (dataObject == nil) {
                    NSMutableString *errorMessage = [[NSMutableString alloc] initWithFormat:@"%@: ",JSONError];
                    [errorMessage appendString:jsonError.localizedDescription];
                    if (error.localizedFailureReason != nil && jsonError.localizedFailureReason.length > 0)
                        [errorMessage appendFormat:@"\n%@",jsonError.localizedFailureReason ];
                    [self webServiceResponse:nil withError:errorMessage];
                } else {
                    [self webServiceResponse:dataObject withError:nil];
                    
                }
            }
        }
    }];
    
    [dataTask resume];
}

-(void)webServiceResponse:(NSDictionary *)dataObject withError:(NSString *)errorMessage {
    if ([self.delegate respondsToSelector:@selector(webServiceResponse: withError:)]) {
        [self.delegate webServiceResponse:dataObject withError:errorMessage];
    }
}

@end
