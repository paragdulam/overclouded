//
//  OCBaseTableViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseTableViewController.h"

@interface OCBaseTableViewController ()
{
}

@end

@implementation OCBaseTableViewController
@synthesize tableStyle;


-(id) initWithTableStyle:(UITableViewStyle) style
{
    if (self = [super init]) {
        self.tableStyle = style;
        tableDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableStyle];
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    [self.view addSubview:dataTableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [dataTableView setTableFooterView:footerView]; //removes unwanted Cell Separators
    
    dataTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setBarTintColor:self.navigationController.navigationBar.barTintColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helpers


-(void) updateTable
{
    [dataTableView reloadData];
}

-(void)updateTableView:(NSArray *) anArray
{
    [tableDataArray removeAllObjects];
    [tableDataArray addObjectsFromArray:anArray];
    [self updateTable];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableDataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell.detailTextLabel setFont:[UIFont italicSystemFontOfSize:11.f]];
        [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
