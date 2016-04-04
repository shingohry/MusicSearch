//
//  SearchResultViewController.m
//  MusicSearch
//
//  Created by 平屋真吾 on 2016/03/30.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultCell.h"
#import "DetailViewController.h"
#import "ITunesItem.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@import StoreKit;

@interface SearchResultViewController ()

@property (nonatomic) SKCloudServiceController *cloudServiceController;
@property (nonatomic) AFHTTPSessionManager *HTTPSessionManager;
@property (nonatomic) NSArray<ITunesItem *> *results;

@end

@implementation SearchResultViewController

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
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        SearchResultCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        DetailViewController *controller = segue.destinationViewController;
        controller.item = self.results[indexPath.row];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"
                                                             forIndexPath:indexPath];
    cell.item = self.results[indexPath.row];
    
    return cell;
}

#pragma mark - Private

- (void)prepare
{
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    
    self.HTTPSessionManager = [AFHTTPSessionManager new];
    self.cloudServiceController = [SKCloudServiceController new];
    
    [self requestCountryCodeWithCompletion:^(NSString * _Nullable countryCode,
                                             NSError * _Nullable error) {
        [self performSearchWithKeyword:self.keyword
                           countryCode:countryCode];
    }];
}

- (void)requestCountryCodeWithCompletion:(void(^)(NSString * _Nullable countryCode, NSError * _Nullable error))completion
{
    // Storefront ID を取得する
    [self.cloudServiceController requestStorefrontIdentifierWithCompletionHandler:^(NSString * _Nullable storefrontIdentifier,
                                                                                    NSError * _Nullable error) {
        NSString *identifier = [[storefrontIdentifier componentsSeparatedByString:@","] firstObject];
        identifier = [[identifier componentsSeparatedByString:@"-"] firstObject];
        NSString *countryCode = [self countryCodeWithIdentifier:identifier];
        
        NSLog(@"storefrontIdentifier:%@", storefrontIdentifier);
        NSLog(@"countryCode:%@", countryCode);
        
        completion(countryCode, error);
    }];
}

- (void)performSearchWithKeyword:(NSString *)keyword
                     countryCode:(NSString *)countryCode
{
    NSDictionary *parameters = @{
                                 @"isStreamable" : @(YES),
                                 @"term" : keyword,
                                 @"media" : @"music",
                                 @"limit" : @(100),
                                 @"country" : countryCode
                                 };
    
    // iTunes Search API にリクエストを投げる
    [self.HTTPSessionManager GET:@"https://itunes.apple.com/search"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task,
                                   id  _Nonnull responseObject) {
                             NSArray *objects = responseObject[@"results"];
                             NSMutableArray *results = [NSMutableArray new];
                             
                             for (NSDictionary *dictionary in objects) {
                                 ITunesItem *item = [ITunesItem itemWithDictionary:dictionary];
                                 [results addObject:item];
                             }
                             
                             self.results = [results copy];
                             [self.tableView reloadData];
                         }
                         failure:nil];
}

- (NSString *)countryCodeWithIdentifier:(NSString *)identifier
{
    // Storefront ID を Country Code に変換する
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"CountryCodes"
                                              withExtension:@"plist"];
    NSDictionary *countryCodeDictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    return countryCodeDictionary[identifier];
}

@end
