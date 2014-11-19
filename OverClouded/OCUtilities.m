//
//  OCUtilities.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCUtilities.h"
#import "OCConstants.h"

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

+(NSString *) getAccountsPath
{
    return [NSString stringWithFormat:@"%@/%@",[[self class] getAppCachePath],OC_ACCOUNTS];
}

+(NSString *) getAccountsDBPath {
    return [NSString stringWithFormat:@"%@/%@",[[self class] getAccountsPath],OC_ACCOUNTS_DB];
}


+(BOOL) doesFileExistAtPath:(NSString *) path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];

}


+(BOOL) doesAccountsFolderExist {
    return [[self class] doesFileExistAtPath:[[self class] getAccountsPath]];
}



+(void) deleteFileAtPath:(NSString *)path
       completionHandler:(void(^)(NSError *error))completionBlock {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    completionBlock(error);
}


+(void) createFileAtPath:(NSString *)path
       completionHandler:(void(^)(NSError *error))completionBlock {
    NSError *error = nil;
    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:nil
                                          attributes:nil];
    completionBlock(error);
}



+(void) createFolderAtPath:(NSString *)path
         completionHandler:(void(^)(NSError *error))completionBlock {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    completionBlock(error);
}


+(void) createAccountsFolder:(void(^)(NSError *error))completionBlock {
    NSString *accountspath = [[self class] getAccountsPath];
    NSLog(@"accountspath %@",accountspath);
    [[self class] createFolderAtPath:accountspath
                   completionHandler:completionBlock];
}

@end
