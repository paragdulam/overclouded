//
//  OCBaseViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCConstants.h"


@class AppDelegate;

@interface OCBaseViewController : UIViewController
{

}

@property (nonatomic,unsafe_unretained) AppDelegate *appDelegate;

-(void) startAnimating;
-(void) stopAnimating:(UIBarButtonItem *) barbuttonItem;
-(void) showAlertWithMessage:(NSString *) message withType:(OCMESSAGE_TYPE) type;


@end
