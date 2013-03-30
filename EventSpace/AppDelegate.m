//
//  AppDelegate.m
//  EventSpace
//
//  Created by Stephanie Shupe on 3/30/13.
//  Copyright (c) 2013 EventSpace, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import <Parse/Parse.h>
#import <Dropbox/Dropbox.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[WelcomeViewController alloc] init]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    DBAccountManager* accountMgr = [[DBAccountManager alloc] initWithAppKey:@"zeeglomt1sk3f5y" secret:@"wfk9njov59m79t3"];
    [DBAccountManager setSharedManager:accountMgr];
    DBAccount *account = accountMgr.linkedAccount;
    
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
    [Parse setApplicationId:@"f2mPe7FUoxQboBQacCvLG5kjr9k1w1aOc4VFkqhU"
                  clientKey:@"lrh69eX7OvTEGcNoscNNodqfDCoaEU1SBdTQxoj9"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        NSLog(@"App linked successfully!");
        return YES;
    }
    
    return YES;
}

@end
