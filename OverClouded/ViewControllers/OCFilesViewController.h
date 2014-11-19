//
//  OCFIlesViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseTableViewController.h"
#import "OCFile.h"

@interface OCFilesViewController : OCBaseTableViewController
{
    OCFile *currentFile;
}

@property (nonatomic,strong)OCFile *currentFile;

-(id) initWithFile:(OCFile *) aFile;

@end
