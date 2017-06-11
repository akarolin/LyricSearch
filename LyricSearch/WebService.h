//
//  WebService.h
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>

@required
-(void)webServiceResponse:(NSDictionary *)dataObject withError:(NSString *)errorMessage;

@end

@interface WebService : NSObject

@property (nonatomic, strong) id <WebServiceDelegate> delegate;
@property (nonatomic, strong) NSString *errorMsg;

- (void) getWebDataByURL:(NSString *)urlString;
- (NSDictionary *)getResponseObjectFromData:(NSData *)data withError:(NSError **)error;
- (void) getWebDataByURL:(NSString *)urlString completionHandler:(void (^)(NSDictionary *dataObject, NSString *errorMessage))responseValues;
- (NSString *)createCompleteURLString:(NSString *)url withParameters:(NSDictionary *)parameters andHTTPS:(BOOL)useHTTPS;

@end

