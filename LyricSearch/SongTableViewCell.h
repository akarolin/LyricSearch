//
//  SongTableViewCell.h
//  SearchTunes
//
//  Created by Andy Karolin on 5/30/17.
//  Copyright © 2017 AccendantC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *artist;

@end
