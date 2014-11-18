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


@interface OCAccount : MTLModel
{
    OCCLOUD_TYPE accountType;
    NSString *email;
    NSString *country;
    NSString *displayName;
    CGFloat normalConsumedBytes;
    CGFloat sharedConsumedBytes;
    CGFloat totalBytes;
    NSString *userId;
}

@property(nonatomic) OCCLOUD_TYPE accountType;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *displayName;
@property(nonatomic) CGFloat normalConsumedBytes;
@property(nonatomic) CGFloat sharedConsumedBytes;
@property(nonatomic) CGFloat totalBytes;
@property(nonatomic,strong) NSString *userId;


-(id) initWithAccount:(id)account ofType:(OCCLOUD_TYPE) type;

@end
