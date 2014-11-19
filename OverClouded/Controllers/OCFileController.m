//
//  OCFileController.m
//  OverClouded
//
//  Created by Parag Dulam on 19/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCFileController.h"
#import "OCUtilities.h"
#import "YapDatabase.h"
#import "OCConstants.h"
#import "OCFile.h"

@implementation OCFileController

@synthesize file;

-(id) initWithFile:(OCFile *) aFile
{
    if (self = [super init]) {
        self.file = aFile;
    }
    return self;
}


-(NSString *) filedbPathForAccountID:(NSString *) accId
{
    return [NSString stringWithFormat:@"%@/%@/%@",[OCUtilities getAccountsPath],accId,OC_FILES_DB];
}

-(void) getFileMetadataAtPath:(NSString *) path withAccountID:(NSString *)accID completionBlock:(fileCompletionBlock)completionHandler
{
    YapDatabase *database = [[YapDatabase alloc] initWithPath:[self filedbPathForAccountID:accID]];
    YapDatabaseConnection *connection = [database newConnection];
    [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        OCFile *aFile = (OCFile *)[transaction objectForKey:path inCollection:OC_FILES];
        completionHandler(aFile);
    }];
}


-(void) storeOCFileInDBWithCompletionBlock:(fileCompletionBlock)completionHandler
{
    YapDatabase *database = [[YapDatabase alloc] initWithPath:[self filedbPathForAccountID:self.file.accountId]];
    YapDatabaseConnection *connection = [database newConnection];
    [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:self.file forKey:self.file.path inCollection:OC_FILES];
        completionHandler(self.file);
    }];
}


-(void) saveWithCompletionBlock:(fileCompletionBlock)completionHandler
{
    [self storeOCFileInDBWithCompletionBlock:completionHandler];
}


@end
