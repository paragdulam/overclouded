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
    switch (type) {
        case DROPBOX:
        {
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
            break;
        default:
            break;
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //cache it
        NSDictionary *accountData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"accountData %@",accountData);
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




@end
