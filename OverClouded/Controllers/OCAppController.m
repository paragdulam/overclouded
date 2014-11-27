//
//  OCAppController.m
//  OverClouded
//
//  Created by Parag Dulam on 26/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCAppController.h"
#import "OCCloudsViewController.h"
#import "OCConstants.h"
#import "OCAccountController.h"
#import "OCAccount.h"
#import "OCFileController.h"
#import "OCUtilities.h"


@implementation OCAppController


+(void) linkFromController:(UIViewController *)vc
{
    OCCloudsViewController *cloudsViewController = [[OCCloudsViewController alloc] initWithTableStyle:UITableViewStylePlain];
    [cloudsViewController setDelegate:vc];
    UINavigationController *cloudsNavController = [[UINavigationController alloc] initWithRootViewController:cloudsViewController];
    [vc presentViewController:cloudsNavController animated:YES completion:NULL];
}

+(void) saveAccountForCredentials:(NSDictionary *) authDict
                  completionBlock:(void(^)(id response,NSError *error))completionhandler
{
    NSNumber *cloudType = [authDict objectForKey:OC_CLOUD_TYPE];
    NSInteger type = [cloudType integerValue];
    NSURL *accountURL = nil;
    NSDictionary *params = nil;
    NSMutableURLRequest *request = nil;
    __block BOOL isAlreadyStored = NO;

    switch (type) {
        case DROPBOX:
        {
            NSString *userId = [authDict objectForKey:@"uid"];
            [[self class] getAllAccountsWithCompletionBlock:^(id response, NSError *error) {
                NSArray *accounts = (NSArray *)response;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
                NSArray *results = [accounts filteredArrayUsingPredicate:predicate];
                isAlreadyStored = [results count] ? YES : NO;
            }];

            if (!isAlreadyStored) {
                NSString *accountURLString = @"https://api.dropbox.com/1/account/info?";
                NSMutableString *finalURLString = [NSMutableString stringWithString:accountURLString];
                params = @{@"access_token":[authDict objectForKey:@"access_token"]};
                NSArray *keys = [params allKeys];
                for (NSString *key in keys) {
                    [finalURLString appendFormat:@"%@=%@",key,[params objectForKey:key]];
                    if (![[keys lastObject] isEqualToString:key]) {
                        [finalURLString appendString:@"&"];
                    }
                }
                accountURL = [NSURL URLWithString:finalURLString];
                request = [NSMutableURLRequest requestWithURL:accountURL];
            }
        }
            break;
        default:
            break;
    }
    if (!isAlreadyStored) {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //cache it
            NSDictionary *accountData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSMutableDictionary *finalAccountDict = [[NSMutableDictionary alloc] init];
            [finalAccountDict addEntriesFromDictionary:accountData];
            [finalAccountDict addEntriesFromDictionary:authDict];
            OCAccount *account = [[OCAccount alloc] initWithAccount:finalAccountDict
                                                             ofType:type];
            OCAccountController *accountController = [[OCAccountController alloc] initWithAccount:account];
            completionhandler(account,nil);
            [accountController saveWithCompletionBlock:^(OCAccount *account) {
            }];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"accounts.already_exists"
                                             code:-9999
                                         userInfo:nil];
        completionhandler(nil,error);
    }
}


+(void) getAllAccountsWithCompletionBlock:(void(^)(id response,NSError *error))completionHandler
{
    [OCAccountController getAllAccounts:^(NSArray *accounts, NSError *error) {
        completionHandler(accounts,error);
    }];
}



+(void) removeAccount:(OCAccount *)account
  WithCompletionBlock:(void (^)(NSError *))completionHandler
{
    OCAccountController *accountController = [[OCAccountController alloc] initWithAccount:account];
    [accountController removeAccountWithCompletionBlock:^(NSError *error) {
        completionHandler(error);
    }];
}



+(void) makeRequestForMetadataOfFilePath:(NSString *) filePath
                               inAccount:(OCAccount *) account
                         completionBlock:(void(^)(id response,NSError *error))completionHandler {
    NSURL *metadataURL = nil;
    NSDictionary *params = nil;
    NSMutableURLRequest *request = nil;
    
    switch ([account.accountType integerValue]) {
        case DROPBOX:
        {
            NSMutableString *metadataURLString = [NSMutableString stringWithString:@"https://api.dropbox.com/1/metadata/auto/"];
            [metadataURLString appendString:filePath];
            [metadataURLString appendString:@"?"];
            params = @{@"access_token":account.access_token};
            NSArray *keys = [params allKeys];
            for (NSString *key in keys) {
                [metadataURLString appendFormat:@"%@=%@",key,[params objectForKey:key]];
                if (![[keys lastObject] isEqualToString:key]) {
                    [metadataURLString appendString:@"&"];
                }
            }

            metadataURL = [NSURL URLWithString:[metadataURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            request = [NSMutableURLRequest requestWithURL:metadataURL];
        }
            break;
            
        default:
            break;
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *metadataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        OCFile *file = [[OCFile alloc] initWithFile:metadataDict WithFileID:[OCUtilities getUUID] ofAccountType:[account.accountType integerValue] inAccountID:account.accountId];
        completionHandler(file,nil);
        OCFileController *fileController = [[OCFileController alloc] initWithFile:file];
        [fileController saveWithCompletionBlock:^(OCFile *afile) {
            
        }];
    }];
}


+(void) makeRequestForMetadataOfFile:(OCFile *) file
                           inAccount:(OCAccount *) account
                     completionBlock:(void(^)(id response,NSError *error))completionHandler {
    [[self class] makeRequestForMetadataOfFilePath:file.path
                                         inAccount:account
                                   completionBlock:completionHandler];
}

+(void) getFileMetadataForFolderPath:(NSString *) filePath
                         withAccount:(OCAccount *) account
                     completionBlock:(void(^)(id response,NSError *error))completionHandler {
    OCFileController *fileController = [[OCFileController alloc] init];
    [fileController getFileMetadataAtPath:filePath
                            withAccountID:account.accountId
                          completionBlock:^(OCFile *afile) {
                              completionHandler(afile,nil);
                          }];
}


+(void) getFileMetadataForFolder:(OCFile *) file
                     withAccount:(OCAccount *) account
                 completionBlock:(void(^)(id response,NSError *error))completionHandler {
    [[self class] getFileMetadataForFolderPath:file.path
                                   withAccount:account
                               completionBlock:completionHandler];
}





@end
