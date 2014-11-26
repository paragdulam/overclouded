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

@interface OCAppController : NSObject

+(void) linkFromController:(UIViewController *)vc;
+(void) saveAccountForCredentials:(NSDictionary *) authDict
                  completionBlock:(void(^)(id response,NSError *error))completionhandler;
+(void) getAllAccountsWithCompletionBlock:(void(^)(id response,NSError *error))completionHandler;
+(void) removeAccount:(OCAccount *)account
  WithCompletionBlock:(void(^)(NSError *error))completionHandler;
@end
