//
//  AppDelegate.m
//  MusicSearch
//
//  Created by 平屋真吾 on 2016/03/23.
//  Copyright © 2016年 Shingo Hiraya. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    return YES;
}

@end
