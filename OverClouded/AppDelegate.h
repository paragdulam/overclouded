//
//  AppDelegate.h
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@class OCAccountsViewController;
@class OCFilesViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    __weak MMDrawerController *drawerViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,weak) MMDrawerController *drawerViewController;

@property (nonatomic,weak) OCAccountsViewController *accountsViewController;
@property (nonatomic,weak) OCFilesViewController *filesViewController;

@property (nonatomic,weak) UINavigationController *accountsNavController;
@property (nonatomic,weak) UINavigationController *filesNavController;




@end

