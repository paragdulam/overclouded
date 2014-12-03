//
//  OCAccount.h
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "MTLModel.h"
#import "OCConstants.h"
#import <UIKit/UIKit.h>

@class OCAccountController;


@interface OCAccount : MTLModel
{
    NSNumber *accountType;
    NSString *email;
    NSString *country;
    NSString *displayName;
    NSNumber *normalConsumedBytes;
    NSNumber *sharedConsumedBytes;
    NSNumber *totalBytes;
    NSString *userId;
    NSString *accountId;
    NSString *access_token;
    NSString *auth_code;
}

@property(nonatomic) NSNumber *accountType;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *displayName;
@property(nonatomic) NSNumber *normalConsumedBytes;
@property(nonatomic) NSNumber *sharedConsumedBytes;
@property(nonatomic) NSNumber *totalBytes;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *accountId;
@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *auth_code;


-(id) initWithAccount:(id)account ofType:(OCCLOUD_TYPE) type;

@end
