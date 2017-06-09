//
//  WebService.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "WebService.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation WebService

- (NSString *)createCompleteURLString:(NSString *)url withParameters:(NSDictionary *)parameters andHTTPS:(BOOL)useHTTPS {
    NSAssert(![[url lowercaseString] hasPrefix:@"http"],@"parameter: 'url' should not start with http prefix");
    NSMutableString *newURL = [[NSMutableString alloc] initWithString: useHTTPS ? @"https://" : @"http://"];
    [newURL appendString:url];
    
    if (parameters != nil && [parameters count] > 0) {
        NSMutableString *parameterString = [[NSMutableString alloc] initWithString:@""];
        NSString *key;
        for(key in parameters) {
            [parameterString appendFormat:@"%s%@=%@", (parameterString.length == 0) ? "?" : "&",key,[parameters objectForKey: key]];
        }

        NSCharacterSet *expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet;
        NSString *encodedParams = [parameterString stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
        [newURL appendString:encodedParams];
    }
    
    return newURL;
}

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
                NSDictionary *dataObject = [self getResponseObjectFromData:data withError:&jsonError];
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

- (NSDictionary *)getResponseObjectFromData:(NSData *)data withError:(NSError **)error {
    
    NSDictionary *dataObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

    if (dataObject == nil) { // not a json object, try a javascript object
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        JSContext *context = [[JSContext alloc] init];
        JSValue *object = [context evaluateScript: dataString ? dataString : @""];
        dataObject = [object toDictionary];
    }
    
    return dataObject;
}


-(void)webServiceResponse:(NSDictionary *)dataObject withError:(NSString *)errorMessage {
    if ([self.delegate respondsToSelector:@selector(webServiceResponse: withError:)]) {
        [self.delegate webServiceResponse:dataObject withError:errorMessage];
    }
}

@end
