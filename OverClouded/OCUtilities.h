//
//  OCUtilities.h
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCUtilities : NSObject

+(NSString *) getUUID;
+(NSString *) getLibraryPath;
+(NSString *) getAppCachePath;
+(NSString *) getAccountsPath;
+(NSString *) getAccountsDBPath;
+(BOOL) doesAccountsFolderExist;
+(void) createAccountsFolder:(void(^)(NSError *error))completionBlock;
+(void) createFolderAtPath:(NSString *)path
         completionHandler:(void(^)(NSError *error))completionBlock;
+(void) createFileAtPath:(NSString *)path
       completionHandler:(void(^)(NSError *error))completionBlock;
+(BOOL) doesFileExistAtPath:(NSString *) path;

@end
