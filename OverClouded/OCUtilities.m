//
//  OCUtilities.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCUtilities.h"

@implementation OCUtilities

+(NSString *) getLibraryPath
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return path;
}


@end
