//
//  OCBaseTableViewController.h
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseViewController.h"

@interface OCBaseTableViewController : OCBaseViewController
{
    UITableView *dataTableView;
    NSMutableArray *tableDataArray;
    UITableViewStyle tableStyle;
}

-(id) initWithTableStyle:(UITableViewStyle) style;
@property (nonatomic) UITableViewStyle tableStyle;

-(void)updateTableView:(NSArray *) anArray;
-(void) updateTable;


@end
