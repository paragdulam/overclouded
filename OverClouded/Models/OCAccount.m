//
//  OCAccount.m
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCAccount.h"
#import <DropboxSDK/DropboxSDK.h>
#import "OCUtilities.h"
#import "OCAccountController.h"

@implementation OCAccount
@synthesize accountType;
@synthesize email;
@synthesize country;
@synthesize displayName;
@synthesize normalConsumedBytes;
@synthesize sharedConsumedBytes;
@synthesize totalBytes;
@synthesize userId;
@synthesize accountId;
@synthesize access_token;
@synthesize auth_code;


-(id) initWithAccount:(id)account ofType:(OCCLOUD_TYPE) type 
{
    if (self = [super init]) {
        switch (type) {
            case DROPBOX:
            {
                NSDictionary *info = (NSDictionary *)account;
                self.email = [info objectForKey:@"email"];
                self.country = [info objectForKey:@"country"];
                self.displayName = [info objectForKey:@"display_name"];
                self.normalConsumedBytes = [[info objectForKey:@"quota_info"] objectForKey:@"normal"];
                self.sharedConsumedBytes = [[info objectForKey:@"quota_info"] objectForKey:@"shared"];
                self.totalBytes = [[info objectForKey:@"quota_info"] objectForKey:@"quota"];
                self.userId = [info objectForKey:@"uid"];
                self.accountId = [OCUtilities getUUID];
                
                self.accountType = [NSNumber numberWithInteger:type];
                self.access_token = [info objectForKey:@"access_token"];
                self.auth_code = [info objectForKey:OC_AUTH_CODE];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

@end
