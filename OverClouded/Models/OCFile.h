//
//  OCFile.h
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "MTLModel.h"
#import <UIKit/UIKit.h>
#import "OCConstants.h"


@interface OCFile : MTLModel
{
    BOOL thumbnailExists;
    CGFloat totalBytes;
    NSDate *lastModifiedDate;
    NSDate *clientMtime;
    NSString *path;
    BOOL isDirectory;
    NSArray *contents;
    NSString *hash;
    NSString *humanReadableSize;
    NSString *root;
    NSString *icon;
    NSString *rev;
    CGFloat revision;
    BOOL isDeleted;
    NSString *filename;
    
    NSString *accountId;
    OCCLOUD_TYPE fileType;
}


-(id) initWithFile:(id) file ofAccountType:(OCCLOUD_TYPE) type andAccountID:(NSString *)accId;

@property(nonatomic) BOOL thumbnailExists;
@property(nonatomic) CGFloat totalBytes;
@property(nonatomic,strong) NSDate *lastModifiedDate;
@property(nonatomic,strong) NSDate *clientMtime;
@property(nonatomic,strong) NSString *path;
@property(nonatomic) BOOL isDirectory;
@property(nonatomic,strong) NSArray *contents;
@property(nonatomic,strong) NSString *hash;
@property(nonatomic,strong) NSString *humanReadableSize;
@property(nonatomic,strong) NSString *root;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *rev;
@property(nonatomic) CGFloat revision;
@property(nonatomic) BOOL isDeleted;
@property(nonatomic,strong) NSString *filename;

@property(nonatomic,strong) NSString *accountId;
@property(nonatomic) OCCLOUD_TYPE fileType;

@end
