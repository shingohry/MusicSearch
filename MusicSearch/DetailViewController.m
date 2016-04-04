//
//  DetailViewController.m
//  MusicSearch
//
//  Created by hiraya.shingo on 2016/03/31.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import "DetailViewController.h"
#import "ITunesItem.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@import MediaPlayer;

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (nonatomic) MPMusicPlayerController *musicPlayerController;

@end

@implementation DetailViewController

#pragma mark - Life Cycle 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepare];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.musicPlayerController stop];
}

#pragma mark - Action

- (IBAction)playButtonDidTouchUpInside:(id)sender
{
    // MPMusicPlayerController クラスの「再生キュー」に曲を追加し、曲を再生する
    [self.musicPlayerController setQueueWithStoreIDs:@[self.item.identifier]];
    [self.musicPlayerController play];
}

- (IBAction)addButtonDidTouchUpInside:(id)sender
{
    // 曲をミュージックライブラリへ追加する
    [[MPMediaLibrary defaultMediaLibrary]
     addItemWithProductID:self.item.identifier
     completionHandler:^(NSArray<__kindof MPMediaEntity *> * _Nonnull entities,
                         NSError * _Nullable error) {
         for (MPMediaEntity *entity in entities) {
             NSLog(@"Artist:%@", [entity valueForProperty:MPMediaItemPropertyArtist]);
             NSLog(@"Title:%@", [entity valueForProperty:MPMediaItemPropertyTitle]);
         }
     }];
}

#pragma mark - Private 

- (void)prepare
{
    self.musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
    
    self.mainLabel.text = self.item.title;
    self.subLabel.text = [NSString stringWithFormat:@"%@ ‐ %@", self.item.artistName, self.item.albumName];
    [self.imageView setImageWithURL:self.item.imageURL];
}

@end
