//
//  SearchTunesTableViewController.m
//  LyricSearch
//
//  Created by Andy Karolin on 6/8/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import "SearchTunesTableViewController.h"
#import "SongTableViewCell.h"
#import "SongData.h"
#import "TuneSearchData.h"
#import "LyricsViewController.h"

@interface SearchTunesTableViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) TuneSearchData *tuneSearchdata;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) NSInteger rowHeight;
@property (nonatomic, strong) NSArray *songList;

@end

@implementation SearchTunesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tuneSearchdata = [[TuneSearchData alloc] init];
    self.searchBar.delegate = self;
    self.cellIdentifier = @"ResultsCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    self.rowHeight = cell.bounds.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (cell == nil) {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    
    SongData *data = (SongData *)[self.songList objectAtIndex:indexPath.row];
    cell.songTitle.text = data.songTitle;
    cell.albumTitle.text = data.albumTitle;
    cell.artist.text = data.artist;
    
    if (data.albumImage == nil)
        data.albumImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.albumImageURL]]];
    
    [cell.albumImage setImage:data.albumImage];
    cell.index = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SongTableViewCell *cell = sender;
    LyricsViewController *vc = [segue destinationViewController];
    vc.songData = (SongData *)[self.songList objectAtIndex:cell.index];
}

#pragma mark - Delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder]; // Dismiss the keyboard

    if (searchBar.text == nil)
        return;
    
    [self.tuneSearchdata getSongsUsingSearchTerms:searchBar.text updatedSongList:^(NSArray *songList) {
        self.songList = songList;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });

    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

@end
