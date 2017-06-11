//
//  LyricsViewController.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/10/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "LyricsViewController.h"
#import "LyricsData.h"

@interface LyricsViewController () 

@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *lyrics;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImage;

@property (nonatomic, strong) LyricsData *lyricsData;

@end

@implementation LyricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.songTitle.text = self.songData.songTitle;
    self.albumTitle.text = self.songData.albumTitle;
    self.lyrics.text = self.songData.songLyrics;
    self.artist.text = self.songData.artist;
    [self.albumCoverImage setImage:self.songData.albumImage];

    
    // check if we have already gotten lyrics
    if (self.songData.songLyrics == nil || self.songData.songLyrics.length == 0) {
        
        // check to se that we have artist and song info
         if ((self.songData.artist != nil && self.songData.artist.length > 0) &&
             (self.songData.songTitle != nil && self.songData.songTitle.length > 0)) {
             
             [UIApplication sharedApplication].networkActivityIndicatorVisible = true;

             self.lyricsData = [[LyricsData alloc] init];
             
             [self.lyricsData getLyrics:self.songData.artist andSongTitle:self.songData.songTitle getLyrics:^(NSString *lyrics) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                self.songData.songLyrics = lyrics;
                 dispatch_async(dispatch_get_main_queue(), ^(void){
                     self.lyrics.text = lyrics;
                 });
             }];
         } else {
             self.lyrics.text = @"Artist and/or song tile is missing";
         }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self.lyrics sizeToFit];
}

@end
