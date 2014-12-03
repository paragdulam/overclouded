//
//  OCBaseTableViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "OCTableView.h"

@interface OCBaseTableViewController : OCBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    OCTableView *dataTableView;
    NSMutableArray *tableDataArray;
    UITableViewStyle tableStyle;
}

-(id) initWithTableStyle:(UITableViewStyle) style;
@property (nonatomic) UITableViewStyle tableStyle;


-(void)updateTableView:(NSArray *) anArray;
-(void) updateTable;


@end
