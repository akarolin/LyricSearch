//
//  NSString+CondenseSpaces.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/9/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "NSString+CondenseSpaces.h"

@implementation NSString (CondenseSpaces)

- (NSString *)condenseSpaces {
    NSString *originalString = self;
    NSString *squashed = [originalString stringByReplacingOccurrencesOfString:@"[ ]+"
                                                                   withString:@" "
                                                                      options:NSRegularExpressionSearch
                                                                        range:NSMakeRange(0, originalString.length)];
    
    return [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
