//
//  OCBaseViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface OCBaseViewController : UIViewController
{

}

@property (nonatomic,unsafe_unretained) AppDelegate *appDelegate;

-(void) startAnimating;
-(void) stopAnimating:(UIBarButtonItem *) barbuttonItem;

@end
