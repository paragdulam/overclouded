//
//  OCCloudsViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 26/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseTableViewController.h"

@protocol OCCloudsViewControllerDelegate;

@interface OCCloudsViewController : OCBaseTableViewController
{
    __unsafe_unretained id<OCCloudsViewControllerDelegate> delegate;
}

@property(nonatomic,unsafe_unretained) id<OCCloudsViewControllerDelegate> delegate;

@end


@protocol OCCloudsViewControllerDelegate<NSObject>

-(void) cloudViewController:(OCCloudsViewController *) vc didRecieveAuthenticationDataDictionary:(NSDictionary *) authDict;

@end
