//
//  OCAccountController.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCAccountController.h"
#import "OCUtilities.h"
#import "YapDatabase.h"

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
    BOOL doesAccountsFolderExist = [OCUtilities doesAccountsFolderExist];
    if (!doesAccountsFolderExist) {
        [OCUtilities createAccountsFolder:^(NSError *error) {
            if (!error) {
                NSLog(@"Accounts Folder Created");
                BOOL doesAccountsDBExist = [OCUtilities doesFileExistAtPath:[OCUtilities getAccountsDBPath]];
                if (!doesAccountsDBExist) {
                    [OCUtilities createFileAtPath:[OCUtilities getAccountsDBPath]
                                completionHandler:^(NSError *error) {
                                    if (!error) {
                                        NSLog(@"Accounts Database Created");
                                        YapDatabase *database = [[YapDatabase alloc] initWithPath:[OCUtilities getAccountsDBPath]];
                                        
                                        // Get a connection to the database (can have multiple for concurrency)
                                        YapDatabaseConnection *connection = [database newConnection];
                                        
                                        // Add an object
                                        [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                                            [transaction setObject:self.account forKey:self.account.accountId inCollection:@"Accounts"];
                                        }];
                                        
                                        // Read it back
                                        [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
                                            NSLog(@"%@", [transaction objectForKey:self.account.accountId inCollection:@"Accounts"]);
                                        }];
                                    }
                                }];
                }
            }
        }];
    } else {
        
    }
    
}


@end
