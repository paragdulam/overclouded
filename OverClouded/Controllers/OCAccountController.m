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
#import "OCConstants.h"


@interface OCAccountController ()

-(void) storeAccountInDBWithCompletionBlock:(completionBlock)completionHandler;

@end

@implementation OCAccountController
@synthesize account;

-(id) initWithAccount:(OCAccount *) accnt
{
    if (self = [super init]) {
        self.account = accnt;
    }
    return self;
}


-(void) saveWithCompletionBlock:(completionBlock)completionHandler
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
                                        [self storeAccountInDBWithCompletionBlock:completionHandler];
                                    }
                                }];
                }
            }
        }];
    } else {
        [self storeAccountInDBWithCompletionBlock:completionHandler];
    }
}


-(void) removeAccountWithCompletionBlock:(void(^)(NSError *error))completionHandler
{
    YapDatabase *database = [[YapDatabase alloc] initWithPath:[OCUtilities getAccountsDBPath]];
    YapDatabaseConnection *connection = [database newConnection];
    NSMutableArray *storedAccounts = [[NSMutableArray alloc] init];
    [[self class] getAllAccounts:^(NSArray *accounts, NSError *error) {
        [storedAccounts addObjectsFromArray:accounts];
    }];
    
    [storedAccounts removeObject:self.account];
    if ([storedAccounts count]) {
        for (OCAccount *accnt in storedAccounts) {
            [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                [transaction setObject:accnt forKey:accnt.accountId inCollection:OC_ACCOUNTS];
            }];
        }
    } else {
        [OCUtilities deleteFileAtPath:[OCUtilities getAccountsPath]
                    completionHandler:^(NSError *error) {
                        completionHandler(error);
                    }];
    }
}


-(void) storeAccountInDBWithCompletionBlock:(completionBlock)completionHandler
{
    YapDatabase *database = [[YapDatabase alloc] initWithPath:[OCUtilities getAccountsDBPath]];
    YapDatabaseConnection *connection = [database newConnection];
    
    NSMutableArray *accounts = [[NSMutableArray alloc] initWithCapacity:0];
    [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        [transaction enumerateRowsInCollection:OC_ACCOUNTS
                                    usingBlock:^(NSString *key, id object, id metadata, BOOL *stop) {
                                        [accounts addObject:object];
                                    }];
    }];
    
    BOOL shouldAddAccount;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",self.account.userId];
    NSArray *storedAccounts = [accounts filteredArrayUsingPredicate:predicate];
    shouldAddAccount = [storedAccounts count] ? NO : YES;
    if (shouldAddAccount) {
        [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [transaction setObject:self.account forKey:self.account.accountId inCollection:OC_ACCOUNTS];
            completionHandler(self.account);
        }];
    } else {
        completionHandler(nil);
    }
}


+(void) getAllAccounts:(void(^)(NSArray *accounts,NSError *error))completionHandler {
    if ([OCUtilities doesFileExistAtPath:[OCUtilities getAccountsDBPath]]) {
        YapDatabase *database = [[YapDatabase alloc] initWithPath:[OCUtilities getAccountsDBPath]];
        YapDatabaseConnection *connection = [database newConnection];
        [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            NSMutableArray *accounts = [[NSMutableArray alloc] initWithCapacity:0];
            [transaction enumerateRowsInCollection:OC_ACCOUNTS
                                        usingBlock:^(NSString *key, id object, id metadata, BOOL *stop) {
                                            [accounts addObject:object];
                                        }];
            completionHandler(accounts,nil);
        }];
    } else {
        completionHandler(nil,nil);
    }
}

@end
