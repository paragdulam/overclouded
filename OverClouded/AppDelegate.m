//
//  AppDelegate.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "AppDelegate.h"
#import "OCAccountsViewController.h"
#import "OCFilesViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "OCConstants.h"


@interface AppDelegate ()<DBSessionDelegate,DBNetworkRequestDelegate>
{
}


@end

@implementation AppDelegate
@synthesize drawerViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window setTintColor:[UIColor whiteColor]];
    
    
    OCAccountsViewController *accountsVC = [[OCAccountsViewController alloc] initWithTableStyle:UITableViewStyleGrouped];
    self.accountsViewController = accountsVC;
    UINavigationController *accountsNavC = [[UINavigationController alloc] initWithRootViewController:self.accountsViewController];
    self.accountsNavController = accountsNavC;
    
    OCFilesViewController *filesVC = [[OCFilesViewController alloc] initWithTableStyle:UITableViewStylePlain];
    self.filesViewController = filesVC;
    UINavigationController *filesNavC = [[UINavigationController alloc] initWithRootViewController:self.filesViewController];
    self.filesNavController = filesNavC;
    
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.filesNavController
                                                                           leftDrawerViewController:self.accountsNavController];
    self.drawerViewController = drawerController;
    [drawerViewController setMaximumLeftDrawerWidth:280.0];
    [drawerViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.window setRootViewController:drawerViewController];
    [self.window makeKeyAndVisible];
    
    
    
    NSString* appKey = @"y1hmeaarl6da494";
    NSString* appSecret = @"4mjdch4itbrvcyh";
    NSString *root = @"auto";
    
    DBSession* session =
    [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
    session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
    [DBSession setSharedSession:session];
    
    [DBRequest setNetworkRequestDelegate:self];

    return YES;
}


-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL retVal = [[DBSession sharedSession] handleOpenURL:url];
    if (retVal) {
        [self.accountsViewController dropboxDidLink];
    }
    return retVal;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Alerts



#pragma mark - DBSessionDelegate

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    
}


#pragma mark - DBNetworkRequestDelegate

- (void)networkRequestStarted
{
    
}

- (void)networkRequestStopped
{
    
}



@end
