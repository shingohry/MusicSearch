//
//  Item.m
//  MusicSearch
//
//  Created by hiraya.shingo on 2016/03/31.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import "ITunesItem.h"

@implementation ITunesItem

#pragma mark - Life Cycle

+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        _identifier = [dictionary[@"trackId"] stringValue];
        _title = dictionary[@"trackName"];
        _artistName = dictionary[@"artistName"];
        _albumName = dictionary[@"collectionName"];
        _imageURL = [NSURL URLWithString:dictionary[@"artworkUrl100"]];
        _isStreamable = [dictionary[@"isStreamable"] boolValue];
    }
    
    return self;
}

@end
