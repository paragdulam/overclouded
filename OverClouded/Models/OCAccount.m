//
//  OCAccount.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCAccount.h"
#import <DropboxSDK/DropboxSDK.h>


@implementation OCAccount
@synthesize accountType;
@synthesize email;
@synthesize country;
@synthesize displayName;
@synthesize normalConsumedBytes;
@synthesize sharedConsumedBytes;
@synthesize totalBytes;
@synthesize userId;



-(id) initWithAccount:(id)account ofType:(OCCLOUD_TYPE) type
{
    if (self = [super init]) {
        switch (type) {
            case DROPBOX:
            {
                DBAccountInfo *info = (DBAccountInfo *)account;
                self.email = info.email;
                self.country = info.country;
                self.displayName = info.displayName;
                self.normalConsumedBytes = info.quota.normalConsumedBytes;
                self.sharedConsumedBytes = info.quota.sharedConsumedBytes;
                self.totalBytes = info.quota.totalBytes;
                self.userId = info.userId;
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

@end
