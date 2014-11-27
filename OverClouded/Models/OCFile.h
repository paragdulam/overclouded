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
    NSNumber * thumbnailExists;
    NSNumber * totalBytes;
    NSDate *lastModifiedDate;
    NSDate *clientMtime;
    NSString *path;
    NSNumber * isDirectory;
    NSArray *contents;
    NSString *hash;
    NSString *humanReadableSize;
    NSString *root;
    NSString *icon;
    NSString *rev;
    NSNumber *revision;
    NSNumber *isDeleted;
    NSString *filename;
    NSString *fileId;
    UIImage *thumbnailData;
    
    NSString *accountId;
    NSNumber * fileType;
}


-(id) initWithFile:(id) file WithFileID:(NSString *) fId ofAccountType:(OCCLOUD_TYPE) type inAccountID:(NSString *)accId;

@property(nonatomic) NSNumber *thumbnailExists;
@property(nonatomic) NSNumber *totalBytes;
@property(nonatomic,strong) NSDate *lastModifiedDate;
@property(nonatomic,strong) NSDate *clientMtime;
@property(nonatomic,strong) NSString *path;
@property(nonatomic) NSNumber *isDirectory;
@property(nonatomic,strong) NSArray *contents;
@property(nonatomic,strong) NSString *hash;
@property(nonatomic,strong) NSString *humanReadableSize;
@property(nonatomic,strong) NSString *root;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *rev;
@property(nonatomic) NSNumber *revision;
@property(nonatomic) NSNumber *isDeleted;
@property(nonatomic,strong) NSString *filename;
@property(nonatomic,strong) NSString *fileId;
@property(nonatomic,strong) UIImage *thumbnailData;

@property(nonatomic,strong) NSString *accountId;
@property(nonatomic) NSNumber * fileType;

@end
