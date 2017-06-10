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

@interface SearchTunesTableViewController () <UISearchBarDelegate, TuneSearchDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) TuneSearchData *tuneSearchdata;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, assign) NSInteger rowHeight;

@end

@implementation SearchTunesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tuneSearchdata = [[TuneSearchData alloc] init];
    self.searchBar.delegate = self;
    self.tuneSearchdata.delegate = self;
    self.cellIdentifier = @"ResultsCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    self.rowHeight = cell.bounds.size.height;

   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.tuneSearchdata.songList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (cell == nil) {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    
    SongData *data = (SongData *)[self.tuneSearchdata.songList objectAtIndex:indexPath.row];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SongTableViewCell *cell = sender;
    LyricsViewController *vc = [segue destinationViewController];
    vc.songData = (SongData *)[self.tuneSearchdata.songList objectAtIndex:cell.index];
}

#pragma mark - Delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder]; // Dimiss the keyboard

    if (searchBar.text == nil)
        return;
    
    [self.tuneSearchdata getSongsUsingSearchTerms:searchBar.text];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)dataLoaded {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    [self.tableView reloadData];
}


@end
