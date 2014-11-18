//
//  OCAccountController.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCAccountController.h"

@implementation OCAccountController
@synthesize account;

-(id) initWithAccount:(OCAccount *) accnt
{
    if (self = [super init]) {
        self.account = accnt;
    }
    return self;
}


-(void) saveWithCompletionBlock:(completionBlock)completionBlock
{
    //Write YapDatabase Code here
}


@end
