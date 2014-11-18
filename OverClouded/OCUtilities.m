//
//  OCUtilities.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCUtilities.h"

@implementation OCUtilities

+(NSString *) getUUID
{
    return [[NSUUID UUID] UUIDString];
}

+(NSString *) getLibraryPath
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return path;
}

+(NSString *) getAppCachePath
{
    return [NSString stringWithFormat:@"%@/app_cache",[[self class] getLibraryPath]];
}


@end
