//
//  OCFileController.h
//  OverClouded
//
//  Created by Parag Dulam on 19/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCFile.h"

typedef void (^fileCompletionBlock)(OCFile *afile);


@interface OCFileController : NSObject
{
    OCFile *file;
}

-(id) initWithFile:(OCFile *) aFile;

@property (nonatomic,strong) OCFile *file;

-(void) saveWithCompletionBlock:(fileCompletionBlock)completionHandler;
-(void) getFileMetadataAtPath:(NSString *) path withAccountID:(NSString *)accID completionBlock:(fileCompletionBlock)completionHandler;
-(void) getThumbnailForFile:(OCFile *) afile withCompletionBlock:(void(^)(id response,NSError *error))completionHandler;



@end
