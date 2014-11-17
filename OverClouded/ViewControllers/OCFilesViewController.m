//
//  OCFIlesViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCFilesViewController.h"

@interface OCFilesViewController ()

@end

@implementation OCFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"OverClouded"];
    UILabel *swipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    dataTableView.frame.size.width,
                                                                    50)];
    [swipeLabel setTextAlignment:NSTextAlignmentCenter];
    [swipeLabel setText:@"Swipe Right to add Accounts"];
    [dataTableView setTableHeaderView:swipeLabel];
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
