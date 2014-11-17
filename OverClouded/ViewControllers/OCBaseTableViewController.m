//
//  OCBaseTableViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseTableViewController.h"

@interface OCBaseTableViewController ()

@end

@implementation OCBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
