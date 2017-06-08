//
//  WebService.h
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

@property (nonatomic, strong) NSDictionary *jsonObject;
@property (nonatomic, strong) NSString *errorMsg;

- (void) getWebData:(NSString *)urlString;

@end

NSString * const ResponseError = @"Error";
NSString * const HTTPError = @"HTTP Error";
NSString * const JSONError = @"JSON Error";
NSString * const DataError = @"DATA Error";

