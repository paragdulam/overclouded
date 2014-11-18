//
//  OCAccountController.h
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCAccount.h"
#import "YapDatabase.h"


typedef void (^completionBlock)(OCAccount *account);

@interface OCAccountController : NSObject
{
    OCAccount *account;
}

@property (nonatomic,strong) OCAccount *account;

-(id) initWithAccount:(OCAccount *) accnt;
-(void) saveWithCompletionBlock:(completionBlock)completionBlock;
+(void) getAllAccounts:(void(^)(NSArray *accounts,NSError *error))completionHandler;

@end
