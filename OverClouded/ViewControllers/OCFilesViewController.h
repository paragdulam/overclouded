//
//  OCFIlesViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseTableViewController.h"
#import "OCFile.h"
#import "OCAccount.h"

@interface OCFilesViewController : OCBaseTableViewController
{
    OCFile *currentFile;
    OCAccount *selectedAccount;
}

@property (nonatomic,strong) OCFile *currentFile;
@property (nonatomic,strong) OCAccount *selectedAccount;

-(id) initWithFile:(OCFile *) aFile inAccount:(OCAccount *) accnt;
-(void)updateView:(OCFile *) file;


@end
