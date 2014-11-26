//
//  OCWebViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 26/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseViewController.h"

@protocol OCAuthorizationCodeDelegate;

@interface OCWebViewController : OCBaseViewController
{
    NSURL *url;
    NSString *redirect_uri;
    OCCLOUD_TYPE type;
    __unsafe_unretained id<OCAuthorizationCodeDelegate> delegate;
}

@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong) NSString *redirect_uri;
@property(nonatomic) OCCLOUD_TYPE type;
@property (nonatomic,unsafe_unretained) id<OCAuthorizationCodeDelegate> delegate;


-(id) initWithURL:(NSURL *) anURL ForCloudType:(OCCLOUD_TYPE) cloudType andRedirectURI:(NSString *) rURI;
@end


@protocol OCAuthorizationCodeDelegate <NSObject>

-(void) webViewController:(OCWebViewController *) vc didRecieveAuthorizationCode:(NSString *) code;

@end
