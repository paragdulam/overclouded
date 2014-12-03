//
//  OCAppController.h
//  OverClouded
//
//  Created by Parag Dulam on 26/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OCAccount.h"
#import "OCFile.h"

@interface OCAppController : NSObject

+(void) linkFromController:(UIViewController *)vc;
+(void) saveAccountForCredentials:(NSDictionary *) authDict
                  completionBlock:(void(^)(id response,NSError *error))completionhandler;
+(void) getAllAccountsWithCompletionBlock:(void(^)(id response,NSError *error))completionHandler;

+(void) removeAccount:(OCAccount *)account WithCompletionBlock:(void(^)(NSError *error))completionHandler;

+(void) getFileMetadataForFolderPath:(NSString *) filePath withAccount:(OCAccount *) account completionBlock:(void(^)(id response,NSError *error))completionHandler;

+(void) getFileMetadataForFolder:(OCFile *) file withAccount:(OCAccount *) account completionBlock:(void(^)(id response,NSError *error))completionHandler;

+(void) makeRequestForMetadataOfFilePath:(NSString *) filePath inAccount:(OCAccount *) account completionBlock:(void(^)(id response,NSError *error))completionHandler;

+(void) makeRequestForMetadataOfFile:(OCFile *) file inAccount:(OCAccount *) account completionBlock:(void(^)(id response,NSError *error))completionHandler;

+(void) makeRequestForThumbnailForFile:(OCFile *) afile
                             inAccount:(OCAccount *) account
                   withCompletionBlock:(void(^)(id response,NSError *error))completionHandler;



@end
