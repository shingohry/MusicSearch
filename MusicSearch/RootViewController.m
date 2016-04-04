//
//  ViewController.m
//  MusicSearch
//
//  Created by 平屋真吾 on 2016/03/23.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import "RootViewController.h"
#import "SearchResultViewController.h"

@import StoreKit;

@interface RootViewController () <UISearchBarDelegate>

@property (nonatomic) SKCloudServiceController *cloudServiceController;
@property (nonatomic) UISearchBar *searchBar;

@end

@implementation RootViewController

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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchResultViewController"]) {
        SearchResultViewController *controller = segue.destinationViewController;
        controller.keyword = self.searchBar.text;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    if (searchBar.text.length > 0) {
        [self performSegueWithIdentifier:@"SearchResultViewController"
                                  sender:nil];
    }
}

#pragma mark - Private

- (void)prepare
{
    self.cloudServiceController = [SKCloudServiceController new];
    
    [self requestAuthorization];
    [self prepareSearchBar];
}

- (void)requestAuthorization
{
    // デバイス上のミュージックライブラリへのアクセスをリクエストする
    [SKCloudServiceController requestAuthorization:^(SKCloudServiceAuthorizationStatus status) {
        NSLog(@"authorized:%@", status == SKCloudServiceAuthorizationStatusAuthorized ? @"YES" : @"NO");
        
        if (status != SKCloudServiceAuthorizationStatusAuthorized) {
            return;
        }
        
        // ミュージックライブラリ関連の機能を利用できるかを確認する
        [self.cloudServiceController requestCapabilitiesWithCompletionHandler:^(SKCloudServiceCapability capabilities,
                                                                                NSError * _Nullable error) {
            NSLog(@"available MusicCatalogPlayback:%@", (capabilities & SKCloudServiceCapabilityMusicCatalogPlayback) ? @"YES" : @"NO");
            NSLog(@"available AddToCloudMusicLibrary:%@", (capabilities & SKCloudServiceCapabilityAddToCloudMusicLibrary) ? @"YES" : @"NO");
        }];
    }];
}

- (void)prepareSearchBar
{
    self.searchBar = [UISearchBar new];
    self.searchBar.placeholder = @"キーワードを入力";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}

@end
