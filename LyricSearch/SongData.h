//
//  SongData.h
//  SearchTunes
//
//  Created by Andy Karolin on 5/30/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongData : NSObject

@property (strong, nonatomic) NSString *songTitle;
@property (strong, nonatomic) NSString *albumTitle;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *albumImageURL;
@property (strong, nonatomic) UIImage  *albumImage;
@property (strong, nonatomic) NSString *songLyrics;

@end
