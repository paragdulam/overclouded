//
//  OCDragView.m
//  OverClouded
//
//  Created by Parag Dulam on 20/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCDragView.h"
#define LABEL_HEIGHT 20.f
#define OFFSET 3.f

@interface OCDragView ()
{
    UIImageView *fileImageView;
    UILabel *fileNameLabel;
}

@end

@implementation OCDragView

-(id) init {
    if (self = [super init]) {
        fileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:fileImageView];
        
        fileNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [fileNameLabel setBackgroundColor:[UIColor colorWithRed:47.f/255.f
                                                          green:129.f/255.f
                                                           blue:184.f/255.f
                                                          alpha:1.f]];
        [fileNameLabel setTextColor:[UIColor whiteColor]];
        [fileNameLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
        [fileNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:fileNameLabel];
    }
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat imageViewHeight = self.bounds.size.height - LABEL_HEIGHT;
    if (imageViewHeight <= 0) {
        imageViewHeight = 0;
    }
    
    fileNameLabel.frame = CGRectMake(self.bounds.origin.x,
                                     imageViewHeight,
                                     self.bounds.size.width,
                                     LABEL_HEIGHT);

    fileImageView.frame = CGRectMake(0,
                                     OFFSET,
                                     imageViewHeight,
                                     imageViewHeight - (2 * OFFSET));
    fileImageView.center = CGPointMake(self.center.x, fileImageView.center.y);
    
    fileImageView.layer.cornerRadius = 2.f;
    fileImageView.clipsToBounds = YES;
    
    fileNameLabel.layer.cornerRadius = fileNameLabel.frame.size.height/2;
    fileNameLabel.clipsToBounds = YES;
}


-(void) setFile:(OCFile *)file
{
    UIImage *image = nil;
    NSString *fileName = file.filename;
    if ([file isDirectory]) {
        image = [UIImage imageNamed:@"folder"];
    } else {
        NSArray *components = [fileName componentsSeparatedByString:@"."];
        NSString *extension = [components lastObject];
        if ([extension length]) {
            image = [UIImage imageNamed:[extension lowercaseString]];
            if (!image) {
                image = [UIImage imageNamed:@"_blank"];
            }
        } else {
            image = [UIImage imageNamed:@"_blank"];
        }
    }
    [fileImageView setImage:image];
    [fileNameLabel setText:fileName];
}

@end
