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
                NSDictionary *metadata = (NSDictionary *)file;
                self.thumbnailExists = [metadata objectForKey:@"thumb_exists"];
                self.totalBytes = [metadata objectForKey:@"bytes"];
                self.lastModifiedDate = [metadata objectForKey:@"modified"];
                self.clientMtime = [metadata objectForKey:@"client_mtime"];
                self.path = [metadata objectForKey:@"path"];
                self.isDirectory = [metadata objectForKey:@"is_dir"];
                
                NSMutableArray *toBeContents = [[NSMutableArray alloc] init];
                for (NSDictionary *aFile in [metadata objectForKey:@"contents"]) {
                    OCFile *tobeStoredFile = [[OCFile alloc] init];
                    tobeStoredFile.thumbnailExists = [aFile objectForKey:@"thumb_exists"];
                    tobeStoredFile.totalBytes = [aFile objectForKey:@"bytes"];
                    tobeStoredFile.lastModifiedDate = [metadata objectForKey:@"modified"];
                    tobeStoredFile.clientMtime = [aFile objectForKey:@"client_mtime"];
                    tobeStoredFile.path = [aFile objectForKey:@"path"];
                    tobeStoredFile.isDirectory = [aFile objectForKey:@"is_dir"];
                    tobeStoredFile.contents = [aFile objectForKey:@"contents"];
                    tobeStoredFile.hash = [aFile objectForKey:@"hash"];
                    tobeStoredFile.humanReadableSize = [aFile objectForKey:@"size"];
                    tobeStoredFile.root = [aFile objectForKey:@"root"];
                    tobeStoredFile.icon = [aFile objectForKey:@"icon"];
                    tobeStoredFile.rev = [aFile objectForKey:@"rev"];
                    tobeStoredFile.revision = [aFile objectForKey:@"revision"];
                    tobeStoredFile.isDeleted = [aFile objectForKey:@"is_deleted"];
                    
                    tobeStoredFile.filename = [[aFile objectForKey:@"path"] lastPathComponent];
                    
                    tobeStoredFile.fileId = [OCUtilities getUUID];
                    
                    tobeStoredFile.accountId = accId;
                    tobeStoredFile.fileType = [NSNumber numberWithInt:type];

                    [toBeContents addObject:tobeStoredFile];
                }
                self.contents = toBeContents;
                self.hash = [metadata objectForKey:@"hash"];
                self.humanReadableSize = [metadata objectForKey:@"size"];
                self.root = [metadata objectForKey:@"root"];
                self.icon = [metadata objectForKey:@"icon"];
                self.rev = [metadata objectForKey:@"rev"];
                self.revision = [metadata objectForKey:@"revision"];
                self.isDeleted = [metadata objectForKey:@"is_deleted"];
                
                self.filename = [[metadata objectForKey:@"path"] lastPathComponent];
                
                self.fileId = fId;
                
                self.accountId = accId;
                self.fileType = [NSNumber numberWithInt:type];
            }
                break;
            default:
                break;
        }
    }
    return self;
}



@end
