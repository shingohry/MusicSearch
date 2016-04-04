//
//  Item.h
//  MusicSearch
//
//  Created by hiraya.shingo on 2016/03/31.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITunesItem : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *artistName;
@property (nonatomic, readonly) NSString *albumName;
@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) BOOL isStreamable;

+ (instancetype)itemWithDictionary:(NSDictionary *)dictionary;

@end
