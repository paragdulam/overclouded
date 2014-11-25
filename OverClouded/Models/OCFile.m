//
//  OCFile.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCFile.h"
#import <DropboxSDK/DropboxSDK.h>
#import "OCUtilities.h"

@implementation OCFile

@synthesize thumbnailExists;
@synthesize totalBytes;
@synthesize lastModifiedDate;
@synthesize clientMtime;
@synthesize path;
@synthesize isDirectory;
@synthesize contents;
@synthesize hash;
@synthesize humanReadableSize;
@synthesize root;
@synthesize icon;
@synthesize rev;
@synthesize revision;
@synthesize isDeleted;
@synthesize filename;
@synthesize fileId;
@synthesize thumbnailData;

@synthesize accountId;
@synthesize fileType;



-(id) initWithFile:(id) file WithFileID:(NSString *) fId ofAccountType:(OCCLOUD_TYPE) type inAccountID:(NSString *)accId
{
    if (self = [super init]) {
        switch (type) {
            case DROPBOX:
            {
                DBMetadata *metadata = (DBMetadata *)file;
                self.thumbnailExists = metadata.thumbnailExists;
                self.totalBytes = metadata.totalBytes;
                self.lastModifiedDate = metadata.lastModifiedDate;
                self.clientMtime = metadata.clientMtime;
                self.path = metadata.path;
                self.isDirectory = metadata.isDirectory;
                
                NSMutableArray *toBeContents = [[NSMutableArray alloc] init];
                for (DBMetadata *aFile in metadata.contents) {
                    OCFile *tobeStoredFile = [[OCFile alloc] init];
                    tobeStoredFile.thumbnailExists = aFile.thumbnailExists;
                    tobeStoredFile.totalBytes = aFile.totalBytes;
                    tobeStoredFile.lastModifiedDate = aFile.lastModifiedDate;
                    tobeStoredFile.clientMtime = aFile.clientMtime;
                    tobeStoredFile.path = aFile.path;
                    tobeStoredFile.isDirectory = aFile.isDirectory;
                    tobeStoredFile.contents = aFile.contents;
                    tobeStoredFile.hash = aFile.hash;
                    tobeStoredFile.humanReadableSize = aFile.humanReadableSize;
                    tobeStoredFile.root = aFile.root;
                    tobeStoredFile.icon = aFile.icon;
                    tobeStoredFile.rev = aFile.rev;
                    tobeStoredFile.revision = aFile.revision;
                    tobeStoredFile.isDeleted = aFile.isDeleted;
                    tobeStoredFile.filename = aFile.filename;
                    tobeStoredFile.fileId = [OCUtilities getUUID];
                    
                    tobeStoredFile.accountId = accId;
                    tobeStoredFile.fileType = type;

                    [toBeContents addObject:tobeStoredFile];
                }
                self.contents = toBeContents;
                self.hash = metadata.hash;
                self.humanReadableSize = metadata.humanReadableSize;
                self.root = metadata.root;
                self.icon = metadata.icon;
                self.rev = metadata.rev;
                self.revision = metadata.revision;
                self.isDeleted = metadata.isDeleted;
                self.filename = metadata.filename;
                self.fileId = fId;
                
                self.accountId = accId;
                self.fileType = type;
            }
                break;
            default:
                break;
        }
    }
    return self;
}



@end
