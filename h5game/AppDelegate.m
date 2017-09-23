//
//  AppDelegate.m
//  h5game
//
//  Created by 光宇 on 2017/6/19.
//  Copyright © 2017年 光宇. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [NSThread sleepForTimeInterval:1.0];
    // Override point for customization after application launch.
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                            diskCapacity:200 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
        
    return YES;
}




- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                   willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSMutableDictionary *mutableUserInfo = [[cachedResponse userInfo] mutableCopy];
    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageAllowedInMemoryOnly;
    
    // ...
    
    return [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
                                                    data:mutableData
                                                userInfo:mutableUserInfo
                                           storagePolicy:storagePolicy];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
