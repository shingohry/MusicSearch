//
//  SearchResultCell.m
//  MusicSearch
//
//  Created by hiraya.shingo on 2016/03/31.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import "SearchResultCell.h"
#import "ITunesItem.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface SearchResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@end

@implementation SearchResultCell

#pragma mark - Accessor

- (void)setItem:(ITunesItem *)item
{
    _item = item;
    
    self.titleLabel.text = item.title;
    self.albumLabel.text = item.albumName;
    self.artistLabel.text = item.artistName;
    [self.thumbnailImageView setImageWithURL:item.imageURL];
}

@end
