//
//  SearchResultCell.h
//  MusicSearch
//
//  Created by hiraya.shingo on 2016/03/31.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITunesItem;

@interface SearchResultCell : UITableViewCell

@property (nonatomic) ITunesItem *item;

@end
